module CoffeeFSM(
    input  logic clk,            
    input  logic reset,
    input  logic start,
    input  logic [1:0] coffee_sel, // 00=E, 01=L, 10=C
    output logic [2:0] state,
    output logic done
);

    typedef enum logic [2:0] {
        IDLE  = 3'd0,
        AGUA  = 3'd1,
        CAFE  = 3'd2,
        LECHE = 3'd3,
        AZUCAR= 3'd4,
        CREMA = 3'd5,
        END   = 3'd6
    } state_t;

    state_t current, next;

    logic [2:0] timer;
    logic timer_done;
    logic start_prev;  

    // Duraciones por estado
    function automatic [2:0] get_duration(state_t st, logic [1:0] sel);
        case (st)
            AGUA: begin
                if (sel == 2'b00) get_duration = 3'd2; // Expreso: 2s
                else if (sel == 2'b01) get_duration = 3'd1; // Latte: 1s
                else get_duration = 3'd2; // Capuchino: 2s
            end
            CAFE: begin
                if (sel == 2'b00) get_duration = 3'd1; // Expreso: 1s
                else if (sel == 2'b01) get_duration = 3'd1; // Latte: 1s
                else get_duration = 3'd0; // Capuchino NO lleva café
            end
            LECHE: begin
                if (sel == 2'b00) get_duration = 3'd0; // Expreso no usa
                else if (sel == 2'b01) get_duration = 3'd1; // Latte: 1s
                else get_duration = 3'd1; // Capuchino: 1s
            end
            AZUCAR: begin
                if (sel == 2'b00) get_duration = 3'd0; // Expreso no usa
                else get_duration = 3'd1; // Latte y Capi: 1s
            end
            CREMA: begin
                if (sel == 2'b10) get_duration = 3'd1; // Solo Capuchino
                else get_duration = 3'd0;
            end
            default: get_duration = 3'd0;
        endcase
    endfunction

    // Registro de estado + timer
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            current <= IDLE;
            timer <= 0;
            done <= 0;
            start_prev <= 0;
        end else begin
            current <= next;
            start_prev <= start;

            if (current != next)
                timer <= 0;
            else
                timer <= timer + 1;

            done <= (next == END);
        end
    end

    assign timer_done = (timer >= get_duration(current, coffee_sel));

    always_comb begin
        next = current;

        case (current)
            IDLE:
                if (start && !start_prev)
                    next = AGUA;

            AGUA:
                if (timer_done) begin
                    if (coffee_sel == 2'b00) next = CAFE;   // E
                    else if (coffee_sel == 2'b01) next = CAFE; // L
                    else next = LECHE; // C
                end

            CAFE:
                if (timer_done) begin
                    if (coffee_sel == 2'b00) next = END;  // E termina aquí
                    else if (coffee_sel == 2'b01) next = LECHE; // L sigue
                    else next = END; // Por si acaso
                end

            LECHE:
                if (timer_done) begin
                    if (coffee_sel == 2'b01) next = AZUCAR; // L
                    else if (coffee_sel == 2'b10) next = AZUCAR; // C
                end

            AZUCAR:
                if (timer_done) begin
                    if (coffee_sel == 2'b01) next = END; // L
                    else if (coffee_sel == 2'b10) next = CREMA; // C
                end

            CREMA:
                if (timer_done)
                    next = END;

            END:
                next = IDLE;

            default: next = IDLE;
        endcase
    end

    assign state = current;

endmodule