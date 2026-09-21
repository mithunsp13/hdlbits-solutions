module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //
    
    reg [1:0] state,next_state;
    
    parameter [1:0] s0=2'd0,s1=2'd1,s2=2'd2,s3=2'd3;
    
    always @(*) begin
        case(state)
            s0: next_state = (in[3])?s1:s0;
            s1: next_state = s2;
            s2: next_state = s3;
            s3: next_state = (in[3])?s1:s0;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset)
            state<=s0;
        else
            state<=next_state;
    end
    
    assign done = &state;


    // State transition logic (combinational)

    // State flip-flops (sequential)
 
    // Output logic

endmodule