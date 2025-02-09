`include "param.svh"

module add_4 (
    input  logic [`BIT_WIDTH-1:0] i_a,
    output logic [`BIT_WIDTH-1:0] o_c
);

  assign o_c = i_a + 4;

endmodule
