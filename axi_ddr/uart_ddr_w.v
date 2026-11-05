module uart_ddr_w#(
	parameter ddr_data_width = 256
)(
	input wire clk,
	input wire rst_n,
	input wire [7:0] uart_rece_data,
	input wire 		 uart_rece_data_valid,
	output reg 		one_time_is_ok,

	//ddr port
	output wire 	   WR_START,
	output wire [31:0] WR_ADRS,
	output wire [31 :0] WR_LEN,
	input wire 		   WR_READY,
	input wire 		   WR_FIFO_RE,
	output wire [ddr_data_width-1:0] WR_FIFO_DATA,
	input wire 		   WR_DONE,
	output wire [2:0]  WR_SIZE,
	output wire [31:0]	   WR_STRB 

);

	reg [ddr_data_width-1:0] buffer_data;
	reg 		buffer_en;
	reg [15:0] buffer_counter;

	wire [15:0] aim_nums = ddr_data_width == 256 ? 31 : 15;

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			buffer_counter <= 0;
			buffer_en <= 0;
		end
		else if(uart_rece_data_valid)begin
			if(buffer_counter == aim_nums)begin
				buffer_counter <= 0;
				buffer_en <= 1;
			end
			else begin
				buffer_counter <= buffer_counter + 1;
				buffer_en <= 0;
			end
		end
		else begin
			buffer_en <= 0;
		end
	end

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			buffer_data <= 0;
		end
		else if(uart_rece_data_valid)begin
			buffer_data <= {uart_rece_data, buffer_data[ddr_data_width-1:8]};
		end
	end

	wire empty;
	wire full;
	wire [ddr_data_width-1:0] data_out;

	// generate
	localparam fifo_depth =
    (ddr_data_width == 128) ? 64 :
    (ddr_data_width == 256) ? 32 : 32;

	localparam fifo_depth_addr = $clog2(fifo_depth);

	// reg [15:0] fifo_depth, fifo_depth_addr;
	// always@(*)begin
	// 	case(ddr_data_width)
	// 		128: begin fifo_depth = 64; fifo_depth_addr = 6; end
	// 		256: begin fifo_depth = 32; fifo_depth_addr = 5; end
	// 		default: begin fifo_depth = 32; fifo_depth_addr = 5; end
	// 	endcase
	// end
	// endgenerate

	FIFO #(
		.width(ddr_data_width),
		.depth(fifo_depth),
		.depth_addr(fifo_depth_addr)
	) inst_fifo (
		.clk            (clk),
		.rst_n          (rst_n),
		.push_req_n     (!buffer_en),
		.pop_req_n      (!WR_FIFO_RE),
		.data_in        (buffer_data),
		.empty          (empty),
		.full           (full),
		.data_out       (data_out)//,
//		.data_out_next  (),
//		.in_fc_fifo_cnt ()
	);
    
	reg [6:0] state;
	reg       ddr_wr_start;
	(* mark_debug="true" *)reg [31:0] ddr_wr_addr;
	
	assign WR_START 	= ddr_wr_start;
	assign WR_ADRS 		= ddr_wr_addr;
	assign WR_FIFO_DATA = data_out;
	assign WR_LEN       = 32;
	assign WR_SIZE      = ddr_data_width == 256 ? 3'b101 : 3'b100;
	assign WR_STRB 		= {32{1'b1}};//8'b11111111;

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			state <= 0;
			ddr_wr_start <= 0;
			one_time_is_ok <= 0;
		end
		else begin
			ddr_wr_start <= 0;
			one_time_is_ok <= 0;
			case(state)
				0:begin
					if(full)begin
						state <= 1;
					end
				end

				1:begin
					if(WR_READY)begin
						ddr_wr_start <= 1;
						state <= 2;
					end
				end

				2:begin
					if(WR_DONE)begin
						state <= 3;
						one_time_is_ok <= 1;
					end
				end

				3:begin
					state <= 0;
				end
			endcase
		end
	end

	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			ddr_wr_addr <= 32'h00000000;
		end
		else if(WR_DONE)begin
			ddr_wr_addr <= ddr_wr_addr + 1024;
		end
	end

endmodule
 