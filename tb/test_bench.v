//==============================================================================
// Module: test_bench
// Description: Testbench for Traffic Light Controller
//              Provides clock, reset, and enable stimulus
//              Generates VCD waveform dump for analysis
// Author: Thuong Nguyen
//==============================================================================

`timescale 1ns/1ps

module test_bench;

    //--------------------------------------------------------------------------
    // Testbench Signal Declarations
    //--------------------------------------------------------------------------
    reg        clk;           // System clock
    reg        rst_n;         // Active-low reset
    reg        en;            // System enable

    wire       green_light;   // Green light output
    wire       yellow_light;  // Yellow light output
    wire       red_light;     // Red light output
    wire [6:0] seg_tens;      // 7-segment tens digit
    wire [6:0] seg_units;     // 7-segment units digit

    //--------------------------------------------------------------------------
    // Device Under Test (DUT) Instantiation
    //--------------------------------------------------------------------------
    top dut (
        .clk          (clk),
        .rst_n        (rst_n),
        .en           (en),
        .green_light  (green_light),
        .yellow_light (yellow_light),
        .red_light    (red_light),
        .seg_tens     (seg_tens),
        .seg_units    (seg_units)
    );

    //--------------------------------------------------------------------------
    // Clock Generation
    // Period: 10ns (100 MHz simulation clock)
    //--------------------------------------------------------------------------
    initial begin
        clk = 1'b1;
        forever #5 clk = ~clk;  // Toggle every 5ns
    end

    //--------------------------------------------------------------------------
    // Stimulus and Test Sequence
    //--------------------------------------------------------------------------
    initial begin
        // Waveform dump configuration
        $dumpfile("wave.vcd");
        $dumpvars(0, test_bench);

        // Initialize signals
        rst_n = 1'b0;
        en    = 1'b0;

        // Hold reset for 10ns
        #10;

        // Release reset and enable system
        rst_n = 1'b1;
        en    = 1'b1;

        // Run simulation for complete traffic light cycle
        // 3500 clock cycles covers multiple state transitions
        repeat(3500) @(posedge clk);

        // End simulation
        #100;
        $display("==============================================");
        $display("  Simulation completed successfully!");
        $display("  Waveform saved to: wave.vcd");
        $display("==============================================");
        $finish;
    end

endmodule
