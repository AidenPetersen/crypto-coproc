`timescale 1ns/1ps
// Implements the sha256 algorithms
module sha256(
    // Inputs
    input clk,
    input rst,
    input [1:0] opcode,
    input [31:0] rs1,
    
    // Outputs
    output reg [31:0] rd
);
    `include "core/defs.v"

    // Useful rotation and shift macros
    `define ror(val, ramt) ((val >> ramt) | (val << 32 - ramt))
    `define srl(val, shamt) ((val >> shamt))

    // sha256 stage computations
    wire [31:0] sig0 = `ror(rs1,  7) ^ `ror(rs1, 18) ^ `srl(rs1,  3);
    wire [31:0] sig1 = `ror(rs1, 17) ^ `ror(rs1, 19) ^ `srl(rs1, 10);
    wire [31:0] sum0 = `ror(rs1,  2) ^ `ror(rs1, 13) ^ `ror(rs1, 22);
    wire [31:0] sum1 = `ror(rs1,  6) ^ `ror(rs1, 11) ^ `ror(rs1, 25);

    always @(*) begin
        case(opcode)
            `SHA256_SIG0: rd = sig0;
            `SHA256_SIG1: rd = sig1;
            `SHA256_SUM0: rd = sum0;
            `SHA256_SUM1: rd = sum1;
        endcase
    end
endmodule
