//==============================================================================
// Module: hex2seg
// Description: BCD to 7-Segment Display Encoder
//              Converts 4-bit BCD digit (0-9) to 7-segment pattern
//              Active-high output configuration
// Author: Thuong Nguyen
//==============================================================================

module hex2seg (
    input  wire [3:0] hex,  // BCD input digit (0-9)
    input  wire       en,   // Encoder enable signal
    output reg  [6:0] seg   // 7-segment output pattern
);

    //--------------------------------------------------------------------------
    // 7-Segment Encoding Truth Table
    //--------------------------------------------------------------------------
    //     Segment Layout:        seg[6:0] = {g, f, e, d, c, b, a}
    //
    //          ─a─
    //         │   │
    //         f   b
    //         │   │
    //          ─g─
    //         │   │
    //         e   c
    //         │   │
    //          ─d─
    //
    //--------------------------------------------------------------------------

    //--------------------------------------------------------------------------
    // Combinational Decoder Logic
    //--------------------------------------------------------------------------
    always @(*) begin
        if (en) begin
            case (hex)
                4'h0: seg = 7'b0111111;  // 0: a,b,c,d,e,f ON
                4'h1: seg = 7'b0000110;  // 1: b,c ON
                4'h2: seg = 7'b1011011;  // 2: a,b,d,e,g ON
                4'h3: seg = 7'b1001111;  // 3: a,b,c,d,g ON
                4'h4: seg = 7'b1100110;  // 4: b,c,f,g ON
                4'h5: seg = 7'b1101101;  // 5: a,c,d,f,g ON
                4'h6: seg = 7'b1111101;  // 6: a,c,d,e,f,g ON
                4'h7: seg = 7'b0000111;  // 7: a,b,c ON
                4'h8: seg = 7'b1111111;  // 8: all segments ON
                4'h9: seg = 7'b1101111;  // 9: a,b,c,d,f,g ON
                default: seg = 7'b0000000;  // Blank display
            endcase
        end else begin
            seg = 7'b0000000;  // Disabled: all segments OFF
        end
    end

endmodule
