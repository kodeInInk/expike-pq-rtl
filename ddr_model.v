module DDR_Read(
	input wire			CLK,
	input wire			RST_N,
	input wire			RD_START,
	input wire	[31:0]	RD_ADDR,
	input wire	[31:0]	RD_LEN,

	output reg			RD_DONE,
	output wire	[63:0]	RD_DATA_FIFO,
	output reg			RD_FIFO_WE
	);

	reg [63:0] weight [0:1566936];

	initial begin
        $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/layer1_weight_DDR.pat",weight);
	end

	reg [2:0] state,nextstate;
              
	reg [31:0] READ_LEN;
	reg [31:0] READ_ADDR;

	always@(posedge CLK or negedge RST_N)begin
		if(!RST_N)begin
			READ_ADDR <= 0;
			READ_LEN  <= 0;        
		end
		else if(RD_START)begin
			READ_LEN <= RD_LEN;
			READ_ADDR <= RD_ADDR[30:3];
		end
	end
	reg [31:0] READ_CNT;
	reg BRAM_Read;
	reg [31:0] BRAM_ADDR;
	always@(posedge CLK or negedge RST_N)begin
		if(!RST_N)begin
			state <= 0;
			READ_CNT <= 0;
			BRAM_Read <= 0;
		end
		else begin
		RD_DONE <= 0;
			case(state)
				0:if(RD_START)begin
					state <= 1;
					READ_CNT <= 0;
				end
				else begin
					state <= 0;
					READ_CNT <= 0;
				end
				1:begin
					if(READ_CNT == READ_LEN)begin
						state <= 0;
						RD_DONE <= 1;
						BRAM_Read <= 0;
					end
					else begin
						BRAM_Read <= 1;
						BRAM_ADDR <= READ_ADDR + READ_CNT;
						READ_CNT <= READ_CNT + 1;
					end
				end
			endcase
		end
	end

	reg [63:0] BRAM_DATA;
	always@(posedge CLK or negedge RST_N)begin
		if(!RST_N)begin
			BRAM_DATA <= 0;
			RD_FIFO_WE <= 0;
		end
		else if(BRAM_Read)begin
			BRAM_DATA <= weight[BRAM_ADDR];
			RD_FIFO_WE <= 1;
		end
		else begin
			BRAM_DATA <= 0;
			RD_FIFO_WE <= 0;
		end
	end

	assign RD_DATA_FIFO = BRAM_DATA;

endmodule