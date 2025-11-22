`timescale 1ns/1ps

module TestClockDivider();

    logic clk;
    logic reset;
    logic clk_out;

   
    ClockDivider #(.DIV(20)) dut (
        .clk    (clk),
        .reset  (reset),
        .clk_out(clk_out)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        
        reset = 1;
        #20;
        reset = 0;
       
        #500;
        
        $stop;
    end

endmodule