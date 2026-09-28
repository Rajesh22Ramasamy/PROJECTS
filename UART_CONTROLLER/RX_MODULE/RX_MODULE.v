//RECEIVER MODULE FOR UART CONTROLLER

module RX_MODULE
(
   input wire clk,
   input wire reset,
   input wire rx,
   
   output reg [7:0] rx_data,
   output reg rx_done
);

reg [2:0]state;
reg [5:0] sample_count;
reg [2:0] bit_count;
reg [7:0] rx_shift_reg;
reg rx_ff1;
reg rx_ff2;

localparam 

IDLE  = 3'b000,
START = 3'b001,
DATA  = 3'b010,
STOP  = 3'b011,
DONE = 3'b100;

always @(posedge clk) begin

    if (reset) begin
        rx_ff1 <= 1'b1;
        rx_ff2 <= 1'b1;
    end

    else begin
        rx_ff1 <= rx;
        rx_ff2 <= rx_ff1;
    end

end

always @(posedge clk) begin

if (reset) begin
   state         <= IDLE;
   sample_count  <= 6'd0;
   bit_count     <= 3'd0;
   rx_shift_reg  <= 8'd0;
   rx_data       <= 8'd0;
   rx_done       <= 1'b0;   
   
   
end

else begin 

  case(state)
   
   IDLE: begin
   
     rx_done       <= 1'b0;
     sample_count  <= 6'd0;
     bit_count     <= 3'd0;
   
     if(!rx_ff2) begin
    
	   state <= START;
	
     end
	 
   end
   
   START: begin
	 
	 
	 if (sample_count == 6'd24) begin
	    
		sample_count <= 6'd0;
		
		if (!rx_ff2) begin

         state <= DATA;
		 
        end	   
		
		else begin
		
		 state <= IDLE;
		
		end
		
     end 
	 
	 else begin
	    
		sample_count <= sample_count + 1'b1;
		
	 end
   
   end
   
   DATA : begin
   
     if (sample_count == 6'd49) begin
    
	  sample_count <= 6'd0;
	  
	  rx_shift_reg[bit_count] <= rx_ff2;
	  
	  if (bit_count == 3'd7) begin
	  
	     state <= STOP;
		
	  end
	  
	  else begin
	  
	    bit_count <= bit_count + 1'b1;
		
	  end
	  
	 end
	  
     else begin
   
      sample_count <= sample_count + 1'b1;
	  
     end
	 
   end
   
   STOP: begin

     if (sample_count == 6'd49) begin

        sample_count <= 6'd0;

        if (rx_ff2 == 1'b1) begin
            state <= DONE;
        end

        else begin
            state <= IDLE;
        end

    end

    else begin

        sample_count <= sample_count + 1'b1;

    end

   end
   
   DONE: begin

    rx_data <= rx_shift_reg;
    rx_done <= 1'b1;
    state   <= IDLE;

   end
  
  
   default: begin
            
	state <= IDLE;
	
   end

  endcase

end

end

endmodule
     
	  
   
   