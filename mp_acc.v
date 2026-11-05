module MP_ACC(
    input wire clk,
    input wire acc_en,
    input wire [15:0] src_mp, //int4 weight,([-7,7]), 9*int4 =+-63, bias 8 bit signed; weight_acc+biat = [-128,127]
    input wire [15:0] weight, //4 bit weight but signed extended

    output reg [15:0] res // to match BRAM width (8*64=512 bits)

);
   wire signed [16:0] pre_acc = {src_mp[15], src_mp} + {weight[15], weight};
//    wire signed [16:0] pre_acc = $signed({src_mp[15], src_mp}) + $signed({weight[15], weight}); //update for lower bits
//    wire [8:0] pre_acc = {src_mp[7], src_mp} + {bias[7], bias}; //extended to account for 8 bit overflow on bit[8]
    wire p_carry = ~src_mp[15] & ~weight[15] & pre_acc[15]; //pos overflow, where both btis pos but 8bit result neg
    wire n_carry =  src_mp[15] &  weight[15] & ~pre_acc[15]; 
    always@(posedge clk)begin
        if(acc_en)begin
            // res <= src_mp + weight;
//            if (pre_acc > 'h180 & pre_acc[8]) // <-128
//                res <= 'h80;
//            else if (pre_acc > 'h07F & !pre_acc[8]) // >127
//                res <= 'h7F;
//            else 
//                res <= pre_acc[7:0];
            if(pre_acc > 127)
                res <= 16'h007F;
            else if(pre_acc < -128)
                res <= 16'hFF80;
            else
                res <= pre_acc[15:0];
        end
    end

endmodule