
`timescale 1ns / 1ps

module traffic_light_4way (
    input clk,
    input reset,
    output reg [2:0] north, // {Red, Yellow, Green}
    output reg [2:0] east,
    output reg [2:0] south,
    output reg [2:0] west
);

    reg [2:0] state;
    reg [3:0] timer;

    // State encoding
    localparam S0 = 3'd0, S1 = 3'd1, S2 = 3'd2, S3 = 3'd3,
               S4 = 3'd4, S5 = 3'd5, S6 = 3'd6, S7 = 3'd7;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= S0;
            timer <= 0;
        end else begin
            timer <= timer + 1;

            case (state)
                S0: if (timer == 5) begin state <= S1; timer <= 0; end
                S1: if (timer == 2) begin state <= S2; timer <= 0; end
                S2: if (timer == 5) begin state <= S3; timer <= 0; end
                S3: if (timer == 2) begin state <= S4; timer <= 0; end
                S4: if (timer == 5) begin state <= S5; timer <= 0; end
                S5: if (timer == 2) begin state <= S6; timer <= 0; end
                S6: if (timer == 5) begin state <= S7; timer <= 0; end
                S7: if (timer == 2) begin state <= S0; timer <= 0; end
            endcase
        end
    end

    always @(*) begin
        // Default: all red
        north = 3'b100;
        east  = 3'b100;
        south = 3'b100;
        west  = 3'b100;

        case (state)
            S0: north = 3'b001; // Green
            S1: north = 3'b010; // Yellow
            S2: east  = 3'b001;
            S3: east  = 3'b010;
            S4: south = 3'b001;
            S5: south = 3'b010;
            S6: west  = 3'b001;
            S7: west  = 3'b010;
        endcase
    end
endmodule
