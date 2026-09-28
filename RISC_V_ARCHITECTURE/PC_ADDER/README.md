# PC Adder

## Description

The PC_ADDER calculates the address of the next sequential instruction.

Since each instruction in the current implementation is 32 bits or 4 bytes, the Program Counter normally advances by 4.

pc_next = pc + 4

## Inputs and Output

| Signal | Width | Description |
|--------|------:|-------------|
| pc | 32-bit | Current Program Counter value |
| pc_next | 32-bit | Next sequential instruction address |

## Operation

The PC Adder is implemented using combinational logic and does not contain a clock or internal storage.

Whenever the current PC changes, the next sequential address is calculated by adding 4.

During normal execution, the address progresses as:

0 → 4 → 8 → 12 → 16

## Branch Handling

The PC Adder only calculates the sequential address and does not make the branch decision.

In the top-level processor, the next PC is selected between the sequential address and the branch target based on branch_taken.

When a branch is not taken, pc + 4 is selected. When a branch is taken, the calculated branch target is selected instead.