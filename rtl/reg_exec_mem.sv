`include "param.svh"

module reg_exec_mem (
    input logic i_clk,
    input logic i_rstn,
    input logic [`BIT_WIDTH-1:0] i_pc,
    input logic [`BIT_WIDTH-1:0] i_alu,
    input logic [`BIT_WIDTH-1:0] i_r2_d,
    input logic [4:0] i_rd,
    output logic [`BIT_WIDTH-1:0] o_pc,
    output logic [`BIT_WIDTH-1:0] o_alu,
    output logic [`BIT_WIDTH-1:0] o_r2_d,
    output logic [4:0] o_rd
);

    always_ff @(posedge i_clk or negedge i_rstn) begin

        if (!i_rstn) begin
            o_pc <= `BIT_WIDTH'b0;
            o_alu <= `BIT_WIDTH'b0;
            o_r2_d <= `BIT_WIDTH'b0;
            o_rd <= 5'b0;
        end

        else begin
            o_pc <= i_pc;
            o_alu <= i_alu;
            o_r2_d <= i_r2_d;
            o_rd <= i_rd;
        end

    end
endmodule