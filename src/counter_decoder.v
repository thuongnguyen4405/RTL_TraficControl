//==============================================================================
// Module: counter_decoder
// Description: Display Decoder Wrapper
//              Integrates BCD converter and 7-segment encoder
//              Converts binary count to dual 7-segment display outputs
// Author: Thuong Nguyen
//==============================================================================

module counter_decoder (
    input  wire [4:0] count,      // Binary countdown value (0-31)
    input  wire       clk,        // System clock input
    input  wire       rst_n,      // Active-low asynchronous reset
    input  wire       en,         // Decoder enable signal
    output wire [6:0] seg_tens,   // 7-segment output for tens digit
    output wire [6:0] seg_units   // 7-segment output for units digit
);

    //--------------------------------------------------------------------------
    // Internal Signal Declarations
    //--------------------------------------------------------------------------
    wire [3:0] tens;      // BCD tens digit (0-9)
    wire [3:0] units;     // BCD units digit (0-9)
    wire       decode_en; // Decoder output enable

    //--------------------------------------------------------------------------
    // Binary to BCD Converter Instance
    // Converts 5-bit binary to two 4-bit BCD digits
    //--------------------------------------------------------------------------
    decimal_split count2hex (
        .clk       (clk),
        .rst_n     (rst_n),
        .en        (en),
        .count     (count),
        .decode_en (decode_en),
        .tens      (tens),
        .units     (units)
    );

    //--------------------------------------------------------------------------
    // 7-Segment Encoder Instance (Tens Digit)
    //--------------------------------------------------------------------------
    hex2seg led7seg_tens (
        .hex (tens),
        .en  (decode_en),
        .seg (seg_tens)
    );

    //--------------------------------------------------------------------------
    // 7-Segment Encoder Instance (Units Digit)
    //--------------------------------------------------------------------------
    hex2seg led7seg_units (
        .hex (units),
        .en  (decode_en),
        .seg (seg_units)
    );

endmodule
