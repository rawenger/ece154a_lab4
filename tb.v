module tb();
  reg clk;
  reg reset;
  wire [31:0] writedata, dataadr;
  wire memwrite;
  // instantiate device to be tested
  top dut (clk, reset, writedata, dataadr, memwrite);
  // initialize test
  initial
  begin
    reset <= 1; # 22; reset <= 0;
  end
  // generate clock to sequence tests
  always
  begin
    clk <= 1; # 5; clk <= 0; # 5;
  end
  
  always @(negedge clk)
  begin
    if (memwrite) begin
        // check results for memfile 1
//      if (dataadr===84 & writedata===7) begin
        // check results for memfile 2
      if (dataadr === 'hffff7385 && writedata === 'hffff7233) begin
        $display("Simulation succeeded");
        $stop;
//      end else if (dataadr !==80) begin
      end else begin
        $display("Simulation failed");
        $stop;
      end
    end
  end
endmodule
