`include "param.svh"
`include "enum_pkg.sv"

module mux_3x1 (
    input logic [`BIT_WIDTH-1:0] i_a,
    input logic [`BIT_WIDTH-1:0]i_b,
    input logic [`BIT_WIDTH-1:0]i_c,
    input logic [1:0] i_sel,
    output logic [`BIT_WIDTH-1:0] o_y
);

    import enum_pkg ::*;

    always_comb begin
        case(i_sel) 
            J_WB: o_y = i_a;
            ALU_WB: o_y = i_b;
            DMEM_WB: o_y = i_c;
        endcase
    end

endmodule