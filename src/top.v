//==============================================================================
// Module: top
// Description: Top-level integration module for Traffic Light Controller
//              Instantiates and connects FSM, counters, and display modules
// Author: Thuong Nguyen
//==============================================================================

module top (
    input  wire       clk,          // System clock input
    input  wire       rst_n,        // Active-low asynchronous reset
    input  wire       en,           // System enable signal
    output wire       green_light,  // Green light output indicator
    output wire       yellow_light, // Yellow light output indicator
    output wire       red_light,    // Red light output indicator
    output wire [6:0] seg_tens,     // 7-segment display for tens digit
    output wire [6:0] seg_units     // 7-segment display for units digit
);

    //--------------------------------------------------------------------------
    // Internal Signal Declarations
    //--------------------------------------------------------------------------
    wire       finish;        // Light counter finished flag
    wire       pre_last;      // Pre-last cycle indicator from second counter
    wire       second_finish; // 1-second tick pulse
    wire [4:0] count;         // Current countdown value
    wire [4:0] light_second;  // Duration value for current state

    //--------------------------------------------------------------------------
    // FSM Controller Instance
    // Controls state transitions: GREEN -> YELLOW -> RED -> GREEN
    //--------------------------------------------------------------------------
    FSM Control (
        .clk          (clk),
        .rst_n        (rst_n),
        .finish       (finish),
        .pre_last     (pre_last),
        .green_light  (green_light),
        .yellow_light (yellow_light),
        .red_light    (red_light),
        .count        (light_second)
    );

    //--------------------------------------------------------------------------
    // Second Counter Instance (Clock Prescaler)
    // Generates 1-second tick pulse from system clock
    //--------------------------------------------------------------------------
    second_counter light (
        .clk           (clk),
        .rst_n         (rst_n),
        .en            (en),
        .pre_last      (pre_last),
        .second_finish (second_finish)
    );

    //--------------------------------------------------------------------------
    // Light Counter Instance (Duration Timer)
    // Counts down the duration for each traffic light state
    //--------------------------------------------------------------------------
    light_counter traffic_light (
        .clk          (clk),
        .rst_n        (rst_n),
        .en           (second_finish),
        .light_second (light_second),
        .count        (count),
        .finish       (finish)
    );

    //--------------------------------------------------------------------------
    // Counter Decoder Instance (7-Segment Display Driver)
    // Converts countdown value to 7-segment display format
    //--------------------------------------------------------------------------
    counter_decoder led7seg (
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .count     (count),
        .seg_tens  (seg_tens),
        .seg_units (seg_units)
    );

endmodule
