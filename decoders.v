module main_decoder(
  input[5:0] op,
  output memtoreg, memwrite,
  output branch, alusrc,
  output regdst, regwrite,
  output jump,
  output[1:0] aluop
);

  reg[8:0] ctrl;
  assign {regwrite, regdst, alusrc, branch,
          memwrite, memtoreg, jump, aluop} = ctrl;

  always @(op) begin
    case(op)
      6'b000000:
        ctrl <= 9'b110000010; // R-type
      6'b000010:
        ctrl <= 9'b000000100; // j
      6'b000100:
        ctrl <= 9'b000100001; // beq
      6'b001000:
        ctrl <= 9'b101000000; // addi
      6'b100011:
        ctrl <= 9'b101001000; // lw
      6'b101011:
        ctrl <= 9'b001010000; // sw
      default:
        ctrl <= 9'bxxxxxxxxx; // illegal op
    endcase
  end
endmodule

module alu_decoder(input[5:0] funct,
  input[1:0] aluop,
  output[2:0] alucontrol
);

  always @(aluop, funct) begin
    case (aluop)
      2'b00:
        alucontrol <= 3'b010; // add for I-types
      2'b01:
        alucontrol <= 3'b110; // sub for I-types (beq)

      default: // R-types
      case (funct)
        6'b100000:
          alucontrol <= 3'b010; // add
        6'b100010:
          alucontrol <= 3'b110; // sub
        6'b100100:
          alucontrol <= 3'b000; // and
        6'b100101:
          alucontrol <= 3'b001; // or
        6'b101010:
          alucontrol <= 3'b111; // slt
        default:
          alucontrol <= 3'bxxx; // ???
      endcase
    endcase
  end
endmodule