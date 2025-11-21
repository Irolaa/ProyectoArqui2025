module CoffeeController_SIM(
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

    logic next_p = ~next_button;
    logic select_p = ~select_button;

    logic prev_next;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            coffee_sel <= 0;
            prev_next  <= 0;
        end
        else begin
            if (next_p && !prev_next)
                coffee_sel <= (coffee_sel == 2'b10) ? 2'b00 : coffee_sel + 1;

            prev_next <= next_p;
        end
    end

    // ==== USAMOS EL DIVISOR DE SIMULACIÓN ====
    ClockDivider_SIM div_sim (
        .clk(clk),
        .reset(reset),
        .clk_out(slow_clk)
    );

    // ==== RESINCRONIZACIÓN ====
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

    assign start_sync = s1 & ~s2;

    // FSM real
    CoffeeFSM fsm (
        .clk(slow_clk),
        .reset(reset),
        .start(start_sync),
        .coffee_sel(coffee_sel),
        .state(state),
        .done(done)
    );

    // Display tipo
    DisplayDecoder dec_type (
        .char_sel(coffee_sel),
        .segments(seg_type)
    );

    // Mapeo estado->letra
    logic [3:0] display_state;

    always_comb begin
        case (state)
            3'd1: display_state = 4'd3;
            3'd2: display_state = 4'd4;
            3'd3: display_state = 4'd5;
            3'd4: display_state = 4'd6;
            3'd5: display_state = 4'd7;
            3'd6: display_state = 4'd8;
            default: display_state = 4'd15;
        endcase
    end

    DisplayDecoder dec_state (
        .char_sel(display_state),
        .segments(seg_state)
    );

    LED_Animation anim (
        .clk(clk),
        .reset(reset),
        .active(done),
        .led(led)
    );

endmodule
