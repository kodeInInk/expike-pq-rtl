`timescale 1ns/1ps
module SPIKE_SIM(
    input wire                  clk,
    input wire                  rst_n,
    input wire  [ 7:0]          did_time_step ,
    input wire                  pooling_calculation_en,
    input wire  [ 7:0]          i_size                ,
    input wire  [ 7:0]          o_size,        
    input wire  [15:0]          rd_spike_addr   ,
    input wire                  rd_spike_en     ,
    output reg  [1023:0]        rd_spike        , // all in_channel

    input  wire                 spike_wb_en     ,
    input  wire [15:0]          spike_wb_addr   ,
    input  wire [1023:0]        spike_wb_data   ,

    //fc calculation
    input  wire                 fc_rd_en        ,
    input  wire [15:0]          fc_rd_addr      ,
    output wire [1023:0]        fc_rd_spike     ,
    output reg                  pooling_cal_done,

    //uart config
    input  wire	[1023:0]	    uart_combine_data,
	input  wire				    uart_combine_data_valid,
	input  wire	[15:0]		    uart_combine_w_addr
);

    reg [1023:0]    spike_mem [0:1023]          ;
    reg [1023:0]    spike_mem_t1 [0:1023]       ;
    // next layer is pooling
    reg             pooling_busy            ;
    reg  [1:0]      pooling_window_cnt      ;
    reg             update_row_col          ;
    reg  [7:0]      row, col                ;
    reg  [7:0]      src_row, src_col        ;
    wire [7:0]      double_row, double_col  ;
    reg             generate_raddr_en       ;
    reg  [15:0]     generate_raddr          ;
    reg             pooling_rd_en           ;
    reg             pooling_start           ;
    reg  [1:0]      p_cnt                   ;
    reg  [1023:0]   pooling_buffer          ;
    reg             pooling_wb_en           ;
    reg  [15:0]     pooling_wb_addr         ;

    wire            process_t0;
    wire            process_t1;

    assign fc_rd_spike = rd_spike;
    assign process_t0 = did_time_step == 0;
    assign process_t1 = did_time_step == 1;
    
    // Xilinx Block RAM
    wire rd_bram_en;
    reg [9:0] rd_bram_addr;
    wire [1023:0] bram_dout_t0, bram_dout_t1;

    always@(*)begin
        case({spike_wb_en, fc_rd_en, pooling_rd_en, rd_spike_en})
            4'b0001: begin rd_bram_addr = rd_spike_addr; end
            4'b0010: begin rd_bram_addr = generate_raddr; end
            4'b0100: begin rd_bram_addr = fc_rd_addr; end
            4'b1000: begin rd_bram_addr = spike_wb_addr; end
            default:begin rd_bram_addr = rd_spike_addr; end
        endcase
    end

    assign rd_bram_en = rd_spike_en | pooling_rd_en | fc_rd_en | spike_wb_en;

    // write back spike data
    reg [511:0] buffer_spike_wb, spike_wb_data_new;
    reg         spike_wb_en_ff1, spike_wb_en_ff2;
    reg [15:0]  spike_wb_addr_ff1, spike_wb_addr_ff2;

    always@(posedge clk)begin
        spike_wb_en_ff1 <= spike_wb_en;
        spike_wb_en_ff2 <= spike_wb_en_ff1;
        spike_wb_addr_ff1 <= spike_wb_addr;
        spike_wb_addr_ff2 <= spike_wb_addr_ff1;
        buffer_spike_wb <= spike_wb_data;
    end

    always@(posedge clk)begin
        if(spike_wb_en_ff1)
            spike_wb_data_new <= bram_dout_t0 & buffer_spike_wb;
    end

    INPUT_MAP U_INPUT_MAP_T0 (
    .clka(clk),    // input wire clka
    .ena((process_t0 & (spike_wb_en | pooling_wb_en)) || uart_combine_data_valid),      // input wire ena
    .wea((process_t0 & (spike_wb_en | pooling_wb_en)) || uart_combine_data_valid),      // input wire [0 : 0] wea
    .addra(uart_combine_data_valid ? uart_combine_w_addr : (spike_wb_en ? spike_wb_addr : pooling_wb_addr)),  // input wire [9 : 0] addra
    .dina(uart_combine_data_valid ? uart_combine_data : (spike_wb_en ? spike_wb_data : pooling_buffer)),    // input wire [1023 : 0] dina

    .clkb(clk),    // input wire clkb
    .enb(rd_bram_en),      // input wire enb
    .addrb(rd_bram_addr),  // input wire [9 : 0] addrb
    .doutb(bram_dout_t0)  // output wire [1023 : 0] doutb
    );

    // INPUT_MAP U_INPUT_MAP_T1 (
    // .clka(clka),    // input wire clka
    // .ena(process_t1 & (spike_wb_en | pooling_wb_en)),      // input wire ena
    // .wea(process_t1 & (spike_wb_en | pooling_wb_en)),      // input wire [0 : 0] wea
    // .addra(spike_wb_en ? spike_wb_addr : pooling_wb_addr),  // input wire [9 : 0] addra
    // .dina(spike_wb_en ? spike_wb_data : pooling_buffer),    // input wire [1023 : 0] dina

    // .clkb(clk),    // input wire clkb
    // .enb(rd_bram_en),      // input wire enb
    // .addrb(rd_bram_addr),  // input wire [9 : 0] addrb
    // .doutb(bram_dout_t1)  // output wire [1023 : 0] doutb
    // );

    always@(*)begin
        rd_spike = process_t0 ? bram_dout_t0 : bram_dout_t1;
    end
    //

    // initial begin
    //     // $readmemb("C:/Full_Event_Computing/input_map.txt",spike_mem);
    //     $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/Config_files/input_code_map.txt",spike_mem);
    //     $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/Config_files/input_code_map.txt",spike_mem_t1);
    //     // $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/Config_files/input_map.txt",spike_mem);
    //     // $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/Config_files/input_map_fc_layer.txt",spike_mem);
    //     // $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/Config_files/input_map_pooling_layer.txt", spike_mem);
    //     // $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/Config_files/input_map_layer_6.txt", spike_mem);
    // end

    // always@(posedge clk)begin
    //     if(rd_spike_en)begin
    //         rd_spike <= process_t0 ? spike_mem[rd_spike_addr] : spike_mem_t1[rd_spike_addr];
    //     end
    //     else if(pooling_rd_en)begin
    //         rd_spike <= process_t0 ? spike_mem[generate_raddr] : spike_mem_t1[generate_raddr];
    //     end
    //     else if(fc_rd_en)begin
    //         rd_spike <= process_t0 ? spike_mem[fc_rd_addr] : spike_mem_t1[fc_rd_addr];
    //     end
    // end

    // always@(posedge clk)begin
    //     if(spike_wb_en & process_t0)begin
    //         spike_mem[spike_wb_addr] <= spike_wb_data;
    //     end
    //     else if(pooling_wb_en & process_t0)begin
    //         spike_mem[pooling_wb_addr] <= pooling_buffer;
    //     end
    // end

    // always@(posedge clk)begin
    //     if(spike_wb_en & process_t1)begin
    //         spike_mem_t1[spike_wb_addr] <= spike_wb_data;
    //     end
    //     else if(pooling_wb_en & process_t1)begin
    //         spike_mem_t1[pooling_wb_addr] <= pooling_buffer;
    //     end
    // end

    // trace
    integer trace_ref;
    reg [511:0] trace_data;
    reg     debug_wb_err;
    wire [511:0] compare_data = spike_wb_en ? spike_wb_data[511:0] : pooling_buffer[511:0];

    initial begin
        trace_ref = $fopen("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/Config_files/trace_spike.txt", "r");
    end

    always @(posedge clk)
    begin 
        #1;
        if(spike_wb_en || pooling_wb_en)
        begin
            $fscanf(trace_ref, "%h", trace_data);
        end
    end

    always @(posedge clk)
    begin
        #2;
        if(!rst_n)
        begin
            debug_wb_err <= 1'b0;
        end
        else if(spike_wb_en || pooling_wb_en)
        begin
            if(compare_data[511:0] != trace_data)  begin
                $display("--------------------------ERROR----------------------------");
                $finish;
            end 
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            pooling_busy <= 0;
            pooling_cal_done <= 0;
        end
        else if(pooling_window_cnt == 3 && row == o_size - 1 && col == o_size - 1)begin
            pooling_busy <= 0;
            pooling_cal_done <= 1;
        end
        else if(pooling_calculation_en)begin
            pooling_busy <= 1;
            pooling_cal_done <= 0;
        end
        else begin
            pooling_cal_done <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            pooling_window_cnt <= 0;
        end
        else if(pooling_busy == 1'b1)begin
            pooling_window_cnt <= pooling_window_cnt + 1;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            update_row_col <= 0;
        end
        else if(pooling_window_cnt == 2)begin
            update_row_col <= 1;
        end
        else begin
            update_row_col <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            row <= 0;
        end
        else if(update_row_col)begin
            if(col == o_size - 1)begin
                row <= row == o_size - 1 ? 0 : row + 1;
            end
            else begin
                row <= row;
            end
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 0)begin
            col <= 0;
        end
        else if(update_row_col)begin
            if(col == o_size - 1)begin
                col <= 0;
            end
            else begin
                col <= col + 1;
            end
        end
    end

    assign double_row = row << 1;
    assign double_col = col << 1;

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            src_row <= 0;
            src_col <= 0;
        end
        else if(pooling_busy)begin
            case(pooling_window_cnt)
                2'd0: begin
                    src_row <= double_row;
                    src_col <= double_col;
                end
                2'd1:begin
                    src_row <= double_row;
                    src_col <= double_col + 1;
                end
                2'd2:begin
                    src_row <= double_row + 1;
                    src_col <= double_col;
                end
                2'd3:begin
                    src_row <= double_row + 1;
                    src_col <= double_col + 1;
                end
            endcase
        end     
    end

    // generate addr
    always@(posedge clk)begin
        generate_raddr_en <= pooling_busy;
    end

    always@(posedge clk)begin
        generate_raddr <= src_row * i_size + src_col;
    end

    // read spike memory
    
    always@(posedge clk)begin
        pooling_rd_en <= generate_raddr_en;
    end

    // pooling calculation
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            p_cnt <= 0;
        end
        else if(pooling_start)begin
            p_cnt <= p_cnt + 1;
        end
    end

    always@(posedge clk)begin
        pooling_start <= pooling_rd_en;
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            pooling_wb_en <= 0;
        end
        else if(p_cnt == 3)begin
            pooling_wb_en <= 1;
        end
        else begin
            pooling_wb_en <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            pooling_buffer <= 0;
        end
        else if(pooling_calculation_en)begin
            pooling_buffer <= 0;
        end
        else if(pooling_start)begin
            if(pooling_wb_en)begin
                pooling_buffer <= rd_spike;
            end
            else begin
                pooling_buffer <= pooling_buffer | rd_spike;
            end
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            pooling_wb_addr <= 0;
        end
        else if(pooling_calculation_en)begin
            pooling_wb_addr <= 0;
        end
        else if(pooling_wb_en)begin
            pooling_wb_addr <= pooling_wb_addr + 1;
        end
    end

endmodule