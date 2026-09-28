// TRANSMITTER MODULE FOR UART CONTROLLER

module TX_MODULE
(
   input wire clk,
   input wire reset,
   input wire baud_tick,
   input wire [7:0] tx_data,
   input wire tx_start,
   output reg tx,
   output reg tx_busy ,
   output reg baud_restart
);


reg [7:0] tx_shift_reg ;
reg [1:0] state;
reg [2:0] bit_count;   

always @(posedge clk) begin

    if(reset) begin
	    
		tx_shift_reg <= 8'd0;
		state        <= 2'b00;
		bit_count    <= 3'd0;
		tx           <= 1'b1;
		tx_busy      <= 1'b0;
		baud_restart <= 1'b0;
		

    end
	
    else if (state == 2'b00) begin 
	
     if (tx_start == 1'b0) begin
	  tx           <= 1'b1;
	  tx_busy      <= 1'b0;
	  state        <= 2'b00;
	  bit_count <= 3'd0;
     end
	  
     else begin 
	  bit_count    <= 3'd0;
      tx_shift_reg <= tx_data;
	  tx_busy      <= 1'b1;
	  state        <= 2'b01;
	  tx           <= 1'b1;
	  baud_restart <= 1'b1;
     end
   end

   else if (state == 2'b01) begin
       baud_restart <= 1'b0;
	   tx <= 1'b0;
	
	if (baud_tick) begin
	
       state <=  2'b10;	   
	end
   end

   else if (state == 2'b10) begin
   
    baud_restart <= 1'b0;
    tx  <= tx_shift_reg[0];

    if (baud_tick) begin
   
    
	 if ( bit_count == 3'd7) begin
	 
	    state  <= 2'b11;
     end
     
   
     else begin
   
      
	  tx_shift_reg  <= tx_shift_reg >> 1;
	  bit_count     <= bit_count + 3'b1;
	  
     end
	 
    end
	
   end
   
   else if (state == 2'b11) begin
   
     baud_restart <= 1'b0;
     tx       <= 1'b1;

     if (baud_tick) begin
     
       tx_busy  <= 1'b0;	
	   state   <= 2'b00;
     end	
   end

end

endmodule   
   

	  
	   
   