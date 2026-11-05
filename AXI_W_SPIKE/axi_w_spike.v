module AXI4_DATA_WRITER #(
    parameter integer AXI_ID_WIDTH      = 4,
    parameter integer AXI_ADDR_WIDTH    = 32,
    parameter integer AXI_DATA_WIDTH    = 32,
    parameter integer TARGET_DATA_WIDTH = 256,
    parameter integer TARGET_ADDR_MAX   = 4096
)(
    input  wire                          aclk,
    input  wire                          aresetn,

    //========================================================
    // AXI4 Write Address Channel
    //========================================================
    input  wire [AXI_ID_WIDTH-1:0]       s_axi_awid,
    input  wire [AXI_ADDR_WIDTH-1:0]     s_axi_awaddr,
    input  wire [7:0]                    s_axi_awlen,
    input  wire [2:0]                    s_axi_awsize,
    input  wire [1:0]                    s_axi_awburst,
    input  wire                          s_axi_awlock,
    input  wire [3:0]                    s_axi_awcache,
    input  wire [2:0]                    s_axi_awprot,
    input  wire [3:0]                    s_axi_awqos,
    input  wire                          s_axi_awvalid,
    output wire                          s_axi_awready,

    //========================================================
    // AXI4 Write Data Channel
    //========================================================
    input  wire [AXI_DATA_WIDTH-1:0]     s_axi_wdata,
    input  wire [AXI_DATA_WIDTH/8-1:0]   s_axi_wstrb,
    input  wire                          s_axi_wlast,
    input  wire                          s_axi_wvalid,
    output wire                          s_axi_wready,

    //========================================================
    // AXI4 Write Response Channel
    //========================================================
    output reg  [AXI_ID_WIDTH-1:0]       s_axi_bid,
    output reg  [1:0]                    s_axi_bresp,
    output reg                           s_axi_bvalid,
    input  wire                          s_axi_bready,

    //========================================================
    // AXI4 Read Address Channel
    //========================================================
    input  wire [AXI_ID_WIDTH-1:0]       s_axi_arid,
    input  wire [AXI_ADDR_WIDTH-1:0]     s_axi_araddr,
    input  wire [7:0]                    s_axi_arlen,
    input  wire [2:0]                    s_axi_arsize,
    input  wire [1:0]                    s_axi_arburst,
    input  wire                          s_axi_arlock,
    input  wire [3:0]                    s_axi_arcache,
    input  wire [2:0]                    s_axi_arprot,
    input  wire [3:0]                    s_axi_arqos,
    input  wire                          s_axi_arvalid,
    output wire                          s_axi_arready,

    //========================================================
    // AXI4 Read Data Channel
    //========================================================
    output reg  [AXI_ID_WIDTH-1:0]       s_axi_rid,
    output reg  [AXI_DATA_WIDTH-1:0]     s_axi_rdata,
    output reg  [1:0]                    s_axi_rresp,
    output reg                           s_axi_rlast,
    output reg                           s_axi_rvalid,
    input  wire                          s_axi_rready,

    //========================================================
    // Target side interface
    //========================================================
    output reg  [31:0]                   target_addr,
    output reg                           target_w_en,
    output reg  [TARGET_DATA_WIDTH-1:0]  target_w_data
);

    // ------------------------------------------------------------
    // localparam
    // ------------------------------------------------------------
    localparam integer AXI_STRB_WIDTH   = AXI_DATA_WIDTH / 8;
    localparam integer TARGET_WORD_NUM  = TARGET_DATA_WIDTH / AXI_DATA_WIDTH;
    localparam integer WORD_CNT_WIDTH   = (TARGET_WORD_NUM <= 1) ? 1 : $clog2(TARGET_WORD_NUM);
    localparam integer AXI_SIZE_EXPECT  = $clog2(AXI_DATA_WIDTH/8);

    localparam [1:0] AXI_RESP_OKAY   = 2'b00;
    localparam [1:0] AXI_RESP_SLVERR = 2'b10;
    localparam [1:0] AXI_RESP_DECERR = 2'b11;

    // ------------------------------------------------------------
    // optional sanity check
    // ------------------------------------------------------------
    initial begin
        if ((TARGET_DATA_WIDTH % AXI_DATA_WIDTH) != 0) begin
            $error("TARGET_DATA_WIDTH must be an integer multiple of AXI_DATA_WIDTH.");
        end
        if (AXI_DATA_WIDTH != 32) begin
            $error("This version assumes AXI_DATA_WIDTH = 32.");
        end
    end

    // ------------------------------------------------------------
    // internal regs
    // ------------------------------------------------------------
    reg                            wr_active;
    reg [8:0]                      wr_beats_left;
    reg [AXI_ID_WIDTH-1:0]         wr_id;
    reg                            wr_resp_err;

    reg [WORD_CNT_WIDTH-1:0]       word_count;
    reg [31:0]                     target_addr_ptr;

    reg                            wstrb_full;
    reg [AXI_DATA_WIDTH-1:0]       valid_word;

    reg [TARGET_DATA_WIDTH-1:0]    word_pack;
    reg [TARGET_DATA_WIDTH-1:0]    word_pack_next;

    wire [15:0]                    word_bit_offset;
    assign word_bit_offset = {word_count, 5'b0}; // word_count * 32

    // ------------------------------------------------------------
    // handshake
    // ------------------------------------------------------------
    assign s_axi_awready = (~wr_active) && (~s_axi_bvalid);
    assign s_axi_wready  = (~s_axi_bvalid) && (wr_active || s_axi_awvalid);

    wire aw_fire = s_axi_awvalid && s_axi_awready;
    wire w_fire  = s_axi_wvalid  && s_axi_wready;

    wire [8:0] aw_beats_total    = {1'b0, s_axi_awlen} + 9'd1;
    wire [8:0] beats_left_before = wr_active ? wr_beats_left : aw_beats_total;
    wire       expected_last     = (beats_left_before == 9'd1);

    wire       aw_param_err      = (s_axi_awsize != AXI_SIZE_EXPECT);

    // ------------------------------------------------------------
    // read channel: not functionally supported, but complete ports
    // ------------------------------------------------------------
    assign s_axi_arready = ~s_axi_rvalid;
    wire ar_fire = s_axi_arvalid && s_axi_arready;

    // ------------------------------------------------------------
    // combinational: WSTRB must be all valid
    // ------------------------------------------------------------
    always @(*) begin
        wstrb_full = 1'b0;
        valid_word = {AXI_DATA_WIDTH{1'b0}};

        if (w_fire) begin
            if (s_axi_wstrb == {AXI_STRB_WIDTH{1'b1}}) begin
                wstrb_full = 1'b1;
                valid_word = s_axi_wdata;
            end
            else begin
                wstrb_full = 1'b0;
                valid_word = {AXI_DATA_WIDTH{1'b0}};
            end
        end
    end

    // ------------------------------------------------------------
    // combinational: next packed TARGET_DATA_WIDTH word
    // ------------------------------------------------------------
    always @(*) begin
        word_pack_next = word_pack;
        if (word_count < TARGET_WORD_NUM) begin
            word_pack_next[word_bit_offset +: AXI_DATA_WIDTH] = valid_word;
        end
    end

    // ------------------------------------------------------------
    // main sequential logic
    // ------------------------------------------------------------
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            wr_active       <= 1'b0;
            wr_beats_left   <= 9'd0;
            wr_id           <= {AXI_ID_WIDTH{1'b0}};
            wr_resp_err     <= 1'b0;

            s_axi_bid       <= {AXI_ID_WIDTH{1'b0}};
            s_axi_bresp     <= AXI_RESP_OKAY;
            s_axi_bvalid    <= 1'b0;

            s_axi_rid       <= {AXI_ID_WIDTH{1'b0}};
            s_axi_rdata     <= {AXI_DATA_WIDTH{1'b0}};
            s_axi_rresp     <= AXI_RESP_DECERR;
            s_axi_rlast     <= 1'b0;
            s_axi_rvalid    <= 1'b0;

            word_count      <= 'd0;
            word_pack       <= {TARGET_DATA_WIDTH{1'b0}};
            target_addr_ptr <= 32'd0;

            target_addr     <= 32'd0;
            target_w_en     <= 1'b0;
            target_w_data   <= {TARGET_DATA_WIDTH{1'b0}};
        end
        else begin
            // 默认拉低脉冲
            target_w_en <= 1'b0;

            // ----------------------------------------------------
            // B channel clear
            // ----------------------------------------------------
            if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 1'b0;
            end

            // ----------------------------------------------------
            // Read response: always return DECERR
            // ----------------------------------------------------
            if (ar_fire) begin
                s_axi_rid    <= s_axi_arid;
                s_axi_rdata  <= {AXI_DATA_WIDTH{1'b0}};
                s_axi_rresp  <= AXI_RESP_DECERR;
                s_axi_rlast  <= 1'b1;
                s_axi_rvalid <= 1'b1;
            end
            else if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 1'b0;
                s_axi_rlast  <= 1'b0;
            end

            // ----------------------------------------------------
            // AW accepted without W in same cycle
            // ----------------------------------------------------
            if (aw_fire && !w_fire) begin
                wr_active     <= 1'b1;
                wr_beats_left <= aw_beats_total;
                wr_id         <= s_axi_awid;
                wr_resp_err   <= aw_param_err;
            end

            // ----------------------------------------------------
            // W accepted
            // ----------------------------------------------------
            if (w_fire) begin
                // AW + first W in same cycle
                if (!wr_active && aw_fire) begin
                    wr_id       <= s_axi_awid;
                    wr_resp_err <= aw_param_err;
                end

                // only accept full WSTRB (all 4 bytes valid)
                if (wstrb_full) begin
                    if (word_count == TARGET_WORD_NUM-1) begin
                        // complete one TARGET_DATA_WIDTH word
                        target_w_data <= word_pack_next;
                        target_w_en   <= 1'b1;
                        target_addr   <= target_addr_ptr;

                        if (target_addr_ptr == TARGET_ADDR_MAX-1)
                            target_addr_ptr <= 32'd0;
                        else
                            target_addr_ptr <= target_addr_ptr + 32'd1;

                        word_pack  <= {TARGET_DATA_WIDTH{1'b0}};
                        word_count <= 'd0;
                    end
                    else begin
                        word_pack  <= word_pack_next;
                        word_count <= word_count + 1'b1;
                    end
                end
                else begin
                    // invalid strobe pattern
                    wr_resp_err <= 1'b1;
                end

                // burst end
                if (expected_last || s_axi_wlast) begin
                    wr_active     <= 1'b0;
                    wr_beats_left <= 9'd0;

                    s_axi_bid    <= (!wr_active && aw_fire) ? s_axi_awid : wr_id;
                    s_axi_bvalid <= 1'b1;

                    if ((expected_last ^ s_axi_wlast) || (!wstrb_full) || wr_resp_err || aw_param_err)
                        s_axi_bresp <= AXI_RESP_SLVERR;
                    else
                        s_axi_bresp <= AXI_RESP_OKAY;

                    wr_resp_err <= 1'b0;
                end
                else begin
                    wr_active     <= 1'b1;
                    wr_beats_left <= beats_left_before - 9'd1;
                end
            end
        end
    end

endmodule