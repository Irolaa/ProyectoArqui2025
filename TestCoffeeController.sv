`timescale 1ns/1ps

module TestCoffeeController;

    // Señales del DUT
    logic clk;
    logic reset;
    logic next_button;
    logic select_button;
    logic [6:0] seg_type;
    logic [6:0] seg_state;
    logic [4:0] led;

    // Señales internas expuestas
    logic [1:0] coffee_sel;
    logic [3:0] display_state;

    // ==========================================================
    // INSTANCIA DEL DUT
    // ==========================================================
    CoffeeController dut (
        .clk(clk),
        .reset(reset),
        .next_button(next_button),
        .select_button(select_button),
        .seg_type(seg_type),
        .seg_state(seg_state),
        .led(led)
    );

    // Conectar señales internas para debugging
    assign coffee_sel    = dut.coffee_sel;
    assign display_state = dut.display_state;

    // ==========================================================
    // RELOJ 50 MHz → 20 ns periodo
    // ==========================================================
    always #10 clk = ~clk;

    // ==========================================================
    // TASKS PARA SIMULAR BOTONES (con debounce realista)
    // ==========================================================

    // El debounce del CoffeeController trabaja con el clk real,
    // así que necesitamos pulsos de varias muestras del reloj.
    task press_next();
        next_button = 0;                // activo-bajo
        repeat(30) @(posedge clk);      // 30 ciclos = 600 ns aprox
        next_button = 1;
        repeat(30) @(posedge clk);
    endtask

    task press_select();
        select_button = 0;              // activo-bajo
        repeat(30) @(posedge clk);
        select_button = 1;
        repeat(30) @(posedge clk);
    endtask

    // ==========================================================
    // LOGGING — imprime cada cambio importante
    // ==========================================================

    function string decode_type(input [1:0] sel);
        case(sel)
            2'b00: decode_type = "Espresso";
            2'b01: decode_type = "Latte";
            2'b10: decode_type = "Capuchino";
            default: decode_type = "???";
        endcase
    endfunction

    function string decode_state(input [3:0] st);
        case (st)
            3: decode_state = "A - Agua";
            4: decode_state = "C - Cafe";
            5: decode_state = "L - Leche";
            6: decode_state = "U - Azucar";
            7: decode_state = "E - Crema";
            8: decode_state = "F - Final";
            default: decode_state = "IDLE";
        endcase
    endfunction

    always @(coffee_sel or display_state) begin
        $display("[t=%0t] coffee_sel=%b (%s)  | estado=%b (%s)",
            $time, coffee_sel, decode_type(coffee_sel),
            display_state, decode_state(display_state));
    end

    // ==========================================================
    // TEST PRINCIPAL
    // ==========================================================
    initial begin
        // Inicialización
        clk = 0;
        reset = 1;
        next_button = 1;
        select_button = 1;

        // Reset global
        repeat(10) @(posedge clk);
        reset = 0;

        // Cambiar tipo de café
        repeat(20) @(posedge clk);
        press_next();    // E → L

        repeat(20) @(posedge clk);
        press_next();    // L → C

        repeat(20) @(posedge clk);
        press_next();    // C → E

        // Empezar preparación
        repeat(40) @(posedge clk);
        press_select();  // genera start_pulse correcto

        // Correr suficiente tiempo para ver la FSM completa
        repeat(3000) @(posedge clk);

        $display("\nSimulación terminada.\n");
        $stop;
    end

endmodule
