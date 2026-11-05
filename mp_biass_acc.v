module MP_BIAS_ACC(
    input wire clk,
    input wire rst_n,
    input wire conv_code_layer_en,
    input wire acc_en,
//    input wire [7:0] src_mp, //8 bit mp(weight acc)
//    input wire [7:0] bias, //8 bit bias

//    output reg [7:0] res, //8bit acc result
//    output wire [7:0] seg_mp_4compare, //8bit segmentation compare mp bais

//    input wire        check_spike,
//    input wire [7:0] threshold, //same range as mp
//    output reg        spike,
//    output reg [7:0] dst_mp //mp written bacl after fire reset
    input wire [15:0] src_mp,           // was [7:0]
    input wire [7:0] bias,              // unchanged
    output reg [15:0] res,              // was [7:0]
    output wire [15:0] seg_mp_4compare, // was [7:0]
    input wire        check_spike,
    input wire [3:0] exp,               // was [7:0] threshold; per-channel, threshold = 1<<exp
    output reg        spike,
    output reg [15:0] dst_mp            // was [7:0]
);
//    wire [8:0] pre_acc = {src_mp[7], src_mp} + {bias[7], bias}; //extended to account for 8 bit overflow on bit[8]
//    wire p_carry = ~src_mp[7] & ~bias[7] & pre_acc[7]; //pos overflow, where both btis pos but 8bit result neg
//    wire n_carry =  src_mp[7] &  bias[7] & ~pre_acc[7];  //neg overflow, where both inputs neg yet 8bit res pos
    wire [16:0] pre_acc = {src_mp[15], src_mp} + {{9{bias[7]}}, bias};
    wire p_carry = ~src_mp[15] & ~bias[7] & pre_acc[15];
    wire n_carry =  src_mp[15] &  bias[7] & ~pre_acc[15];
    
    always@(posedge clk)begin
        if(acc_en)begin
            //TODO: ask yuehai, this stuff is fixed point format
            //what r the 8-bit saturation limits for p_carry+n_carry in mp_biass_acc, conv_code_layer_en path/ non-code path
//            if(p_carry)begin
//                // res <= conv_code_layer_en ? 16'b0111111111000000 : 16'b0100000000000000;
//                res <= conv_code_layer_en ? 8'b01111111 : 8'b01111111; //!!!!!! TODO: confirm sat limit
//            end
//            else if(n_carry)begin
//                // res <= conv_code_layer_en ? 16'b1001000000000000 : 16'b1100000000000000;
//                res <= conv_code_layer_en ? 8'b10000000 : 8'b10000000; //!!!!!!!TODO: confirm sat limit p_carry neh
//            end
           if(p_carry)begin
                res <= conv_code_layer_en ? 16'h7FFF : 16'h7FFF;
            end
            else if(n_carry)begin
                res <= conv_code_layer_en ? 16'h8000 : 16'h8000;
            end
            else begin
                res <= pre_acc[15:0];
            end

            // if(conv_code_layer_en)begin
            //     if(p_carry)
            //         res <= 16'b0111111111000000;
            //     else if(n_carry)
            //         res <= 16'b1001000000000000;
            //     else begin
            //         res <= pre_acc;
            //     end
            // end
//            else begin
//                res <= pre_acc[7:0];//src_mp + bias;
//            end
        end
        else if(check_spike)begin
            res <= 0;
        end
    end

//    wire [7:0] div_2_res = {res[7],res[7:1]}; //division by 2(through right shift by 1)
    wire [15:0] thr = 16'b1 << exp; //per-channel threshold = 2^exp
    assign seg_mp_4compare = res;

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            spike <= 0;
        end
        else if(check_spike & res >= thr)begin
            spike <= res[15] == 0; //rest when spike pos???
        end
        else begin
            spike <= 0;
        end
    end

    always@(posedge clk)begin
        if(check_spike & res >= thr & ~res[15])begin
            dst_mp <= 0;
        end
        else begin
            dst_mp <= res; //no >>1 decay
        end
    end
//    assign seg_mp_4compare = res;

//    always@(posedge clk or negedge rst_n)begin
//        if(rst_n == 1'b0)begin
//            spike <= 0;
//        end
//        else if(check_spike & div_2_res >= threshold)begin
//            spike <= div_2_res[7] == 0; //rest when spike pos???
//        end
//        else begin
//            spike <= 0;
//        end
//    end

//    always@(posedge clk)begin
//        if(check_spike & div_2_res >= threshold & ~div_2_res[7])begin
//            dst_mp <= 0;
//        end
//        else begin
//            dst_mp <= div_2_res;
//        end
//    end
    
    integer acc_count;
    initial acc_count = 0;
    always@(posedge clk)begin
        if(acc_en)begin 
            acc_count <= acc_count + 1;
        end
        if(check_spike)begin
            acc_count <= 0;
        end
    end

endmodule