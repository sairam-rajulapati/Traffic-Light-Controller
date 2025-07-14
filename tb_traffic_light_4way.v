
`timescale 1ns / 1ps

module tb_traffic_light_4way;

    reg clk = 0, reset = 1;
    wire [2:0] north, east, south, west;

    traffic_light_4way uut (
        .clk(clk),
        .reset(reset),
        .north(north),
        .east(east),
        .south(south),
        .west(west)
    );

    // Clock: 10ns period
    always #5 clk = ~clk;

    initial begin
        $dumpfile("traffic.vcd");
        $dumpvars(0, tb_traffic_light_4way);

        #15 reset = 0;

        #200 $finish;
    end

    always @(posedge clk) begin
        $display("Time=%0t | N=%b E=%b S=%b W=%b", $time, north, east, south, west);
    end
endmodule
