`timescale 1ns/1ps

module Minilab0_tb;

  // Clock and reset signals
  logic CLOCK_50;
  logic [3:0] KEY;

  // Switch inputs
  logic [9:0] SW;

  // Outputs
  logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  logic [9:0] LEDR;

  // Instantiate the DUT (Device Under Test)
  Minilab0 idut (
    .CLOCK_50(CLOCK_50),
	.CLOCK2_50(),
	.CLOCK3_50(),
	.CLOCK4_50(),
    .KEY(KEY),
    .SW(SW),
    .HEX0(HEX0),
    .HEX1(HEX1),
    .HEX2(HEX2),
    .HEX3(HEX3),
    .HEX4(HEX4),
    .HEX5(HEX5),
    .LEDR(LEDR)
  );

  // Clock generation
  initial begin
    CLOCK_50 = 0;
    forever #10 CLOCK_50 = ~CLOCK_50; // 50 MHz clock
  end

  // Test sequence
  initial begin
    // Initialize inputs
    KEY = 4'b1111; // Reset inactive
    SW = 10'b0;

    // Apply reset
	repeat(2) @(posedge CLOCK_50);
    KEY[0] = 0; // Assert reset
	repeat(2) @(posedge CLOCK_50);
    KEY[0] = 1; // Deassert reset

    // Wait for the FILL state
    repeat(10) @(posedge CLOCK_50);

    // Simulate switch activation to display result
    SW[0] = 1;

    // Wait for state transitions to Done
    @(posedge LEDR[1])
	// Wait for ouputs to be updated
	repeat(2) @(posedge CLOCK_50);

	// Print results
	$display("7-seg display: %b, %b, %b, %b, %b, %b", HEX5, HEX4, HEX3, HEX2, HEX1, HEX0);

	// End simulation
	$stop;
		
  end

endmodule
