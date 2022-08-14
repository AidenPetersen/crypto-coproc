`timescale 1ns/1ps

module aes(
    // Inputs
    input clk,
    input rst,
    input [1:0] opcode, // Operation being executed
    input [31:0] rs1,
    input [31:0] rs2,
    input [1:0] bs, // byte select intermediate

    // Outputs
    output [31:0] rd
);
    `include "core/defs.v"


    wire [7:0] input_bytes [3:0];

    assign input_bytes[0] = rs2[7:0];
    assign input_bytes[1] = rs2[15:8];
    assign input_bytes[2] = rs2[23:16];
    assign input_bytes[3] = rs2[31:24];
    wire [7:0] selected_byte = input_bytes[bs];

    wire decode = opcode == `AES_D_MID || opcode == `AES_D_FINAL;
    wire mix    = opcode == `AES_D_MID || opcode == `AES_E_MID;

    

    // multiply by 2 function
    function [7:0] times2;
        input [7:0] x;

        times2 = {x[6:0], 1'b0} ^ (x[7] ? 8'h1b : 8'h00);
    endfunction

    // multiply by n
    function [7:0] timesN;
        input[7:0] x;
        input[7:0] y;

        timesN = 
            (y[0] ? x : 0) ^
            (y[1] ? times2(x) : 0) ^
            (y[2] ? times2(times2(x)) : 0) ^
            (y[3] ? times2(times2(times2(x))) : 0);
    endfunction

    wire [7:0] sbox_fwd_out, sbox_inv_out;
    wire [7:0] sbox_out = decode ? sbox_inv_out : sbox_fwd_out;

    // Sbox instances
    aes_forward_sbox i_aes_forward_sbox (.x(selected_byte), .y(sbox_fwd_out));
    aes_inverse_sbox i_aes_inverse_sbox (.x(selected_byte), .y(sbox_inv_out));

    // Rotations and stuff
    wire [31:0] mix_result;
    assign mix_result[31:24] = timesN(sbox_out, (decode ? 11 : 3));
    assign mix_result[23:16] = decode ? timesN(sbox_out, 13) : sbox_out;
    assign mix_result[15: 8] = decode ? timesN(sbox_out,  9) : sbox_out;
    assign mix_result[ 7: 0] = timesN(sbox_out, (decode ? 14 : 2)); 
    wire [31:0] result = mix ? mix_result : {24'b0, sbox_out};
    wire [31:0] rotated_result = 
        {32{bs == 2'b00}} & result |
        {32{bs == 2'b01}} & {result[23:0], result[31:24]} |
        {32{bs == 2'b10}} & {result[15:0], result[31:16]} |
        {32{bs == 2'b11}} & {result[ 7:0], result[31: 8]};
    assign rd = rotated_result ^ rs1;

endmodule
