`timescale 1ns/1ps

module TestDebounce2;

    logic clk;
    logic reset;
    logic button_in;
    logic button_out;

    Debounce dut (
        .clk(clk),
        .reset(reset),
        .button_in(button_in),
        .button_out(button_out)
    );

    always #5 clk = ~clk;  // 100 MHz

    initial begin
        $display("=== Simulación 2: Pulsos rápidos (ruido eléctrico) ===");

        clk = 0;
        reset = 1;
        button_in = 0;
        #20 reset = 0;

        // Ruido: pulsos cortos no cambia la salida
        repeat (10) begin
            button_in = 1;
            #50;  // demasiado corto para debounce
            button_in = 0;
            #50;
        end

        // pulsación verdadera
        button_in = 1;
        #20000000; // mantener presionado lo suficiente

        button_in = 0;
        #20000000;

        $finish;
    end

endmodule
