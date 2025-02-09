module tb;
  logic clk;
  logic rstn;

  risc_top dut (
      .i_clk (clk),
      .i_rstn(rstn)
  );

  initial begin
    clk = 0;
    forever #10 clk = ~clk;
  end

  initial begin
    rstn = 0;
    #10 rstn = 1;
    
  end

endmodule
