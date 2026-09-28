// ALU MODULE

module ALU
(
   input wire [31:0] operand_A,
   input wire [31:0] operand_B,
   input wire [3:0] alu_operation,
   
   output reg [31:0] alu_result,
   output wire zero
);

always @(*) begin

    case (alu_operation)
	
	   4'b0000 : alu_result = operand_A + operand_B; //ADD
	   
	   4'b0001 : alu_result = operand_A - operand_B; //SUB
	   
	   4'b0010 : alu_result = operand_A & operand_B; //AND
	   
	   4'b0011 : alu_result = operand_A | operand_B; //OR
	   
	   4'b0100 : alu_result = operand_A ^ operand_B; //EXOR
	   
	   4'b0101 : alu_result = ($signed(operand_A) < $signed(operand_B))? 32'd1 : 32'd0;  //SLT
	   
	   default : alu_result = 32'd0;
	   
	endcase
	
end

assign zero = (alu_result == 0);

endmodule