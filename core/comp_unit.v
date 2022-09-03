module comp_unit(
    input clk,
    input rst,
    input [31:0] rs1, rs2,
    input [15:0] immediate,
    input [3:0] operation,

    output reg [31:0] out
);
    `include "core/defs.v"
    reg [1:0] subcode;
    wire [31:0] load_out, aes_out, sha256_out;

    loads ld(
        .clk(clk),
        .rst(rst),
        .opcode(subcode),
        .immediate(immediate),
        .rs(rs1),

        .rd(load_out)
    );

    sha256 sha(
        .clk(clk),
        .rst(rst),
        .opcode(subcode),
        .rs1(rs1),

        .rd(sha256_out)
    );

    aes a(
        .clk(clk),
        .rst(rst),
        .opcode(subcode),
        .rs1(rs1),
        .rs2(rs2),
        .bs(immediate[1:0]),

        .rd(aes_out)
    );

    always @(*) begin
        case (operation)
            `OP_SHA256_SIG0: begin 
                out <= sha256_out;
                subcode <= `SHA256_SIG0;
            end
            `OP_SHA256_SIG1: begin 
                out <= sha256_out;
                subcode <= `SHA256_SIG1;

            end
            `OP_SHA256_SUM0: begin 
                out <= sha256_out;
                subcode <= `SHA256_SUM0;
            end
            `OP_SHA256_SUM1: begin 
                out <= sha256_out;
                subcode <= `SHA256_SUM1;
            end
            `OP_AES_D_MID: begin 
                out <= aes_out;
                subcode <= `AES_D_MID;
            end
            `OP_AES_D_FINAL: begin 
                out <= aes_out;
                subcode <= `AES_D_FINAL;
            end
            `OP_AES_E_MID: begin 
                out <= aes_out;
                subcode <= `AES_E_MID;
            end
            `OP_AES_E_FINAL: begin 
                out <= aes_out;
                subcode <= `AES_E_FINAL;
            end
            `OP_LOAD_LLI: begin
                out <= load_out;
                subcode <= `LOAD_LLI;
            end
            `OP_LOAD_LUI: begin
                out <= load_out;
                subcode <= `LOAD_LUI;
            end
            default: begin
                out <= 0;
                subcode <= 0;
            end
        endcase
    end
endmodule
