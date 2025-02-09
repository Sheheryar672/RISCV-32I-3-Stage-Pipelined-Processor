`include "param.svh"
`include "enum_pkg.sv"

module data_mem (
    input logic i_clk,
    input logic i_rd_en,
    input logic i_wr_en,
    input logic [2:0] i_fun3,  //funct 3 of load and store instruction
    input logic [`BIT_WIDTH-1:0] i_addr,
    input logic [`BIT_WIDTH-1:0] i_wr_data,
    output logic [`BIT_WIDTH-1:0] o_rd_data
);
  import enum_pkg::*;
  // 2048 bytes / 4 = 512 words
  logic [`BIT_WIDTH-1:0] mem[0 : 511];

  logic [`BIT_WIDTH-1:0] rd_data;

  initial begin
    $readmemh("E:/study related/Studies/study/Computer Architecture (CA)/CA_LAB_MINE/RV32I 3 stages pipelined/Complete single cycle pipelined/memory.mem",mem);
  end

  // Reading data memory
  always_comb begin
    if (i_rd_en) begin
      rd_data = mem[i_addr>>2];

      case (i_fun3)  // LOAD
        LB: begin  // Load byte
          case (i_addr[1:0])
            0: o_rd_data = {{24{rd_data[7]}}, rd_data[7:0]};
            1: o_rd_data = {{24{rd_data[15]}}, rd_data[15:8]};
            2: o_rd_data = {{24{rd_data[23]}}, rd_data[23:16]};
            3: o_rd_data = {{24{rd_data[31]}}, rd_data[31:24]};

          endcase
        end

        LH: begin  // Load halfword
          case (i_addr[1])
            0: o_rd_data = {{16{rd_data[15]}}, rd_data[15:0]};
            1: o_rd_data = {{16{rd_data[31]}}, rd_data[31:15]};
          endcase
        end

        LW: begin  // Load word 
          o_rd_data = rd_data;
        end

        LBU: begin  // Load Byte Unsigned
          case (i_addr[1:0])
            0: o_rd_data = {24'b0, rd_data[7:0]};
            1: o_rd_data = {24'b0, rd_data[15:8]};
            2: o_rd_data = {24'b0, rd_data[23:16]};
            3: o_rd_data = {24'b0, rd_data[31:24]};

          endcase
        end

        LHU: begin  // Load Halfword Unsigned
          case (i_addr[1])
            0: o_rd_data = {16'b0, rd_data[15:0]};
            1: o_rd_data = {16'b0, rd_data[31:15]};
          endcase
        end

      endcase

    end else begin
      o_rd_data = '0;
    end
  end

  // Writing data memory
  always_ff @(posedge i_clk) begin
    if (i_wr_en) begin
      case (i_fun3)
        SB: begin  // Store Byte
          case (i_addr[1:0])
            0: mem[i_addr>>2][7:0] <= i_wr_data[7:0];
            1: mem[i_addr>>2][15:8] <= i_wr_data[7:0];
            2: mem[i_addr>>2][23:16] <= i_wr_data[7:0];
            3: mem[i_addr>>2][31:24] <= i_wr_data[7:0];
          endcase

        end

        SH: begin  // Store Halfword
          case (i_addr[1])
            0: mem[i_addr>>2][15:0] <= i_wr_data[15:0];
            1: mem[i_addr>>2][31:16] <= i_wr_data[15:0];
          endcase

        end

        SW: begin  // Store Word
          mem[i_addr>>2] <= i_wr_data;
        end

      endcase

    end

  end

  initial begin
    #500;
    $writememh("Add the memory path here",mem);
  end

endmodule
