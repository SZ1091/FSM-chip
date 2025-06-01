`timescale 1ns / 1ps

module Clock (
    input clk,
    output wire reloj
);

    reg [31:0] myreg = 0;

    always @(posedge clk) begin
        myreg <= myreg + 1;
    end

    assign reloj = myreg[27];

endmodule
