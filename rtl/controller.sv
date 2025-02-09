`include "enum_pkg.sv"

module controller (
    input logic [6:0] i_op,
    input logic [2:0] i_fun3,
    input logic [6:0] i_fun7,
    input logic [31:0] i_imm,
    output logic [3:0] o_alu_op,
    output logic o_reg_wr,
    output logic o_sel_a,
    output logic o_sel_b,
    output logic o_rd_en,
    output logic o_wr_en,
    output logic [1:0] o_wb_sel,
    output logic [2:0] o_br_ty
);
  import enum_pkg::*;

  always_comb begin

    case (i_op)
      ALU_REG: begin  // R-type
        o_reg_wr = 1'b1;
        o_sel_a  = 1'b1;
        o_sel_b  = 1'b0;
        o_wb_sel = 2'b01;
        o_rd_en  = 1'b0;
        o_wr_en  = 2'b0;
        o_br_ty  = NB;

        case ({
          i_fun7, i_fun3
        })
          {7'b0000000, 3'b000} : o_alu_op = ADD;
          {7'b0100000, 3'b000} : o_alu_op = SUB;
          {7'b0000000, 3'b001} : o_alu_op = SLL;
          {7'b0000000, 3'b010} : o_alu_op = SLT;
          {7'b0000000, 3'b011} : o_alu_op = SLTU;
          {7'b0000000, 3'b100} : o_alu_op = XOR;
          {7'b0000000, 3'b101} : o_alu_op = SRL;
          {7'b0100000, 3'b101} : o_alu_op = SRA;
          {7'b0000000, 3'b110} : o_alu_op = OR;
          {7'b0000000, 3'b111} : o_alu_op = AND;
          default: o_alu_op = 4'b0000;
        endcase

      end
      ALU_IMM: begin  // I-type
        o_reg_wr = 1'b1;
        o_sel_a  = 1'b1;
        o_sel_b  = 1'b1;
        o_wb_sel = 2'b01;
        o_rd_en  = 1'b0;
        o_wr_en  = 1'b0;
        o_br_ty  = NB;

        case ({
          i_imm[11:5], i_fun3
        })
          {7'b0000000, 3'b000} : o_alu_op = ADD;  // ADDI (Add Immediate)
          {7'b0000000, 3'b001} : o_alu_op = SLL;  //SLLI (Shift Left Logical Immediate)
          {7'b0000000, 3'b010} : o_alu_op = SLT;  // SLTI (Set Less Than Immediate)
          {7'b0000000, 3'b011} : o_alu_op = SLTU;  // SLTIU (Set Less Than Immediate Unsigned)
          {7'b0000000, 3'b100} : o_alu_op = XOR;  // XORI (XOR Immediate)
          {7'b0000000, 3'b101} : o_alu_op = SRL;  // SRLI (Shift Right Logical Immediate)
          {7'b0100000, 3'b101} : o_alu_op = SRA;  // SRAI (Shift Right Arithmetic Immediate)
          {7'b0000000, 3'b110} : o_alu_op = OR;  // ORI (OR Immediate)
          {7'b0000000, 3'b111} : o_alu_op = AND;  // ANDI (AND Immediate)
          default: o_alu_op = ADD;  // Default case, if needed           
        endcase

      end

      LOAD: begin  // I-type
        o_reg_wr = 1'b1;
        o_sel_a  = 1'b1;
        o_sel_b  = 1'b1;
        o_wb_sel = 2'b10;
        o_rd_en  = 1'b1;
        o_alu_op = ADD;  // Add register to immediate
        o_wr_en  = 1'b0;
        o_br_ty  = NB;
      end

      STORE: begin  // S-type
        o_reg_wr = 1'b0;
        o_sel_a  = 1'b1;
        o_sel_b  = 1'b1;
        o_wb_sel = 2'b01;  // Not used for STORE instructions
        o_rd_en  = 1'b0;
        o_alu_op = ADD;  // Add register to immediate
        o_wr_en  = 1'b1;
        o_br_ty  = NB;
      end

      BRANCH: begin  // B-type
        o_alu_op = ADD;
        o_reg_wr = 1'b0;
        o_sel_a  = 1'b0;
        o_sel_b  = 1'b1;
        o_rd_en  = 1'b0;
        o_wr_en  = 1'b0;
        o_wb_sel = 2'b01;
        o_br_ty  = i_fun3;
      end

      LUI: begin  // U-type
        o_alu_op = LUI_ALU;
        o_reg_wr = 1'b1;
        o_sel_a  = 1'b0;  // Not used for LUI instruction
        o_sel_b  = 1'b1;
        o_rd_en  = 1'b0;
        o_wr_en  = 1'b0;
        o_wb_sel = 2'b01;
        o_br_ty  = NB;
      end

      AUIPC: begin  // U-type
        o_alu_op = ADD;
        o_reg_wr = 1'b1;
        o_sel_a  = 1'b0;
        o_sel_b  = 1'b1;
        o_rd_en  = 1'b0;
        o_wr_en  = 1'b0;
        o_wb_sel = 2'b01;
        o_br_ty  = NB;
      end

      JAL: begin  // J-type
        o_alu_op = ADD;
        o_reg_wr = 1'b1;
        o_sel_a  = 1'b0;
        o_sel_b  = 1'b1;
        o_rd_en  = 1'b0;
        o_wr_en  = 1'b0;
        o_wb_sel = 2'b00; // JAL writes PC + 4 to rd
        o_br_ty  = J;       
      end

      JALR: begin  // I-type
        o_alu_op = ADD;
        o_reg_wr = 1'b1;
        o_sel_a  = 1'b1;
        o_sel_b  = 1'b1;
        o_rd_en  = 1'b0;
        o_wr_en  = 1'b0;
        o_wb_sel = 2'b00; // JAL writes PC + 4 to rd
        o_br_ty  = J;   
      end

      default: begin
        o_alu_op = ADD;
        o_reg_wr = 1'b0;
        o_sel_a  = 1'b0;
        o_sel_b  = 1'b0;
        o_rd_en  = 1'b0;
        o_wr_en  = 1'b0;
        o_wb_sel = 2'b01; // default because register write is off
        o_br_ty  = NB;
      end
    endcase
  end


endmodule
