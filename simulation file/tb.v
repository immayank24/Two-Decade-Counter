`timescale 1ns / 1ps



module tb();
reg clk;
reg rst;
reg [3:0] start_val;
wire [6:0] seg;
wire[7:0] an;
wire dp1;

top dut (
        .clk(clk),
        .rst(rst),
        .start_val(start_val),
        .seg(seg),
        .an(an),
        .dp1(dp1)
    );

// Clock generation of 100 MHz
initial clk=0;
always #5 clk=~clk;


 initial begin 

       $monitor("Time=%0t | rst=%b start_val=%d | seg=%b, an=%b, dp1=%b", $time, rst, start_val, seg, an, dp1);

        // Initial values
        rst = 1;
        start_val = 4'd3; // initialise to 3

        // Hold reset
        #20;
        rst = 0;

        // Let it run for a few increments.
        #25000000; // for a couple of ticks (with 100MHz, 1 tick = 1e8*10ns=1s)

        // Test another value
        rst = 1;
        start_val = 4'd7;
        #20;
        rst = 0;

        #1_500_000_000; // Wait for a tick or two.

        // Test edge case: start at 9
        rst = 1;
        start_val = 4'd9;
        #20;
        rst = 0;

        #500_000_000;

        // Finish simulation
        $finish;
    end


endmodule
