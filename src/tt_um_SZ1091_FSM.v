`timescale 1ns / 1ps

module tt_um_SZ1091_FSM (
    input wire [7:0] ui_in,  // Entradas
    output wire [7:0] uo_out, // Salidas
    inout wire [7:0] uio_inout, // Pines bidireccionales (no usados)
    input wire clk,   // Reloj global
    input wire rst_n, // Reset global activo bajo
    input wire ena    // Señal de habilitación
);

wire btnC = ui_in[3];   // Reset
wire [2:0] sw = ui_in[2:0]; // Señales de entrada
wire reloj;
wire [2:0] led; // Salidas

// Instanciación del módulo FSM
FSM fsm_inst (
    .clk(clk), 
    .btnC(btnC), 
    .sw(sw), 
    .led(led)
);

// Conexión de las salidas
assign uo_out[2:0] = led;
assign uo_out[7:3] = 5'b00000; // No usados
assign uio_inout = 8'bZZZZZZZZ; // Pines bidireccionales no utilizados

endmodule
