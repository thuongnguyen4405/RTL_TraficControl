//==============================================================================
// Module: FSM
// Description: Finite State Machine for Traffic Light Controller
//              Implements 3-state control logic: GREEN -> YELLOW -> RED
// Author: Thuong Nguyen
//==============================================================================

module FSM (
    input  wire       clk,          // System clock input
    input  wire       rst_n,        // Active-low asynchronous reset
    input  wire       finish,       // Timer finished signal
    input  wire       pre_last,     // Pre-last cycle indicator
    output wire       green_light,  // Green light output
    output wire       yellow_light, // Yellow light output
    output wire       red_light,    // Red light output
    output wire [4:0] count         // Duration value for current state
);

    //--------------------------------------------------------------------------
    // State Encoding (One-hot style for clarity)
    //--------------------------------------------------------------------------
    localparam GREEN  = 2'b01;  // Green state encoding
    localparam YELLOW = 2'b10;  // Yellow state encoding
    localparam RED    = 2'b11;  // Red state encoding

    //--------------------------------------------------------------------------
    // State Registers
    //--------------------------------------------------------------------------
    reg [1:0] current_state;  // Current FSM state
    reg [1:0] next_state;     // Next FSM state

    //--------------------------------------------------------------------------
    // Next-State Combinational Logic
    // Transitions occur when both finish and pre_last are asserted
    //--------------------------------------------------------------------------
    always @(*) begin
        case (current_state)
            GREEN:   next_state = (finish && pre_last) ? YELLOW : current_state;
            YELLOW:  next_state = (finish && pre_last) ? RED    : current_state;
            RED:     next_state = (finish && pre_last) ? GREEN  : current_state;
            default: next_state = GREEN;
        endcase
    end

    //--------------------------------------------------------------------------
    // State Register (Sequential Logic)
    // Updates state on positive clock edge, resets to GREEN
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= GREEN;
        else
            current_state <= next_state;
    end

    //--------------------------------------------------------------------------
    // Light Duration Assignment
    // GREEN: 18 seconds, YELLOW: 3 seconds, RED: 15 seconds
    //--------------------------------------------------------------------------
    assign count = (current_state == GREEN)  ? 5'd18 :  // 18 seconds
                   (current_state == YELLOW) ? 5'd3  :  // 3 seconds
                   (current_state == RED)    ? 5'd15 :  // 15 seconds
                                               5'd0;

    //--------------------------------------------------------------------------
    // Output Decode Logic
    // Generates one-hot light control signals based on current state
    //--------------------------------------------------------------------------
    assign green_light  = (current_state == GREEN);
    assign yellow_light = (current_state == YELLOW);
    assign red_light    = (current_state == RED);

endmodule
