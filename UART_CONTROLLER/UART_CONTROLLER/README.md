# UART Controller

## Description

This project implements a UART Controller in Verilog with separate transmitter, receiver and baud-generation modules.

The design supports transmission and reception of 8-bit serial data using a standard UART frame consisting of:

- 1 start bit
- 8 data bits
- 1 stop bit
- LSB-first data transfer

The design was developed and verified using ModelSim.

## Main RTL Modules

The UART Controller consists of three main modules:

| Module | Function |
|--------|----------|
| BAUD_GENERATOR | Generates the timing pulse used by the transmitter |
| TX_MODULE | Converts 8-bit parallel data into UART serial data |
| RX_MODULE | Receives UART serial data and reconstructs the 8-bit value |

The UART_CONTROLLER module integrates these blocks into the complete design.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| clk | 1-bit | System clock |
| reset | 1-bit | Resets the UART Controller |
| tx_data | 8-bit | Parallel data to be transmitted |
| tx_start | 1-bit | Starts a new transmission |
| rx | 1-bit | UART serial input |
| tx | 1-bit | UART serial output |
| tx_busy | 1-bit | Indicates an active transmission |
| rx_data | 8-bit | Received parallel data |
| rx_done | 1-bit | Indicates successful reception of a byte |

## Transmitter Operation

When tx_start is asserted, the transmitter stores tx_data and begins sending a UART frame.

The transmission sequence is:

Start Bit → Data Bits 0 to 7 → Stop Bit

The data bits are transmitted LSB first.

tx_busy remains asserted while the frame is being transmitted and is cleared after the stop-bit period is completed.

## Baud Generation

The Baud Generator produces one baud_tick for every 50 system clock cycles in the current simulation setup.

The transmitter uses baud_tick to control the duration of the start bit, each data bit and the stop bit.

When a new transmission begins, the transmitter generates baud_restart. This resets the baud counter so that the start bit begins with a complete baud period.

The division value of 50 is used for the current simulation and can be changed for other clock and baud-rate requirements.

## Receiver Operation

The receiver monitors the RX line for a falling transition indicating the beginning of a UART frame.

The incoming asynchronous RX signal first passes through a two-flip-flop synchronizer before being processed by the receiver state machine.

After detecting a possible start bit, the receiver checks the signal near the middle of the start-bit period. If the line remains low, the start bit is accepted.

The receiver then samples eight data bits at one-bit-period intervals and stores them LSB first.

After receiving all eight bits, the stop bit is checked. A valid stop bit causes the received byte to be transferred to rx_data and rx_done to be asserted for one clock cycle.

## UART Frame

The implemented UART frame contains 10 bits:

| Position | Function |
|----------|----------|
| 1 | Start bit = 0 |
| 2–9 | 8 data bits, LSB first |
| 10 | Stop bit = 1 |

No parity bit is used in the current implementation.

## TX and RX Timing

The transmitter uses the Baud Generator to determine when each output bit should advance.

The receiver performs its own clock-based sample counting. The start bit is first checked near its midpoint, after which the data and stop bits are sampled at 50-clock intervals.

This allows the receiver to sample the serial input near the expected center of each UART bit.

## Verification

The complete UART Controller was verified in ModelSim.

Verification included:

- Baud tick generation
- Baud counter restart at the beginning of transmission
- Start-bit generation and detection
- LSB-first transmission
- Reception of all eight data bits
- Stop-bit generation and verification
- tx_busy behavior
- rx_done pulse generation
- Two-flip-flop synchronization of the RX input
- Recovery of the transmitted 8-bit value at rx_data

The transmitter output was connected to the receiver input during simulation to verify the complete TX-to-RX data path.

An 8-bit test value representing ASCII character A was transmitted and successfully reconstructed by the receiver.

## Tools Used

- Verilog HDL
- ModelSim
- UART serial communication concepts

## Current Scope

The current design implements basic 8-bit UART transmission and reception with one start bit and one stop bit.

The baud timing is fixed to 50 system clock cycles per bit for the current simulation setup.

Possible future improvements include configurable baud rates, parity support, framing-error indication, FIFO buffering and FPGA implementation.