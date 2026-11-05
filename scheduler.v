module SCHEDULER(
    input wire          clk                     ,
    input wire          rst_n                   ,

    input wire          processing_en           ,
    input wire          event_valid             ,
    output wire         event_fetch_en          ,
    input wire  [41:0]  event_info              ,
    input wire          can_receive_weight_top  ,
    input wire          event_check_finish      ,

    // output
    output wire         event_info_vld_to_w     ,
    output wire [41:0]  event_info_to_w         ,
    output wire         one_position_finish     

);

    reg fifo_read;
    reg event_info_vld;
    reg buffer_vld;
    reg in_processing;
    reg [41:0] buffer_info;
        
    wire new_row_col = event_info[41];// & event_valid;

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            in_processing <= 1'b0;
        end
        else if(event_info_vld)begin
            in_processing <= 1'b1;
        end
        else if(new_row_col || event_check_finish)begin
            in_processing <= 0;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            fifo_read <= 1'b0;
        end
        else if(~event_valid)begin
            fifo_read <= 1'b0;
        end
        else if(in_processing && new_row_col)begin
            fifo_read <= 1'b0;
        end
        else if(event_valid && in_processing)begin
            fifo_read <= 1'b1;
        end
        else if((event_valid || buffer_vld) && can_receive_weight_top)begin
            fifo_read <= 1'b1;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            event_info_vld <= 0;
        end
        else if(new_row_col & in_processing)begin
            event_info_vld <= 0;
        end
        // else if(can_receive_weight_top && buffer_vld)begin
        //     event_info_vld <= 1;
        // end
        else begin
            event_info_vld <= event_fetch_en || (fifo_read && buffer_vld);
        end
    end

    assign event_fetch_en = event_valid & fifo_read & ~(new_row_col & in_processing) & ~buffer_vld;

    //buffer
    // reg [41:0] buffer_info;
    reg event_check_finish_ff1, event_check_finish_ff2;
    wire event_check_finish_pos;
    always@(posedge clk or negedge rst_n)begin
        if(rst_n == 1'b0)begin
            buffer_vld <= 0;
        end
        else if(buffer_info == event_info && buffer_vld)begin
            buffer_vld <= 0;
        end
        else if(new_row_col && in_processing)begin
            buffer_vld <= 1;
        end
        else if(fifo_read || event_check_finish_ff1)begin
            buffer_vld <= 0;
        end
    end

    

    assign event_check_finish_pos = event_check_finish_ff1 & ~event_check_finish_ff2;
    always@(posedge clk)begin
        event_check_finish_ff1 <= event_check_finish;
        event_check_finish_ff2 <= event_check_finish_ff1;
    end

    assign one_position_finish = (new_row_col & in_processing) || event_check_finish_pos;

    assign event_info_vld_to_w = event_info_vld && ~(new_row_col && in_processing);
    assign event_info_to_w     = event_info;

    always@(posedge clk)begin
        if(event_info_vld_to_w)begin
            buffer_info <= event_info_to_w;
        end
    end

endmodule