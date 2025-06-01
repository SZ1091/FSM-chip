`timescale 1ns / 1ps

module tt_um_SZ1091_FSM (
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    inout wire [7:0] uio_inout,
    input wire clk,
    input wire rst_n,
    input wire ena
);

// Entradas del usuario
wire btnC = ui_in[3];
wire [2:0] sw = ui_in[2:0];
wire [2:0] led;

// Señales no usadas (explícitamente ignoradas para claridad)
wire _unused_rst_n = rst_n;
wire _unused_ena   = ena;

// Instancia del módulo FSM
FSM fsm_inst (
    .clk(clk), 
    .btnC(btnC), 
    .sw(sw), 
    .led(led)
);

// Salidas
assign uo_out[2:0] = led;
assign uo_out[7:3] = 5'b0;
assign uio_inout = 8'bZ;

endmodule
