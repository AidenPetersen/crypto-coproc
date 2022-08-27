module regfile (
    // inputs
    input clk,
    input rst,

    input write_enable,
    input [4:0] write_addr,
    input [31:0] write_data,

    // Used for writes
    input [4:0] read0_addr,
    input [4:0] read1_addr,

    // Used for reads
    input [4:0] read2_addr,

    // outputs
    output reg [31:0] read0_data,
    output reg [31:0] read1_data,
    output reg [31:0] read2_data
);
    reg [31:0] registers [31:0];

    always @(posedge clk) begin
        if(write_enable) 
            registers[write_addr] <= write_data;
    end

    integer i;
    always @(*) begin
        if(rst) begin
            for(i = 0; i < 32; i = i + 1) registers[i] <= 32'h0000;
        end
        registers[0] <= 0;
        read0_data <= registers[read0_addr];
        read1_data <= registers[read1_addr];
        read2_data <= registers[read2_addr];
    end
endmodule