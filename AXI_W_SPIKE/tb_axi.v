`timescale 1ns / 1ps

module tb_AXI4_DATA_WRITER;

    localparam AXI_ID_WIDTH      = 4;
    localparam AXI_ADDR_WIDTH    = 32;
    localparam AXI_DATA_WIDTH    = 32;
    localparam TARGET_DATA_WIDTH = 512;

    reg                           aclk;
    reg                           aresetn;

    //========================================================
    // AXI4 Write Address Channel
    //========================================================
    reg  [AXI_ID_WIDTH-1:0]       s_axi_awid;
    reg  [AXI_ADDR_WIDTH-1:0]     s_axi_awaddr;
    reg  [7:0]                    s_axi_awlen;
    reg  [2:0]                    s_axi_awsize;
    reg  [1:0]                    s_axi_awburst;
    reg                           s_axi_awlock;
    reg  [3:0]                    s_axi_awcache;
    reg  [2:0]                    s_axi_awprot;
    reg  [3:0]                    s_axi_awqos;
    reg                           s_axi_awvalid;
    wire                          s_axi_awready;

    //========================================================
    // AXI4 Write Data Channel
    //========================================================
    reg  [AXI_DATA_WIDTH-1:0]     s_axi_wdata;
    reg  [AXI_DATA_WIDTH/8-1:0]   s_axi_wstrb;
    reg                           s_axi_wlast;
    reg                           s_axi_wvalid;
    wire                          s_axi_wready;

    //========================================================
    // AXI4 Write Response Channel
    //========================================================
    wire [AXI_ID_WIDTH-1:0]       s_axi_bid;
    wire [1:0]                    s_axi_bresp;
    wire                          s_axi_bvalid;
    reg                           s_axi_bready;

    //========================================================
    // AXI4 Read Address Channel
    //========================================================
    reg  [AXI_ID_WIDTH-1:0]       s_axi_arid;
    reg  [AXI_ADDR_WIDTH-1:0]     s_axi_araddr;
    reg  [7:0]                    s_axi_arlen;
    reg  [2:0]                    s_axi_arsize;
    reg  [1:0]                    s_axi_arburst;
    reg                           s_axi_arlock;
    reg  [3:0]                    s_axi_arcache;
    reg  [2:0]                    s_axi_arprot;
    reg  [3:0]                    s_axi_arqos;
    reg                           s_axi_arvalid;
    wire                          s_axi_arready;

    //========================================================
    // AXI4 Read Data Channel
    //========================================================
    wire [AXI_ID_WIDTH-1:0]       s_axi_rid;
    wire [AXI_DATA_WIDTH-1:0]     s_axi_rdata;
    wire [1:0]                    s_axi_rresp;
    wire                          s_axi_rlast;
    wire                          s_axi_rvalid;
    reg                           s_axi_rready;

    //========================================================
    // Target side
    //========================================================
    wire [31:0]                   target_addr;
    wire                          target_w_en;
    wire [TARGET_DATA_WIDTH-1:0]  target_w_data;

    //========================================================
    // DUT
    // TARGET_ADDR_MAX = 2，方便验证回卷
    //========================================================
    AXI4_DATA_WRITER #(
        .AXI_ID_WIDTH      (AXI_ID_WIDTH),
        .AXI_ADDR_WIDTH    (AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH    (AXI_DATA_WIDTH),
        .TARGET_DATA_WIDTH (TARGET_DATA_WIDTH),
        .TARGET_ADDR_MAX   (2)
    ) dut (
        .aclk           (aclk),
        .aresetn        (aresetn),

        .s_axi_awid     (s_axi_awid),
        .s_axi_awaddr   (s_axi_awaddr),
        .s_axi_awlen    (s_axi_awlen),
        .s_axi_awsize   (s_axi_awsize),
        .s_axi_awburst  (s_axi_awburst),
        .s_axi_awlock   (s_axi_awlock),
        .s_axi_awcache  (s_axi_awcache),
        .s_axi_awprot   (s_axi_awprot),
        .s_axi_awqos    (s_axi_awqos),
        .s_axi_awvalid  (s_axi_awvalid),
        .s_axi_awready  (s_axi_awready),

        .s_axi_wdata    (s_axi_wdata),
        .s_axi_wstrb    (s_axi_wstrb),
        .s_axi_wlast    (s_axi_wlast),
        .s_axi_wvalid   (s_axi_wvalid),
        .s_axi_wready   (s_axi_wready),

        .s_axi_bid      (s_axi_bid),
        .s_axi_bresp    (s_axi_bresp),
        .s_axi_bvalid   (s_axi_bvalid),
        .s_axi_bready   (s_axi_bready),

        .s_axi_arid     (s_axi_arid),
        .s_axi_araddr   (s_axi_araddr),
        .s_axi_arlen    (s_axi_arlen),
        .s_axi_arsize   (s_axi_arsize),
        .s_axi_arburst  (s_axi_arburst),
        .s_axi_arlock   (s_axi_arlock),
        .s_axi_arcache  (s_axi_arcache),
        .s_axi_arprot   (s_axi_arprot),
        .s_axi_arqos    (s_axi_arqos),
        .s_axi_arvalid  (s_axi_arvalid),
        .s_axi_arready  (s_axi_arready),

        .s_axi_rid      (s_axi_rid),
        .s_axi_rdata    (s_axi_rdata),
        .s_axi_rresp    (s_axi_rresp),
        .s_axi_rlast    (s_axi_rlast),
        .s_axi_rvalid   (s_axi_rvalid),
        .s_axi_rready   (s_axi_rready),

        .target_addr    (target_addr),
        .target_w_en    (target_w_en),
        .target_w_data  (target_w_data)
    );

    //========================================================
    // clock
    //========================================================
    initial begin
        aclk = 1'b0;
        forever #5 aclk = ~aclk; // 100MHz
    end

    //========================================================
    // monitor
    //========================================================
    integer pulse_count;
    integer err_count;
    reg [31:0]  last_target_addr;
    reg [TARGET_DATA_WIDTH-1:0] last_target_data;

    always @(posedge aclk) begin
        if (target_w_en) begin
            pulse_count      = pulse_count + 1;
            last_target_addr = target_addr;
            last_target_data = target_w_data;
            $display("[%0t] TARGET_PULSE: count=%0d addr=%0d data=%h",
                     $time, pulse_count, target_addr, target_w_data);
        end
    end

    //========================================================
    // AXI tasks
    //========================================================
    task axi_send_aw;
        input [AXI_ID_WIDTH-1:0]   id;
        input [AXI_ADDR_WIDTH-1:0] addr;
        input [7:0]                len;
        input [2:0]                size;
        begin
            @(negedge aclk);
            s_axi_awid    = id;
            s_axi_awaddr  = addr;
            s_axi_awlen   = len;
            s_axi_awsize  = size;
            s_axi_awburst = 2'b01; // INCR
            s_axi_awlock  = 1'b0;
            s_axi_awcache = 4'b0000;
            s_axi_awprot  = 3'b000;
            s_axi_awqos   = 4'b0000;
            s_axi_awvalid = 1'b1;

            while (!(s_axi_awvalid && s_axi_awready))
                @(posedge aclk);

            @(negedge aclk);
            s_axi_awvalid = 1'b0;
            s_axi_awid    = 'd0;
            s_axi_awaddr  = 'd0;
            s_axi_awlen   = 'd0;
            s_axi_awsize  = s_axi_awsize;
            s_axi_awburst = 'd0;
        end
    endtask

    task axi_send_w;
        input [31:0] word_val;
        input        last_flag;
        begin
            @(negedge aclk);
            s_axi_wdata  = word_val;
            s_axi_wstrb  = 4'b1111;
            s_axi_wlast  = last_flag;
            s_axi_wvalid = 1'b1;

            while (!(s_axi_wvalid && s_axi_wready))
                @(posedge aclk);

            @(negedge aclk);
            s_axi_wvalid = 1'b0;
            s_axi_wlast  = 1'b0;
            s_axi_wdata  = 32'd0;
            s_axi_wstrb  = 4'd0;
        end
    endtask

    task axi_wait_bresp;
        input [AXI_ID_WIDTH-1:0] exp_id;
        input [1:0]              exp_resp;
        begin
            while (s_axi_bvalid !== 1'b1)
                @(posedge aclk);

            if (s_axi_bid !== exp_id) begin
                $display("[%0t] ERROR: BID mismatch. exp=%0d got=%0d",
                         $time, exp_id, s_axi_bid);
                err_count = err_count + 1;
            end

            if (s_axi_bresp !== exp_resp) begin
                $display("[%0t] ERROR: BRESP mismatch. exp=%0h got=%0h",
                         $time, exp_resp, s_axi_bresp);
                err_count = err_count + 1;
            end

            @(negedge aclk);
            s_axi_bready = 1'b1;
            @(negedge aclk);
            s_axi_bready = 1'b0;
        end
    endtask

    task wait_target_and_check;
        input integer exp_pulse_count;
        input [31:0] exp_addr;
        input [TARGET_DATA_WIDTH-1:0] exp_data;
        integer timeout;
        begin
            timeout = 0;
            while ((pulse_count < exp_pulse_count) && (timeout < 500)) begin
                @(posedge aclk);
                timeout = timeout + 1;
            end

            if (timeout >= 500) begin
                $display("[%0t] ERROR: timeout waiting target_w_en pulse %0d",
                         $time, exp_pulse_count);
                err_count = err_count + 1;
            end
            else begin
                if (last_target_addr !== exp_addr) begin
                    $display("[%0t] ERROR: target_addr mismatch. exp=%0d got=%0d",
                             $time, exp_addr, last_target_addr);
                    err_count = err_count + 1;
                end

                if (last_target_data !== exp_data) begin
                    $display("[%0t] ERROR: target_w_data mismatch.", $time);
                    $display("       exp = %h", exp_data);
                    $display("       got = %h", last_target_data);
                    err_count = err_count + 1;
                end
            end
        end
    endtask

    // 发送 1 个 16-beat burst，拼成 512bit
    task send_packet_and_expect;
        input [AXI_ID_WIDTH-1:0]   awid_in;
        input [AXI_ADDR_WIDTH-1:0] awaddr_in;
        input [31:0]               seed_word;
        output reg [TARGET_DATA_WIDTH-1:0] exp_word;
        integer i;
        reg [31:0] word_val;
        begin
            exp_word = {TARGET_DATA_WIDTH{1'b0}};

            // 16 beats -> AWLEN = 15
            axi_send_aw(awid_in, awaddr_in, 8'd15, 3'd2);

            for (i = 0; i < 16; i = i + 1) begin
                word_val = seed_word + i;
                exp_word[i*32 +: 32] = word_val;
                axi_send_w(word_val, (i == 15));
            end

            axi_wait_bresp(awid_in, 2'b00);
        end
    endtask

    //========================================================
    // init
    //========================================================
    initial begin
        s_axi_awid    = 0;
        s_axi_awaddr  = 0;
        s_axi_awlen   = 0;
        s_axi_awsize  = 0;
        s_axi_awburst = 0;
        s_axi_awlock  = 0;
        s_axi_awcache = 0;
        s_axi_awprot  = 0;
        s_axi_awqos   = 0;
        s_axi_awvalid = 0;

        s_axi_wdata   = 0;
        s_axi_wstrb   = 0;
        s_axi_wlast   = 0;
        s_axi_wvalid  = 0;

        s_axi_bready  = 0;

        s_axi_arid    = 0;
        s_axi_araddr  = 0;
        s_axi_arlen   = 0;
        s_axi_arsize  = 0;
        s_axi_arburst = 0;
        s_axi_arlock  = 0;
        s_axi_arcache = 0;
        s_axi_arprot  = 0;
        s_axi_arqos   = 0;
        s_axi_arvalid = 0;

        s_axi_rready  = 0;

        pulse_count      = 0;
        err_count        = 0;
        last_target_addr = 0;
        last_target_data = 0;
    end

    //========================================================
    // test sequence
    //========================================================
    reg [TARGET_DATA_WIDTH-1:0] exp_word0;
    reg [TARGET_DATA_WIDTH-1:0] exp_word1;
    reg [TARGET_DATA_WIDTH-1:0] exp_word2;

    initial begin
        aresetn = 1'b0;
        repeat (5) @(posedge aclk);
        aresetn = 1'b1;
        repeat (3) @(posedge aclk);

        $display("==============================================");
        $display("TEST1: 16 writes -> 1 x 512-bit output, addr=0");
        $display("==============================================");
        send_packet_and_expect(4'h1, 32'h0000_0000, 32'h1000_0000, exp_word0);
        wait_target_and_check(1, 32'd0, exp_word0);

        $display("==============================================");
        $display("TEST2: second packet, addr=1");
        $display("==============================================");
        send_packet_and_expect(4'h2, 32'h0000_1000, 32'h2000_0000, exp_word1);
        wait_target_and_check(2, 32'd1, exp_word1);

        $display("==============================================");
        $display("TEST3: third packet, wrap addr back to 0");
        $display("==============================================");
        send_packet_and_expect(4'h3, 32'h0000_2000, 32'h3000_0000, exp_word2);
        wait_target_and_check(3, 32'd0, exp_word2);

        if (err_count == 0) begin
            $display("==============================================");
            $display("ALL TESTS PASSED");
            $display("==============================================");
        end
        else begin
            $display("==============================================");
            $display("TEST FAILED, err_count = %0d", err_count);
            $display("==============================================");
        end

        #50;
        $finish;
    end

endmodule