# Baud Generator

## Description

The BAUD_GENERATOR generates a periodic baud_tick signal used for timing operations in the UART Controller.

The current implementation produces one baud tick for every 50 input clock cycles. An internal 6-bit counter is used to count from 0 to 49.

The module also supports baud_restart, which resets the counter so that baud timing can restart from a known point when required by the UART logic.

## Inputs and Output

| Signal | Width | Description |
|--------|------:|-------------|
| clk | 1-bit | Input system clock |
| reset | 1-bit | Resets the baud counter and output |
| baud_restart | 1-bit | Restarts the baud counter |
| baud_tick | 1-bit | One-clock-cycle baud timing pulse |

## Operation

The Baud Generator uses a 6-bit counter that increments at every positive clock edge.

When the counter reaches 49:

- The counter is cleared to zero.
- baud_tick is asserted for one clock cycle.

Therefore, one baud_tick is generated for every 50 system clock cycles.

During the remaining clock cycles, baud_tick remains low.

## Baud Restart

When baud_restart is asserted, the counter is immediately cleared to zero at the next positive clock edge and baud_tick is cleared.

This allows the UART logic to restart the baud timing sequence from the beginning when required.

## Reset Behavior

When reset is asserted:

- The counter is cleared to zero.
- baud_tick is cleared to zero.

After reset is released, the counter begins counting again from zero.

## Timing

For the current implementation:

Baud tick period = 50 × System clock period

Therefore:

Baud tick frequency = System clock frequency / 50

The division value of 50 is used for the current UART simulation setup and can be modified for other clock frequencies and baud-rate requirements.

## Verification

The Baud Generator was verified during the UART Controller simulation in ModelSim.

The simulation was checked to confirm that:

- The counter advances with each positive clock edge.
- baud_tick is generated after every 50 clock cycles.
- baud_tick remains high for one clock cycle.
- Reset clears the counter and baud_tick.
- baud_restart restarts the baud timing sequence.