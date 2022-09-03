// Definitions
`timescale 1ns/1ps
// Test Stimulus
//
module top_tb;

    reg s_axi_aclk;
    reg s_axi_aresetn;
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

    top t(
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
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

    // Initialze all of the signals
    initial begin
        s_axi_aclk = 0;
        s_axi_aresetn = 0;
        s_axi_awaddr = 5'b00000;
        s_axi_awvalid = 0;
        s_axi_wdata = 0;
        s_axi_wstrb = 4'hF;
        s_axi_wvalid = 0;
        s_axi_bready = 0;
        s_axi_araddr = 5'b00000;
        s_axi_arvalid = 0;
        s_axi_rready = 0;
    end
    always
        #5 s_axi_aclk = ~s_axi_aclk;
  
    initial begin
        #7.5 s_axi_aresetn <= 1;
        #5 s_axi_aresetn <= 0;
        // LLI on reg 1
        s_axi_wdata <= {11'h0008, 5'd1, 16'h1234};
        s_axi_awaddr <= 5'b00001;
        s_axi_wvalid <= 1;
        s_axi_awvalid <= 1;
        s_axi_bready <= 1;
        #10
        s_axi_wdata <= 32'h00000000;
        s_axi_awaddr <= 5'b00000;
        s_axi_wvalid <= 0;
        s_axi_awvalid <= 0;
        s_axi_bready <= 0;
        #10
        // Read recently written value
        s_axi_arvalid <= 1;
        s_axi_araddr <= 1;
        #10
        s_axi_arvalid <= 0;
        s_axi_araddr <= 0;
        #10
        // LUI reg 1 -> reg 2
        s_axi_wdata <= {11'h0009, 5'd1, 16'h5678};
        s_axi_awaddr <= 2;
        s_axi_wvalid <= 1;
        s_axi_awvalid <= 1;
        s_axi_bready <= 1;
        #10
        s_axi_wdata <= 32'h00000000;
        s_axi_awaddr <= 5'b00000;
        s_axi_wvalid <= 0;
        s_axi_awvalid <= 0;
        s_axi_bready <= 0;
        #10
        // Read recently written value
        s_axi_arvalid <= 1;
        s_axi_araddr <= 2;
        #10
        s_axi_arvalid <= 0;
        s_axi_araddr <= 0;
        #10
        s_axi_wdata <= {11'h0000, 5'd1, 5'd2, 11'h0000};
        s_axi_awaddr <= 3;
        s_axi_wvalid <= 1;
        s_axi_awvalid <= 1;
        s_axi_bready <= 1;
        #10
        s_axi_wdata <= {11'h0001, 5'd1, 5'd2, 11'h0000};
        s_axi_awaddr <= 4;
        #10
        s_axi_wdata <= {11'h0004, 5'd1, 5'd2, 11'h0000};
        s_axi_awaddr <= 5;
        #10
        s_axi_wdata <= {11'h0005, 5'd1, 5'd2, 11'h0001};
        s_axi_awaddr <= 6;
        #10
        s_axi_wdata <= 32'h00000000;
        s_axi_awaddr <= 5'b00000;
        s_axi_wvalid <= 0;
        s_axi_awvalid <= 0;
        s_axi_bready <= 0;
        #10
        s_axi_arvalid <= 1;
        s_axi_araddr <= 3;
        #10
        s_axi_arvalid <= 1;
        s_axi_araddr <= 4;
        #10
        s_axi_arvalid <= 1;
        s_axi_araddr <= 5;
        #10
        s_axi_arvalid <= 1;
        s_axi_araddr <= 6;
        #10
        s_axi_arvalid <= 0;
        s_axi_araddr <= 0;
        #10
        $finish;
    end
  
    initial begin
        $dumpfile("top_tb.vcd");
        $dumpvars(0,t);
    end

endmodule