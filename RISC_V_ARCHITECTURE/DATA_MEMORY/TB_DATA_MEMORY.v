// TESTBENCH FOR DATA MEMORY

`timescale 1ns/1ps

module tb_DATA_MEMORY;

reg clk;

reg mem_read;
reg mem_write;

reg [31:0] address;
reg [31:0] write_data;

wire [31:0] read_data;


// DUT INSTANTIATION

DATA_MEMORY DUT
(
   .clk(clk),

   .mem_read(mem_read),
   .mem_write(mem_write),

   .address(address),
   .write_data(write_data),

   .read_data(read_data)
);


// CLOCK GENERATION
// Clock period = 20 ns

initial begin
   clk = 1'b0;

   forever #10 clk = ~clk;
end


initial begin

$display("---------------------------------------------------------------");
$display("                 DATA MEMORY TESTBENCH");
$display("---------------------------------------------------------------");
$display(" MEM_READ  MEM_WRITE   ADDRESS   WRITE_DATA   READ_DATA");
$display("---------------------------------------------------------------");

$monitor("    %b         %b        %4d        %4d        %4d",
         mem_read,
         mem_write,
         address,
         write_data,
         read_data);


   // Initial values

   mem_read  = 1'b0;
   mem_write = 1'b0;
   address   = 32'd0;
   write_data = 32'd0;

   #100;


   // ------------------------------------------------
   // TEST 1 : WRITE 25 TO ADDRESS 0
   // SW behavior
   // Expected:
   // data_memory[0] = 25
   // ------------------------------------------------

   address    = 32'd0;
   write_data = 32'd25;

   mem_write = 1'b1;
   mem_read  = 1'b0;

   #100;


   // ------------------------------------------------
   // TEST 2 : READ ADDRESS 0
   // LW behavior
   // Expected read_data = 25
   // ------------------------------------------------

   mem_write = 1'b0;
   mem_read  = 1'b1;

   address = 32'd0;

   #100;


   // ------------------------------------------------
   // TEST 3 : WRITE 50 TO ADDRESS 8
   //
   // address[9:2] = 8 / 4 = 2
   // Expected:
   // data_memory[2] = 50
   // ------------------------------------------------

   mem_read  = 1'b0;
   mem_write = 1'b1;

   address    = 32'd8;
   write_data = 32'd50;

   #100;


   // ------------------------------------------------
   // TEST 4 : READ ADDRESS 8
   // Expected read_data = 50
   // ------------------------------------------------

   mem_write = 1'b0;
   mem_read  = 1'b1;

   address = 32'd8;

   #100;


   // ------------------------------------------------
   // TEST 5 : VERIFY ADDRESS 0 IS STILL 25
   // ------------------------------------------------

   address = 32'd0;

   #100;


   // ------------------------------------------------
   // TEST 6 : MEM_WRITE = 0
   // Try changing write_data to 99
   // Memory should NOT be modified
   // ------------------------------------------------

   mem_read  = 1'b0;
   mem_write = 1'b0;

   address    = 32'd0;
   write_data = 32'd99;

   #100;


   // ------------------------------------------------
   // TEST 7 : READ ADDRESS 0 AGAIN
   // Expected read_data = 25, NOT 99
   // ------------------------------------------------

   mem_read  = 1'b1;
   mem_write = 1'b0;

   address = 32'd0;

   #100;


   // ------------------------------------------------
   // TEST 8 : MEM_READ = 0
   // Expected read_data = 0
   // ------------------------------------------------

   mem_read = 1'b0;

   #100;


$display("---------------------------------------------------------------");
$display("             DATA MEMORY TEST COMPLETED");
$display("---------------------------------------------------------------");

$stop;

end

endmodule