module Debounce (
    input  logic clk,
    input  logic reset,
    input  logic button_in,
    output logic button_out
);

    logic [19:0] counter;
    logic stable_state;
    localparam DEBOUNCE_TIME = 500000;  

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            stable_state <= 0;
        end else if (button_in != stable_state) begin
            counter <= counter + 1;
            if (counter >= DEBOUNCE_TIME) begin
                stable_state <= button_in;
                counter <= 0;
            end
        end else begin
            counter <= 0;
        end
    end

    assign button_out = stable_state;

endmodule