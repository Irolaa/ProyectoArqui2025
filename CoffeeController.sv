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


    // DEBOUNCE SIMPLIFICADO

    logic next_debounced, select_debounced;
    
    Debounce debounce_next (
        .clk(clk),
        .reset(reset),
        .button_in(next_button),
        .button_out(next_debounced)
    );
    
    Debounce debounce_select (
        .clk(clk),
        .reset(reset),
        .button_in(select_button),
        .button_out(select_debounced)
    );

    // Invertir botones
    logic next_p, select_p;
    assign next_p   = ~next_debounced;
    assign select_p = ~select_debounced;


    // CAMBIO DE TIPO DE CAFÉ

    logic prev_next;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            coffee_sel <= 2'b00;
            prev_next  <= 0;
        end else begin
            if (next_p && !prev_next)
                coffee_sel <= (coffee_sel == 2'b10) ? 2'b00 : coffee_sel + 1;
            prev_next <= next_p;
        end
    end

  
    // CLOCK DIVIDER 1 Hz

    ClockDivider #(.DIV(50000000)) div1 (
        .clk(clk),
        .reset(reset),
        .clk_out(slow_clk)
    );

 
    // DETECTOR DE FLANCO 

    logic select_prev, start_pulse;
    
    always_ff @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            select_prev <= 0;
        end else begin
            select_prev <= select_p;
        end
    end
    
    assign start_pulse = select_p && !select_prev;

   
    // FSM PRINCIPAL
 
    CoffeeFSM fsm1 (
        .clk(slow_clk),
        .reset(reset),
        .start(start_pulse),  
        .coffee_sel(coffee_sel),
        .state(state),
        .done(done)
    );

    // DISPLAY TIPO DE CAFÉ

    DisplayDecoder dec_type (
        .char_sel(coffee_sel),
        .segments(seg_type)
    );

 
    // MAPEAR ESTADO

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


    // DISPLAY ESTADO

    DisplayDecoder dec_state (
        .char_sel(display_state),
        .segments(seg_state)
    );

    // LED animation

    LED_Animation anim1 (
        .clk(clk),
        .reset(reset),
        .active(done),
        .led(led)
    );

endmodule