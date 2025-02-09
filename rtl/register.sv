
`include "param.svh"


module register (
    input  logic i_clk,
    input  logic i_rstn,     //reset is active low
    input  logic i_wr_en,
    input  logic [4:0] i_raddr1,
    input  logic [4:0] i_raddr2,
    input  logic [4:0] i_wr_addr,
    input  logic [`BIT_WIDTH-1:0] i_data,
    output logic [`BIT_WIDTH-1:0] o_rdata1,
    output logic [`BIT_WIDTH-1:0] o_rdata2
);

  reg [`BIT_WIDTH-1:0] reg_32b[0:15];

  always_ff @(posedge i_clk or negedge i_rstn) begin
    if (!i_rstn) begin
      // Reset all Register to 0
      for (int i = 0; i < 16; i++) begin
        reg_32b[i] <= `BIT_WIDTH'b0;
      end
    end else if (i_wr_en && (i_wr_addr != 4'b0000)) begin
      // Writing data
      reg_32b[i_wr_addr] <= i_data;
    end
  end

  always_comb begin
    // Reading data from register 1
    o_rdata1 = (i_raddr1 == 4'b0000) ? `BIT_WIDTH'b0 : reg_32b[i_raddr1];
    // Reading data from Register 2
    o_rdata2 = (i_raddr2 == 4'b0000) ? `BIT_WIDTH'b0 : reg_32b[i_raddr2];
  end

endmodule
