// single-cycle MIPS processor
// instantiates a controller and a datapath module

module mips(input          clk, reset,
  output  [31:0] pc,
  input   [31:0] instr,
  output         memwrite,
  output  [31:0] aluout, writedata,
  input   [31:0] readdata);

  wire        memtoreg, branch,
  pcsrc, zero,
  alusrc, regdst, regwrite, jump, 
  ///////////MODIFIED////////////
  ext;
  /////////END MODIFIED//////////
  wire [2:0]  alucontrol;

  controller c(instr[31:26], instr[5:0], zero,
    memtoreg, memwrite, pcsrc,
    alusrc, regdst, regwrite, jump,
    alucontrol,
    ///////////MODIFIED///////////
    ext
    ////////END MODIFIED//////////
    );
  datapath dp(clk, reset, memtoreg, pcsrc,
    alusrc, regdst, regwrite, jump,
    alucontrol,
    ///////////MODIFIED///////////
    ext,
    ////////END MODIFIED//////////
    zero, pc, instr,
    aluout, writedata, readdata);
endmodule

// Todo: Implement controller module
module controller(input[5:0] op, funct,
  input zero,
  output memtoreg, memwrite,
  output pcsrc, alusrc,
  output regdst, regwrite,
  output jump,
  output [2:0] alucontrol,
  output ext
);

  // **PUT YOUR CODE HERE**
  wire[1:0] aluop;
  wire[1:0] branch;
  main_decoder maindec(op, memtoreg, memwrite,
    branch, alusrc, regdst, regwrite,
    jump, aluop,
    /////////////MODIFIED/////////////
    ext
    ///////////END MODIFIED///////////
  );
  alu_decoder aludec(funct, aluop, alucontrol);
  
  ////////////////MODIFIED////////////////
  assign pcsrc = branch[1] & (zero ^ branch[0]);
  /////////////END MODIFIED///////////////

endmodule

// Todo: Implement datapath
module datapath(input clk, reset,
  input memtoreg, pcsrc,
  input alusrc, regdst,
  input regwrite, jump,
  input [2:0]  alucontrol,
  input ext,
  output zero,
  output [31:0] pc,
  input [31:0] instr,
  output [31:0] aluout, writedata,
  input [31:0] readdata
);

  // **PUT YOUR CODE HERE**
  wire [31:0] pcnext, pcnextbr, pcplus4, pcbranch;
  wire [4:0] writereg;
  wire [31:0] signimm, signimmsh, zeroimm, immext;
  
  wire [31:0] srca, srcb;
  wire [31:0] result;
  
// increment PC at each clock edge
  DFF pcreg(clk, reset, pcnext, pc);
  adder pcadd1(pc, 32'b100, pcplus4);
  sll2 immsh(signimm, signimmsh);
  adder pcadd2(pcplus4, signimmsh, pcbranch);
  mux2to1 pcbr_sel(pcsrc, pcplus4, pcbranch, pcnextbr);
  mux2to1 pc_sel(jump, pcnextbr, {pcplus4[31:28], instr[25:0], 2'b00}, 
                pcnext);

  // register file logic
  regfile regs(clk, regwrite, instr[25:21], instr[20:16],
                writereg, result, srca, writedata);
  mux2to1 #(5) a3_sel(regdst, instr[20:16], instr[15:11],
                writereg);
  mux2to1 res_sel(memtoreg, aluout, readdata, result);
  signext16to32 signextimm(instr[15:0], signimm);

  // ALU logic
  ///////////MODIFIED///////////////
  mux2to1 imm_sel(ext, {16'b0, instr[15:0]}, signimm, immext);
  ////////END MODIFIED//////////////
  mux2to1 srcb_sel(alusrc, writedata, immext, srcb);
  alu alu(srca, srcb, alucontrol, aluout, zero);

endmodule