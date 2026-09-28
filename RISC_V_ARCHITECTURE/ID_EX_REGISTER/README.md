# ID/EX Pipeline Register

## Description

The ID_EX_REGISTER is the pipeline register between the Instruction Decode (ID) and Execute (EX) stages.

It stores the decoded instruction data and control signals required by the EX stage. All values are captured at the positive edge of the clock and are available to the EX stage during the following cycle.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| id_pc | 32-bit | PC of the instruction in the ID stage |
| read_data1 | 32-bit | Data read from rs1 |
| read_data2 | 32-bit | Data read from rs2 |
| immediate | 32-bit | Sign-extended immediate value |
| rs1 | 5-bit | Source register 1 address |
| rs2 | 5-bit | Source register 2 address |
| rd | 5-bit | Destination register address |
| funct3 | 3-bit | Instruction function field |
| funct7 | 7-bit | Instruction function field |
| reg_write | 1-bit | Register File write enable |
| alu_src | 1-bit | Selects register or immediate for ALU operand B |
| mem_read | 1-bit | Data Memory read enable |
| mem_write | 1-bit | Data Memory write enable |
| mem_to_reg | 1-bit | Selects memory or ALU result for write-back |
| branch | 1-bit | Branch control signal |
| alu_op | 2-bit | Main ALU operation control |

The corresponding outputs contain the registered versions of these signals for use in the EX stage.

## Operation

At every positive clock edge, the ID/EX register captures the instruction PC, register operands, immediate value, register addresses, function fields and control signals.

The rs1 and rs2 information is used by the Forwarding Unit, while funct3, funct7 and alu_op are passed to the ALU Control Unit to determine the required ALU operation.

The remaining control signals are carried forward with the instruction for execution, memory access and write-back operations.

## Reset and Flush

When reset is asserted, all stored data and control signals are cleared to zero.

The register also supports a flush operation. When flush is asserted, the current contents are cleared and a bubble is inserted into the pipeline.

This is used when a taken branch requires a younger wrong-path instruction to be removed from the pipeline.

## Stall Handling

When the Hazard Detection Unit detects a load-use dependency, the PC and IF/ID pipeline register are held.

At the same time, the control signals entering the ID/EX stage are cleared. This inserts a bubble while allowing the older load instruction to continue through the pipeline.
