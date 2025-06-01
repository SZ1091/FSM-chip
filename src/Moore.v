`timescale 1ns / 1ps

module Moore(
    input CLK,
    input reset,
    input H,
    input DC,
    input C,
    output AAH,
    output AADC,
    output AAC
);

    // Definición de estados como parámetros
    localparam s0 = 3'd0;
    localparam s1 = 3'd1;
    localparam s2 = 3'd2;
    localparam s3 = 3'd3;
    localparam s4 = 3'd4;
    localparam s5 = 3'd5;
    localparam s6 = 3'd6;
    localparam s7 = 3'd7;

    reg [2:0] est, ns;

    reg aah, aadc, aac;

    // Registro de estado
    always @ (posedge CLK or posedge reset) begin
        if (reset)
            est <= s0;
        else
            est <= ns;
    end

    // Lógica de siguiente estado
    always @(*) begin
        case (est)
            s0: if (H) ns = s1;
                else if (DC) ns = s2;
                else if (C) ns = s3;
                else ns = s0;
            s1: if (!H) ns = s0;
                else if (H && DC) ns = s4;
                else if (H && C) ns = s5;
                else ns = s1;
            s2: if (!DC) ns = s0;
                else if (H && DC) ns = s4;
                else if (DC && C) ns = s6;
                else ns = s2;
            s3: if (!C) ns = s0;
                else if (H && C) ns = s5;
                else if (DC && C) ns = s6;
                else ns = s3;
            s4: if (!DC) ns = s1;
                else if (!H) ns = s2;
                else if (H && DC && C) ns = s7;
                else ns = s4;
            s5: if (!C) ns = s1;
                else if (!H) ns = s3;
                else if (H && DC && C) ns = s7;
                else ns = s5;
            s6: if (!DC) ns = s3;
                else if (!C) ns = s2;
                else if (H && DC && C) ns = s7;
                else ns = s6;
            s7: if (!H) ns = s6;
                else if (!DC) ns = s5;
                else if (!C) ns = s4;
                else ns = s7;
            default: ns = s0;
        endcase
    end

    // Lógica de salida tipo Moore
    always @(*) begin
        case (est)
            s0: begin aah = 0; aadc = 0; aac = 0; end
            s1: begin aah = 1; aadc = 0; aac = 0; end
            s2: begin aah = 0; aadc = 1; aac = 0; end
            s3: begin aah = 0; aadc = 0; aac = 1; end
            s4: begin aah = 1; aadc = 1; aac = 0; end
            s5: begin aah = 1; aadc = 0; aac = 1; end
            s6: begin aah = 0; aadc = 1; aac = 1; end
            s7: begin aah = 1; aadc = 1; aac = 1; end
            default: begin aah = 0; aadc = 0; aac = 0; end
        endcase
    end

    assign AAH = aah;
    assign AADC = aadc;
    assign AAC = aac;

endmodule
