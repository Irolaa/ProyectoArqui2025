`timescale 1ns/1ps

module TestClockDivider2;

    logic clk, reset;
    logic clk_out_20, clk_out_8;

    ClockDivider #(.DIV(16)) dut_20 (
        .clk    (clk),
        .reset  (reset),
        .clk_out(clk_out_20)
    );

    ClockDivider #(.DIV(8)) dut_8 (
        .clk    (clk),
        .reset  (reset),
        .clk_out(clk_out_8)
    );

    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz

    initial begin
        reset = 1;
        #20;
        reset = 0;
        #500;
        $stop;
    end

endmodule