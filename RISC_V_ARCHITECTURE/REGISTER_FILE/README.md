# Register File

## Description

The REGISTER_FILE implements the 32 general-purpose registers used by the RISC-V processor.

Each register is 32 bits wide. The module provides two independent read ports and one write port, allowing two source operands to be read while supporting result write-back.

Register x0 is permanently maintained at zero.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| clk | 1-bit | Processor clock |
| reset | 1-bit | Resets all registers |
| rs1 | 5-bit | First source register address |
| rs2 | 5-bit | Second source register address |
| rd | 5-bit | Destination register address |
| write_data | 32-bit | Data written to the destination register |
| reg_write | 1-bit | Register write enable |
| read_data1 | 32-bit | Data read from rs1 |
| read_data2 | 32-bit | Data read from rs2 |

## Register Organization

The Register File contains 32 registers, with each register storing a 32-bit value.

The 5-bit addresses rs1, rs2 and rd are used to select registers from x0 to x31.

## Read Operation

The Register File provides two combinational read ports.

rs1 selects the first source register and rs2 selects the second source register. Their values are available through read_data1 and read_data2 without waiting for a clock edge.

These values are captured by the ID/EX pipeline register before entering the Execute stage.

## Write Operation

Register writes are performed at the positive edge of the clock.

A value is written to rd only when reg_write is enabled and the destination register is not x0.

In the complete processor, the destination register and write enable are received from the MEM/WB stage. The write_data value is selected from either the ALU result or Data Memory output depending on the instruction.

## x0 Register

RISC-V register x0 is permanently fixed to zero.

Reading x0 always returns zero, and any attempt to write a value into x0 is ignored.

This behavior is enforced during both register read and write operations.

## Reset Behavior

When reset is asserted, all 32 registers are cleared to zero.

This provides a known initial state for the processor simulation.

## Pipeline Dependencies

Some instructions may require a register value before an earlier instruction has completed the Write Back stage.

These dependencies are handled by the Forwarding Unit, which can provide the newer result directly to the Execute stage instead of waiting for it to be written into the Register File.

A load-use dependency that cannot be resolved immediately by forwarding is handled by the Hazard Detection Unit.

## Verification

The Register File was verified during the complete processor simulation.

The simulation was checked to confirm that:

- Source registers are read correctly.
- Register writes occur at the positive clock edge.
- reg_write prevents writes when disabled.
- x0 always reads as zero.
- Writes to x0 are ignored.
- Write-back results are stored in the correct destination registers.