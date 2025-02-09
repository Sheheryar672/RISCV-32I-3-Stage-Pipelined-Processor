`include "enum_pkg.sv"
`include "param.svh"


module risc_dec (
    input logic [`BIT_WIDTH-1:0] instr_i,
    output logic [6:0] op_o,
    output logic [4:0] rd_o,
    output logic [2:0] funct3_o,
    output logic [4:0] rs1_o,
    output logic [4:0] rs2_o,
    output logic [6:0] funct7_o,
    output logic [`BIT_WIDTH-1:0] imm_o
);
  import enum_pkg::*;

  assign op_o = instr_i[6:0];

  always_comb begin

    case (op_o)

      ALU_REG: begin  // R_type
        rd_o = instr_i[11:7];
        funct3_o = instr_i[14:12];
        rs1_o = instr_i[19:15];
        rs2_o = instr_i[24:20];
        funct7_o = instr_i[31:25];
        imm_o = 32'b0;
      end

      LOAD, ALU_IMM, JALR: begin  // I-type
        rd_o = instr_i[11:7];
        funct3_o = instr_i[14:12];
        rs1_o = instr_i[19:15];
        imm_o = {{20{instr_i[31]}}, instr_i[31:20]};
        rs2_o = 5'b0;
        funct7_o = 7'b0;
      end

      STORE: begin  // S-type
        funct3_o = instr_i[14:12];
        rs1_o = instr_i[19:15];
        rs2_o = instr_i[24:20];
        imm_o = {{20{instr_i[31]}}, instr_i[31:25], instr_i[11:7]};
        rd_o = 5'b0;
        funct7_o = 7'b0;
      end

      JAL: begin  // J-type
        rd_o = instr_i[11:7];
        imm_o = {{12{instr_i[31]}}, instr_i[19:12], instr_i[20], instr_i[30:21], 1'b0};
        funct7_o = 7'b0;
        rs1_o = 5'b0;
        rs2_o = 5'b0;
        funct3_o = 3'b0;
      end

      BRANCH: begin  // B-type
        funct3_o = instr_i[14:12];
        rs1_o = instr_i[19:15];
        rs2_o = instr_i[24:20];
        imm_o = {{20{instr_i[31]}}, instr_i[7], instr_i[30:25], instr_i[11:8], 1'b0};
        funct7_o = 7'b0;
        rd_o = 5'b0;
      end

      AUIPC, LUI: begin  // U-type
        rd_o = instr_i[11:7];
        imm_o = {instr_i[31:12], 12'b0};
        funct7_o = 7'b0;
        rs1_o = 5'b0;
        rs2_o = 5'b0;
        funct3_o = 3'b0;
      end

      default: begin
        rd_o = 5'b0;
        rs1_o = 5'b0;
        rs2_o = 5'b0;
        funct3_o = 3'b0;
        funct7_o = 7'b0;
        imm_o = 32'b0;
      end

    endcase

  end
endmodule
