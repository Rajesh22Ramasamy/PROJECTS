// HAZARD DETECTION UNIT

module HAZARD_DETECTION_UNIT
(
   
   input wire id_ex_mem_read,
   input wire [4:0] id_ex_rd,
   input wire [4:0] if_id_rs1,
   input wire [4:0] if_id_rs2,

   output reg pc_write,
   output reg if_id_write,
   output reg control_stall
);

always @(*) begin

   // Default: pipeline operates normally
   pc_write      = 1'b1;
   if_id_write   = 1'b1;
   control_stall = 1'b0;

   // Detect Load-Use Hazard
   if (id_ex_mem_read &&
       (id_ex_rd != 5'd0) &&
       ((id_ex_rd == if_id_rs1) ||
        (id_ex_rd == if_id_rs2))) begin

      // Stall the pipeline
      pc_write      = 1'b0;
      if_id_write   = 1'b0;
      control_stall = 1'b1;

   end

end

endmodule