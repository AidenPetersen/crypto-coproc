// SHA256 constants
`define SHA256_SIG0 2'b00
`define SHA256_SIG1 2'b01
`define SHA256_SUM0 2'b10
`define SHA256_SUM1 2'b11

`define AES_D_MID 2'b00
`define AES_D_FINAL 2'b01
`define AES_E_MID 2'b10
`define AES_E_FINAL 2'b11

`define LOAD_LLI 2'b00
`define LOAD_LUI 2'b01

`define OP_SHA256_SIG0 4'd0
`define OP_SHA256_SIG1 4'd1
`define OP_SHA256_SUM0 4'd2
`define OP_SHA256_SUM1 4'd3
`define OP_AES_D_MID 4'd4
`define OP_AES_D_FINAL 4'd5
`define OP_AES_E_MID 4'd6
`define OP_AES_E_FINAL 4'd7
`define OP_LOAD_LLI 4'd8
`define OP_LOAD_LUI 4'd9