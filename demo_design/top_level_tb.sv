module top_level_tb( );

logic CLK = 0;
logic RST;
logic [7:0] LEDS;

top_level DUT(
    .clk(CLK),
    .rst_ext(RST),
    .leds(LEDS)
    );

always #5ns CLK = ~CLK;

initial
begin
    RST = 0;
    #100ns;
    RST = 1;
    #100ns;
    RST = 0;
    
    #1us;
    $finish;
end

endmodule
