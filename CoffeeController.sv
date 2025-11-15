module CoffeeController(
    input  logic clk,
    input  logic reset,
    input  logic next_button,      
    input  logic select_button,    
    output logic [6:0] seg_type,
    output logic [6:0] seg_state,
    output logic [4:0] led
);

    logic slow_clk;
    logic [1:0] coffee_sel;
    logic [2:0] state;
    logic done;

  
    logic next_p;
    logic select_p;

    assign next_p   = ~next_button;
    assign select_p = ~select_button;

    // ========================
    // CAMBIO DE TIPO DE CAFÉ
    // ========================
    logic prev_next;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            coffee_sel <= 2'b00;   // empieza en Expreso
            prev_next  <= 0;
        end else begin

            // Flanco de subida
            if (next_p && !prev_next)
                coffee_sel <= (coffee_sel == 2'b10) ? 2'b00 : coffee_sel + 1;

            prev_next <= next_p;
        end
    end

    // ========================
    // CLOCK DIVIDER 1 Hz
    // ========================
    ClockDivider #(.DIV(50_000_000)) div1 (
        .clk(clk),
        .reset(reset),
        .clk_out(slow_clk)
    );

    // ========================
    // RESINCRONIZAR SELECT A 1 Hz
    // ========================
    logic s1, s2, start_sync;

    always_ff @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            s1 <= 0;
            s2 <= 0;
        end else begin
            s1 <= select_p;
            s2 <= s1;
        end
    end

    assign start_sync = s1 & ~s2; // flanco en slow clock

    // ========================
    // FSM PRINCIPAL
    // ========================
    CoffeeFSM fsm1 (
        .clk(slow_clk),
        .reset(reset),
        .start(start_sync),
        .coffee_sel(coffee_sel),
        .state(state),
        .done(done)
    );

    // ========================
    // DISPLAY TIPO DE CAFÉ
    // ========================
    DisplayDecoder dec_type (
        .char_sel(coffee_sel),  // 0=E, 1=L, 2=C
        .segments(seg_type)
    );

    // ========================
    // MAPEAR ESTADO -> LETRA
    // ========================
    logic [3:0] display_state;

    always_comb begin
        case (state)
            3'd1: display_state = 4'd3; // A (Agua)
            3'd2: display_state = 4'd4; // C (Café)
            3'd3: display_state = 4'd5; // L (Leche)
            3'd4: display_state = 4'd6; // U (Azúcar)
            3'd5: display_state = 4'd7; // E (Crema)
            3'd6: display_state = 4'd8; // F (Fin)
            default: display_state = 4'd15; // apagado
        endcase
    end

    // ========================
    // DISPLAY ESTADO
    // ========================
    DisplayDecoder dec_state (
        .char_sel(display_state),
        .segments(seg_state)
    );

    // ========================
    // LED animation
    // ========================
    LED_Animation anim1 (
        .clk(clk),
        .reset(reset),
        .active(done),
        .led(led)
    );

endmodule
