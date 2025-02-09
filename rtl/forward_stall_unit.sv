// we are forwarding from write back register instead of alu because this is 3 stage pipeline so we will not lose a cycle

module forward_stall_unit (
    input logic [4:0] i_rs1_addr,
    input logic [4:0] i_rs2_addr,
    input logic [4:0] i_rd_addr,
    input logic i_reg_wr_pp,
    input logic i_br_tk,
    output logic o_sela,
    output logic o_selb,
    output logic o_flush
);
    logic rs1_valid;
    logic rs2_valid;
    
    // Checking the validity of the source operand from decode & ececute stage
    assign rs1_valid = |i_rs1_addr;
    assign rs2_valid = |i_rs2_addr;

    // Forward mux selection logic 
    assign o_sela = ~( (i_rs1_addr == i_rd_addr) & i_reg_wr_pp & rs1_valid );
    assign o_selb = ~( (i_rs2_addr == i_rd_addr) & i_reg_wr_pp & rs2_valid );

    //Flushing next instruction in case of branch taken
    assign o_flush = i_br_tk;

endmodule