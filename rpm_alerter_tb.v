`timescale 1ns / 1ps

module top_basys3_tacho_tb;

  // Testbench signals
  reg clk = 0;
  reg rst_n = 0;
  reg pulse_in = 0;
  wire led, buzzer;
  wire [6:0] seg;
  wire [3:0] an;

  // Instantiate DUT
  top_basys3_tacho dut (
    .clk(clk),
    .rst_n(rst_n),
    .pulse_in(pulse_in),
    .led(led),
    .buzzer(buzzer),
    .seg(seg),
    .an(an)
  );

  // Generate 10ns clock
  always #5 clk = ~clk;

  // Seven-segment driver stub (to prevent compilation error)
  // If you have an implementation, use that one. This is only for simulation.
  // Place this module at the end of the testbench file.
  
  initial begin
    // Apply reset (active-low BTN0)
    rst_n = 0;
    pulse_in = 0;
    #50;
    rst_n = 1; // release reset

    // --------- CASE 1: RPM < threshold ---------
    wait(dut.tick); @(posedge clk);
    send_pulses(1); // threshold = 3, send 1 pulse
    wait(dut.done); #1;
    $display("CASE 1: RPM < threshold, count_out = %d, buzzer = %b, led = %b", dut.count_out, buzzer, led);

    // --------- CASE 2: RPM == threshold ---------
    wait(dut.tick); @(posedge clk);
    send_pulses(3); // send 3 pulses
    wait(dut.done); #1;
    $display("CASE 2: RPM == threshold, count_out = %d, buzzer = %b, led = %b", dut.count_out, buzzer, led);

    // --------- CASE 3: RPM > threshold ---------
    wait(dut.tick); @(posedge clk);
    send_pulses(5); // send 5 pulses
    wait(dut.done); #1;
    $display("CASE 3: RPM > threshold, count_out = %d, buzzer = %b, led = %b", dut.count_out, buzzer, led);

    $display("Testbench complete.");
    $finish;
  end

  // Task to pulse the Hall input
  task send_pulses(input integer npulses);
    integer i;
    begin
      for (i = 0; i < npulses; i = i + 1) begin
        pulse_in = 1; #10;
        pulse_in = 0; #10;
      end
    end
  endtask

endmodule
module sevenseg_driver(input clk, input [3:0] bin, output reg [6:0] seg, output reg [3:0] an);
    always @(posedge clk) begin
      seg = 7'b1111111;
      an = 4'b1110;
    end
  endmodule
