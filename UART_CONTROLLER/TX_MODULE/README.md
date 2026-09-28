# UART Transmitter

## Description

The TX_MODULE converts 8-bit parallel data into a UART serial data stream.

When tx_start is asserted, the transmitter stores tx_data and sends a complete UART frame consisting of one start bit, eight data bits and one stop bit.

Data is transmitted LSB first. The baud_tick signal controls the duration of each transmitted bit.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| clk | 1-bit | System clock |
| reset | 1-bit | Resets the transmitter |
| baud_tick | 1-bit | Baud timing pulse |
| tx_data | 8-bit | Parallel data to be transmitted |
| tx_start | 1-bit | Starts a new transmission |
| tx | 1-bit | UART serial output |
| tx_busy | 1-bit | Indicates an active transmission |
| baud_restart | 1-bit | Restarts the Baud Generator |

## Transmission Operation

The transmitter operates through four phases:

| Phase | Operation |
|-------|-----------|
| IDLE | Waits for tx_start |
| START | Transmits the start bit |
| DATA | Transmits eight data bits |
| STOP | Transmits the stop bit |

During IDLE, the TX line remains high and tx_busy is low.

When tx_start is detected, tx_data is copied into tx_shift_reg, tx_busy is asserted and baud_restart is generated.

## Baud Restart

baud_restart is asserted when a new transmission begins.

This resets the Baud Generator counter so that the start bit begins with a complete baud period rather than using a partially completed count from an earlier cycle.

After transmission begins, baud_restart returns low and baud_tick controls the timing of the UART frame.

## Start Bit

The START phase drives the TX line low.

The transmitter remains in this phase until the next baud_tick, ensuring that the start bit is transmitted for one complete bit period.

## Data Transmission

After the start bit, the transmitter sends eight data bits.

The least significant bit of tx_shift_reg is placed on the TX line first. At each baud_tick, the shift register is shifted right and bit_count is incremented.

This continues until all eight bits have been transmitted.

For an 8-bit value:

tx_data[0] is transmitted first.

tx_data[7] is transmitted last.

## Stop Bit

After the eighth data bit, the transmitter enters the STOP phase and drives TX high.

The stop bit remains high for one complete bit period.

After the final baud_tick, tx_busy is cleared and the transmitter returns to IDLE.

## tx_busy

tx_busy indicates whether a UART transmission is currently active.

It is asserted when tx_start begins a transmission and remains high throughout the start bit, eight data bits and stop bit.

It is cleared after the stop-bit period is completed.

## Reset Behavior

When reset is asserted:

- The transmitter returns to IDLE.
- tx is set high to represent the UART idle state.
- tx_busy is cleared.
- baud_restart is cleared.
- tx_shift_reg and bit_count are cleared.

## Verification

The UART Transmitter was verified in ModelSim as part of the complete UART Controller simulation.

Verification included:

- Detection of tx_start
- Start-bit generation
- LSB-first transmission of eight data bits
- Stop-bit generation
- tx_busy behavior during transmission
- baud_restart generation at the beginning of a frame
- Correct bit timing using baud_tick
- Reset behavior

The transmitter was tested with 8-bit data and the resulting serial frame was monitored to confirm correct UART transmission.