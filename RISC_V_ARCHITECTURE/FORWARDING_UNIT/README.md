# Forwarding Unit

## Description

The Forwarding Unit handles data hazards in the pipelined RISC-V processor.

A data hazard occurs when an instruction in the EX stage requires a register value that is being produced by an earlier instruction but has not yet been written back to the Register File.

Instead of waiting for the normal write-back operation, the required result can be forwarded directly from a later pipeline stage to the ALU input. This avoids unnecessary pipeline stalls.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| id_ex_rs1 | 5-bit | Source register 1 of the instruction in EX |
| id_ex_rs2 | 5-bit | Source register 2 of the instruction in EX |
| ex_mem_rd | 5-bit | Destination register from EX/MEM |
| ex_mem_reg_write | 1-bit | Register write control from EX/MEM |
| mem_wb_rd | 5-bit | Destination register from MEM/WB |
| mem_wb_reg_write | 1-bit | Register write control from MEM/WB |
| forward_A | 2-bit | Forwarding selection for operand A |
| forward_B | 2-bit | Forwarding selection for the rs2 path |

## Forwarding Selection

| Forward Signal | Selected Source |
|---------------|-----------------|
| 00 | Normal ID/EX value |
| 10 | EX/MEM result |
| 01 | MEM/WB result |

The forwarding decision is applied independently to rs1 and rs2.

## Operation

The Forwarding Unit compares id_ex_rs1 and id_ex_rs2 with the destination registers available in EX/MEM and MEM/WB.

If the destination register in EX/MEM matches one of the source registers and register writing is enabled, the corresponding operand is forwarded from EX/MEM.

If the dependency is found in MEM/WB, the required value is forwarded from the MEM/WB path.

EX/MEM is given higher priority when both stages contain a matching destination register because it contains the result from the more recent instruction.

## Register x0 and RegWrite Check

Register x0 is excluded from forwarding because it always contains zero in RISC-V.

The RegWrite control signal is also checked before forwarding. This prevents instructions that do not write a result to the Register File from incorrectly triggering the forwarding logic.

## Load-Use Dependency

Forwarding cannot resolve an immediate load-use dependency such as:

LW x5, 0(x2)  
ADD x6, x5, x3

The value loaded by LW becomes available only after the memory access stage. Therefore, the following dependent instruction must be stalled for one clock cycle.

This condition is handled by the Hazard Detection Unit. After the stall, the loaded value can be forwarded from the MEM/WB stage.

## Verification

The module was verified using a Verilog testbench covering:

- No forwarding
- Operand A forwarding from EX/MEM and MEM/WB
- Operand B forwarding from EX/MEM and MEM/WB
- Simultaneous forwarding of both operands
- EX/MEM priority over MEM/WB
- No forwarding for register x0
- No forwarding when RegWrite is disabled

The forward_A and forward_B outputs were checked for each dependency condition.