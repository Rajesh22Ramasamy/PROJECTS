// ALU CONTROL UNIT

module ALU_CONTROL
(
   input wire [1:0] alu_op,
   input wire [2:0] funct3,
   input wire [6:0] funct7,

   output reg [3:0] alu_control
);

always @(*) begin

   // Default operation
   alu_control = 4'b0000;       // ADD

   case (alu_op)

      // LW / SW
      
      2'b00: begin
         alu_control = 4'b0000; // ADD
      end


      // BEQ
     
      2'b01: begin
         alu_control = 4'b0001; // SUB
      end


      // R-TYPE
      2'b10: begin

         case (funct3)

            3'b000: begin

               if (funct7 == 7'b0100000)
                  alu_control = 4'b0001; // SUB

               else
                  alu_control = 4'b0000; // ADD

            end

            3'b111:
               alu_control = 4'b0010;    // AND

            3'b110:
               alu_control = 4'b0011;    // OR

            3'b100:
               alu_control = 4'b0100;    // XOR

            3'b010:
               alu_control = 4'b0101;    // SLT

            default:
               alu_control = 4'b0000;

         endcase

      end


      // I-TYPE arithmetic
      
      2'b11: begin
         alu_control = 4'b0000;          // ADD
      end


      default: begin
         alu_control = 4'b0000;
      end

   endcase

end

endmodule