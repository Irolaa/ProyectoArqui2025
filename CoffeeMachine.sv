module CoffeeMachine(
    input  logic clk,          // Reloj principal (50 MHz)
    input  logic reset,        // Reset global
    input  logic start_btn,    // Botón para iniciar
    input  logic [1:0] coffee_sel, // 00=Expreso, 01=Leche, 10=Capuchino
    output logic [6:0] seg_type,   // Tipo de café (E/L/C)
    output logic [6:0] seg_state,  // Estado actual (A/C/L/U/E)
    output logic [3:0] leds,       // Animación al finalizar
    output logic done              // Señal de finalización del café
);

    logic slow_clk;
    logic [2:0] state;

    // === Divisor de frecuencia a 1 Hz ===
    ClockDivider div_inst (
        .clk(clk),
        .reset(reset),
        .clk_out(slow_clk)
    );

    // === Máquina de estados ===
    CoffeeFSM fsm_inst (
        .clk(slow_clk),
        .reset(reset),
        .start(start_btn),
        .coffee_sel(coffee_sel),
        .state(state),
        .done(done)
    );

    // === Decodificador para tipo de café (display 1) ===
    DisplayDecoder type_disp (
        .char_sel({2'b00, coffee_sel}),
        .segments(seg_type)
    );

    // === Decodificador para estado actual (display 4) ===
    DisplayDecoder state_disp (
        .char_sel(state),
        .segments(seg_state)
    );

    // === Animación de LEDs cuando el café termina ===
    LED_Animation led_inst (
        .clk(clk),
        .reset(reset),
        .active(done),
        .led(leds)
    );

endmodule
