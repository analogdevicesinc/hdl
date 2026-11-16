<!-- no_dts, no_no_os -->

# CORUNDUM/100G/VCK190 HDL Project

Corundum (one interface, one 100GE port) on the VCK190 QSFP28 cage, through
the MRMAC in 1x100GE CAUI-4 mode over four GTY lanes at 25.78125 Gb/s. The
host is the Versal CIPS: register access from the APU, DMA to DDR4 through the
NoC, one interrupt.

The MRMAC has no hardware enable. `mrmac_init` (library/corundum/versal) brings
the port up after every reset with no software involvement:

1. holds the GT in reset until `gtpowergood`, waits for TX/RX reset done
2. applies the MRMAC example design's second reset once the GT has locked
3. programs MRMAC port 0 (non-segmented 384b AXIS, CAUI-4 wide, RS-FEC)
4. waits for RX alignment and reports it on `mrmac_link_ready`, GPIO input 32
5. starts over if the link stays down for 1 ms or alignment does not come up;
   this resets the MRMAC datapath, which clears the MRMAC statistics

The Corundum port tx/rx enable bits are mirrored into the MRMAC
`CONFIGURATION_TX/RX_REG1_0` enables.

| Clock | Frequency | Source |
|-------|-----------|--------|
| Corundum core (`clk_corundum`), DMA | 250 MHz | `corundum_clkgen` from the CIPS PL0 clock |
| MRMAC AXIS client | 390.625 MHz | `corundum_mac_clkgen` |
| MRMAC PTP timestamp | 250 MHz | `corundum_mac_ts_clkgen` |
| GT free-running, MRMAC/GT registers, `mrmac_init`, `mrmac_gt_regs`, `rb_drp` DRP side | 100 MHz | CIPS PL0 clock |
| PTP hardware clock | 156.25 MHz | QSFP GT reference clock |

| Address (APU) | Block |
|---------------|-------|
| 0xA600_0000 | Corundum control (16 MB) |
| 0xA700_0000 | MRMAC registers, through `mrmac_init` (64 KB) |
| 0xA800_0000 | GT wizard registers, through `mrmac_gt_regs` (256 KB) |

The GT reference clock (156.25 MHz) is GTY_REFCLK0_201, the quad above the
QSFP28 lanes, fed by the user Si570 through the SI53340 mux (J306 open, the
default). The link only comes up once this user clock is programmed to
156.25 MHz on the System Controller, from the BEAM UI or with
`sc_app -c setclock -t "User1 FMC2 Si570" -v 156.25` from the System
Controller UART.

The QSFP28 sideband pins are on GPIO 33..37. The outputs default to 0, which
leaves the module out of reset, in high-power mode and selected, as optical
modules need.

| GPIO | Signal | Direction |
|------|--------|-----------|
| 33 | module reset (drives RESETL inverted) | out |
| 34 | LPMODE | out |
| 35 | MODSELL | out |
| 36 | MODPRSL | in |
| 37 | INTL | in |

## MAC loopback

The loopback is only built with `make LOOPBACK=1` (outputs in `LOOPBACK1/`);
the default build has no loopback and ignores GPIO 44/45.

GPIO 44 turns on `mrmac_axis_loopback`: every frame the MRMAC receives is sent
straight back out of its TX, at line rate and without the CPU. Corundum gets no
RX traffic and its TX frames are dropped while it is on. GPIO 45 swaps the
destination and source MAC addresses, so the link partner accepts the frames
as unicast. Frames with a bad FCS, or that do not fit in the 48 KB FIFO, are
dropped. The mode changes only between frames.

```
devmem 0xA4000000 32 0x3000   # GPIO 44 + 45: loopback with MAC swap
devmem 0xA4000000 32 0x0      # back to normal
```

Writing this register also drives the QSFP sideband outputs (GPIO 33..35):
keep those bits 0.

## Transceiver access

`mqnic-xcvr` (corundum/utils) sees the four GTY lanes as one GTYE5 quad
through Corundum's `rb_drp` block. `mrmac_gt_regs` forwards its accesses to
the GT wizard register port, which it shares with the APU, and drives the
per-lane PRBS pins. Running PRBS needs a QSFP28 loopback module or a link
partner sending the same pattern. The Ethernet link is down while PRBS runs on
any lane, and `mrmac_init` holds off its relink until PRBS is off on every
lane.

## Building the project

This project uses [Corundum NIC](https://github.com/corundum/corundum), cloned
alongside this repository at the tested commit.

```
hdl/../> git clone https://github.com/ucsdsysnet/corundum.git
corundum/> git checkout 37f2607
cd hdl/projects/corundum/100g/vck190
make
```

## Example configurations

The default configuration enables clause 91 RS-FEC, which 100GBASE-SR4/CR4
link partners require. To run without FEC, set `ETH_RS_FEC_ENABLE` to `0` in
`library/corundum/scripts/corundum_vck190_cfg.tcl`.

## Checking the link on hardware

Bring the link up in this order: a QSFP28 loopback module, then a cable to a
100G NIC or switch with RS-FEC enabled on both ends.

Line rate is measured at the MAC (MRMAC counters with an external 100G
traffic generator). Traffic terminated on the Versal APU through the `mqnic`
driver is CPU and DDR4 bound and stays well below 100 Gb/s.
