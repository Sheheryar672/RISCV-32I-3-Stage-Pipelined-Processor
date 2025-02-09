`include "param.svh"
module mux_2x1 (
    input  logic [`BIT_WIDTH-1:0] i_a,
    input  logic [`BIT_WIDTH-1:0] i_b,
    input  logic i_sel,  // control signal for mux
    output logic [`BIT_WIDTH-1:0] o_y
);

  assign o_y = i_sel ? i_b : i_a;

endmodule

