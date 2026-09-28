# MEM/WB Pipeline Register

## Description

The MEM_WB_REGISTER is the pipeline register between the Memory Access (MEM) and Write Back (WB) stages.

It stores the Data Memory output, ALU result, destination register address and control signals required during the Write Back stage.

All values are captured at the positive edge of the clock.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| read_data | 32-bit | Data read from Data Memory |
| alu_result | 32-bit | ALU result |
| rd | 5-bit | Destination register address |
| reg_write | 1-bit | Register File write enable |
| mem_to_reg | 1-bit | Selects the write-back data source |
| mem_wb_read_data | 32-bit | Registered Data Memory output |
| mem_wb_alu_result | 32-bit | Registered ALU result |
| mem_wb_rd | 5-bit | Registered destination register address |
| mem_wb_reg_write | 1-bit | Registered Register File write enable |
| mem_wb_mem_to_reg | 1-bit | Registered write-back source selection |

## Operation

At every positive clock edge, the MEM/WB register captures the memory data, ALU result, destination register address and write-back control signals.

These values are passed together to the Write Back stage so that the correct result is written to the correct destination register.

## Write Back Selection

The mem_wb_mem_to_reg signal determines the value written back to the Register File.

| mem_wb_mem_to_reg | Write Back Source |
|-------------------|-------------------|
| 0 | ALU result |
| 1 | Data Memory result |

LW uses the Data Memory result, while R-Type and ADDI instructions use the ALU result.

The mem_wb_reg_write signal determines whether the selected value is written into the Register File. Register writing is disabled for instructions such as SW and BEQ.

## Reset Behavior

When reset is asserted, all stored data and control signals are cleared to zero.

Clearing mem_wb_reg_write prevents an invalid register write during processor initialization.
