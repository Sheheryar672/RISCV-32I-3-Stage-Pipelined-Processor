`include "param.svh"

module risc_top (
    input logic i_clk,
    input logic i_rstn
);

  logic [`BIT_WIDTH-1:0] pc_addr;
  logic [`BIT_WIDTH-1:0] pc_add_4;
  logic [`BIT_WIDTH-1:0] o_pc_mux;

  logic [`BIT_WIDTH-1:0] instr;

  logic [6:0] op;
  logic [4:0] rd;
  logic [2:0] funct3;
  logic [4:0] rs1;
  logic [4:0] rs2;
  logic [6:0] funct7;
  logic [`BIT_WIDTH-1:0] imm;

  logic [3:0] alu_op;
  logic reg_wr;

  logic [`BIT_WIDTH-1:0] rs1_data;
  logic [`BIT_WIDTH-1:0] rs2_data;

  logic [`BIT_WIDTH-1:0] alu_res;

  logic sel_b;
  logic rd_en;
  logic [1:0] wb_sel;

  logic [`BIT_WIDTH-1:0] dmem_out;
  logic [`BIT_WIDTH-1:0] i_alu_b;
  logic [`BIT_WIDTH-1:0] i_alu_a;

  logic [`BIT_WIDTH-1:0] wb_out;

  logic wr_en;

  logic sel_a;
  logic [2:0] br_ty;
  logic br_tk;

  logic [`BIT_WIDTH-1:0] pc_addr_pp_1;
  logic [`BIT_WIDTH-1:0] instr_pp;

  logic [`BIT_WIDTH-1:0] pc_addr_pp_2;
  logic [`BIT_WIDTH-1:0] alu_res_pp;
  logic [`BIT_WIDTH-1:0] rs2_data_pp;
  logic [4:0] rd_pp;

  logic [`BIT_WIDTH-1:0] pc_add_4_pp_2;

    logic reg_wr_pp;
    logic wr_en_pp;
    logic rd_en_pp;
    logic [1:0] wb_sel_pp;

    logic sela;
    logic selb;

    logic [`BIT_WIDTH-1:0] for_mux_rd1;
    logic [`BIT_WIDTH-1:0] for_mux_rd2;
     
    logic flush;

// Fetch
  pc progam_counter (
      .i_clk(i_clk),
      .i_rstn(i_rstn),
      .i_a(o_pc_mux),
      .o_c(pc_addr)
  );

  add_4 add4 (
      .i_a(pc_addr),
      .o_c(pc_add_4)
  );

  mux_2x1 pc_mux (
      .i_a  (pc_add_4),
      .i_b  (alu_res),
      .i_sel(br_tk),
      .o_y  (o_pc_mux)
  );

  instr_mem instr_memory (
      .pc_addr(pc_addr),
      .o_instr(instr)
  );
// pipeline register between fetch and decode_execute

    reg_fec_dec reg_if_id (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_pc(pc_addr),
        .i_instr(instr),
        .i_flush(flush),
        .o_pc(pc_addr_pp_1),
        .o_instr(instr_pp)
    );

// Decode and execute
  risc_dec dec (
      .instr_i(instr_pp),
      .op_o(op),
      .rd_o(rd),
      .funct3_o(funct3),
      .rs1_o(rs1),
      .rs2_o(rs2),
      .funct7_o(funct7),
      .imm_o(imm)
  );

  controller control (
      .i_op(op),
      .i_fun3(funct3),
      .i_fun7(funct7),
      .i_imm(imm),
      .o_alu_op(alu_op),
      .o_reg_wr(reg_wr),
      .o_sel_a(sel_a),
      .o_sel_b(sel_b),
      .o_rd_en(rd_en),
      .o_wr_en(wr_en),
      .o_wb_sel(wb_sel),
      .o_br_ty(br_ty)
  );

  register reg_f (
      .i_clk(i_clk),
      .i_rstn(i_rstn),
      .i_wr_en(reg_wr_pp),
      .i_raddr1(rs1),
      .i_raddr2(rs2),
      .i_wr_addr(rd_pp),
      .i_data(wb_out),
      .o_rdata1(rs1_data),
      .o_rdata2(rs2_data)
  );

    mux_2x1 rd2_imm_mux (
        .i_a  (for_mux_rd2),
        .i_b  (imm),
        .i_sel(sel_b),
        .o_y  (i_alu_b)
    );

    mux_2x1 rd1_pc_mux (
        .i_a  (pc_addr_pp_1),
        .i_b  (for_mux_rd1),
        .i_sel(sel_a),
        .o_y  (i_alu_a)
    );

    alu alu_unit (
        .i_a  (i_alu_a),
        .i_b  (i_alu_b),
        .i_sel(alu_op),
        .o_y  (alu_res)
    );

    branch_cond branch (
        .i_a(for_mux_rd1),
        .i_b(for_mux_rd2),
        .i_br_ty(br_ty),
        .o_br_tk(br_tk)
    );

// Pipeline and controlregister between decode_execute and Memory_writeback

    reg_exec_mem reg_ie_im (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_pc(pc_addr_pp_1),
        .i_alu(alu_res),
        .i_r2_d(rs2_data),
        .i_rd(rd),
        .o_pc(pc_addr_pp_2),
        .o_alu(alu_res_pp),
        .o_r2_d(rs2_data_pp),
        .o_rd(rd_pp)
    );

    ctrl_reg control_reg (
        .i_clk(i_clk),
        .i_rstn(i_rstn),
        .i_reg_wr(reg_wr),
        .i_wr_en(wr_en),
        .i_rd_en(rd_en),
        .i_wb_sel(wb_sel),
        .o_reg_wr(reg_wr_pp),
        .o_wr_en(wr_en_pp),
        .o_rd_en(rd_en_pp),
        .o_wb_sel(wb_sel_pp)
    );



// Memory and Writeback
    
    add_4 add4_mem_wb (
        .i_a(pc_addr_pp_2),
        .o_c(pc_add_4_pp_2)
    );

    data_mem d_mem (
        .i_clk(i_clk),
        .i_rd_en(rd_en_pp),
        .i_wr_en(wr_en_pp),
        .i_fun3(funct3),
        .i_addr(alu_res_pp),
        .i_wr_data(rs2_data_pp),
        .o_rd_data(dmem_out)
    );

    mux_3x1 wb_mux (
        .i_a  (pc_add_4_pp_2),
        .i_b  (alu_res_pp),
        .i_c  (dmem_out),
        .i_sel(wb_sel_pp),
        .o_y  (wb_out)
    );

  // Forwarding unit and  Muxes (using writeback mux and not alu)

    forward_stall_unit fsu (
        .i_rs1_addr(rs1),
        .i_rs2_addr(rs2),
        .i_rd_addr(rd_pp),
        .i_reg_wr_pp(reg_wr_pp),
        .i_br_tk(br_tk),
        .o_sela(sela),
        .o_selb(selb),
        .o_flush(flush)
    );

    
    mux_2x1 fw_rd1 (
        .i_a  (wb_out),
        .i_b  (rs1_data),
        .i_sel(sela),
        .o_y  (for_mux_rd1)
    );

    mux_2x1 fw_rd2 (
        .i_a  (wb_out),
        .i_b  (rs2_data),
        .i_sel(selb),
        .o_y  (for_mux_rd2)
    );




endmodule
