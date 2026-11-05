`timescale 1ns/1ps

module tb_top();
	reg clk;
	reg rst_n;
	reg Key_Signal;
	wire uart_tx;
	reg uart_rx;

	reg [7:0] uart_rx_get [0:16384];
	initial begin
		// $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/DVS_Gesture_P32/P32_T8/uart_send.txt",uart_rx_get);
//		$readmemh("C:/Python_Project/SNN_FPL/ST/model_preprocess/Config_files/uart_send.txt", uart_rx_get); 
	end
	always @(posedge clk)
	   if(inst_accelerator_top.U_LAYER_CTRL.layer_index == 8'd17) //check second layer
	       $finish; //end on 16th layer
    wire success = inst_accelerator_top.cal_finish;
//    reg [3:0] mp_delay_cnt;
//    reg printed_mp;
//    initial begin printed_mp = 0; mp_delay_cnt = 0; end

//    always @(posedge clk) begin
//        if (!printed_mp && inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_bias_mp_en) begin
//            mp_delay_cnt <= mp_delay_cnt + 1;
//        end
//        if (mp_delay_cnt == 3 && !printed_mp) begin
//            $display("[%0t] DECISION INPUTS for pixel(0,0) oc 0..7:", $time);
//            $display("  rd_mp: oc0=%h oc1=%h oc2=%h oc3=%h oc4=%h oc5=%h oc6=%h oc7=%h",
//                $signed(inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[7:0]),
//                $signed(inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[15:8]),
//                $signed(inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[23:16]),
//                $signed(inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[31:24]),
//                $signed(inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[39:32]),
//                $signed(inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[47:40]),
//                $signed(inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[55:48]),
//                $signed(inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[63:56]));
//            $display("  threshold (8 bits seen by MP_BIAS_ACC) = %0d  (full = %h)",
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.threshold,
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.threshold);
//            printed_mp <= 1;
//        end
//        if (mp_delay_cnt == 3 && !printed_mp) begin
//            $display("[%0t] DECISION INPUTS for pixel(0,0) oc 0..7:", $time);
//            $display("  rd_mp: oc0=%h oc1=%h oc2=%h oc3=%h oc4=%h oc5=%h oc6=%h oc7=%h",
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[7:0],
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[15:8],
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[23:16],
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[31:24],
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[39:32],
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[47:40],
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[55:48],
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.rd_mp[63:56]);
//            $display("  mp_addr in read_mp_bias = %h",
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.mp_addr);
//            $display("  bias_addr = %h",
//                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.bias_addr);
//            $display("  threshold = %0d", inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.threshold);
//            printed_mp <= 1;
//        end
//    end
    
    reg probe_done2;
    initial probe_done2 = 0;

    always @(posedge clk) begin
        if (!probe_done2 && inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.spike_wb_en) begin
            $display("[%0t] FIRST spike_wb_en:", $time);
            $display("  spike_wb_addr = %h",
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.spike_wb_addr);
            $display("  spike_wb_data[63:0]   = %h",
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.spike_wb_data[63:0]);
            $display("  spike_wb_data[127:64] = %h",
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.spike_wb_data[127:64]);
            $display("  bias_addr = %h",
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.bias_addr);
            $display("  mp_addr   = %h",
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MP_BIAS.mp_addr);
            probe_done2 <= 1'b1;
        end
    end
    
    reg [3:0] prev_multi_time;
    always @(posedge clk) begin
        if (inst_accelerator_top.U_NEURAL_PROC.U_READ_MEMBRANE_P.o_vld_from_weight_top) begin
            $display("[%0t] weight_top vld: oc_change_flag=%b  base_mp_addr_now=%h",
                $time,
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MEMBRANE_P.o_data_from_weight_top[1+144+9*8*64-1],
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MEMBRANE_P.base_mp_addr);
        end
    end
    always @(posedge clk) begin
        if (inst_accelerator_top.U_NEURAL_PROC.U_READ_MEMBRANE_P.bram_ena_0
            && inst_accelerator_top.U_NEURAL_PROC.U_READ_MEMBRANE_P.bram_addra < 16'd256) begin
            $display("[%0t] MP write to ocg0 region: addr=%h dina[7:0]=%h",
                $time,
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MEMBRANE_P.bram_addra,
                inst_accelerator_top.U_NEURAL_PROC.U_READ_MEMBRANE_P.bram_dina[7:0]);
        end
    end
   reg probe2_done;
    initial probe2_done = 0;
    always @(posedge clk) begin
        if (!probe2_done && $time > 110000) begin
           // $display("[%0t] max_vld_row_sel=%d max_vld_col_sel=%d",
          //      $time,
          //      inst_accelerator_top.U_NEURAL_PROC.U_WEIGHT_TOP.max_vld_row_sel,
         //      inst_accelerator_top.U_NEURAL_PROC.U_WEIGHT_TOP.max_vld_col_sel);
            probe2_done <= 1;
        end
    end

    // Track max self_row / self_col ever reached
    reg [7:0] max_self_row_seen, max_self_col_seen;
    initial begin max_self_row_seen = 0; max_self_col_seen = 0; end
    always @(posedge clk) begin
        if (inst_accelerator_top.U_NEURAL_PROC.U_WEIGHT_TOP.self_row_ff1 > max_self_row_seen)
            max_self_row_seen <= inst_accelerator_top.U_NEURAL_PROC.U_WEIGHT_TOP.self_row_ff1;
        if (inst_accelerator_top.U_NEURAL_PROC.U_WEIGHT_TOP.self_col_ff1 > max_self_col_seen)
            max_self_col_seen <= inst_accelerator_top.U_NEURAL_PROC.U_WEIGHT_TOP.self_col_ff1;
    end

    reg printed_max_seen;
    initial printed_max_seen = 0;
    always @(posedge clk) begin
        if (!printed_max_seen && $time > 112400) begin
            printed_max_seen <= 1;
        end
    end
    
    reg printed_diag;
    initial printed_diag = 0;
    always @(posedge clk) begin
        if (!printed_diag && $time > 50000) begin
            printed_diag <= 1'b1;
        end
    end
//     wire arest_n = inst_accelerator_top.arest_n;
//    wire success = inst_accelerator_top.inst_sim_top.inst_PE_cal_controller.state == 4;//6
//    wire success_0 = inst_accelerator_top.inst_sim_top.read_from_buffer_0;
	/////**  clk Generate **/////
	initial begin
		clk = 0;
	end

	always #(2.5) clk = ~clk;
	integer i;
	/////**  rst_n Generate **/////
	initial begin
		rst_n = 0;
		 Key_Signal = 1;
		#100;
		rst_n = 1;
		#100;
		
          @(posedge clk)begin
            Key_Signal <= 0;
          end
    
          @(posedge clk)begin
            Key_Signal <= 1;
          end
        
          @(posedge success)begin
                  $finish;
          end
		 @(posedge clk)begin
            for(i=0;i<12288;i=i+1)begin
                uart_tx_byte(uart_rx_get[i]);
            end
            uart_tx_byte(4);
        end
		// @(posedge clk)begin
		// 	Key_Signal <= 0;
		// end

		// @(posedge clk)begin
		// 	Key_Signal <= 1;
		// end
		
		@(posedge success)begin
		        $finish;
		end

		@(posedge clk)begin
            for(i=0;i<2048;i=i+1)begin //16rowx16colx8bytes=2048, before there were 12 bytes per pixell
                uart_tx_byte(uart_rx_get[i]);
            end
        end
		
		@(posedge success)begin
		      $finish;
		end
		// @(posedge clk)begin
		// 	Key_Signal <= 0;
		// end

		// @(posedge clk)begin
		// 	Key_Signal <= 1;
		// end
	end
	/////**  Function Signal define **/////
		///ddr port
	wire			RD_START;
	wire	[31:0]	RD_ADRS;
	wire	[31:0]	RD_LEN; 
	wire	[2 :0]	RD_SIZE;

	wire			RD_READY;
	wire			RD_FIFO_WE;
	wire	[255:0]	RD_FIFO_DATA;
	wire			RD_DONE;
	wire			RD_LAST;
    wire				WR_START;
	wire	[31:0]		WR_ADRS;
	wire	[31 :0]		WR_LEN;
	wire				WR_READY;
	wire				WR_FIFO_RE;
	wire	[255:0]		WR_FIFO_DATA;
	wire				WR_DONE;
	wire	[2:0]		WR_SIZE;
	wire	[31:0]		WR_STRB ;
	//////////////////////////////////////

	/////**  Top Module  **/////
	EVENT_PROCESSOR_TOP #(
    .parallel_metric(64),
    .ddr_data_width (256)
	)	
	inst_accelerator_top (
//		.clk_in_p(clk),
//		.clk_in_n(~clk), 
        .clk(clk),
		.rst_n(rst_n), 
		.Key_Signal(Key_Signal),
		.uart_tx(uart_tx),
		.uart_rx(uart_rx),
		.RD_START(RD_START),
		.RD_ADRS(RD_ADRS),
		.RD_LEN(RD_LEN), 
		.RD_SIZE(RD_SIZE),

		.RD_READY(RD_READY),
		.RD_FIFO_WE(RD_FIFO_WE),
		.RD_FIFO_DATA(RD_FIFO_DATA),
		.RD_DONE(RD_DONE),
		.RD_LAST(RD_LAST),

		.target_addr(0),
		.target_w_data(512'b0),
		.target_w_en(0)
		/*.WR_START 					 (WR_START),
		.WR_ADRS					 (WR_ADRS),
		.WR_LEN					     (WR_LEN),
		.WR_READY					 (WR_READY),
		.WR_FIFO_RE					 (WR_FIFO_RE),
		.WR_FIFO_DATA				 (WR_FIFO_DATA),
		.WR_DONE					 (WR_DONE),
		.WR_SIZE					 (WR_SIZE),
		.WR_STRB 					 (WR_STRB)*/
	);
	DDR_Read_256bit #(
		.ddr_data_width(256)
	)
	U_DDR_Read_256bit(
        .CLK          ( clk          ),
        .RST_N        ( rst_n          ),
        .RD_START     ( RD_START     ),
        .RD_ADDR      ( RD_ADRS      ),
        .RD_LEN       ( RD_LEN       ),
        .RD_DONE      ( RD_DONE      ),
        .RD_DATA_FIFO ( RD_FIFO_DATA ),
        .RD_FIFO_WE   ( RD_FIFO_WE   )
    );
	
//	initial begin
//		wait(success_0);
//		$dumpfile("E:/CPIPC/test.vcd");
//		$dumpvars();
//	end
//	SCNN_top inst_SCNN_top
//		(
//			.sys_clk_p  (clk),
//			.sys_clk_n  (!clk),
//			.sys_rst    (rst_n),
//			.Key_Signal (Key_Signal)
//		);


	//////////////////////////////////////

	/////**  Logic Part  **/////
	    task uart_tx_byte;
        input [7:0]tx_data;
        begin
            uart_rx = 1;
            #8680;
            uart_rx = 0;
            #8680;
            uart_rx = tx_data[0];
            #8680;
            uart_rx = tx_data[1];
            #8680;
            uart_rx = tx_data[2];
            #8680;
            uart_rx = tx_data[3];
            #8680;
            uart_rx = tx_data[4];
            #8680;
            uart_rx = tx_data[5];
            #8680;
            uart_rx = tx_data[6];
            #8680;
            uart_rx = tx_data[7];
            #8680;
            uart_rx = 1;
            #8680;         
        end
    endtask
    
	//////////////////////////////////////
	wire [7:0] layer_index = inst_accelerator_top.U_LAYER_CTRL.layer_index;
    wire [31:0] counter_ns = inst_accelerator_top.U_LAYER_CTRL.counter_ns;
    reg [7:0] layer_index_reg;
    integer latency_fd;
    reg [1023:0] latency_file;
    
    always@(posedge clk)begin
        layer_index_reg <= layer_index;
    end
    
    wire record_trigger = layer_index_reg != layer_index;
    
    initial begin
        latency_fd = $fopen("/home/yuehai/Sara_Thesis/artifacts/vgg16_layer_latency.txt", "w");
        if(latency_fd == 0)begin
            $display("ERROR latency file");
            $finish;
        end
        
        $fdisplay(latency_fd, "layer_index, counter_cycles (1 cycle is 5ns)");
    end
    
    always@(posedge clk)begin
        if(record_trigger)begin
            $fdisplay(latency_fd, "%d, %d", layer_index, counter_ns);
            $fflush(latency_fd);
        end
    end
    
    initial begin
        @(posedge success);
        #80;
        if(latency_fd != 0)begin
            $fclose(latency_fd);
        end
    end
endmodule