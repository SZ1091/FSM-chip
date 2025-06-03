`timescale 1ns / 1ps

module tt_um_SZ1091_FSM (
    input wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input wire clk,
    input wire rst_n,
    input wire ena
);


wire btnC = ui_in[3];
wire [2:0] sw = ui_in[2:0];
wire [2:0] led;


wire _unused_rst_n = rst_n;
wire _unused_ena   = ena;


FSM fsm_inst (
    .clk(clk),
    .btnC(btnC),
    .sw(sw),
    .led(led)
);


assign uo_out[2:0] = led;
assign uo_out[7:3] = 5'b00000;


assign uio_out = 8'b00000000;
assign uio_oe  = 8'b00000000;

endmodule
