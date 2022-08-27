`timescale 1ns/1ps
module regfile_tb;
    reg clk, rst, write_enable;
    reg [4:0] write_addr, read0_addr, read1_addr;
    reg [31:0] write_data;
    wire [31:0] read0_data, read1_data;
    
    regfile dut (
        .clk(clk),
        .rst(rst),
        
        .write_enable(write_enable),

        .write_addr(write_addr),
        .write_data(write_data),

        .read0_addr(read0_addr),
        .read1_addr(read1_addr),

        .read0_data(read0_data),
        .read1_data(read1_data)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        #7.5 rst <= 1;
        #5 rst <= 0;
        write_enable <= 1;
        write_data <= 15;
        write_addr <= 15;
        read0_addr <= 15;
        read1_addr <= 0;
        #10
        write_data <= 123;
        write_addr <= 0;
        #10
        write_data <= 123;
        write_addr <= 1;
        read1_addr <= 1;
        #10
        $finish;
    end

    initial begin
        $dumpfile("regfile_tb.vcd");
        $dumpvars(0, regfile_tb);
    end

endmodule