`timescale 1ns / 1ps

module Clock(input clk,
             output reloj);

reg [31:0] myreg;

always @(posedge clk)
    myreg <= myreg + 1;

assign reloj = myreg[27];

endmodule
