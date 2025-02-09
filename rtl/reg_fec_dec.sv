`include "param.svh"

module reg_fec_dec (
    input logic i_clk,
    input logic i_rstn,
    input logic [`BIT_WIDTH-1:0] i_pc,
    input logic [`BIT_WIDTH-1:0] i_instr,
    input logic i_flush,
    output logic [`BIT_WIDTH-1:0] o_pc,
    output logic [`BIT_WIDTH-1:0] o_instr
);

    always_ff @(posedge i_clk or negedge i_rstn) begin

        if (!i_rstn) begin
            o_pc <= `BIT_WIDTH'b0;
            o_instr <= `BIT_WIDTH'b0;
        end

        else if (i_flush) begin
            o_pc <= i_pc;
            o_instr <= 32'h00000013;    // addi x0,x0,0
        end

        else  begin
            o_pc <= i_pc;
            o_instr <= i_instr;
        end

    end
endmodule