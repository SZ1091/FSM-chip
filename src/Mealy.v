`timescale 1ns / 1ps

module Mealy(input CLK, reset, A,
             output L);

reg est, ns;  // est=estado, ns=siguiente estado
reg l;
reg C = 0; // Contador

// Registro de estado
always @ (posedge CLK or posedge reset)
begin
    if (reset) 
    begin 
        est <= 1'b0; // s0
        C <= 1'b0;
    end
    else 
    begin 
        est <= ns;
        C <= ~C;
    end
end

// Lógica de siguiente estado
always @ *
begin
    case (est)
        1'b0: if (A && C) ns = 1'b1;
        1'b1: if (A && C) ns = 1'b0;
              else ns = 1'b0;
        default: ns = 1'b0;
    endcase
end

// Lógica de salida pre-estado
always @ *
begin
    case (est)
        1'b0: l = 1'b0;
        1'b1: l = 1'b1;
        default: l = 1'b0;
    endcase
end

// Asignación de salida
assign L = l;

endmodule
