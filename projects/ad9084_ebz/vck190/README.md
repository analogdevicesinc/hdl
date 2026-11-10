<!-- no_dts, no_no_os -->

# AD9084-EBZ/VCK190 HDL Project

- VADJ with which it was tested in hardware: 1.5V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad9084_ebz/vck190
make
```

All of the RX/TX link modes can be found in the [AD9084 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/eval-ad9084-ad9088-ug-2326.pdf). We offer support for only a few of them.

The overwritable parameters from the environment are:

- JESD_MODE : Used link layer encoder mode
  - 64B66B - 64b66b link layer defined in JESD 204C
  - 8B10B  - 8b10b link layer defined in JESD 204B
-
- REF_CLK_RATE : Reference clock frequency in MHz, should be Lane Rate / 66 for JESD204C or Lane Rate / 40 for JESD204B
- HSCI_ENABLE : If set, adds and enables the HSCI core in the design
- RX_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA )
- TX_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo )
- [RX/TX]_JESD_M : Number of converters per link
- [RX/TX]_JESD_L : Number of lanes per link
- [RX/TX]_JESD_S : Number of samples per converter per frame
- [RX/TX]_JESD_NP : Number of bits per sample
- [RX/TX]_NUM_LINKS : Number of links - only when ASYMMETRIC_A_B_MODE = 0
- [RX/TX]_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M)
- ASYMMETRIC_A_B_MODE : When set, each Apollo side has its own JESD link
- RX_B_LANE_RATE :  Lane rate of the Rx link ( Apollo to FPGA ) for B side
- TX_B_LANE_RATE :  Lane rate of the Tx link ( FPGA to Apollo ) for B side
- [RX/TX]_B_JESD_M : Number of converters per link for B side
- [RX/TX]_B_JESD_L : Number of lanes per link for B side
- [RX/TX]_B_JESD_S : Number of samples per converter per frame for B side
- [RX/TX]_B_JESD_NP : Number of bits per sample for B side
- [RX/TX]_B_KS_PER_CHANNEL: Number of samples stored in internal buffers in kilosamples per converter (M) for B side
- AION_ENABLE : If set, adds and enables the AION core in the design; the adf4030 then sources sysref and drives the trigger pins
- SIDE_B_ONLY : When set, use only the B side of the Apollo device (maximum 8 lanes instead of 4)
- FSRC_ENABLE : When set, fractional sample rate conversion is inserted in both directions: RX deletes the samples Apollo marked invalid and compacts what is left, TX leaves holes where Apollo will not read
- FSRC_ACCUM_WIDTH : Width of the FSRC rate accumulator, which sets the granularity of the achievable ratio
- CORUNDUM : When set, adds the [Corundum NIC](https://github.com/corundum/corundum) on the QSFP28 cage (MRMAC, 1x100GE), as in projects/corundum/100g/vck190
- APP_ENABLE : When set, adds the Corundum application core, which streams the A-side ADC samples over UDP; needs CORUNDUM=1

### Example configurations

#### JESD204C, 20.625 Gbps lane rate (default)

This specific command is equivalent to running `make` only:

```
make JESD_MODE=64B66B \
REF_CLK_RATE=312.5 \
HSCI_ENABLE=1 \
AION_ENABLE=0 \
SIDE_B_ONLY=0 \
RX_LANE_RATE=20.625 \
TX_LANE_RATE=20.625 \
RX_JESD_M=4 \
RX_JESD_L=4 \
RX_JESD_S=1 \
RX_JESD_NP=16 \
RX_NUM_LINKS=2 \
TX_JESD_M=4 \
TX_JESD_L=4 \
TX_JESD_S=1 \
TX_JESD_NP=16 \
TX_NUM_LINKS=2 \
RX_KS_PER_CHANNEL=64 \
TX_KS_PER_CHANNEL=64 \
ASYMMETRIC_A_B_MODE=0 \
FSRC_ENABLE=0 \
FSRC_ACCUM_WIDTH=56
```

## Corundum

```
make CORUNDUM=1
make CORUNDUM=1 APP_ENABLE=1
```

Corundum is cloned next to this repository, with the patches in
library/corundum applied (`apply_patches.sh`).

| Address (APU) | Block |
|---------------|-------|
| 0xA600_0000 | Corundum control (16 MB) |
| 0xA700_0000 | MRMAC registers, through `mrmac_init` (64 KB) |
| 0xA800_0000 | GT wizard registers, through `mrmac_gt_regs` (256 KB) |
| 0xA900_0000 | Application core registers (APP_ENABLE=1) |
| 0xAA00_0000 | `corundum_dac_load`, DAC data offload source (APP_ENABLE=1) |

The Corundum interrupt is PS IRQ 5. GPIO 80 is the MRMAC link status; GPIO
81..83 drive the QSFP28 RESETL (inverted), LPMODE and MODSELL, and GPIO 84/85
read MODPRSL and INTL. Set the QSFP refclk on the System Controller:
`sc_app -c setclock -t "User1 FMC2 Si570" -v 156.25`.

The application core takes the A-side ADC samples after a second `util_cpack2`
and sends them on Corundum's 512-bit, 250 MHz sync TX path (128 Gb/s), which
100GE drains at about 98 Gb/s of frames. The default JESD mode carries
160 Gb/s of ADC data, so enable at most half of the channels when streaming.

In the other direction the application core can load the DAC data offload in
place of the TX DMA; the offload then replays the buffer as it does after a
DMA load. The application takes the UDP frames whose headers match its header
registers (the same registers that build its TX headers) and forwards their
payloads, which must be packed like a TX DMA buffer for the enabled channels.
Keep each payload a multiple of 64 bytes, one 512-bit beat. The
`corundum_dac_load` registers (word offsets) are:

| Offset | Register |
|--------|----------|
| 0x10 | SOURCE: 0 TX DMA (default), 1 application; not changed while pending |
| 0x11 | LOAD: write bit 0 to start a load, or to queue the next one during a load; write bit 1 to stop. Reads bit 0 pending (until the FIFO has drained), bit 1 queued, bit 2 feeding the DAC, bit 3 continuous |
| 0x12 | LENGTH: length of the next load in 512-bit beats; 0 streams until stop |
| 0x13 | COUNT: beats taken in by the current or last load, bits 31:0 (0x1E: bits 63:32) |
| 0x14 | PAUSE_ON: request pause above this FIFO level, in beats (default 7680) |
| 0x15 | PAUSE_OFF: release the pause below this FIFO level (default 5120) |
| 0x16 | LEVEL: beats in the FIFO |
| 0x17 | PEAK: highest LEVEL of the run |
| 0x18 | DROPPED: beats dropped on a full FIFO in the run |
| 0x19 | STARVED: clock cycles the run, once feeding the DAC, had no beat ready for the offload |
| 0x1A | PAUSES: pause requests raised in the run |
| 0x1B | START_LEVEL: beats the FIFO holds before it feeds the DAC (default 4096) |
| 0x1C | CONTROL: bit 0 stops feeding the DAC when the FIFO runs empty, until it holds START_LEVEL again |
| 0x1D | UNDERFLOW: DAC clock cycles the DAC read no data in the run, from its first sample until the run has drained |
| 0x1F | LOADS: loads in the run |

A run is a LOAD from idle and the loads queued after it; the run counters
restart with it.

To load a waveform: set the offload to cyclic, write LENGTH and SOURCE=1, then
LOAD, and send LENGTH beats of payload. The load ends on the last beat, which
starts the replay. Outside a load the application's DAC samples are dropped.

To stream instead, put the offload in bypass and write LENGTH 0 before LOAD;
stop the stream by writing 2 to LOAD. A queued load also follows the current
one without a gap, and only the last beat of the run carries tlast.

A load passes through an 8192-beat (512 KB) URAM FIFO, which feeds the DAC
once it holds START_LEVEL beats. The FIFO's level, not Corundum's RX FIFO,
raises the link pause: Corundum's own request only watches the host DMA path,
which the application's frames never reach. The request is ORed into the
MRMAC global pause request, so it needs TX pause enabled on the interface
(`ethtool -A eth0 tx on`). The MRMAC sends a zero-quanta pause when the
request drops, so the link partner resumes at once. With the offload in
bypass, this lets the host stream the DAC continuously at the DAC rate, as
long as the host keeps up: the FIFO covers stalls of about 100 us at 40 Gb/s.
