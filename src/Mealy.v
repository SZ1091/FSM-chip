`timescale 1ns / 1ps

module Mealy(
    input CLK,
    input reset,
    input A,
    output L
);

    // Estados codificados
    localparam s0 = 1'b0;
    localparam s1 = 1'b1;

    reg est, ns;
    reg l;
    reg C = 0; // Contador interno

    // Registro de estado
    always @(posedge CLK or posedge reset) begin
        if (reset) begin
            est <= s0;
            C <= 0;
        end else begin
            est <= ns;
            C <= ~C;
        end
    end

    // Lógica de siguiente estado
    always @(*) begin
        case (est)
            s0: if (A && C) ns = s1;
                else ns = s0;
            s1: if (A && C) ns = s0;
                else ns = s0;
            default: ns = s0;
        endcase
    end

    // Lógica de salida (tipo Mealy)
    always @(*) begin
        case (est)
            s0: l = 0;
            s1: l = 1;
            default: l = 0;
        endcase
    end

    assign L = l;

endmodule
