`timescale 1ns / 1ps

module FSM(input clk,
           input btnC, // reset
           input [2:0] sw,    // sw[0]=H, sw[1]=DC, sw[2]=C
           output [2:0] led); // led[0]=L1, led[1]=L2, led[2]=L3

wire A1, A2, A3;  // Una señal por cada entrada
wire reloj;

// Instanciación de módulos
Clock CLK (.clk(clk), .reloj(reloj));

Moore FSM_Moore( .H(sw[0]), .DC(sw[1]), .C(sw[2]), .CLK(reloj), .reset(btnC),
                 .AAH(A1), .AADC(A2), .AAC(A3));

Mealy FSM_Mealy1(.CLK(reloj), .reset(btnC), .A(A1), .L(led[0]));
Mealy FSM_Mealy2(.CLK(reloj), .reset(btnC), .A(A2), .L(led[1]));
Mealy FSM_Mealy3(.CLK(reloj), .reset(btnC), .A(A3), .L(led[2]));

endmodule
