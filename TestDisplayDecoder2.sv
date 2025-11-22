`timescale 1ns/1ps

module TestDisplayDecoder2;

    logic [3:0] char_sel;
    logic [6:0] segments;

    DisplayDecoder dut (
        .char_sel(char_sel),
        .segments(segments)
    );

    initial begin
        $display("=== Simulación 2: Valores aleatorios ===");

        $monitor("[%0t] char_sel=%0d ----> segments=%b",
                  $time, char_sel, segments);

        // Secuencia aleatoria (8 muestras)
        repeat (8) begin
            char_sel = $urandom_range(0, 15);
            #10;
        end

        $finish;
    end

endmodule
