`timescale 1ns/1ps

module TestDebounce;

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

    // Reloj de 10 ns (100 MHz)
    always #5 clk = ~clk;

    initial begin
        $display("=== Simulación 1: Rebotes de un botón físico ===");
        clk = 0;
        reset = 1;
        button_in = 0;
        #20 reset = 0;

        // Rebote
        repeat (5) begin
            button_in = ~button_in;
            #30; // rebotes rápidos
        end

        // estable
        button_in = 1;
        #20000000;  // deja tiempo para cumplir DEBOUNCE_TIME

        // Rebote cuando suelta
        repeat (5) begin
            button_in = ~button_in;
            #20;
        end

        // Suelta estable
        button_in = 0;
        #20000000;

        $finish;
    end

endmodule
