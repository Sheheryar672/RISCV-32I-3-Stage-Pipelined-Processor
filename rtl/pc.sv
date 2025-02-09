`include "param.svh"

module pc (
    input logic i_clk,
    input logic i_rstn,     // Active low reset
    input logic [`BIT_WIDTH-1:0] i_a,
    output logic [`BIT_WIDTH-1:0] o_c
);

  always_ff @(posedge i_clk or negedge i_rstn) begin

    if (!i_rstn) begin
      o_c = `BIT_WIDTH'b0;
    end else begin
      o_c = i_a;
    end
  end

endmodule
