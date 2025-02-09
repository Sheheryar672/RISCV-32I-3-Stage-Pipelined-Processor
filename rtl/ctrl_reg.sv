`include "enum_pkg.sv"

module ctrl_reg (
    input logic i_clk,
    input logic i_rstn,
    input logic i_reg_wr,
    input logic i_wr_en,
    input logic i_rd_en,
    input logic [1:0] i_wb_sel,
    output logic o_reg_wr,
    output logic o_wr_en,
    output logic o_rd_en,
    output logic [1:0] o_wb_sel
);

    import enum_pkg::*;

    always_ff @(posedge i_clk or negedge i_rstn) begin

        if (!i_rstn) begin
            o_reg_wr <= 1'b0;
            o_wr_en  <= 1'b0;
            o_rd_en  <= 1'b0;
            o_wb_sel <= 2'b10;      // Initilize to LOAD instructions
        end

        else begin
            o_reg_wr <= i_reg_wr;
            o_wr_en <= i_wr_en;
            o_rd_en <= i_rd_en;
            o_wb_sel <= i_wb_sel;
        end

    end 

endmodule