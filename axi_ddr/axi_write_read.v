module AXI_Write_Read#(
	parameter WIDTH = 256
	)(
	input  wire 		ARESETN,
	input  wire 		ACLK,

	//AXI Line
	//Read ADDR Channel
	output wire [3: 0] 	M_AXI_ARID,//
	output wire [31:0] 	M_AXI_ARADDR,//
	output wire [7: 0]  M_AXI_ARLEN,//
	output wire [2: 0]  M_AXI_ARSIZE,//
	output wire [1: 0]  M_AXI_ARBURST,//
	output wire [1: 0]  M_AXI_ARLOCK,//
	output wire [3: 0]  M_AXI_ARCACHE,//
	output wire [2: 0]  M_AXI_ARPROT,//
	output wire [3: 0]  M_AXI_ARQOS,////////
	output wire [0: 0]  M_AXI_ARUSER,///////
	output wire         M_AXI_ARVALID,
	input               M_AXI_ARREADY,
	//Read DATA Channel
	input  wire [0: 0]  M_AXI_RID,//
	input  wire [WIDTH-1:0]  M_AXI_RDATA,//
	input  wire [1: 0]  M_AXI_RRESP,//
	input  wire         M_AXI_RLAST,//
	input  wire [0: 0]  M_AXI_RUSER,//////////
	input  wire         M_AXI_RVALID,//
	output wire         M_AXI_RREADY,//
	//Write ADDR Channel
	output wire [3: 0]  M_AXI_AWID,//
	output wire [31:0]  M_AXI_AWADDR,//
	output wire [7: 0]  M_AXI_AWLEN,  //
	output wire [2: 0]  M_AXI_AWSIZE, //
	output wire [1: 0]  M_AXI_AWBURST,//
	output wire [1: 0]  M_AXI_AWLOCK, //
	output wire [3: 0]  M_AXI_AWCACHE, //
	output wire [2: 0]  M_AXI_AWPROT,  //
	output wire [3: 0]  M_AXI_AWQOS,/////////////
	output wire [0: 0]  M_AXI_AWUSER,////////////
	output wire         M_AXI_AWVALID,//
	input  wire         M_AXI_AWREADY,//
	//Write DATA Channel
	output wire [WIDTH-1:0]  M_AXI_WDATA,//
	output wire [31: 0] M_AXI_WSTRB,//
	output wire         M_AXI_WLAST,//
	output wire [0: 0]  M_AXI_WUSER,////////////////
	output wire         M_AXI_WVALID,//
	input  wire         M_AXI_WREADY,//
	//// Master Write Response
	input  wire [0: 0]  M_AXI_BID,
	input  wire [1: 0]  M_AXI_BRESP,
	input  wire [0: 0]  M_AXI_BUSER,/////////////
	input  wire         M_AXI_BVALID,
	output wire         M_AXI_BREADY,

	//User Interface Channel:READ
	input  wire         RD_START,
	input  wire [31:0]  RD_ADRS,
	input  wire [31:0]  RD_LEN, 
	output wire         RD_READY,
	output wire         RD_FIFO_WE,
	output wire [WIDTH-1:0]  RD_FIFO_DATA,
	output wire         RD_DONE,
	input  wire [2 :0]  RD_SIZE,
	output wire         RD_LAST,

	//User Interface Channel:WRITE
	input  wire         WR_START,
	input  wire [31:0]  WR_ADRS,
	input  wire [31:0]  WR_LEN, 
	output wire         WR_READY,
	output wire         WR_FIFO_RE,
	input  wire         WR_FIFO_EMPTY,
	input  wire         WR_FIFO_AEMPTY,
	input  wire [WIDTH-1:0]  WR_FIFO_DATA,
	output wire         WR_DONE,
	input  wire [2 :0]  WR_SIZE,
	input  wire [31 :0]  WR_STRB

	);

axi_master_read #(
	.WIDTH(WIDTH)
	) read
	(
	  .ARESETN(ARESETN),
	  .ACLK(ACLK),

	  .M_AXI_ARID(M_AXI_ARID),
	  .M_AXI_ARADDR(M_AXI_ARADDR),
	  .M_AXI_ARLEN(M_AXI_ARLEN),
	  .M_AXI_ARSIZE(M_AXI_ARSIZE),
	  .M_AXI_ARBURST(M_AXI_ARBURST),
	  .M_AXI_ARLOCK(M_AXI_ARLOCK),
	  .M_AXI_ARCACHE(M_AXI_ARCACHE),
	  .M_AXI_ARPROT(M_AXI_ARPROT),
	  .M_AXI_ARQOS(),
	  .M_AXI_ARUSER(),
	  .M_AXI_ARVALID(M_AXI_ARVALID),
	  .M_AXI_ARREADY(M_AXI_ARREADY),
	    
	  // Master Read Data 
	  .M_AXI_RID(M_AXI_RID),
	  .M_AXI_RDATA(M_AXI_RDATA),
	  .M_AXI_RRESP(M_AXI_RRESP),
	  .M_AXI_RLAST(M_AXI_RLAST),
	  .M_AXI_RUSER(),
	  .M_AXI_RVALID(M_AXI_RVALID),
	  .M_AXI_RREADY(M_AXI_RREADY),
	       
	  .RD_START(RD_START),
	  .RD_ADRS(RD_ADRS),
	  .RD_LEN(RD_LEN), 
	  .RD_READY(RD_READY),
	  .RD_FIFO_WE(RD_FIFO_WE),
	  .RD_FIFO_DATA(RD_FIFO_DATA),
	  .RD_DONE(RD_DONE),
	  .RD_SIZE(RD_SIZE),
	  .RD_LAST(RD_LAST)
	);

axi_master_write #(
	.WIDTH(WIDTH)
	)write
(
	  .ARESETN(ARESETN),
	  .ACLK(ACLK),

	  .M_AXI_AWID(M_AXI_AWID),
	  .M_AXI_AWADDR(M_AXI_AWADDR),
	  .M_AXI_AWLEN(M_AXI_AWLEN),    // Burst Length: 0-255
	  .M_AXI_AWSIZE(M_AXI_AWSIZE),   // Burst Size: Fixed 2'b011
	  .M_AXI_AWBURST(M_AXI_AWBURST),  // Burst Type: Fixed 2'b01(Incremental Burst)
	  .M_AXI_AWLOCK(M_AXI_AWLOCK),   // Lock: Fixed 2'b00
	  .M_AXI_AWCACHE(M_AXI_AWCACHE),  // Cache: Fiex 2'b0011
	  .M_AXI_AWPROT(M_AXI_AWPROT),   // Protect: Fixed 2'b000
	  .M_AXI_AWQOS(),    // QoS: Fixed 2'b0000
	  .M_AXI_AWUSER(),   // User: Fixed 32'd0
	  .M_AXI_AWVALID(M_AXI_AWVALID),
	  .M_AXI_AWREADY(M_AXI_AWREADY),

	  // Master Write Data
	  .M_AXI_WDATA(M_AXI_WDATA),
	  .M_AXI_WSTRB(M_AXI_WSTRB),
	  .M_AXI_WLAST(M_AXI_WLAST),
	  .M_AXI_WUSER(),
	  .M_AXI_WVALID(M_AXI_WVALID),
	  .M_AXI_WREADY(M_AXI_WREADY),
	  
	  // Master Write Response
	  .M_AXI_BID(M_AXI_BID),
	  .M_AXI_BRESP(M_AXI_BRESP),
	  .M_AXI_BUSER(),
	  .M_AXI_BVALID(M_AXI_BVALID),
	  .M_AXI_BREADY(M_AXI_BREADY),
	  
	  .WR_START(WR_START),
	  .WR_ADRS(WR_ADRS),
	  .WR_LEN(WR_LEN), 
	  .WR_READY(WR_READY),
	  .WR_FIFO_RE(WR_FIFO_RE),
	  .WR_FIFO_EMPTY(WR_FIFO_EMPTY),
	  .WR_FIFO_AEMPTY(WR_FIFO_AEMPTY),
	  .WR_FIFO_DATA(WR_FIFO_DATA),
	  .WR_DONE(WR_DONE),
	  .WR_SIZE(WR_SIZE),
	  .WR_STRB(WR_STRB)
);

endmodule