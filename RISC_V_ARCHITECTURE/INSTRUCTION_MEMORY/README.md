# Instruction Memory

## Description

The Instruction Memory stores the machine-code instructions executed by the RISC-V processor.

The Program Counter provides the address of the current instruction, and the corresponding 32-bit instruction is supplied to the Instruction Fetch stage.

The current implementation contains 256 locations, with each location storing one 32-bit instruction, giving a total capacity of 1 KiB.

## Inputs and Output

| Signal | Width | Description |
|--------|------|-------------|
| pc | 32-bit | Program Counter containing the instruction address |
| instruction | 32-bit | Instruction read from memory |

## Memory Organization

The Instruction Memory contains 256 locations with a width of 32 bits per location.

Since the Program Counter represents a byte address and each instruction occupies 4 bytes, pc[9:2] is used as the memory index.

For example:

| PC | Memory Index |
|---:|---:|
| 0 | 0 |
| 4 | 1 |
| 8 | 2 |
| 12 | 3 |

The lower two address bits are not used because the implemented instructions are 32 bits wide and aligned to 4-byte boundaries.

## Program Loading

For simulation, the machine-code instructions are stored in the INSTRUCTION.hex file.

The program is loaded into Instruction Memory using the Verilog readmemh system task at the beginning of the simulation.

Each line of the hexadecimal file represents one 32-bit machine instruction and is loaded into the corresponding memory location.

## Read Operation

Instruction Memory uses combinational read logic.

When the PC changes, the instruction output is updated based on the selected memory location. The fetched instruction is then captured by the IF/ID pipeline register at the positive clock edge.

## Instruction and Data Memory

Instruction Memory and Data Memory are implemented as separate modules in the current processor.

Instruction Memory is used for fetching program instructions, while Data Memory is used for LW and SW operations. This allows instruction fetching and data-memory access to be handled independently in the pipeline.
