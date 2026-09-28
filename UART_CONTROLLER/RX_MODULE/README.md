# UART Receiver

## Description

The RX_MODULE receives an asynchronous UART serial data stream and converts it into an 8-bit parallel output.

The receiver uses a finite state machine to detect the start bit, sample eight data bits, verify the stop bit and indicate completion using rx_done.

A two-flip-flop synchronizer is used at the RX input before the signal is processed by the receiver logic.

## Inputs and Outputs

| Signal | Width | Description |
|--------|------:|-------------|
| clk | 1-bit | System clock |
| reset | 1-bit | Resets the receiver |
| rx | 1-bit | UART serial input |
| rx_data | 8-bit | Received parallel data |
| rx_done | 1-bit | Indicates completion of a received byte |

## RX Synchronizer

The rx input is asynchronous with respect to the system clock.

Two flip-flops, rx_ff1 and rx_ff2, are used to synchronize the incoming signal before it is processed by the receiver state machine.

The state machine uses rx_ff2 as the synchronized RX signal.

This reduces the risk of metastability propagating into the receiver logic.

## Receiver States

The receiver uses five states:

| State | Function |
|-------|----------|
| IDLE | Waits for the RX line to go low |
| START | Validates the start bit |
| DATA | Samples the eight data bits |
| STOP | Checks the stop bit |
| DONE | Transfers received data and asserts rx_done |

## Start Bit Detection

UART remains high while the line is idle.

When the synchronized RX signal goes low, the receiver moves from IDLE to START.

The receiver waits approximately half of the 50-clock bit period before checking the RX line again.

If the signal is still low, the start bit is considered valid and reception continues. Otherwise, the receiver returns to IDLE.

Sampling near the middle of the start bit helps distinguish a valid start bit from a short transition or disturbance on the RX line.

## Data Reception

After validating the start bit, the receiver samples one data bit every 50 clock cycles.

UART data is received LSB first, so each sampled bit is stored using bit_count:

rx_shift_reg[bit_count] = received bit

bit_count progresses from 0 to 7 until all eight data bits have been received.

## Stop Bit

After receiving the eighth data bit, the receiver enters the STOP state.

After one bit period, the RX line is checked for the expected logic-high stop bit.

If the stop bit is valid, the receiver proceeds to DONE. If the line is low, the receiver returns to IDLE without asserting rx_done.

## Reception Complete

In the DONE state, the completed byte in rx_shift_reg is transferred to rx_data.

rx_done is asserted for one clock cycle to indicate that a new byte has been received successfully.

The receiver then returns to IDLE and waits for the next UART frame.

## Reset Behavior

When reset is asserted:

- The state machine returns to IDLE.
- sample_count and bit_count are cleared.
- rx_shift_reg and rx_data are cleared.
- rx_done is cleared.
- The synchronizer stages are initialized high to represent the UART idle state.

## Verification

The UART Receiver was verified in ModelSim as part of the complete UART Controller simulation.

Verification included:

- Start-bit detection
- Mid-start-bit validation
- LSB-first reception of eight data bits
- Stop-bit verification
- One-cycle rx_done generation
- Correct transfer of received data to rx_data
- Reset behavior

The receiver was successfully tested by transmitting a UART frame and confirming that the original 8-bit data was reconstructed at rx_data.