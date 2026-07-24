<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

This project is an SPI-controlled PWM peripheral. An SPI slave (`spi_peripheral.v`) receives
16-bit write transactions over `SCLK` / `COPI` / `nCS` (SPI mode 0) and uses the decoded
address/data to drive a 16-bit PWM peripheral (`pwm_peripheral.v`), whose outputs are exposed
on `uo_out[7:0]` and `uio_out[7:0]`.

All three SPI inputs are double-flop synchronized into the `clk` domain before use, and edges
are detected in that domain, so the design is safe against SPI signals that are asynchronous
to `clk`.

Each SPI transaction is 16 bits: 1 read/write bit, 7 address bits, 8 data bits. Only writes are
supported; read transactions (R/W bit = 0) are decoded but ignored.

Register map:

| Address | Description |
|---|---|
| `0x00` | Output value for `uo_out[7:0]` |
| `0x01` | Output value for `uio_out[7:0]` |
| `0x02` | Enable PWM mode on `uo_out[7:0]` (per-bit) |
| `0x03` | Enable PWM mode on `uio_out[7:0]` (per-bit) |
| `0x04` | PWM duty cycle, 0x00 (0%) - 0xFF (100%) |

For any output bit, if the corresponding PWM-enable bit (`0x02`/`0x03`) is set, that bit follows
the internal ~3 kHz PWM signal at the configured duty cycle instead of its raw value from
`0x00`/`0x01`.

## How to test

Drive `ui_in[0]` = SCLK, `ui_in[1]` = COPI, `ui_in[2]` = nCS from a controller using SPI mode 0
(CPOL=0, CPHA=0). To turn on a PWM output:

1. Write `0x00` with a bitmask enabling the desired `uo_out` bits.
2. Write `0x02` with the same bitmask to switch those bits into PWM mode.
3. Write `0x04` with the desired duty cycle (0-255).

The selected `uo_out` bits will then output a ~3 kHz square wave at the configured duty cycle.
Writing `0x01`/`0x03` configures `uio_out[7:0]` the same way.

See `test/test.py` for a cocotb testbench that exercises the SPI register writes
(`test_spi`) and verifies the PWM frequency and duty cycle (`test_pwm_freq`, `test_pwm_duty`).

## External hardware

None — this project only requires an SPI controller (e.g. a microcontroller or the RP2040 on
the Tiny Tapeout demo board) to drive `SCLK`/`COPI`/`nCS`.
