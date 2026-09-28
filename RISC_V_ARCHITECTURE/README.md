# 32-bit Pipelined RISC-V Processor

## Description

This project implements a 32-bit 5-stage pipelined RISC-V processor in Verilog.

The processor was developed module-by-module and later integrated into a complete datapath. The current implementation supports a selected subset of RV32I instructions along with forwarding, load-use hazard detection, pipeline stalls and branch flushing.

The processor follows five pipeline stages:

- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

## Supported Instructions

| Type | Instructions |
|------|--------------|
| R-Type | ADD, SUB, AND, OR, XOR, SLT |
| I-Type | ADDI |
| Load | LW |
| Store | SW |
| Branch | BEQ |

## Pipeline Architecture

The processor uses four pipeline registers to separate the five execution stages:

| Pipeline Register | Stages |
|-------------------|--------|
| IF/ID | Instruction Fetch → Instruction Decode |
| ID/EX | Instruction Decode → Execute |
| EX/MEM | Execute → Memory Access |
| MEM/WB | Memory Access → Write Back |

Data and control signals are passed through these registers so that multiple instructions can progress through different stages of the processor simultaneously.

## Main RTL Modules

The processor consists of the following modules:

- PROGRAM_COUNTER
- PC_ADDER
- INSTRUCTION_MEMORY
- IF_ID_REGISTER
- REGISTER_FILE
- IMMEDIATE_GENERATOR
- MAIN_CONTROL
- ID_EX_REGISTER
- ALU_CONTROL
- ALU
- FORWARDING_UNIT
- HAZARD_DETECTION_UNIT
- BRANCH_LOGIC
- EX_MEM_REGISTER
- DATA_MEMORY
- MEM_WB_REGISTER
- RISC_V_PIPELINED_PROCESSOR

Each major module is documented separately in the repository.

## Data Hazard Handling

The Forwarding Unit handles dependencies where a required result is available in a later pipeline stage but has not yet been written back to the Register File.

The forwarding logic compares the source registers of the instruction in the EX stage with destination registers in the EX/MEM and MEM/WB stages.

ALU operands can therefore be selected from:

- ID/EX register data
- EX/MEM ALU result
- MEM/WB write-back data

EX/MEM forwarding is given priority over MEM/WB forwarding because it contains the more recent result.

## Load-Use Hazard Handling

A direct dependency following an LW instruction requires a pipeline stall because the loaded data is not available early enough for normal EX/MEM forwarding.

When this condition is detected, the Hazard Detection Unit:

- Holds the Program Counter
- Holds the IF/ID pipeline register
- Clears the control signals entering ID/EX

This inserts one bubble into the pipeline while allowing the load instruction to continue. The required value can then be obtained through the forwarding path.

## Branch Handling

BEQ is resolved in the EX stage.

The ALU compares the two source operands using subtraction. When the result is zero and the branch control signal is active, the branch is taken.

The branch target is calculated using:

Branch Target = Instruction PC + Branch Immediate

When a branch is taken, the Program Counter is redirected to the branch target and the younger instructions in IF/ID and ID/EX are flushed.

## Memory Organization

Instruction Memory and Data Memory are implemented as separate modules.

Instruction Memory contains 256 locations with 32 bits per location. Since the Program Counter uses byte addresses, pc[9:2] is used to select the required instruction word.

The simulation program is loaded from INSTRUCTION.hex.

Data Memory also contains 256 locations with 32 bits per location. The current implementation uses synchronous writes and combinational reads.

## Verification

The main functional blocks were verified before integrating the complete processor.

Verification covered:

- ALU arithmetic and logical operations
- ALU control decoding
- Register and pipeline data transfer
- Data Memory read and write operations
- EX/MEM and MEM/WB forwarding
- Load-use hazard detection and pipeline stall
- BEQ decision and branch target calculation
- Pipeline flushing after a taken branch

The integrated processor was then simulated in ModelSim using a small RV32I machine-code program loaded through INSTRUCTION.hex.

The test sequence included:

ADDI x1, x0, 5  
ADDI x2, x0, 3  
ADD  x3, x1, x2  
SUB  x4, x3, x2  
SW   x4, 0(x0)  
LW   x5, 0(x0)  
ADD  x6, x5, x1  
BEQ  x6, x0, +8  
ADDI x7, x0, 7  
BEQ  x7, x7, +8  
ADDI x8, x0, 99  
ADDI x9, x0, 9

The final simulation results were:

| Register / Memory | Result |
|-------------------|-------:|
| x1 | 5 |
| x2 | 3 |
| x3 | 8 |
| x4 | 5 |
| x5 | 5 |
| x6 | 10 |
| x7 | 7 |
| x8 | 0 |
| x9 | 9 |
| Data Memory[0] | 5 |

The dependency between LW and the following ADD verifies the load-use stall and forwarding operation.

The second BEQ is taken because both source operands contain the same value. As a result, the instruction that would write 99 to x8 is flushed, leaving x8 equal to zero.

## Tools Used

- Verilog HDL
- ModelSim
- RISC-V RV32I instruction encoding

## Current Scope

The project currently implements a selected subset of RV32I instructions with the main concepts required for a 5-stage pipelined processor.

The current design includes data forwarding, load-use hazard detection, pipeline stalls and BEQ branch handling.

Future development can include additional RV32I instructions, JAL and JALR support, additional branch instructions, synthesis, timing analysis and FPGA implementation.