module LED_Animation(
    input  logic clk,
    input  logic reset,
    input  logic active,
    output logic [4:0] led
);

    logic [25:0] div;
    logic slow_clk;
    logic [3:0] step;
    logic running;

    // Divisor para animación (~3 Hz)
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            div <= 0;
        else
            div <= div + 1;
    end
	 
	 
	`ifdef MODEL_TECH
		 assign slow_clk = clk;
		  `else
		 assign slow_clk = div[23];
		  `endif


    always_ff @(posedge slow_clk or posedge reset) begin
        if (reset) begin
            led <= 0;
            running <= 0;
            step <= 0;
        end else if (active && !running) begin
            running <= 1;
            step <= 0;
        end else if (running) begin
            step <= step + 1;

            case (step)
                0: led <= 5'b00001;
                1: led <= 5'b00011;
                2: led <= 5'b00111;
                3: led <= 5'b01111;
                4: led <= 5'b11111;
                5: begin
                    led <= 0;
                    running <= 0;
                end
            endcase
        end
    end

endmodule
