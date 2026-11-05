module DDR_READ_CTRL#(
    parameter parallel_metric = 32
)
(
    input  wire         clk                      ,
    input  wire         rst_n                    ,
    input  wire         processing_en            ,
    input  wire         need_rd_ddr              ,
    output reg          weight_vld               ,

    // nn parameter
    input  wire [15:0]  next_i_channel_mult_time ,
    input  wire [15:0]  next_i_channel           ,
    input  wire [31:0]  next_ddr_base_addr       ,

    // read_weight Inference
    input  wire [15:0]  rd_weight_addr_ddr       ,
    input  wire         rd_weight_en_ddr         ,
    output reg  [2303:0]rd_weight_ddr            ,

    // DDR controller
	output reg			RD_START                 ,
	output reg	[31:0]	RD_ADRS                  ,
	output reg	[31:0]	RD_LEN                   , 
	output wire	[2 :0]	RD_SIZE                  ,

	input wire			RD_READY                 ,
	input wire			RD_FIFO_WE               ,
	input wire	[255:0]	RD_FIFO_DATA             ,
	input wire			RD_DONE                  ,
	input wire			RD_LAST         
);

    reg [2303:0]    weight_mem_0 [0:8191];
    reg [2303:0]    weight_mem_1 [0:8191];
    reg [31:0]      INTER_LEN;
    reg             reading_busy;
    reg             ddr_in_reading;
    reg [15:0]      loop0;
    reg [15:0]      did_loop0, did_o_channel_multi;
    reg             choose;
    reg             rd_choose;
    reg             reading_busy_ff1;
    wire            reading_busy_neg;

    assign RD_SIZE = 3'b101;//3'b011;//3'b010;

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            reading_busy <= 0;
        end
        else if(processing_en && need_rd_ddr)begin
            reading_busy <= 1;
        end
        else if(RD_DONE && did_loop0 == loop0 - 1 && did_o_channel_multi == next_i_channel_mult_time - 1)begin
            reading_busy <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            ddr_in_reading <= 0;
        end
        else if(RD_START)begin
            ddr_in_reading <= 1;
        end
        else if(RD_DONE)begin
            ddr_in_reading <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            RD_START <= 0;
        end
        else if(reading_busy && ~ddr_in_reading)begin
            RD_START <= 1;
        end
        else begin
            RD_START <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            RD_ADRS <= 0;
        end
        else if(RD_DONE)begin
            RD_ADRS <= RD_ADRS + INTER_LEN;
        end
        else if(processing_en)begin
            RD_ADRS <= next_ddr_base_addr;
        end
    end

    always@(*)begin
        case(parallel_metric)
            32: begin RD_LEN = 144; INTER_LEN = 4608; loop0 = next_i_channel >> 4; end
            default:  begin RD_LEN = 144; INTER_LEN = 4608; loop0 = next_i_channel >> 4; end
        endcase
    end 

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            did_loop0 <= 0;
            did_o_channel_multi <= 0;
        end
        else if(RD_DONE)begin
            if(did_loop0 == loop0 - 1)begin
                did_loop0 <= 0;
                did_o_channel_multi <= did_o_channel_multi + 1;
            end
            else begin
                did_loop0 <= did_loop0 + 1;
            end
        end
        else if(processing_en)begin
            did_loop0 <= 0;
            did_o_channel_multi <= 0;
        end
    end

    reg [2303:0] buffer;
    reg [7:0]    w_cnt;
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            w_cnt <= 0;
        end
        else if(RD_FIFO_WE)begin
            if(w_cnt == 8)
                w_cnt <= 0;
            else
                w_cnt <= w_cnt + 1;
        end
        else if(processing_en)begin
            w_cnt <= 0;
        end
    end
    always@(posedge clk)begin
        if(RD_FIFO_WE) begin
            buffer <= {RD_FIFO_DATA ,buffer[2303 -: 2048]};
        end
    end

    reg [15:0] w_addr;
    reg        w_en;

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            w_en <= 0;
        end
        else if(RD_FIFO_WE && w_cnt == 8)begin
            w_en <= 1;
        end
        else begin
            w_en <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            w_addr <= 0;
        end
        else if(processing_en)begin
            w_addr <= 0;
        end
        else if(w_en)begin
            w_addr <= w_addr + 1;
        end
    end

    assign reading_busy_neg = ~reading_busy & reading_busy_ff1;

    always@(posedge clk)begin
        reading_busy_ff1 <= reading_busy;
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            choose <= 0;
        end
        else if(reading_busy_neg)begin
            choose <= ~choose;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            weight_vld <= 0;
        end
        else if(processing_en)begin
            weight_vld <= 0;
        end
        else if(reading_busy_neg)begin
            weight_vld <= 1;
        end
    end

    // assign rd_choose = ~choose;
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            rd_choose <= 0;
        end
        else if(processing_en)begin
            rd_choose <= ~choose;
        end
    end
    // Xilinx Block RAM
    // WEIGHT_BUFFER U_WEIGHT_BUFFER_0 (
    //     .clka(clk),    // input wire clka
    //     .ena(ena),      // input wire ena
    //     .wea(wea),      // input wire [0 : 0] wea
    //     .addra(addra),  // input wire [12 : 0] addra
    //     .dina(dina),    // input wire [2303 : 0] dina
    //     .douta(douta)  // output wire [2303 : 0] douta
    // );

    // WEIGHT_BUFFER U_WEIGHT_BUFFER_0 (
    //     .clka(clk),    // input wire clka
    //     .ena(ena),      // input wire ena
    //     .wea(wea),      // input wire [0 : 0] wea
    //     .addra(addra),  // input wire [12 : 0] addra
    //     .dina(dina),    // input wire [2303 : 0] dina
    //     .douta(douta)  // output wire [2303 : 0] douta
    // );

    always@(posedge clk)begin
        if(w_en && choose == 0)begin
            weight_mem_0[w_addr] <= buffer;
        end
    end

    always@(posedge clk)begin
        if(w_en && choose == 1)begin
            weight_mem_1[w_addr] <= buffer;
        end
    end

    always@(posedge clk)begin
        if(rd_weight_en_ddr)begin
            rd_weight_ddr <= rd_choose == 0 ? weight_mem_0[rd_weight_addr_ddr] : weight_mem_1[rd_weight_addr_ddr];
        end
    end

endmodule