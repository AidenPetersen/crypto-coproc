`timescale 1ns/1ps
module write_decode_tb;
    // Inputs
    reg clk;
    reg rst;

    reg [4:0] write_addr;
    reg [31:0] write_data;
    reg write;

    // Outputs
    wire [4:0] rs1;
    wire [4:0] rs2;
    wire [4:0] rd;
    wire [15:0] imm;
    wire [3:0] operation;
    wire load;
    wire write_enable;
    
    write_decode dut(
        .clk(clk),
        .rst(rst),
        .write_addr(write_addr),
        .write_data(write_data),
        .write(write),
        
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .imm(imm),
        .load(load),
        .write_enable(write_enable),
        .operation(operation)
    );

    always #5 clk = ~clk;

    initial begin
        clk <= 0;
        rst <= 0;
        write <= 1;
        // Load
        write_addr <= 12;
        write_data <= {11'd8, 5'd13, 16'd1234};
        #10
        // R-Type
        write_addr <= 3;
        write_data <= {11'd0, 5'd3, 5'd4, 11'd0};
        #10

        $finish;
    end

    initial begin
        $dumpfile("write_decode_tb.vcd");
        $dumpvars(0, write_decode_tb);
    end
endmodule