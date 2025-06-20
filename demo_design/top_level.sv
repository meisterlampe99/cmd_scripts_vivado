`default_nettype none

module top_level(
    input wire clk, rst_ext, 
    output logic [7:0] leds
    );

//internal variables
logic rst;
logic [1:0] rst_sreg;

//supply based reset synchronizer
always_ff @(posedge clk, posedge rst_ext)
begin
    if (rst_ext)
        //assert internal reset asynchronously
        rst_sreg <= 2'b11;
    else
        //deassert internal reset synchronously
        rst_sreg <= {rst_sreg[0], 1'b0};
end
//assign synchronized reset from rst_sreg
always_comb rst = rst_sreg[1];
    
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

//contect the 8MSBs to the leds
always_comb leds = cnt[23:16];
    
endmodule

`default_nettype wire