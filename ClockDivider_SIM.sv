module ClockDivider_SIM(
    input  logic clk,
    input  logic reset,
    output logic clk_out
);

    parameter DIV = 20;   // SUPER PEQUEÑO PARA MODELSIM

    logic [31:0] counter;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_out <= 0;
        end
        else if (counter >= DIV/2 - 1) begin
            clk_out <= ~clk_out;
            counter <= 0;
        end
        else begin
            counter <= counter + 1;
        end
    end

endmodule
