`timescale 1ns / 1ps

module Moore(input CLK, reset, H, DC, C,
             output AAH, AADC, AAC);

reg [2:0] est, ns;  // est=estado, ns=siguiente estado
reg aah, aadc, aac;

// Registro de estado
always @ (posedge CLK or posedge reset)
begin
    if (reset) 
        est <= 3'b000; // s0
    else 
        est <= ns;
end

// Lógica de siguiente estado
always @ *
begin
    case(est)
        3'b000: if (H) ns = 3'b001;
                else if (DC) ns = 3'b010;
                else if (C) ns = 3'b011;
                else ns = 3'b000;

        3'b001: if (~H) ns = 3'b000;
                else if (H && DC) ns = 3'b100;
                else if (H && C) ns = 3'b101;
                else ns = 3'b001;

        3'b010: if (~DC) ns = 3'b000;
                else if (H && DC) ns = 3'b100;
                else if (DC && C) ns = 3'b110;
                else ns = 3'b010;

        3'b011: if (~C) ns = 3'b000;
                else if (H && C) ns = 3'b101;
                else if (DC && C) ns = 3'b110;
                else ns = 3'b011;

        3'b100: if (~DC) ns = 3'b001;
                else if (~H) ns = 3'b010;
                else if (H && DC && C) ns = 3'b111;
                else ns = 3'b100;

        3'b101: if (~C) ns = 3'b001;
                else if (~H) ns = 3'b011;
                else if (H && DC && C) ns = 3'b111;
                else ns = 3'b101;

        3'b110: if (~DC) ns = 3'b011;
                else if (~C) ns = 3'b010;
                else if (H && DC && C) ns = 3'b111;
                else ns = 3'b110;

        3'b111: if (~H) ns = 3'b110;
                else if (~DC) ns = 3'b101;
                else if (~C) ns = 3'b100;
                else ns = 3'b111;

        default: ns = 3'b000;
    endcase
end

// Lógica de salida pre-estado
always @ *
begin
    case(est)
        3'b000: {aah, aadc, aac} = 3'b000;
        3'b001: {aah, aadc, aac} = 3'b100;
        3'b010: {aah, aadc, aac} = 3'b010;
        3'b011: {aah, aadc, aac} = 3'b001;
        3'b100: {aah, aadc, aac} = 3'b110;
        3'b101: {aah, aadc, aac} = 3'b101;
        3'b110: {aah, aadc, aac} = 3'b011;
        3'b111: {aah, aadc, aac} = 3'b111;
    endcase
end

// Asignaciones de salida
assign AAH = aah;
assign AADC = aadc;
assign AAC = aac;

endmodule
