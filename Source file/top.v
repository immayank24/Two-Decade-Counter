`timescale 1ns / 1ps


module bcd_to_7seg(
    input [3:0] bcd,
    output reg [6:0] seg
);

always @(*) begin
    case(bcd)
        4'd0: seg = 7'b1000000; // 0 
        4'd1: seg = 7'b1111001; // 1
        4'd2: seg = 7'b0100100; // 2
        4'd3: seg = 7'b0110000; // 3
        4'd4: seg = 7'b0011001; // 4
        4'd5: seg = 7'b0010010; // 5
        4'd6: seg = 7'b0000010; // 6
        4'd7: seg = 7'b1111000; // 7
        4'd8: seg = 7'b0000000; // 8
        4'd9: seg = 7'b0010000; // 9
        default: seg = 7'b0111111; // Display '-' for error
    endcase
end
endmodule


module top(
    input              clk,          
    input              rst,          
    input [3:0] start_val,
    output reg  [6:0]  seg,          
    output reg  [7:0]  an,            
    output dp1
);

assign dp1=1'b1; // for the display enable pin on fpga 

    reg [3:0] ones_digit;
    reg [3:0] tens_digit;

    // Clock enable tick generator for a ~1Hz update rate
    // 100Mhz clk
    localparam COUNT_SPEED = 100_000_000;
    reg [31:0] slow_clk_counter;
    wire tick;

    assign tick = (slow_clk_counter == COUNT_SPEED - 1);

 
    always @(posedge clk) begin
        if (rst) begin
            ones_digit <= start_val;
            tens_digit <= 4'd0;
            slow_clk_counter <= 0;
        end else begin
            // Increment the slow clock counter on every clock cycle
            slow_clk_counter <= slow_clk_counter + 1;
            if (tick) begin // A 'tick' occurs once per second
                slow_clk_counter <= 0; // Reset the speed counter
                
                // When a tick occurs, update the BCD digits
                if (ones_digit == 4'd9) begin
                    ones_digit <= 4'd0;
                    if (tens_digit == 4'd9) begin
                        tens_digit <= 4'd0; 
                    end else begin
                        tens_digit <= tens_digit + 1;
                    end
                end else begin
                    ones_digit <= ones_digit + 1;
                end
            end
        end
    end

    
    // A high-speed counter to switch between the two digits
    reg [15:0] refresh_counter;  // 16 bit wide because it helps in making visual effect of seeing two numbers on display 
    
    wire display_select; 

    assign display_select = refresh_counter[15];

    always @(posedge clk) begin
        if (rst) begin
            refresh_counter <= 0;
        end else begin
            refresh_counter <= refresh_counter + 1;
        end
    end
    

    wire [6:0] seg_ones, seg_tens;
    
    
    bcd_to_7seg decoder_ones(.bcd(ones_digit), .seg(seg_ones));
    bcd_to_7seg decoder_tens(.bcd(tens_digit), .seg(seg_tens));

    always @(*) begin
        if (display_select == 1'b0) begin
           
            an  = 8'b11111110; 
            seg = seg_ones;
        end else begin
           
            an  = 8'b11111101;
            seg = seg_tens;
        end
    end

endmodule