`timescale 1ns/1ps
module READ_MP_BIAS_V2(
    input wire          clk             ,
    input wire          rst_n           ,
    //nn_params
    input wire [15:0]   i_feature_map_len,
    input wire [15:0]   threshold       ,
    input wire [15:0]   i_channel_mult_time,
    input wire [15:0]   layer_bias_addr ,
    input wire          conv_code_layer_en,

    input wire          enable          ,
    input wire [511:0]  rd_mp           ,
    output wire         rd_mp_en        ,
    output wire [15:0]  rd_mp_addr      ,

    output wire         spike_wb_en     ,
    output reg  [15:0]  spike_wb_addr   ,
    output wire [511:0] spike_wb_data   ,
    output reg           conv_cal_done  ,

    // for multiple time step
    output wire          dst_wb_en      ,
    output reg  [15:0]   dst_wb_addr    ,
    output wire [511:0]  dst_wb_mp       
);

    reg [15:0] bias_addr;
    reg [15:0] mp_addr;
    reg [511:0] rd_bias;
    reg [15:0] base_mp_addr;
    reg [7:0]  multi_time;
    reg rd_bias_mp_en;
    reg check_finish;
    wire one_cal_finish;

    // assign conv_cal_done = check_finish;

    assign rd_mp_en = rd_bias_mp_en;
    assign rd_mp_addr = mp_addr;

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            rd_bias_mp_en <= 0;
        end
        else if(base_mp_addr == i_feature_map_len)begin//check_finish
            rd_bias_mp_en <= 0;
        end
        else if(enable)begin
            rd_bias_mp_en <= 1;
        end
    end
    
    // statge 1�? generate bias addr //// rd bias & mp
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            bias_addr <= 0;
        end
        else if(enable)begin
            bias_addr <= layer_bias_addr + multi_time;
        end
    end     

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            multi_time <= 0;
        end
        else if(one_cal_finish)begin
            if(multi_time == i_channel_mult_time - 1)
                multi_time <= 0;
            else
                multi_time <= multi_time + 1;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            conv_cal_done <= 0;
        end
        else if(one_cal_finish && multi_time == i_channel_mult_time - 1)begin
            conv_cal_done <= 1;
        end
        else begin
            conv_cal_done <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            base_mp_addr <= 0;
        end
        else if(conv_cal_done)begin
            base_mp_addr <= 0;
        end
        else if(rd_bias_mp_en)begin
            base_mp_addr <= base_mp_addr + 1;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            mp_addr <= 0;
        end
        else if(enable)begin
            mp_addr <= 0;
        end
        else if(rd_bias_mp_en)begin
            mp_addr <= mp_addr + 1;
        end
    end

    // Xilinx Block RAM Generation
    wire [511:0] bias_mem_dout;
    BIAS_MEM U_BIAS_MEM (
        .clka(clk),    // input wire clka
        .ena(rd_bias_mp_en),      // input wire ena
        .addra(bias_addr),  // input wire [6 : 0] addra
        .douta(bias_mem_dout)  // output wire [511 : 0] douta
        );
    always@(*)begin
        rd_bias = bias_mem_dout;
    end

    // reg [511:0] bias_mem [0:85];
    // initial begin
    //     // $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/test_bias.txt", bias_mem);
    //     $readmemh("C:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/test_bias_code_layer.txt", bias_mem);
    //     // $readmemh("c:/Sparity_SCNN_Design/SW/Python_Project/Sparsity_SCNN_Acceleration/SNN/Hardware/test_bias_layer_7.txt", bias_mem);
    // end
    // always@(posedge clk)begin
    //     if(rd_bias_mp_en)begin
    //         rd_bias <= bias_mem[bias_addr];
    //     end
    // end

    ///////////////////////MEM AREA////////////////////////////////////////

    // stage 2 & 3: add & check spike
    reg acc_en;
    reg check_spike;
    wire [511:0] res;
    wire [31:0] spike;

    always@(posedge clk)begin
        acc_en <= rd_bias_mp_en;
        check_spike <= acc_en;
    end

    genvar i;
    generate
        for(i=0;i<32;i=i+1)begin
            MP_BIAS_ACC U_MP_BIAS_ACC(
                .clk         ( clk                      ),
                .rst_n       ( rst_n                    ),
                .conv_code_layer_en (conv_code_layer_en ),
                .acc_en      ( acc_en                   ),   
                .src_mp      ( rd_mp[i*16 +: 16]        ),
                .bias        ( rd_bias[i*16 +: 16]      ),
                .res         ( res[i*16 +: 16]          ),
                .check_spike ( check_spike              ),
                .threshold   ( threshold                ),
                .spike       ( spike[i]                 ),
                .dst_mp      ( dst_wb_mp[i*16 +: 16]    )
            );
        end
    endgenerate

    reg [15:0] addr_ff1, addr_ff2;
    reg [15:0] spike_addr_ff1, spike_addr_ff2;
    always@(posedge clk)begin
        addr_ff1 <= rd_mp_addr;
        addr_ff2 <= addr_ff1;
        dst_wb_addr <= addr_ff2;
        spike_addr_ff1 <= base_mp_addr;
        spike_addr_ff2 <= spike_addr_ff1;
        spike_wb_addr <= spike_addr_ff2;
        spike_wb_en <= wb_spike_en;
    end

    // stage 4: save spike
    reg wb_spike_en;
    reg wb_spike_en_ff1;
    always@(posedge clk)begin
        wb_spike_en <= check_spike;
        wb_spike_en_ff1 <= wb_spike_en;
    end

    // assign spike_wb_en = wb_spike_en;
    assign spike_wb_data = {multi_time, spike};

    assign one_cal_finish = !wb_spike_en & wb_spike_en_ff1;

    assign dst_wb_en = wb_spike_en;

    //just for sim
    // reg [1023:0] spike_line;
    // reg [7:0] w_cnt;
    // reg [15:0] wb_real_spike_addr;
    // reg        wb_real_spike_en;
    // always@(posedge clk or negedge rst_n)begin
    //     if(rst_n == 1'b0)begin
    //         w_cnt <= 0;
    //         wb_real_spike_en <= 0;
    //     end
    //     else if(enable)begin
    //         w_cnt <= 0;
    //         wb_real_spike_en <= 0;
    //     end
    //     else if(wb_spike_en)begin
    //         if(w_cnt == i_channel_mult_time - 1)begin
    //             wb_real_spike_en <= 1;
    //             w_cnt <= 0;
    //         end
    //         else begin
    //             wb_real_spike_en <= 0;
    //             w_cnt <= w_cnt + 1;
    //         end
    //     end
    //     else begin
    //         wb_real_spike_en <= 0;
    //     end
    // end

    // always@(posedge clk or negedge rst_n)begin
    //     if(rst_n == 1'b0)begin
    //         wb_real_spike_addr <= 0;
    //     end
    //     else if(enable)begin
    //         wb_real_spike_addr <= 0;
    //     end
    //     else if(wb_real_spike_en)begin
    //         wb_real_spike_addr <= wb_real_spike_addr + 1;
    //     end
    // end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            spike_line <= 0;
        end
        else if(wb_spike_en)begin
            case(multi_time)
                0: spike_line[31: 0] <= spike;
                1: spike_line[63: 32] <= spike;
                2: spike_line[95: 64] <= spike;
                3: spike_line[127: 96] <= spike;
                4: spike_line[159: 128] <= spike;
                5: spike_line[191: 160] <= spike;
                6: spike_line[223: 192] <= spike;
                7: spike_line[255: 224] <= spike;
                8: spike_line[287: 256] <= spike;
                9: spike_line[319: 288] <= spike;
                10: spike_line[351: 320] <= spike;
                11: spike_line[383: 352] <= spike;
                12: spike_line[415: 384] <= spike;
                13: spike_line[447: 416] <= spike;
                14: spike_line[479: 448] <= spike;
                15: spike_line[511: 480] <= spike;
                default: spike_line <= spike_line;
            endcase
        end
        else begin
            spike_line <= {512{1'b1}};
        end
    end

    // always@(posedge clk or negedge rst_n)begin
    //     if(rst_n == 1'b0)begin
    //         check_finish <= 0;
    //     end
    //     else if(wb_real_spike_addr == i_feature_map_len - 1 && wb_real_spike_en)begin
    //         check_finish <= 1;
    //     end
    //     else begin
    //         check_finish <= 0;
    //     end
    // end

    // assign spike_wb_en   = wb_real_spike_en;
    // assign spike_wb_addr = wb_real_spike_addr;
    assign spike_wb_data = spike_line;

endmodule