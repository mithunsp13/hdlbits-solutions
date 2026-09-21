module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

reg [2:0]cnt;
    reg[2:0] state,next_state;
    parameter [2:0] s0=3'd0,//idle state
    s1=3'd1,//data state,
    s2=3'd2,//stop state
    s3=3'd3,//done state
    s4=3'd4;//error state
    
    always @(*) begin
        case(state)
            s0: next_state = (in)?s0:s1;
            s1: next_state = (cnt==3'd7)?s2:s1;
            s2: next_state = (in)?s3:s4;
            s3: next_state = (in)?s0:s1;
            s4: next_state = (in)?s0:s4;
            default: next_state = s0;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            state<=s0;
            cnt<=3'd0;
            out_byte<=8'bxxxxxxxx;
        end
        else begin
            state<=next_state;
            cnt<=(next_state == s1 && state!=s1)?3'd0:(state==s1)?cnt+1:cnt;
            if(state==s1)
            out_byte<={in,out_byte[7:1]};
        end
    end
    
    assign done = (state==s3);

    // New: Datapath to latch input bits.

endmodule