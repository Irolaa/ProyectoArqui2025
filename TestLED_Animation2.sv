`timescale 1ns/1ps

module TestLED_Animation2;

    logic clk, reset, active;
    logic [4:0] led;

    LED_Animation dut (
        .clk(clk),
        .reset(reset),
        .active(active),
        .led(led)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        reset = 1; active = 0; #40;
        reset = 0; #40;
       
        active = 1; #100;
        active = 0;
        #500;
          
          active = 1; #100;
        active = 0;
        #500;
    
        $stop;
    end
endmodule