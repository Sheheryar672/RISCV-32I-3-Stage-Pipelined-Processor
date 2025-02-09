`include "enum_pkg.sv"
`include "param.svh"

module alu (
    input logic [`BIT_WIDTH-1 : 0] i_a,
    input logic [`BIT_WIDTH-1 : 0] i_b,
    input logic [3:0] i_sel,
    output logic [`BIT_WIDTH-1 : 0] o_y
);

    import enum_pkg ::*;

    always_comb begin

        case (i_sel)
            ADD:  o_y = i_a + i_b;            // ADD
            SUB:  o_y = i_a - i_b;            // SUB
            SLL:  o_y = i_a << i_b;           // SLL (Shift Left Logical)
            SLT:  o_y = ($signed(i_a) < $signed(i_b)) ? 1 : 0; // SLT (Set Less Than)
            SLTU: o_y = (i_a < i_b) ? 1 : 0; // SLTU (Set Less Than Unsigned)
            XOR:  o_y = i_a ^ i_b;            // XOR
            SRL:  o_y = i_a >> i_b;           // SRL (Shift Right Logical)
            SRA:  o_y = $signed(i_a) >>> i_b[4:0]; // SRA (Shift Right Arithmetic) //i_b[4:0] will give shamt
            OR:   o_y = i_a | i_b;            // OR
            AND:  o_y = i_a & i_b;            // AND
            LUI_ALU: o_y = i_b;                // LUI (U-type) 
            default: o_y = {`BIT_WIDTH{1'b0}}; // Default case (zero output)
        endcase
        
    end

endmodule