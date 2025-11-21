`timescale 1ns/1ps

module TestCoffeeController;

    logic clk;
    logic reset;
    logic next_button;
    logic select_button;
    logic [6:0] seg_type;
    logic [6:0] seg_state;
    logic [4:0] led;

    // =======================
    // Instanciar CoffeeController
    // =======================
    CoffeeController uut (
        .clk(clk),
        .reset(reset),
        .next_button(next_button),
        .select_button(select_button),
        .seg_type(seg_type),
        .seg_state(seg_state),
        .led(led)
    );

    // =======================
    // CLOCK 100 MHz
    // =======================
    always #5 clk = ~clk;

    // =======================
    // TAREA: esperar slow_clk
    // =======================
    task wait_slow();
        @(posedge uut.slow_clk);
        #1;
        $display("t=%0t | TYPE=%b | STATE=%b (%0d) | LED=%b",
                  $time, seg_type, seg_state, uut.state, led);
    endtask

    // =======================
    // SIMULACIÓN
    // =======================
    initial begin
        $display("\n=== INICIO SIMULACIÓN ===");

        clk = 0;
        reset = 1;
        next_button = 0;
        select_button = 0;

        #100;
        reset = 0;

        // ===========================
        // SIM 1: EXPRESSO
        // ===========================
        $display("\n=== SIMULACIÓN 1: Expreso ===");

        // Iniciar
        select_button = 1; #20; select_button = 0;

        repeat(10) wait_slow();

        // ===========================
        // SIM 2: LATTE
        // ===========================
        $display("\n=== SIMULACIÓN 2: Latte ===");

        // Cambiar a Latte
        next_button = 1; #20; next_button = 0;

        // Iniciar
        select_button = 1; #20; select_button = 0;

        repeat(15) wait_slow();

        // ===========================
        // SIM 3: CAPUCHINO
        // ===========================
        $display("\n=== SIMULACIÓN 3: Capuchino ===");

        // Cambiar a Capuchino
        next_button = 1; #20; next_button = 0;

        // Iniciar
        select_button = 1; #20; select_button = 0;

        repeat(20) wait_slow();

        // Fin
        $display("\n=== FIN DE SIMULACIÓN ===\n");
        $stop;
    end

endmodule
