//==============================================================================
// Module: second_counter
// Description: Clock Prescaler / 1-Second Tick Generator
//              Counts down from 99 to 0 when enabled
//              Generates single-cycle pulse when count reaches 0
// Author: Thuong Nguyen
//==============================================================================

module second_counter (
    input  wire clk,           // System clock input
    input  wire rst_n,         // Active-low asynchronous reset
    input  wire en,            // Counter enable signal
    output wire pre_last,      // Pre-last cycle indicator (count == 1)
    output wire second_finish  // 1-second tick pulse (count == 0)
);

    //--------------------------------------------------------------------------
    // Counter Register
    //--------------------------------------------------------------------------
    reg [6:0] second_count;  // 7-bit counter (0-99 range)

    //--------------------------------------------------------------------------
    // Counter Logic (Sequential)
    // Counts down from 99 to 0, reloads on completion
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            second_count <= 7'd99;          // Reset to initial value
        else if (second_finish)
            second_count <= 7'd99;          // Reload on completion
        else if (en)
            second_count <= second_count - 1'b1;  // Decrement when enabled
        else
            second_count <= second_count;   // Hold value
    end

    //--------------------------------------------------------------------------
    // Output Signal Generation
    //--------------------------------------------------------------------------
    assign second_finish = (second_count == 7'd0);  // Pulse when count is 0
    assign pre_last      = (second_count == 7'd1);  // Pre-last cycle indicator

endmodule
