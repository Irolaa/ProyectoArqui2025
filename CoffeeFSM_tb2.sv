`timescale 1ns/1ps

module CoffeeFSM_tb2;

    logic clk;
    logic reset;
    logic start;
    logic [1:0] coffee_sel;
    logic [2:0] state;
    logic done;

   
    CoffeeFSM #(.FAST(1)) dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .coffee_sel(coffee_sel),
        .state(state),
        .done(done)
    );

    // Generador de reloj
    always #5 clk = ~clk;  // periodo = 10ns → 100MHz

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        coffee_sel = 2'b10; // Latte

        #20 reset = 0;

        #10 start = 1;
        #10 start = 0;

        wait(done);
        #50;

        $display(">>> Cafe LATTE terminado correctamente.");
        $stop;
    end
endmodule