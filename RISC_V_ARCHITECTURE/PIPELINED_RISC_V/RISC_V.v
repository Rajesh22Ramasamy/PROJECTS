// 5-STAGE PIPELINED RISC-V PROCESSOR
// Supported instructions:
// ADD, SUB, AND, OR, XOR, SLT
// ADDI, LW, SW, BEQ

module RISC_V_PIPELINED_PROCESSOR
(
   input wire clk,
   input wire reset
);


// ============================================================
//                     IF STAGE
// ============================================================

// Program Counter signals
wire [31:0] pc;
wire [31:0] pc_plus4;
wire [31:0] pc_next;

wire [31:0] instruction;


// Hazard / control signals
wire pc_write;
wire if_id_write;
wire control_stall;


// Branch signals
wire        branch_taken;
wire [31:0] branch_target;


// Select next PC
assign pc_next = branch_taken
               ? branch_target
               : pc_plus4;


// PROGRAM COUNTER

PROGRAM_COUNTER PC_UNIT
(
   .clk(clk),
   .reset(reset),
   .pc_write(pc_write),

   .pc_next(pc_next),

   .pc(pc)
);


// PC + 4

PC_ADDER PC_ADD_UNIT
(
   .pc(pc),

   .pc_next(pc_plus4)
);


// INSTRUCTION MEMORY

INSTRUCTION_MEMORY INST_MEM
(
   .pc(pc),

   .instruction(instruction)
);


// ============================================================
//                   IF/ID PIPELINE REGISTER
// ============================================================

wire [31:0] if_id_pc;
wire [31:0] if_id_instruction;


IF_ID_REGISTER IF_ID
(
   .clk(clk),
   .reset(reset),

   .if_id_write(if_id_write),
   .flush(branch_taken),

   .pc(pc),
   .instruction(instruction),

   .if_id_pc(if_id_pc),
   .if_id_instruction(if_id_instruction)
);


// ============================================================
//                     ID STAGE
// ============================================================

// Extract instruction fields

wire [6:0] opcode;

wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;

wire [2:0] funct3;
wire [6:0] funct7;


assign opcode = if_id_instruction[6:0];

assign rd     = if_id_instruction[11:7];

assign funct3 = if_id_instruction[14:12];

assign rs1    = if_id_instruction[19:15];

assign rs2    = if_id_instruction[24:20];

assign funct7 = if_id_instruction[31:25];


// ============================================================
//                    MAIN CONTROL UNIT
// ============================================================

wire reg_write;
wire alu_src;
wire mem_read;
wire mem_write;
wire mem_to_reg;
wire branch;

wire [1:0] alu_op;


MAIN_CONTROL MAIN_CONTROL_UNIT
(
   .opcode(opcode),

   .reg_write(reg_write),
   .alu_src(alu_src),
   .mem_read(mem_read),
   .mem_write(mem_write),
   .mem_to_reg(mem_to_reg),
   .branch(branch),

   .alu_op(alu_op)
);


// ============================================================
//                     REGISTER FILE
// ============================================================

wire [31:0] read_data1;
wire [31:0] read_data2;


// Write-back signals will be generated later
wire [31:0] wb_write_data;

wire [4:0] mem_wb_rd;
wire       mem_wb_reg_write;


REGISTER_FILE REG_FILE
(
   .clk(clk),
   .reset(reset),

   .rs1(rs1),
   .rs2(rs2),

   .rd(mem_wb_rd),

   .write_data(wb_write_data),

   .reg_write(mem_wb_reg_write),

   .read_data1(read_data1),
   .read_data2(read_data2)
);


// ============================================================
//                   IMMEDIATE GENERATOR
// ============================================================

wire [31:0] immediate;


IMMEDIATE_GENERATOR IMM_GEN
(
   .instruction(if_id_instruction),

   .immediate(immediate)
);


// ============================================================
//                 HAZARD DETECTION UNIT
// ============================================================

// ID/EX signals required here are declared below.

wire       id_ex_mem_read;
wire [4:0] id_ex_rd;


HAZARD_DETECTION_UNIT HAZARD_UNIT
(
   .id_ex_mem_read(id_ex_mem_read),
   .id_ex_rd(id_ex_rd),

   .if_id_rs1(rs1),
   .if_id_rs2(rs2),

   .pc_write(pc_write),
   .if_id_write(if_id_write),
   .control_stall(control_stall)
);


// ============================================================
//            STALL CONTROL / BUBBLE GENERATION
// ============================================================

// When control_stall = 1,
// all control signals entering ID/EX become zero.

wire id_reg_write;
wire id_alu_src;
wire id_mem_read;
wire id_mem_write;
wire id_mem_to_reg;
wire id_branch;

wire [1:0] id_alu_op;


assign id_reg_write  = control_stall ? 1'b0  : reg_write;

assign id_alu_src    = control_stall ? 1'b0  : alu_src;

assign id_mem_read   = control_stall ? 1'b0  : mem_read;

assign id_mem_write  = control_stall ? 1'b0  : mem_write;

assign id_mem_to_reg = control_stall ? 1'b0  : mem_to_reg;

assign id_branch     = control_stall ? 1'b0  : branch;

assign id_alu_op     = control_stall ? 2'b00 : alu_op;


// ============================================================
//                  ID/EX PIPELINE REGISTER
// ============================================================

wire [31:0] id_ex_pc;

wire [31:0] id_ex_read_data1;
wire [31:0] id_ex_read_data2;

wire [31:0] id_ex_immediate;

wire [4:0] id_ex_rs1;
wire [4:0] id_ex_rs2;

wire [2:0] id_ex_funct3;
wire [6:0] id_ex_funct7;

wire id_ex_reg_write;
wire id_ex_alu_src;
wire id_ex_mem_write;
wire id_ex_mem_to_reg;
wire id_ex_branch;

wire [1:0] id_ex_alu_op;


ID_EX_REGISTER ID_EX
(
   .clk(clk),
   .reset(reset),

   .flush(branch_taken),

   .id_pc(if_id_pc),

   .read_data1(read_data1),
   .read_data2(read_data2),

   .immediate(immediate),

   .rs1(rs1),
   .rs2(rs2),
   .rd(rd),

   .funct3(funct3),
   .funct7(funct7),

   .reg_write(id_reg_write),
   .alu_src(id_alu_src),

   .mem_read(id_mem_read),
   .mem_write(id_mem_write),

   .mem_to_reg(id_mem_to_reg),

   .branch(id_branch),

   .alu_op(id_alu_op),

   .id_ex_pc(id_ex_pc),

   .id_ex_read_data1(id_ex_read_data1),
   .id_ex_read_data2(id_ex_read_data2),

   .id_ex_immediate(id_ex_immediate),

   .id_ex_rs1(id_ex_rs1),
   .id_ex_rs2(id_ex_rs2),
   .id_ex_rd(id_ex_rd),

   .id_ex_funct3(id_ex_funct3),
   .id_ex_funct7(id_ex_funct7),

   .id_ex_reg_write(id_ex_reg_write),
   .id_ex_alu_src(id_ex_alu_src),

   .id_ex_mem_read(id_ex_mem_read),
   .id_ex_mem_write(id_ex_mem_write),

   .id_ex_mem_to_reg(id_ex_mem_to_reg),

   .id_ex_branch(id_ex_branch),

   .id_ex_alu_op(id_ex_alu_op)
);


// ============================================================
//                     EX STAGE
// ============================================================


// ============================================================
//                     ALU CONTROL
// ============================================================

wire [3:0] alu_control;


ALU_CONTROL ALU_CONTROL_UNIT
(
   .alu_op(id_ex_alu_op),

   .funct3(id_ex_funct3),
   .funct7(id_ex_funct7),

   .alu_control(alu_control)
);


// ============================================================
//                    FORWARDING UNIT
// ============================================================

wire [4:0] ex_mem_rd;
wire       ex_mem_reg_write;

wire [1:0] forward_A;
wire [1:0] forward_B;


FORWARDING_UNIT FORWARD_UNIT
(
   .id_ex_rs1(id_ex_rs1),
   .id_ex_rs2(id_ex_rs2),

   .ex_mem_rd(ex_mem_rd),
   .ex_mem_reg_write(ex_mem_reg_write),

   .mem_wb_rd(mem_wb_rd),
   .mem_wb_reg_write(mem_wb_reg_write),

   .forward_A(forward_A),
   .forward_B(forward_B)
);


// ============================================================
//                 FORWARDING MULTIPLEXERS
// ============================================================

reg [31:0] forwarded_A;
reg [31:0] forwarded_B;


wire [31:0] ex_mem_alu_result;


// Operand A forwarding

always @(*) begin

   case (forward_A)

      2'b00:
         forwarded_A = id_ex_read_data1;

      2'b10:
         forwarded_A = ex_mem_alu_result;

      2'b01:
         forwarded_A = wb_write_data;

      default:
         forwarded_A = id_ex_read_data1;

   endcase

end


// Operand B forwarding

always @(*) begin

   case (forward_B)

      2'b00:
         forwarded_B = id_ex_read_data2;

      2'b10:
         forwarded_B = ex_mem_alu_result;

      2'b01:
         forwarded_B = wb_write_data;

      default:
         forwarded_B = id_ex_read_data2;

   endcase

end


// ============================================================
//                     ALU SOURCE MUX
// ============================================================

wire [31:0] alu_operand_B;


assign alu_operand_B = id_ex_alu_src
                     ? id_ex_immediate
                     : forwarded_B;


// ============================================================
//                          ALU
// ============================================================

wire [31:0] alu_result;
wire        zero;


ALU ALU_UNIT
(
   .operand_A(forwarded_A),

   .operand_B(alu_operand_B),

   .alu_operation(alu_control),

   .alu_result(alu_result),

   .zero(zero)
);


// ============================================================
//                      BRANCH LOGIC
// ============================================================

BRANCH_LOGIC BRANCH_UNIT
(
   .pc(id_ex_pc),

   .immediate(id_ex_immediate),

   .branch(id_ex_branch),

   .zero(zero),

   .branch_target(branch_target),

   .branch_taken(branch_taken)
);


// ============================================================
//                  EX/MEM PIPELINE REGISTER
// ============================================================

wire [31:0] ex_mem_store_data;

wire        ex_mem_zero;

wire ex_mem_mem_read;
wire ex_mem_mem_write;
wire ex_mem_mem_to_reg;
wire ex_mem_branch;


EX_MEM_REGISTER EX_MEM
(
   .clk(clk),
   .reset(reset),

   .alu_result(alu_result),

   // Important:
   // use forwarded_B, not alu_operand_B.
   // SW needs the register value being stored.
   .store_data(forwarded_B),

   .rd(id_ex_rd),

   .zero(zero),

   .reg_write(id_ex_reg_write),

   .mem_read(id_ex_mem_read),

   .mem_write(id_ex_mem_write),

   .mem_to_reg(id_ex_mem_to_reg),

   .branch(id_ex_branch),

   .ex_mem_alu_result(ex_mem_alu_result),

   .ex_mem_store_data(ex_mem_store_data),

   .ex_mem_rd(ex_mem_rd),

   .ex_mem_zero(ex_mem_zero),

   .ex_mem_reg_write(ex_mem_reg_write),

   .ex_mem_mem_read(ex_mem_mem_read),

   .ex_mem_mem_write(ex_mem_mem_write),

   .ex_mem_mem_to_reg(ex_mem_mem_to_reg),

   .ex_mem_branch(ex_mem_branch)
);


// ============================================================
//                     MEM STAGE
// ============================================================

wire [31:0] memory_read_data;


DATA_MEMORY DATA_MEM
(
   .clk(clk),

   .mem_read(ex_mem_mem_read),

   .mem_write(ex_mem_mem_write),

   .address(ex_mem_alu_result),

   .write_data(ex_mem_store_data),

   .read_data(memory_read_data)
);


// ============================================================
//                 MEM/WB PIPELINE REGISTER
// ============================================================

wire [31:0] mem_wb_read_data;
wire [31:0] mem_wb_alu_result;

wire        mem_wb_mem_to_reg;


MEM_WB_REGISTER MEM_WB
(
   .clk(clk),
   .reset(reset),

   .read_data(memory_read_data),

   .alu_result(ex_mem_alu_result),

   .rd(ex_mem_rd),

   .reg_write(ex_mem_reg_write),

   .mem_to_reg(ex_mem_mem_to_reg),

   .mem_wb_read_data(mem_wb_read_data),

   .mem_wb_alu_result(mem_wb_alu_result),

   .mem_wb_rd(mem_wb_rd),

   .mem_wb_reg_write(mem_wb_reg_write),

   .mem_wb_mem_to_reg(mem_wb_mem_to_reg)
);


// ============================================================
//                       WB STAGE
// ============================================================

// Select:
// LW       → memory data
// ALU ops  → ALU result

assign wb_write_data = mem_wb_mem_to_reg
                     ? mem_wb_read_data
                     : mem_wb_alu_result;


endmodule