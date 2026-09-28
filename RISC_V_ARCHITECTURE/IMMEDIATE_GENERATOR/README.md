# Immediate Generator

## Description

The Immediate Generator extracts the immediate value from a 32-bit RISC-V instruction and converts it into a 32-bit signed value.

Different instruction formats store immediate bits at different positions. The instruction opcode is used to identify the required format and generate the corresponding immediate value.

The current implementation supports ADDI, LW, SW and BEQ instructions.

## Inputs and Output

| Signal | Width | Description |
|--------|------:|-------------|
| instruction | 32-bit | Instruction being decoded |
| immediate | 32-bit | Extracted and sign-extended immediate value |

## Supported Formats

| Instruction | Format | Opcode |
|-------------|--------|--------|
| ADDI | I-Type | 0010011 |
| LW | I-Type | 0000011 |
| SW | S-Type | 0100011 |
| BEQ | B-Type | 1100011 |

## Immediate Generation

For ADDI and LW, the I-Type immediate is obtained from instruction bits 31:20 and sign-extended to 32 bits.

For SW, the S-Type immediate is formed by combining instruction bits 31:25 and 11:7. The resulting value is then sign-extended.

For BEQ, the B-Type immediate is reconstructed from different parts of the instruction. The immediate fields are taken from bits 31, 7, 30:25 and 11:8.

The least significant bit of the branch immediate is set to zero because branch offsets are aligned to 2-byte boundaries.

The generated branch immediate is later used to calculate:

branch_target = instruction_pc + immediate

## Design

The Immediate Generator is implemented using combinational logic and does not contain a clock or internal storage.

Whenever the instruction changes, the immediate value is recalculated based on the instruction format.

For unsupported opcodes, the immediate output is set to zero.
