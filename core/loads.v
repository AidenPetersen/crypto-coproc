module loads(
    // Inputs
    input clk,
    input rst,
    input [1:0] opcode,
    input [15:0] immediate,
    input [31:0] rs,

    // Outputs
    output reg [31:0] rd
);
    `include "core/defs.v"

    always @(*) begin
        case(opcode)
            `LOAD_LUI: rd = {immediate, rs[15:0]};
            `LOAD_LLI: rd = {rs[31:16], immediate};
            default: rd = rs;
        endcase
    end
endmodule