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
    // Instancia del DUT
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
    // Reloj rápido 100 MHz
    // =======================
    always #5 clk = ~clk;   // 10ns periodo

    // =======================
    // TEST
    // =======================
    initial begin
        $display("=== INICIO SIM ===");

        clk = 0;
        reset = 1;
        next_button = 0;
        select_button = 0;

        #100;
        reset = 0;

        // ===== CAMBIAR CAFÉ =====
        $display("=== Cambiando café ===");
        next_button = 1; #20; next_button = 0;
        next_button = 1; #20; next_button = 0;

        // ===== INICIAR CAFÉ =====
        $display("=== Iniciar café ===");
        select_button = 1; #20; select_button = 0;

        // ===== AVANZAR ESTADOS =====
        $display("=== Avanzando estados ===");

        repeat(20) begin
            @(posedge uut.slow_clk);
            #1;
            $display("t=%0t | state=%d | seg_type=%b | seg_state=%b | led=%b",
                      $time, uut.state, seg_type, seg_state, led);
        end

        $display("=== FIN SIM ===");
        $stop;
    end

endmodule
