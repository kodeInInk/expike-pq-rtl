module ELASTIC_FIFO#(
	parameter DATA_WIDTH = 32
	)(
	input wire 							clk 	,
	input wire 							rst_n 	,


	// input hand shake
	output wire  						i_ready ,
	input  wire 						i_vld   ,
	/// data
	input  wire [DATA_WIDTH - 1 : 0] 	i_data  ,

	// output hand shake
	output wire 						o_vld 	,
	input  wire  						o_ready ,
	/// data
	output wire [DATA_WIDTH - 1 : 0]    o_data   

	);

	reg [2*DATA_WIDTH - 1 : 0] 	fifo    	;
	reg [1:0] 					cnt			;

	wire     					wr_en 		;
	wire  						rd_en       ;

	assign wr_en = i_ready & i_vld			;
	assign rd_en = o_vld   & o_ready        ;

	always@(posedge clk or negedge rst_n) begin
		if(rst_n == 1'b0)begin
			cnt <= 2'b00;
		end
		else begin
			case({wr_en,rd_en})
				2'b00, 2'b11: cnt <= cnt 	;
				2'b10		: cnt <= cnt + 1;
				2'b01		: cnt <= cnt - 1;
				default     : cnt <= cnt   	;
			endcase
		end
	end

	assign i_ready = (cnt != 2'b10);
	assign o_vld   = (cnt != 2'b00);
	assign o_data  = fifo[DATA_WIDTH-1:0];

	// FIFO operation
	always@(posedge clk)begin
		// if(wr_en == 1'b1 && rd_en == 1'b1)begin
		// 	fifo <= {i_data,fifo[2*DATA_WIDTH - 1 -: DATA_WIDTH]}
		// end
		// else if(wr_en == 1'b1)begin
		// 	fifo <= {i_data,fifo[2*DATA_WIDTH - 1 -: DATA_WIDTH]};
		// end
		// else if(rd_en == 1'b1)begin
		// 	fifo <= {i_data,fifo[2*DATA_WIDTH - 1 -: DATA_WIDTH]};
		// end
		if ((wr_en == 1'b1 && rd_en == 1'b1))begin
			if(cnt == 1)begin
				fifo <= {fifo[2*DATA_WIDTH - 1 -: DATA_WIDTH],i_data};
			end
			else begin
				fifo <= {i_data,fifo[2*DATA_WIDTH - 1 -: DATA_WIDTH]};
			end
		end
		else if (rd_en == 1'b1)begin
			fifo <= {i_data,fifo[2*DATA_WIDTH - 1 -: DATA_WIDTH]};
		end
		else if(wr_en == 1'b1)begin
			case(cnt)
				0: fifo[DATA_WIDTH - 1:0] <= i_data;
				1: fifo[2*DATA_WIDTH - 1 -: DATA_WIDTH] <= i_data;
				default:;
			endcase
		end

	end

endmodule

// module ELASTIC_FIFO #(
//     parameter DATA_WIDTH = 32,
//     parameter DEPTH      = 8          // 新增：FIFO深度，可配置（建议为2的幂次，便于综合）
// )(
//     input  wire                      clk,
//     input  wire                      rst_n,

//     // Input handshake
//     output wire                      i_ready,
//     input  wire                      i_vld,
//     input  wire [DATA_WIDTH-1:0]     i_data,

//     // Output handshake
//     output wire                      o_vld,
//     input  wire                      o_ready,
//     output wire [DATA_WIDTH-1:0]     o_data
// );

//     // ------------------ 参数计算 ------------------
//     localparam ADDR_WIDTH = $clog2(DEPTH);   // 地址位宽

//     // ------------------ 内部信号 ------------------
//     reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];   // RAM风格存储器

//     reg [ADDR_WIDTH-1:0] wptr;   // 写指针
//     reg [ADDR_WIDTH-1:0] rptr;   // 读指针
//     reg [ADDR_WIDTH:0]   cnt;    // 数据计数器（范围0~DEPTH）

//     wire wr_en = i_ready & i_vld;
//     wire rd_en = o_vld   & o_ready;

//     // ------------------ 握手信号 ------------------
//     assign i_ready = (cnt != DEPTH);           // 未满即可写入
//     assign o_vld   = (cnt != 0);               // 有数据即可读出
//     assign o_data  = fifo_mem[rptr];           // 读数据直接从RAM取出

//     // ------------------ 指针与计数器更新 ------------------
//     always @(posedge clk or negedge rst_n) begin
//         if (!rst_n) begin
//             wptr <= 0;
//             rptr <= 0;
//             cnt  <= 0;
//         end
//         else begin
//             case ({wr_en, rd_en})
//                 2'b00: begin /* 无操作 */ end
//                 2'b01: begin // 只读
//                     rptr <= (rptr == DEPTH-1) ? 0 : rptr + 1;
//                     cnt  <= cnt - 1;
//                 end
//                 2'b10: begin // 只写
//                     wptr <= (wptr == DEPTH-1) ? 0 : wptr + 1;
//                     cnt  <= cnt + 1;
//                 end
//                 2'b11: begin // 同时读写（指针同时移动）
//                     wptr <= (wptr == DEPTH-1) ? 0 : wptr + 1;
//                     rptr <= (rptr == DEPTH-1) ? 0 : rptr + 1;
//                     // cnt 保持不变
//                 end
//             endcase
//         end
//     end

//     // ------------------ RAM 写操作 ------------------
//     always @(posedge clk) begin
//         if (wr_en) begin
//             fifo_mem[wptr] <= i_data;
//         end
//     end

// endmodule