// Definitions
`timescale 1ns/1ps
// Test Stimulus
//
module top_tb;
  reg clk;
  wire[7:0] out;
  top t1(clk,out);
  integer tally=0;

  initial
     clk = 1'b0;
  always
     #5 clk = ~clk;

  always @(posedge clk)
    if ( tally > 1000 )
      $finish;
    else
      tally <= tally + 1;

  initial
  begin
    $dumpfile("top_tb.vcd");
    $dumpvars(0,clk);
    $dumpvars(1,out);
  end

endmodule