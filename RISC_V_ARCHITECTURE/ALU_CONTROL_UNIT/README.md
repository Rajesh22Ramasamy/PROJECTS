# ALU Control Unit

## Description

The ALU Control Unit generates the control signal required by the ALU to perform the required arithmetic or logical operation.

The operation is selected using alu_op from the Main Control Unit along with the funct3 and funct7 fields of the instruction.

## Inputs and Output

| Signal | Width | Description |
|--------|-------|-------------|
| alu_op | 2-bit | Control signal from the Main Control Unit |
| funct3 | 3-bit | Function field from the instruction |
| funct7 | 7-bit | Used to differentiate operations such as ADD and SUB |
| alu_control | 4-bit | Control signal provided to the ALU |

## ALU Control Encoding

| alu_control | Operation |
|-------------|-----------|
| 0000 | ADD |
| 0001 | SUB |
| 0010 | AND |
| 0011 | OR |
| 0100 | XOR |
| 0101 | SLT |

## Working

The Main Control Unit identifies the instruction type and generates alu_op. The ALU Control Unit then uses alu_op along with funct3 and funct7 to determine the required ALU operation.

- alu_op = 00 is used for LW and SW. Addition is performed to calculate the memory address using rs1 and the immediate value.
- alu_op = 01 is used for BEQ. Subtraction is performed to compare rs1 and rs2.
- alu_op = 10 is used for R-type instructions. funct3 and funct7 are used to select ADD, SUB, AND, OR, XOR or SLT.
- alu_op = 11 is used for I-type arithmetic instructions. The current implementation supports ADDI.

For R-type ADD and SUB, funct3 is 000 for both instructions. The funct7 field is therefore used to distinguish between the two operations.

## Verification

The module was verified using a Verilog testbench with different combinations of alu_op, funct3 and funct7.

The test cases include LW and SW address calculation, BEQ comparison, R-type ADD, SUB, AND, OR, XOR, SLT and ADDI. Unsupported combinations were also tested to verify the default behavior.