// IMMEDIATE GENERATOR

module  IMMEDIATE_GENERATOR
(
   input wire [31:0] instruction,
   output reg [31:0] immediate   // the immediate is updated inside always(*) begin
);

wire [6:0] opcode;

assign opcode = instruction [6:0];

   always @(*) begin
   
      case(opcode)
	  
	    7'b0010011 : begin    //ADDI TYPE
		
		  immediate = {{20{instruction[31]}}, instruction[31:20]};
		  
		end
		
		7'b0000011 : begin   //LW TYPE
		
		  immediate = {{20{instruction[31]}}, instruction[31:20]};
		  
		end
		
		7'b0100011 : begin   //S TYPE
		
		  immediate = {{20{instruction[31]}},instruction[31:25], instruction[11:7]};
		  
		end
		
		7'b1100011 : begin   //B TYPE
		
		  immediate = {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25], instruction[11:8], 1'b0};
		  
		end
		
		default : begin
		
		  immediate = 32'd0;
		  
		end
	  
	  endcase
	  
	end

endmodule