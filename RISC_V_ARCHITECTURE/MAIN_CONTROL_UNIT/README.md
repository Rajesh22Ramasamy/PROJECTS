# Main Control Unit

## Description

The Main Control Unit generates the main control signals required by the processor based on the instruction opcode.

It operates in the Instruction Decode (ID) stage and determines the required operations for the EX, MEM and WB stages.

The current implementation supports R-Type instructions, ADDI, LW, SW and BEQ.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| opcode | 7-bit | Instruction opcode |
| reg_write | 1-bit | Register File write enable |
| alu_src | 1-bit | Selects the second ALU operand |
| mem_read | 1-bit | Data Memory read enable |
| mem_write | 1-bit | Data Memory write enable |
| mem_to_reg | 1-bit | Selects the write-back data source |
| branch | 1-bit | Branch control signal |
| alu_op | 2-bit | ALU operation category |

## Supported Opcodes

| Instruction | Opcode |
|-------------|--------|
| R-Type | 0110011 |
| ADDI | 0010011 |
| LW | 0000011 |
| SW | 0100011 |
| BEQ | 1100011 |

## Control Signal Generation

| Instruction | RegWrite | ALUSrc | MemRead | MemWrite | MemToReg | Branch | ALUOp |
|-------------|----------:|-------:|--------:|---------:|---------:|-------:|------:|
| R-Type | 1 | 0 | 0 | 0 | 0 | 0 | 10 |
| ADDI | 1 | 1 | 0 | 0 | 0 | 0 | 11 |
| LW | 1 | 1 | 1 | 0 | 1 | 0 | 00 |
| SW | 0 | 1 | 0 | 1 | 0 | 0 | 00 |
| BEQ | 0 | 0 | 0 | 0 | 0 | 1 | 01 |

## Operation

reg_write controls whether the instruction writes a result into the Register File. It is enabled for R-Type, ADDI and LW instructions.

alu_src selects the second ALU operand. R-Type and BEQ use a register value, while ADDI, LW and SW use the generated immediate value.

mem_read and mem_write control Data Memory access for LW and SW respectively.

mem_to_reg determines whether the value written back to the Register File comes from the ALU or Data Memory.

The branch signal identifies a BEQ instruction and is used along with the ALU zero flag to determine whether the branch is taken.

## ALU Control

alu_op provides the operation category required by the ALU Control Unit.

| ALUOp | Operation |
|-------|-----------|
| 00 | Addition for LW and SW address calculation |
| 01 | Subtraction for BEQ comparison |
| 10 | R-Type operation using funct3 and funct7 |
| 11 | Addition for ADDI |

For R-Type instructions, funct3 and funct7 are further decoded by the ALU Control Unit to select the required arithmetic or logical operation.

## Stall Handling

During a load-use hazard, the Hazard Detection Unit generates control_stall.

When control_stall is asserted, the control signals entering the ID/EX pipeline register are cleared. This inserts a bubble and prevents register, memory or branch operations from being performed by the stalled instruction during that cycle.

