# Traffic-Light-Controller
A traffic light controller is a critical component in intelligent transportation systems. It manages the safe and efficient flow of vehicles and pedestrians at intersections using automated signaling.

## Table of Contents

1. [Introduction](#1-introduction)
2. [Methodology](#2-methodology)  
   - [State Machine Details](#State-Machine-Details)  
   - [Problem Statement](#problem-statement)
   - [System Design Approach](#system-design-approach)
   - [State Diagram](#state-diagram)  
   - [State Table](#state-table)
3. [RTL Code](#RTL-Code)
   - [RTL Schematic View](#RTL-Schematic-View)
4. [TESTBENCH](#TESTBENCH)    
5. [Output Waveforms](#Output-Waveforms)   




# 1. Introduction
The 4-Way Traffic Light Controller is a digital system designed to manage vehicle movement at a four-way intersection (North, East, South, West) using traffic signals. Each direction has a 3-bit signal representing the traffic light: {Red, Yellow, Green}.

This Verilog design simulates the timing and light sequencing of a real-world traffic light system using a Finite State Machine (FSM). Each direction takes turns displaying Green → Yellow → Red lights in a cyclic manner. The FSM progresses through eight states, ensuring fair and safe movement of vehicles from all directions.

# 2. Methodology
The system uses:

Clock signal (clk) to drive state transitions.

Reset signal (reset) to initialize the FSM.

State Machine with 8 states (S0–S7), managing the light cycle.

Timer (4-bit) to control how long each light stays active.

Combinational logic to assign lights based on current state.

#  State Machine Details

| State | Active Direction | Light  | Duration (clock cycles) |
| ----- | ---------------- | ------ | ----------------------- |
| S0    | North            | Green  | 5                       |
| S1    | North            | Yellow | 2                       |
| S2    | East             | Green  | 5                       |
| S3    | East             | Yellow | 2                       |
| S4    | South            | Green  | 5                       |
| S5    | South            | Yellow | 2                       |
| S6    | West             | Green  | 5                       |
| S7    | West             | Yellow | 2                       |

Each light is encoded as:

3'b100 – Red

3'b010 – Yellow

3'b001 – Green

Other directions remain Red during each phase.

➤ Clock:
10 ns period (#5 clk = ~clk)

Entire FSM cycle = 8 states × (5 or 2 cycles) = 28 cycles


State Transition Logic: An always @(posedge clk or posedge reset) block implements the sequential logic for state transitions and timer management.

Reset Condition: Upon reset being high, the FSM initializes to S0 and the timer is reset to 0.

Normal Operation: When reset is low, the timer increments with each clock cycle.

State Advancement: Each state has a specific timer threshold. Once the timer reaches this threshold, the FSM transitions to the next state, and the timer is reset. Green lights are active for 5 clock cycles, and yellow lights are active for 2 clock cycles.

Output Logic: An always @(*) (combinational) block determines the traffic light outputs based on the current state.

Default State: By default, all traffic lights are set to Red (3'b100) at the beginning of this always block.

State-Dependent Output: A case statement then overrides the default red state for the specific direction(s) that should have a Green or Yellow light based on the current state. This ensures that only one direction has a non-red light at a time (or yellow for transition).

Testbench Implementation: The tb_traffic_light_4way module is created to verify the functionality of the traffic_light_4way module.

Clock Generation: An always #5 clk = ~clk; statement creates a clock signal with a period of 10ns (5ns high, 5ns low).

Reset Control: The reset signal is initially high for 15ns (to allow for reset synchronization), then driven low to start the traffic light sequence.

Simulation Control: $dumpfile and $dumpvars are used to generate a Value Change Dump (VCD) file for waveform viewing. $finish terminates the simulation after 200ns.

Monitoring: An always @(posedge clk) block with $display is used to print the time and the current state of all traffic lights at each positive clock edge, facilitating textual verification of the system's behavior.

#  Problem Statement
Design and implement a four-way traffic light controller for an intersection. The controller must manage the flow of traffic in North, East, South, and West directions, ensuring that only one direction has a green light at a time, followed by a brief yellow light before transitioning to another direction. The system should operate synchronously with a given clock and be resettable. Each green light phase should last for a configurable duration, and each yellow light phase should also last for a configurable, shorter duration.

Key Requirements:

Four Directions: Control lights for North, East, South, and West.

Light States: Each direction has Red, Yellow, and Green lights.

Sequential Flow: Lights must change in a specific, safe sequence (e.g., Green -> Yellow -> Red).

Mutual Exclusion: Only one direction can have a green light at any given time. During yellow transitions, other directions remain red.

Timing Control: Configurable durations for Green and Yellow phases.

Synchronous Operation: All state changes and timing are driven by a clock signal.

Reset Capability: The system should reset to a predefined initial state.

# System Design Approach
System Design Approach
The traffic light controller is designed using a Finite State Machine (FSM). This approach is well-suited for systems that have a finite number of states and transition between them based on inputs and internal logic.

Components:

Clock (clk): Provides the timing reference for all synchronous operations.

Reset (reset): An asynchronous reset signal to initialize the FSM to a known state.

State Register (state): A register to hold the current state of the FSM. This determines which traffic lights are active.

Timer Register (timer): A counter that increments with each clock cycle within a state. It's used to define the duration of each light phase.

Output Logic: Combinational logic that decodes the current state and sets the appropriate Red, Yellow, or Green lights for each direction.

Design Steps:

Define States: Identify all the necessary states to cover the complete cycle of the traffic lights. In this case, each direction having a green light and then a yellow light requires two states per direction, leading to 8 states in total (S0 through S7).

S0: North Green (others Red)

S1: North Yellow (others Red)

S2: East Green (others Red)

S3: East Yellow (others Red)

S4: South Green (others Red)

S5: South Yellow (others Red)

S6: West Green (others Red)

S7: West Yellow (others Red)

Define State Transitions: Specify how the FSM moves from one state to another. This is based on the timer reaching a predefined threshold for each state. The transitions are sequential, ensuring a smooth flow.

S0 (North Green) -> S1 (North Yellow) after 5 clock cycles.

S1 (North Yellow) -> S2 (East Green) after 2 clock cycles.

S2 (East Green) -> S3 (East Yellow) after 5 clock cycles.

S3 (East Yellow) -> S4 (South Green) after 2 clock cycles.

S4 (South Green) -> S5 (South Yellow) after 5 clock cycles.

S5 (South Yellow) -> S6 (West Green) after 2 clock cycles.

S6 (West Green) -> S7 (West Yellow) after 5 clock cycles.

S7 (West Yellow) -> S0 (North Green) after 2 clock cycles.

Implement Synchronous Logic (Sequential Block): An always @(posedge clk or posedge reset) block is used for state and timer updates.

Reset Logic: If reset is active, set state to S0 and timer to 0.

Timer Logic: Otherwise, increment the timer on each clock edge.

State Transition Logic: Use a case statement on state to check the timer threshold. When the threshold is met, update state to the next state and reset timer to 0.

Implement Combinational Output Logic: An always @(*) block is used to generate the traffic light outputs based solely on the current state.

Default Output: Initially set all lights to Red (3'b100) to ensure safety and prevent undefined states.

State-Specific Output: Use another case statement on state to activate the specific Green or Yellow light for the current direction, overriding the default Red. For example, in S0, north is set to 3'b001 (Green).

This two-block approach (one for sequential logic, one for combinational output logic) is a common and good practice in Verilog FSM design, as it clearly separates state transitions from output generation.

# State Diagram
 State Diagram
The state diagram visually represents the FSM's states and transitions.

States:

S0: North_Green

S1: North_Yellow

S2: East_Green

S3: East_Yellow

S4: South_Green

S5: South_Yellow

S6: West_Green

S7: West_Yellow

Transitions:

Each arrow represents a transition from one state to another. The label on the arrow indicates the condition for the transition (i.e., timer == X and the current state). The outputs for each state are indicated within the state bubble.

       +--------------------+      timer == 2      +--------------------+
       |                    |<---------------------+                    |
       |  S0: North_Green   |                      |  S1: North_Yellow  |
       |     N=G, E=R, S=R, W=R |                      |    N=Y, E=R, S=R, W=R    |
       +----------+---------+                      +----------+---------+
                  |  timer == 5                                 ^
                  v                                           |
       +----------+---------+      timer == 2      +----------+---------+
       |                    |<---------------------+                    |
       |  S2: East_Green    |                      |  S3: East_Yellow   |
       |    N=R, E=G, S=R, W=R  |                      |    N=R, E=Y, S=R, W=R    |
       +----------+---------+                      +----------+---------+
                  |  timer == 5                                 ^
                  v                                           |
       +----------+---------+      timer == 2      +----------+---------+
       |                    |<---------------------+                    |
       |  S4: South_Green   |                      |  S5: South_Yellow  |
       |    N=R, E=R, S=G, W=R  |                      |    N=R, E=R, S=Y, W=R    |
       +----------+---------+                      +----------+---------+
                  |  timer == 5                                 ^
                  v                                           |
       +----------+---------+      timer == 2      +----------+---------+
       |                    |<---------------------+                    |
       |  S6: West_Green    |                      |  S7: West_Yellow   |
       |    N=R, E=R, S=R, W=G  |                      |    N=R, E=R, S=R, W=Y    |
       +----------+---------+                      +----------+---------+
                  |  timer == 5                                 ^
                  +---------------------------------------------+
                                      (Cycles back to S0)
Initial State: The reset signal always forces the FSM into the S0 (North Green) state.

Output Key:

G = Green (3'b001)

Y = Yellow (3'b010)

R = Red (3'b100)

# State Table

| Current State | Timer Threshold | Next State | North Output (RYG) | East Output (RYG) | South Output (RYG) | West Output (RYG) | Description                                       |
| :------------ | :-------------- | :--------- | :------------------ | :---------------- | :----------------- | :---------------- | :------------------------------------------------ |
| `S0`          | 5               | `S1`       | `3'b001` (Green)    | `3'b100` (Red)    | `3'b100` (Red)     | `3'b100` (Red)    | North is Green for 5 cycles.                      |
| `S1`          | 2               | `S2`       | `3'b010` (Yellow)   | `3'b100` (Red)    | `3'b100` (Red)     | `3'b100` (Red)    | North is Yellow for 2 cycles. All others Red.     |
| `S2`          | 5               | `S3`       | `3'b100` (Red)      | `3'b001` (Green)  | `3'b100` (Red)     | `3'b100` (Red)    | East is Green for 5 cycles.                       |
| `S3`          | 2               | `S4`       | `3'b100` (Red)      | `3'b010` (Yellow) | `3'b100` (Red)     | `3'b100` (Red)    | East is Yellow for 2 cycles. All others Red.      |
| `S4`          | 5               | `S5`       | `3'b100` (Red)      | `3'b100` (Red)    | `3'b001` (Green)   | `3'b100` (Red)    | South is Green for 5 cycles.                      |
| `S5`          | 2               | `S6`       | `3'b100` (Red)      | `3'b100` (Red)    | `3'b010` (Yellow)  | `3'b100` (Red)    | South is Yellow for 2 cycles. All others Red.     |
| `S6`          | 5               | `S7`       | `3'b100` (Red)      | `3'b100` (Red)    | `3'b100` (Red)     | `3'b001` (Green)  | West is Green for 5 cycles.                       |
| `S7`          | 2               | `S0`       | `3'b100` (Red)      | `3'b100` (Red)    | `3'b100` (Red)     | `3'b010` (Yellow) | West is Yellow for 2 cycles. All others Red. Then cycles back to North Green. |

# 3. RTL Code

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

# RTL Schematic View
<img width="1605" height="858" alt="Screenshot 2025-07-28 211359" src="https://github.com/user-attachments/assets/aba8ebed-9ac6-4d1d-9b7a-2b70fe61c65a" />

# 4. TESTBENCH


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

# 5. Output Waveforms
<img width="1901" height="599" alt="Screenshot 2025-07-14 172437" src="https://github.com/user-attachments/assets/eb001773-c5e6-48ea-ac7e-8656b21914ac" />
