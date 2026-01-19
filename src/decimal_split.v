//==============================================================================
// Module: decimal_split
// Description: Binary to BCD Converter
//              Converts 5-bit binary (0-31) to two BCD digits (tens, units)
//              Uses iterative subtraction algorithm
// Author: Thuong Nguyen
//==============================================================================

module decimal_split (
    input  wire       clk,       // System clock input
    input  wire       rst_n,     // Active-low asynchronous reset
    input  wire       en,        // Module enable signal
    input  wire [4:0] count,     // Binary input value (0-31)
    output wire       decode_en, // Decoder output enable
    output wire [3:0] units,     // BCD units digit output (0-9)
    output wire [3:0] tens       // BCD tens digit output (0-9)
);

    //--------------------------------------------------------------------------
    // Internal Registers and Signals
    //--------------------------------------------------------------------------
    reg  [4:0] count_reg;    // Previous count value register
    wire       en_count;     // Internal enable for conversion
    wire       count_change; // Count value changed flag
    reg  [4:0] units_count;  // Working register for units
    reg  [4:0] tens_count;   // Working register for tens

    //--------------------------------------------------------------------------
    // Count Change Detection
    // Tracks changes in input count value
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count_reg <= 5'd0;
        else
            count_reg <= count;
    end

    //--------------------------------------------------------------------------
    // Units Digit Calculation (Iterative Subtraction)
    // Subtracts 10 repeatedly while value > 10
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            units_count <= 4'd0;
        else if (count_change)
            units_count <= count;           // Load new count value
        else if (en & en_count)
            units_count <= units_count - 4'd10;  // Subtract 10
        else
            units_count <= units_count;     // Hold value
    end

    //--------------------------------------------------------------------------
    // Tens Digit Calculation
    // Increments for each subtraction of 10
    //--------------------------------------------------------------------------
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            tens_count <= 4'd0;
        else if (count_change)
            tens_count <= 4'd0;             // Reset on new value
        else if (en & en_count)
            tens_count <= tens_count + 1'b1;  // Increment tens
        else
            tens_count <= tens_count;       // Hold value
    end

    //--------------------------------------------------------------------------
    // Control and Output Signal Generation
    //--------------------------------------------------------------------------
    assign count_change = (count != count_reg);            // Detect change
    assign en_count     = (units_count > 5'd10) ? 1'b1 : 1'b0;  // Continue if > 10
    assign decode_en    = (~en_count) & en;                // Output valid
    assign units        = (~en_count) ? units_count[3:0] : 4'd0;  // Units output
    assign tens         = tens_count[3:0];                 // Tens output

endmodule
