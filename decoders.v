/*
* bne is implemented by adding an extra bit to the branch
* control signal, such that the signal is then 0'b10 for beq
* and 0b'11 for bne. The zero signal from the ALU is then XOR'ed
* with branch[0]
* 
* ori is implemented by setting alusrc to 1 and sending the
* correct alucontrol signal to the ALU, which already contained 
* OR functionality. The ext control is used to determine if an
* immediate should be sign- or zero-extended
*/

module main_decoder(
  input[5:0] op,
  output memtoreg, memwrite,
  /////////MODIFIED/////////
  output[1:0] branch, 
  ////////END MODIFIED///////
  output alusrc,
  output regdst, regwrite,
  output jump,
  output[1:0] aluop,
  /////////MODIFIED/////////
  output ext // sign or zero extend
  ////////END MODIFIED//////
);

//////////MODIFIED///////////
  reg[10:0] ctrl;
  assign {regwrite, regdst, alusrc, branch,
          memwrite, memtoreg, jump, aluop, ext} = ctrl;

  always @(op) begin
    case(op)
      6'b000000:
        ctrl <= 11'b1100000010x; // R-type
      6'b000010:
        ctrl <= 11'b0000000100x; // j
      6'b000100:
        ctrl <= 11'b00010000011; // beq
      6'b000101:
        ctrl <= 11'b00011000011; // bne
      6'b001000:
        ctrl <= 11'b10100000001; // addi
      6'b001101:
        ctrl <= 11'b10100000110; // ori
      6'b100011:
        ctrl <= 11'b10100010001; // lw
      6'b101011:
        ctrl <= 11'b00100100001; // sw
      default:
        ctrl <= 11'bxxxxxxxxxxx; // illegal op
    endcase
  end
/////////END MODIFIED//////////
endmodule

module alu_decoder(input[5:0] funct,
  input[1:0] aluop,
  output[2:0] alucontrol
);

  reg [2:0] ctrl;
  assign alucontrol = ctrl;

  always @(aluop, funct) begin
    case (aluop)
      2'b00:
        ctrl <= 3'b010; // add for I-types
      2'b01:
        ctrl <= 3'b110; // sub for I-types (beq, bne)
      ///////////MODIFIED/////////////
      2'b11:
        ctrl <= 3'b001; // or for I-types
      //////////END MODIFIED//////////
      default: // R-types 
      case (funct)
        6'b100000:
          ctrl <= 3'b010; // add
        6'b100010:
          ctrl <= 3'b110; // sub
        6'b100100:
          ctrl <= 3'b000; // and
        6'b100101:
          ctrl <= 3'b001; // or
        6'b101010:
          ctrl <= 3'b111; // slt
        default:
          ctrl <= 3'bxxx; // ???
      endcase
    endcase
  end
endmodule