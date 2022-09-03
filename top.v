// Definitions
module top(   
    input wire s_axi_aclk,
    input wire s_axi_aresetn,
    input wire [4:0] s_axi_awaddr,
    input wire s_axi_awvalid,
    output wire s_axi_awready,
    input wire [31:0] s_axi_wdata,
    input wire [3:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    output wire s_axi_wready,
    output wire [1:0] s_axi_bresp,
    output wire s_axi_bvalid,
    input wire s_axi_bready,
    input wire [4:0] s_axi_araddr,
    input wire s_axi_arvalid,
    output wire s_axi_arready,
    output wire [31:0] s_axi_rdata,
    output wire [1:0] s_axi_rresp,
    output wire s_axi_rvalid,
    input wire s_axi_rready
);
    // -----------------------------------------
    // Initialize axi interface and signals
    // -----------------------------------------
    // Local write wires
    wire write;
    wire [4:0] write_addrs;
    wire [31:0] write_data;
    reg write_error;
    reg write_done;
    wire [3:0] write_strobe;
    // Local read wires
    wire read;
    wire [4:0] read_addrs;
    wire [31:0] read_data;
    reg read_error;
    reg read_done;

    axi a(
        .write(write),
        .write_addrs(write_addrs),
        .write_data(write_data),
        .write_error(write_error),
        .write_done(write_done),
        .write_strobe(write_strobe),

        .read(read),
        .read_addrs(read_addrs),
        .read_data(read_data),
        .read_error(read_error),
        .read_done(read_done),

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

    // -----------------------------------------
    // Decode Write
    // -----------------------------------------
    wire write_enable;
    wire [4:0] rs1_reg, rs2_reg, rd_reg;
    wire [15:0] imm;
    wire load;
    wire [3:0] operation;
    write_decode wd(
        .clk(s_axi_aclk),
        .rst(s_axi_aresetn),
        .write_addr(write_addrs),
        .write_data(write_data),
        .write(write),

        .rs1(rs1_reg),
        .rs2(rs2_reg),
        .rd(rd_reg),
        .imm(imm),
        .write_enable(write_enable),
        .operation(operation)
    );

    // -----------------------------------------
    // Register file
    // -----------------------------------------
    wire [31:0] rs1_data, rs2_data;
    wire [31:0] writeback_data;

    regfile regf(
        .clk(s_axi_aclk),
        .rst(s_axi_aresetn),
        
        .write_enable(write_enable),
        .write_addr(write_addrs),
        .write_data(writeback_data),

        .read0_addr(read ? read_addrs : 5'b00000),
        .read1_addr(rs1_reg),
        .read2_addr(rs2_reg),

        .read0_data(read_data),
        .read1_data(rs1_data),
        .read2_data(rs2_data)
    );

    // -----------------------------------------
    // Computation logic unit
    // -----------------------------------------
    comp_unit cu(
        .clk(s_axi_aclk),
        .rst(s_axi_aresetn),
        .rs1(rs1_data),
        .rs2(rs2_data),
        .immediate(imm),
        .operation(operation),
        .out(writeback_data)
    );
    initial begin
        write_done = 0;
        write_error = 0;
        read_error = 0;
        read_done = 0;
    end
    // -----------------------------------------
    // Axi response logic
    // -----------------------------------------
    always @(posedge s_axi_aclk) begin
        // Assign Write
        if(write_done)
            write_done <= 0;
        if(write)
            write_done <= 1;
        
        // Assign Read
        if(read_done)
            read_done <= 0;
        if(read)
            read_done <= 1;
    end
endmodule