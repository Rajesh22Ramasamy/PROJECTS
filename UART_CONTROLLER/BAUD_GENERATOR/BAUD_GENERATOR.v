// BAUD GENERATOR

module BAUD_GENERATOR
(
  input wire clk,
  input wire reset,
  output reg baud_tick,
  input wire baud_restart
);

reg [5:0]count; // 6 bits required to count up to 49

always @(posedge clk) begin

  if (reset || baud_restart) begin 
      count <= 6'd0;
      baud_tick <= 1'b0;
  end
  
  else begin
   
    if (count == 6'd49) begin
       count     <= 	6'd0;
	   baud_tick <= 1'b1;
	end
	
	else begin 
	
	   count     <= count + 1'b1;
	   baud_tick <= 1'b0;
	end
	
  end
  
end

endmodule

	
	   
	   
  