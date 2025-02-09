`include "param.svh"
`include "enum_pkg.sv"

module branch_cond (
    input  logic [`BIT_WIDTH-1:0] i_a,
    input  logic [`BIT_WIDTH-1:0] i_b,
    input  logic [2:0] i_br_ty,  // Input for funct3 to specify the branch condition
    output logic o_br_tk   // Output for branch taken signal
);
  import enum_pkg::*;

  always_comb begin

    case (i_br_ty)
      BEQ:  o_br_tk = (i_a == i_b);  // BEQ: Branch if Equal
      BNE:  o_br_tk = (i_a != i_b);  // BNE: Branch if Not Equal
      BLT:  o_br_tk = ($signed(i_a) < $signed(i_b));  // BLT: Branch if Less Than
      BGE:  o_br_tk = ($signed(i_a) >= $signed(i_b));  // BGE: Branch if Greater Than or Equal
      BLTU: o_br_tk = (i_a < i_b);  // BLTU: Branch if Less Than Unsigned
      BGEU: o_br_tk = (i_a >= i_b);  // BGEU: Branch if Greater Than or Equal Unsigned
      NB:   o_br_tk = 0;  // No B-type instruction
      J:    o_br_tk = 1;  // JAL instruction
    endcase

  end

endmodule
