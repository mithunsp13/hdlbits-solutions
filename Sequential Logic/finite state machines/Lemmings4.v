module top_module(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
    reg [2:0] state, next_state;
    reg [4:0] count;
    reg       max;                                    // ← new

    localparam [2:0] left=3'd0, right=3'd1, fall_left=3'd2, fall_right=3'd3,
                     dig_left=3'd4, dig_right=3'd5, splat=3'd6;
    
    always @(*) begin
        case (state)
            left:       next_state = (~ground)?fall_left :(dig)?dig_left :(bump_left) ?right:left;
            right:      next_state = (~ground)?fall_right:(dig)?dig_right:(bump_right)?left :right;
            fall_left:  next_state = (ground)?left :fall_left;
            fall_right: next_state = (ground)?right:fall_right;
            dig_left:   next_state = (ground)?dig_left :fall_left;
            dig_right:  next_state = (ground)?dig_right:fall_right;
            splat:      next_state = splat;
            default:    next_state = left;
        endcase
    end
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= left;
            count <= 5'd0;
            max   <= 1'b0;
        end
        else begin
            state <= (max && ground) ? splat : next_state;

            if ((next_state == fall_left) || (next_state == fall_right)) begin
                count <= count + 5'd1;
                max   <= max | (count > 5'd19);       // ← sticky
            end
            else begin
                count <= 5'd0;
                max   <= 1'b0;
            end
        end
    end
    
    assign walk_left  = (state == left);
    assign walk_right = (state == right);
    assign aaah       = (state == fall_left) || (state == fall_right);
    assign digging    = (state == dig_left)  || (state == dig_right);

endmodule