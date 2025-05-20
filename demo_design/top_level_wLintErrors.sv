`default_nettype none

module top_level(
    input wire clk, rst, 
    output logic [7:0] leds,
	output logic inflatch,
	output logic c
    );
    
//variable for storing count value
logic [23:0] cnt;

//counter itself
always_ff @(posedge clk)
begin
    if (rst)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

logic [3:0] a,b;
always @* if(cnt[1]==1) inflatch = 1;
always @* c = a + b;

//contect the 8MSBs to the leds
always_comb leds = cnt[23:16];
    
endmodule

`default_nettype wire