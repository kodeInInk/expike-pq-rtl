module axi_master_read#(
  parameter WIDTH = 32)
(
  input           ARESETN,
  input           ACLK,

  output [3:0]  M_AXI_ARID,
  output [31:0] M_AXI_ARADDR,
  output [7:0]  M_AXI_ARLEN,
  output [2:0]  M_AXI_ARSIZE,
  output [1:0]  M_AXI_ARBURST,
  output [1:0]  M_AXI_ARLOCK,
  output [3:0]  M_AXI_ARCACHE,
  output [2:0]  M_AXI_ARPROT,
  output [3:0]  M_AXI_ARQOS,
  output [0:0]  M_AXI_ARUSER,
  output        M_AXI_ARVALID,
  input         M_AXI_ARREADY,
    
  // Master Read Data 
  input [0:0]   M_AXI_RID,
  input [WIDTH-1:0]  M_AXI_RDATA,
  input [1:0]   M_AXI_RRESP,
  input         M_AXI_RLAST,
  input [0:0]   M_AXI_RUSER,
  input         M_AXI_RVALID,
  output        M_AXI_RREADY,
       
  input         RD_START,
  input [31:0]  RD_ADRS,
  input [31:0]  RD_LEN, 
  output        RD_READY,
  output        RD_FIFO_WE,
  output [WIDTH-1:0] RD_FIFO_DATA,
  output reg    RD_DONE,
  input  [2:0]  RD_SIZE,
  output        RD_LAST
);
 
  localparam S_RD_IDLE  = 3'd0;
  localparam S_RA_WAIT  = 3'd1;
  localparam S_RA_START = 3'd2;
  localparam S_RD_WAIT  = 3'd3;
  localparam S_RD_PROC  = 3'd4;
  localparam S_RD_DONE  = 3'd5;
  
  reg [2:0]   rd_state;
  reg [31:0]  reg_rd_adrs;
  reg [31:0]  reg_rd_len;
  reg         reg_arvalid;
  reg [2:0]   reg_rd_size;
  // assign RD_DONE = (rd_state == S_RD_DONE) ;
  assign RD_LAST =  M_AXI_RLAST;
  // Read State
  always @(posedge ACLK or negedge ARESETN) begin
    if(!ARESETN) begin
      rd_state          <= S_RD_IDLE;
      reg_rd_adrs[31:0] <= 32'd0;
      reg_rd_len[31:0]  <= 32'd0;
      reg_arvalid       <= 1'b0;
      reg_rd_size       <= 3'd0;
    end else begin
      RD_DONE <= 0;
      case(rd_state)
        S_RD_IDLE: begin//0
          if(RD_START & !RD_DONE) begin
            reg_arvalid       <= 1'b1;
            rd_state          <= S_RD_WAIT;
            reg_rd_adrs[31:0] <= RD_ADRS[31:0];
            reg_rd_len[31:0]  <= RD_LEN[31:0] -32'd1;
            reg_rd_size       <= RD_SIZE;
          end
          else begin
            reg_arvalid     <= 1'b0;
          end
          
        end
        S_RD_WAIT: begin//3
          if(M_AXI_ARREADY) begin
            rd_state        <= S_RD_PROC;
            reg_arvalid     <= 1'b0;
          end
        end
        S_RD_PROC: begin//4
          if(M_AXI_RVALID) begin
            if(M_AXI_RLAST) begin
                rd_state<= S_RD_IDLE;
                RD_DONE <= 1;
            end
          end
        end
		// S_RD_DONE:begin
		// 	rd_state          <= S_RD_IDLE;
		// end
	  endcase
    end
  end
   
  // Master Read Address
  assign M_AXI_ARID         = 2'b00;
  assign M_AXI_ARADDR[31:0] = reg_rd_adrs[31:0];
  assign M_AXI_ARLEN[7:0]   = reg_rd_len[7:0];
  assign M_AXI_ARSIZE[2:0]  = reg_rd_size;
  assign M_AXI_ARBURST[1:0] = 2'b01;
  assign M_AXI_ARLOCK       = 1'b0;
  assign M_AXI_ARCACHE[3:0] = 4'b0000;
  assign M_AXI_ARPROT[2:0]  = 3'b000;
  assign M_AXI_ARQOS[3:0]   = 4'b0000;
  assign M_AXI_ARUSER[0]    = 1'b1;
  assign M_AXI_ARVALID      = reg_arvalid;

  assign M_AXI_RREADY       = M_AXI_RVALID;

  assign RD_READY           = (rd_state == S_RD_IDLE)?1'b1:1'b0;
  assign RD_FIFO_WE         = M_AXI_RVALID;
  assign RD_FIFO_DATA[WIDTH-1:0] = M_AXI_RDATA[WIDTH-1:0];
  
  endmodule