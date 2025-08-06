Two Decade Counter

This project implements a two-digit (00-99) BCD counter in Verilog. 
It's designed to drive a common-anode, multiplexed 7-segment display, updating the count once per second from a 100MHz clock.
The repository includes the top module, a BCD-to-7-segment decoder, and a complete testbench for verification 
NOTE: (Testbench code may not work directly in the  simulation file because of higher delay in code and bubbled logic at the 7- segment display of Spartan-7 FPGA)


