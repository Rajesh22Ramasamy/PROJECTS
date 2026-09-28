# IF/ID Pipeline Register

## Description

The IF_ID_REGISTER is the pipeline register between the Instruction Fetch (IF) and Instruction Decode (ID) stages.

It stores the fetched instruction and its corresponding Program Counter value so that they can be used by the Decode stage in the following clock cycle.

The register also supports stall and flush operations for hazard and branch handling.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| clk | 1-bit | Processor clock |
| reset | 1-bit | Resets the pipeline register |
| if_id_write | 1-bit | Enables updating of the register |
| flush | 1-bit | Clears the current register contents |
| pc | 32-bit | PC of the fetched instruction |
| instruction | 32-bit | Instruction fetched from Instruction Memory |
| if_id_pc | 32-bit | Registered PC value |
| if_id_instruction | 32-bit | Registered instruction |

## Operation

During normal operation, the PC and instruction are captured at the positive clock edge when if_id_write is enabled.

The stored instruction is then passed to the Decode stage, where fields such as opcode, rs1, rs2, rd, funct3 and funct7 are extracted for further processing.

## Stall Handling

The if_id_write signal is controlled by the Hazard Detection Unit.

When a load-use hazard is detected, if_id_write is disabled and the IF/ID register holds its previous PC and instruction. The Program Counter is also held during this condition.

This prevents the dependent instruction from progressing until the required data becomes available.

## Flush Handling

When a branch is taken, the flush signal clears the stored PC and instruction.

This removes the instruction fetched from the incorrect sequential path and prevents it from continuing through the pipeline.

## Control Priority

The register follows this control priority:

1. Reset clears the register.
2. Flush clears the current contents.
3. if_id_write allows the PC and instruction to be updated.
4. When if_id_write is disabled, the previous values are retained.

