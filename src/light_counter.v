//==============================================================================
// Module: light_counter
// Description: Countdown Timer for Traffic Light Duration
//              Decrements by 1 when enabled (1-second tick)
//              Reloads with new duration value when finished
// Author: Thuong Nguyen
//==============================================================================

module light_counter (
    input  wire       clk,          // System clock input
    input  wire       rst_n,        // Active-low asynchronous reset
    input  wire       en,           // Counter enable (1-second tick)
    input  wire [4:0] light_second, // Duration value from FSM
    output wire       finish,       // Timer finished flag (count == 0)
    output reg  [4:0] count         // Current countdown value
);

    //--------------------------------------------------------------------------
    // Counter Logic (Sequential)
    // Decrements on enable, reloads when finished
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 5'd18;                 // Reset to GREEN duration
        else if (finish && en)
            count <= light_second;          // Reload with new duration
        else begin
            if (en)
                count <= count - 1'b1;      // Decrement on 1-second tick
            else
                count <= count;             // Hold current value
        end
    end

    //--------------------------------------------------------------------------
    // Finish Flag Generation
    //--------------------------------------------------------------------------
    assign finish = (count == 5'd0);  // Asserted when countdown complete

endmodule
