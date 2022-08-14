`timescale 1ns/1ps
// Definitions
module top(   
  input clk,
  output [7:0] out
);
  reg out=0;
  always @(posedge clk)
    out <= out + 1;
endmodule