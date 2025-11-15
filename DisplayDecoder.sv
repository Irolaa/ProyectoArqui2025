module DisplayDecoder(
    input  logic [3:0] char_sel,
    output logic [6:0] segments
);

    always_comb begin
        case (char_sel)

            // ===== TIPO DE CAFÉ =====
            4'd0: segments = 7'b0000110; // E (espresso)
            4'd1: segments = 7'b1000111; // L (leche)
            4'd2: segments = 7'b1000110; // C (capuchino)

            // ===== ESTADOS =====
            4'd3: segments = 7'b0001000; // A (agua)
            4'd4: segments = 7'b1000110; // C (café)
            4'd5: segments = 7'b1000111; // L (leche)
            4'd6: segments = 7'b1000001; // U (azúcar)
            4'd7: segments = 7'b0000110; // E (crema)
            4'd8: segments = 7'b0001110; // F (fin)

            default: segments = 7'b1111111; // apagado
        endcase
    end

endmodule
