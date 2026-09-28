# Hazard Detection Unit

## Description

The Hazard Detection Unit detects load-use data hazards in the 5-stage pipelined RISC-V processor.

Most register dependencies are handled by the Forwarding Unit. However, when an instruction immediately depends on the result of an LW instruction, the required data is not available early enough for forwarding.

For example:

LW x5, 0(x2)  
ADD x6, x5, x3

In this case, the pipeline is stalled for one clock cycle.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| id_ex_mem_read | 1-bit | Indicates that the instruction in EX is performing a memory read |
| id_ex_rd | 5-bit | Destination register of the instruction in EX |
| if_id_rs1 | 5-bit | Source register 1 of the instruction in ID |
| if_id_rs2 | 5-bit | Source register 2 of the instruction in ID |
| pc_write | 1-bit | Enables or holds the Program Counter |
| if_id_write | 1-bit | Enables or holds the IF/ID pipeline register |
| control_stall | 1-bit | Used to insert a pipeline bubble |

## Hazard Detection

A load-use hazard is checked when id_ex_mem_read is enabled.

The destination register id_ex_rd is compared with if_id_rs1 and if_id_rs2. If a match is detected, the following instruction depends on the result of the load operation.

Register x0 is excluded from the comparison because it always contains zero.

## Stall Operation

During normal operation:

pc_write = 1  
if_id_write = 1  
control_stall = 0

When a load-use hazard is detected:

pc_write = 0  
if_id_write = 0  
control_stall = 1

Disabling pc_write holds the current Program Counter, while disabling if_id_write prevents the IF/ID pipeline register from being updated.

control_stall disables the control signals entering the ID/EX stage, inserting a bubble into the pipeline.

After one stall cycle, the loaded value becomes available through a later pipeline stage and can be handled by forwarding.

## Verification

The module was verified using a Verilog testbench covering:

- Normal operation without a dependency
- Load-use dependency through rs1
- Load-use dependency through rs2
- Load instruction without a dependency
- Dependency through both source registers
- Destination register equal to x0
- Register dependency from a non-load instruction

The stall signals were asserted only for the required load-use dependency conditions.

## Current Scope

The Hazard Detection Unit handles the load-use dependency that cannot be resolved directly by forwarding.

Other ALU-to-ALU register dependencies are handled by the Forwarding Unit without introducing a pipeline stall.