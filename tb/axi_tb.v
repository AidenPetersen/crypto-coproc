`timescale 1ns/1ps
module axi_tb;
    // Write channel signals
    wire write;
    wire [4:0] write_addrs;
    wire [31:0] write_data;
    wire [3:0] write_strobe;
    reg write_error, write_done;

    // Read Channel signals
    wire read;
    wire [4:0] read_addrs;
    reg [31:0] read_data;
    reg read_error;
    reg read_done;

    // Axi interface signals
    reg clk, rst;
    reg [4:0] s_axi_awaddr;
    reg s_axi_awvalid;
    wire s_axi_awready;
    reg [31:0] s_axi_wdata;
    reg [3:0] s_axi_wstrb;
    reg s_axi_wvalid;
    wire s_axi_wready;
    wire [1:0] s_axi_bresp;
    wire s_axi_bvalid;
    reg s_axi_bready;
    reg [4:0] s_axi_araddr;
    reg s_axi_arvalid;  
    wire s_axi_arready;
    wire [31:0] s_axi_rdata;
    wire [1:0] s_axi_rresp;
    wire s_axi_rvalid;
    reg s_axi_rready;

    axi dut (

        // Write channel
        .write(write),
        .write_addrs(write_addrs),
        .write_data(write_data),
        .write_error(write_error),
        .write_done(write_done),
        .write_strobe(write_strobe),

        // Read channel
        .read(read),
        .read_addrs(read_addrs),
        .read_data(read_data),
        .read_error(read_error),
        .read_done(read_done),

        // Slave Interface
        .s_axi_aclk(clk),
        .s_axi_aresetn(rst),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awready(s_axi_awready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .s_axi_wready(s_axi_wready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arready(s_axi_arready),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_rready(s_axi_rready)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        #7.5 rst <= 1;
        #5 rst <= 0;
        // Setup
        write_error <= 0;
        write_done <= 0;
        read_data <= 0;
        read_error <= 0;
        read_done <= 0;

        s_axi_awaddr <= 0;
        s_axi_awvalid <= 0;
        s_axi_wdata <= 0;
        s_axi_wstrb <= 4'b1111;
        s_axi_wvalid <= 0;
        s_axi_bready <= 0;
        s_axi_araddr <= 0;
        s_axi_arvalid <= 0;
        s_axi_rready <= 0;
        #10

        // Write Send
        s_axi_awaddr <= 12;
        s_axi_wdata <= 123; // This would be an instruction in the actual coproc
        s_axi_awvalid <= 1;
        s_axi_wvalid <= 1;
        s_axi_bready <= 1;
        write_done <= 1;


        #10
        // Write done
        s_axi_awvalid <= 0;
        s_axi_wvalid <= 0;
        s_axi_bready <= 0;
        write_done <= 0;

        #10
        // Read
        s_axi_araddr <= 13;
        s_axi_arvalid <= 1;
        read_data <= 1234;
        read_done <= 1;
        #10
        read_done <= 0;
        #10
        $finish;
    end


    initial begin
        $dumpfile("axi_tb.vcd");
        $dumpvars(0, axi_tb);
    end

endmodule