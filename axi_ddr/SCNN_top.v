module SCNN_top(
    //ddr3 memory port
	inout	[63:0]	ddr3_dq,
	inout	[7:0]	ddr3_dqs_n,
	inout	[7:0]	ddr3_dqs_p,
	output	[14:0]	ddr3_addr,
	output	[2:0]	ddr3_ba,
	output			ddr3_ras_n,
	output			ddr3_cas_n,
	output			ddr3_we_n,
	output			ddr3_reset_n,
	output	[1:0]	ddr3_ck_p,
	output	[1:0]	ddr3_ck_n,
	output	[1:0]	ddr3_cke,
	output	[1:0]	ddr3_cs_n,
	output	[7:0]	ddr3_dm,
	output	[1:0]	ddr3_odt,

	input			sys_clk_p,
	input			sys_clk_n,
	input			sys_rst,

	// output 			uart_tx_ddr,
	// input   		uart_rx_ddr,

	output   		uart_tx,
	input 			uart_rx,
	
	input           Key_Signal,
	output  		dummpy_pin
	
);	
	parameter WIDTH = 256;
	parameter PARALLEL = 32;

	wire [3: 0] 	M_AXI_ARID;//
	wire [31:0] 	M_AXI_ARADDR;//
	wire [7: 0]  M_AXI_ARLEN;//
	wire [2: 0]  M_AXI_ARSIZE;//
	wire [1: 0]  M_AXI_ARBURST;//
	wire [1: 0]  M_AXI_ARLOCK;//
	wire [3: 0]  M_AXI_ARCACHE;//
	wire [2: 0]  M_AXI_ARPROT;//
	wire [3: 0]  M_AXI_ARQOS;////////
	wire [0: 0]  M_AXI_ARUSER;///////
	wire         M_AXI_ARVALID;
	wire             M_AXI_ARREADY;
	//Read DATA Channel
	wire [0: 0]  M_AXI_RID;//
	wire [WIDTH-1:0]  M_AXI_RDATA;//
	wire [1: 0]  M_AXI_RRESP;//
	wire         M_AXI_RLAST;//
	wire [0: 0]  M_AXI_RUSER;//////////
	wire         M_AXI_RVALID;//
	wire         M_AXI_RREADY;//
	//Write ADDR Channel
	wire [3: 0]  M_AXI_AWID;//
	wire [31:0]  M_AXI_AWADDR;//
	wire [7: 0]  M_AXI_AWLEN;  //
	wire [2: 0]  M_AXI_AWSIZE; //
	wire [1: 0]  M_AXI_AWBURST;//
	wire [1: 0]        M_AXI_AWLOCK; //
	wire [3: 0]  M_AXI_AWCACHE; //
	wire [2: 0]  M_AXI_AWPROT;  //
	wire [3: 0]  M_AXI_AWQOS;/////////////
	wire [0: 0]  M_AXI_AWUSER;////////////
	wire         M_AXI_AWVALID;//
	wire         M_AXI_AWREADY;//
	//Write DATA Channel
	wire [WIDTH-1:0]  M_AXI_WDATA;//
	wire [31: 0]  M_AXI_WSTRB;//
	wire         M_AXI_WLAST;//
	wire [0: 0]  M_AXI_WUSER;////////////////
	wire         M_AXI_WVALID;//
	wire         M_AXI_WREADY;//
	//// Master Write Response
	wire [0: 0]  M_AXI_BID;
	wire [1: 0]  M_AXI_BRESP;
	wire [0: 0]  M_AXI_BUSER;/////////////
	wire         M_AXI_BVALID;
	wire         M_AXI_BREADY;

	//User Interface Channel:READ
	wire         RD_START;
	wire [31:0]  RD_ADRS;
	wire [31:0]  RD_LEN; 
	wire         RD_READY;
	wire         RD_FIFO_WE;
	wire [WIDTH-1:0]  RD_FIFO_DATA;
	wire         RD_DONE;
	wire [2 :0]  RD_SIZE;
	wire         RD_LAST;

	//User Interface Channel:WRITE
	wire         WR_START;
	wire [31:0]  WR_ADRS;
	wire [31:0]  WR_LEN; 
	wire         WR_READY;
	wire         WR_FIFO_RE;
	wire         WR_FIFO_EMPTY;
	wire         WR_FIFO_AEMPTY;
	wire [WIDTH-1:0]  WR_FIFO_DATA;
	wire         WR_DONE;
	wire [2 :0]  WR_SIZE;
	wire [31 :0]  WR_STRB;
	wire 			init_calib_complete;
	wire			ui_clk;
    wire			ui_clk_sync_rst;
    wire			mmcm_locked;
    wire			app_sr_req;
    wire			app_ref_req;
    wire			app_zq_req;
    wire			app_sr_active;
    wire			app_ref_ack;
    wire			app_zq_ack;
	wire 			clk;
    wire [7:0] 		rx_data;
	wire       		po_flag;
	wire       		one_time_is_ok;
	wire   			Tx_done;

	reg [31:0] cnt;
	always@(posedge clk or negedge sys_rst)begin
		if(sys_rst == 0)begin
			cnt <= 0;
		end
		else begin
			cnt <= cnt + 1;
		end
	end

	
	assign clk = ui_clk;
	wire choose;

	//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
	vio_0 your_instance_name (
	.clk(clk),                // input wire clk
	.probe_out0(choose)  // output wire [0 : 0] probe_out0
	);

	wire uart_tx_spike;
	wire uart_rx_spike;
	wire uart_tx_weight;
	wire uart_rx_weight;

	assign uart_tx = choose == 0 ? uart_tx_weight : uart_tx_spike;
	assign uart_rx_spike = choose == 1 ? uart_rx : 1'b1;
	assign uart_rx_weight = choose == 0 ? uart_rx : 1'b1;
	
	EVENT_PROCESSOR_TOP #(
		.parallel_metric(PARALLEL),
		.ddr_data_width (WIDTH)
	) U_EVENT_PROCESSOR_TOP (
		// .clk_in_p     (clk_in_p),
		// .clk_in_n     (clk_in_n),
		.clk 		  (clk),
		.rst_n        (sys_rst),
		.uart_tx      (uart_tx_spike),
		.uart_rx      (uart_rx_spike),
		.Key_Signal   (Key_Signal),
		.RD_START     (RD_START),
		.RD_ADRS      (RD_ADRS),
		.RD_LEN       (RD_LEN),
		.RD_SIZE      (RD_SIZE),
		.RD_READY     (RD_READY),
		.RD_FIFO_WE   (RD_FIFO_WE),
		.RD_FIFO_DATA (RD_FIFO_DATA),
		.RD_DONE      (RD_DONE),
		.RD_LAST      (RD_LAST),
		.dummpy_pin   (dummpy_pin)
	);

	input_uart_r inst_input_uart_r(
		.sclk(clk), 
		.s_rst_n(sys_rst), 
		.rx(uart_rx_weight), 
		.rx_data(rx_data), 
		.po_flag(po_flag)
	);

	reco_uart_send inst_reco_uart_send(
		.Clk      (clk),
		.Reset_n  (sys_rst),
		.Data     (8'h55),
		.Send_Go  (one_time_is_ok),
		.Baud_set (3'b100),
		.uart_tx  (uart_tx_weight),
		.Tx_done  (Tx_done)
	);

	uart_ddr_w #(
		.ddr_data_width(WIDTH)
	)
	inst_uart_ddr_w(
		.clk                  (clk),
		.rst_n                (sys_rst),
		.uart_rece_data       (rx_data),
		.uart_rece_data_valid (po_flag),
		.one_time_is_ok		  (one_time_is_ok),
		.WR_START             (WR_START),
		.WR_ADRS              (WR_ADRS),
		.WR_LEN               (WR_LEN),
		.WR_READY             (WR_READY),
		.WR_FIFO_RE           (WR_FIFO_RE),
		.WR_FIFO_DATA         (WR_FIFO_DATA),
		.WR_DONE              (WR_DONE),
		.WR_SIZE              (WR_SIZE),
		.WR_STRB              (WR_STRB)
	);

	AXI_Write_Read #(
		.WIDTH(WIDTH)
		)
	inst_AXI_Write_Read(
			.ARESETN        (sys_rst),
			.ACLK           (clk),
			.M_AXI_ARID     (M_AXI_ARID),
			.M_AXI_ARADDR   (M_AXI_ARADDR),
			.M_AXI_ARLEN    (M_AXI_ARLEN),
			.M_AXI_ARSIZE   (M_AXI_ARSIZE),
			.M_AXI_ARBURST  (M_AXI_ARBURST),
			.M_AXI_ARLOCK   (M_AXI_ARLOCK),
			.M_AXI_ARCACHE  (M_AXI_ARCACHE),
			.M_AXI_ARPROT   (M_AXI_ARPROT),
			.M_AXI_ARQOS    (M_AXI_ARQOS),
			.M_AXI_ARUSER   (M_AXI_ARUSER),
			.M_AXI_ARVALID  (M_AXI_ARVALID),
			.M_AXI_ARREADY  (M_AXI_ARREADY),
			.M_AXI_RID      (M_AXI_RID),
			.M_AXI_RDATA    (M_AXI_RDATA),
			.M_AXI_RRESP    (M_AXI_RRESP),
			.M_AXI_RLAST    (M_AXI_RLAST),
			.M_AXI_RUSER    (M_AXI_RUSER),
			.M_AXI_RVALID   (M_AXI_RVALID),
			.M_AXI_RREADY   (M_AXI_RREADY),
			.M_AXI_AWID     (M_AXI_AWID),
			.M_AXI_AWADDR   (M_AXI_AWADDR),
			.M_AXI_AWLEN    (M_AXI_AWLEN),
			.M_AXI_AWSIZE   (M_AXI_AWSIZE),
			.M_AXI_AWBURST  (M_AXI_AWBURST),
			.M_AXI_AWLOCK   (M_AXI_AWLOCK),
			.M_AXI_AWCACHE  (M_AXI_AWCACHE),
			.M_AXI_AWPROT   (M_AXI_AWPROT),
			.M_AXI_AWQOS    (M_AXI_AWQOS),
			.M_AXI_AWUSER   (M_AXI_AWUSER),
			.M_AXI_AWVALID  (M_AXI_AWVALID),
			.M_AXI_AWREADY  (M_AXI_AWREADY),
			.M_AXI_WDATA    (M_AXI_WDATA),
			.M_AXI_WSTRB    (M_AXI_WSTRB),
			.M_AXI_WLAST    (M_AXI_WLAST),
			.M_AXI_WUSER    (M_AXI_WUSER),
			.M_AXI_WVALID   (M_AXI_WVALID),
			.M_AXI_WREADY   (M_AXI_WREADY),
			.M_AXI_BID      (M_AXI_BID),
			.M_AXI_BRESP    (M_AXI_BRESP),
			.M_AXI_BUSER    (M_AXI_BUSER),
			.M_AXI_BVALID   (M_AXI_BVALID),
			.M_AXI_BREADY   (M_AXI_BREADY),
			.RD_START       (RD_START),
			.RD_ADRS        (RD_ADRS),
			.RD_LEN         (RD_LEN),
			.RD_READY       (RD_READY),
			.RD_FIFO_WE     (RD_FIFO_WE),
			.RD_FIFO_DATA   (RD_FIFO_DATA),
			.RD_DONE        (RD_DONE),
			.RD_SIZE        (RD_SIZE),
			.RD_LAST        (RD_LAST),
			.WR_START       (WR_START),
			.WR_ADRS        (WR_ADRS),
			.WR_LEN         (WR_LEN),
			.WR_READY       (WR_READY),
			.WR_FIFO_RE     (WR_FIFO_RE),
			.WR_FIFO_EMPTY  (WR_FIFO_EMPTY),
			.WR_FIFO_AEMPTY (WR_FIFO_AEMPTY),
			.WR_FIFO_DATA   (WR_FIFO_DATA),
			.WR_DONE        (WR_DONE),
			.WR_SIZE        (WR_SIZE),
			.WR_STRB        (WR_STRB)
		);

	ddr3a_controller u_ddr3a_controller (
    // Memory interface ports

    .ddr3_addr                      (ddr3_addr),  // output [14:0]		ddr3_addr
    .ddr3_ba                        (ddr3_ba),  // output [2:0]		ddr3_ba
    .ddr3_cas_n                     (ddr3_cas_n),  // output			ddr3_cas_n
    .ddr3_ck_n                      (ddr3_ck_n),  // output [1:0]		ddr3_ck_n
    .ddr3_ck_p                      (ddr3_ck_p),  // output [1:0]		ddr3_ck_p
    .ddr3_cke                       (ddr3_cke),  // output [1:0]		ddr3_cke
    .ddr3_ras_n                     (ddr3_ras_n),  // output			ddr3_ras_n
    .ddr3_reset_n                   (ddr3_reset_n),  // output			ddr3_reset_n
    .ddr3_we_n                      (ddr3_we_n),  // output			ddr3_we_n
    .ddr3_dq                        (ddr3_dq),  // inout [63:0]		ddr3_dq
    .ddr3_dqs_n                     (ddr3_dqs_n),  // inout [7:0]		ddr3_dqs_n
    .ddr3_dqs_p                     (ddr3_dqs_p),  // inout [7:0]		ddr3_dqs_p
    .init_calib_complete            (init_calib_complete),  // output			init_calib_complete
	.ddr3_cs_n                      (ddr3_cs_n),  // output [1:0]		ddr3_cs_n
    .ddr3_dm                        (ddr3_dm),  // output [7:0]		ddr3_dm

    .ddr3_odt                       (ddr3_odt),  // output [1:0]		ddr3_odt

    // Application interface ports 

    .ui_clk                         (ui_clk),  // output			ui_clk
    .ui_clk_sync_rst                (ui_clk_sync_rst),  // output			ui_clk_sync_rst
    .mmcm_locked                    (mmcm_locked),  // output			mmcm_locked
    .aresetn                        (sys_rst),  // input			aresetn
    .app_sr_req                     (1'b0),  // input			app_sr_req
    .app_ref_req                    (1'b0),  // input			app_ref_req
    .app_zq_req                     (1'b0),  // input			app_zq_req
    .app_sr_active                  (),  // output			app_sr_active
    .app_ref_ack                    (),  // output			app_ref_ack
    .app_zq_ack                     (),  // output			app_zq_ack

    // Slave Interface Write Address Ports

    .s_axi_awid                     (M_AXI_AWID),  // input [3:0]			s_axi_awid
    .s_axi_awaddr                   (M_AXI_AWADDR),  // input [31:0]			s_axi_awaddr
    .s_axi_awlen                    (M_AXI_AWLEN),  // input [7:0]			s_axi_awlen
    .s_axi_awsize                   (M_AXI_AWSIZE),  // input [2:0]			s_axi_awsize
    .s_axi_awburst                  (M_AXI_AWBURST),  // input [1:0]			s_axi_awburst
    .s_axi_awlock                   (M_AXI_AWLOCK),  // input [0:0]			s_axi_awlock
    .s_axi_awcache                  (M_AXI_AWCACHE),  // input [3:0]			s_axi_awcache
    .s_axi_awprot                   (M_AXI_AWPROT),  // input [2:0]			s_axi_awprot
    .s_axi_awqos                    (M_AXI_AWQOS),  // input [3:0]			s_axi_awqos
    .s_axi_awvalid                  (M_AXI_AWVALID),  // input			s_axi_awvalid
    .s_axi_awready                  (M_AXI_AWREADY),  // output			s_axi_awready

    // Slave Interface Write Data Ports

    .s_axi_wdata                    (M_AXI_WDATA),  // input [31:0]			s_axi_wdata
    .s_axi_wstrb                    (M_AXI_WSTRB),  // input [3:0]			s_axi_wstrb
    .s_axi_wlast                    (M_AXI_WLAST),  // input			s_axi_wlast
    .s_axi_wvalid                   (M_AXI_WVALID),  // input			s_axi_wvalid
    .s_axi_wready                   (M_AXI_WREADY),  // output			s_axi_wready

    // Slave Interface Write Response Ports

    .s_axi_bid                      (M_AXI_BID),  // output [3:0]			s_axi_bid
    .s_axi_bresp                    (M_AXI_BRESP),  // output [1:0]			s_axi_bresp
    .s_axi_bvalid                   (M_AXI_BVALID),  // output			s_axi_bvalid
    .s_axi_bready                   (M_AXI_BREADY),  // input			s_axi_bready

    // Slave Interface Read Address Ports

    .s_axi_arid                     (M_AXI_ARID),  // input [3:0]			s_axi_arid
    .s_axi_araddr                   (M_AXI_ARADDR),  // input [31:0]			s_axi_araddr
    .s_axi_arlen                    (M_AXI_ARLEN),  // input [7:0]			s_axi_arlen
    .s_axi_arsize                   (M_AXI_ARSIZE),  // input [2:0]			s_axi_arsize
    .s_axi_arburst                  (M_AXI_ARBURST),  // input [1:0]			s_axi_arburst
    .s_axi_arlock                   (M_AXI_ARLOCK),  // input [0:0]			s_axi_arlock
    .s_axi_arcache                  (M_AXI_ARCACHE),  // input [3:0]			s_axi_arcache
    .s_axi_arprot                   (M_AXI_ARPROT),  // input [2:0]			s_axi_arprot
    .s_axi_arqos                    (M_AXI_ARQOS),  // input [3:0]			s_axi_arqos
    .s_axi_arvalid                  (M_AXI_ARVALID),  // input			s_axi_arvalid
    .s_axi_arready                  (M_AXI_ARREADY),  // output			s_axi_arready

    // Slave Interface Read Data Ports

    .s_axi_rid                      (M_AXI_RID),  // output [3:0]			s_axi_rid
    .s_axi_rdata                    (M_AXI_RDATA),  // output [31:0]			s_axi_rdata
    .s_axi_rresp                    (M_AXI_RRESP),  // output [1:0]			s_axi_rresp
    .s_axi_rlast                    (M_AXI_RLAST),  // output			s_axi_rlast
    .s_axi_rvalid                   (M_AXI_RVALID),  // output			s_axi_rvalid
    .s_axi_rready                   (M_AXI_RREADY),  // input			s_axi_rready

    // System Clock Ports

    .sys_clk_p                       (sys_clk_p),  // input				sys_clk_p
    .sys_clk_n                       (sys_clk_n),  // input				sys_clk_n
    .sys_rst                        (sys_rst) // input sys_rst

    );


endmodule
 