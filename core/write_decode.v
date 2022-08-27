module write_decode(
    // Inputs
    input clk,
    input rst,
    input [4:0] write_addr,
    input [31:0] write_data,
    input write,

    // Outputs
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output [4:0] rd,
    output reg [15:0] imm,
    output load,
    output write_enable,
    output [3:0] operation
);
    `include "core/defs.v"
    wire is_load = write_data[24:21] == `OP_LOAD_LLI || write_data[24:21] == `OP_LOAD_LUI;

    assign operation = write_data[24:21];
    assign load = is_load;
    assign rd = write_addr;
    assign write_enable = write;

    always @(*) begin
        // Load instructions
        if (is_load) begin
            rs1 <= write_data[20:16];
            rs2 <= 0;
            imm <= write_data[15:0];
        end
        // normal "R"-type instructions
        else begin
            rs1 <= write_data[20:16];
            rs2 <= write_data[15:11];
            imm <= {5'b00000, write_data[10:0]};
        end
    end
endmodule