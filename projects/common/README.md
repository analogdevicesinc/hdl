# TEMPLATE HDL Project

- Evaluation board product page: [EVAL-AD400x-FMCZ](https://www.analog.com/eval-ad400x-fmcz)
- System documentation: https://wiki.analog.com/resources/eval/10-lead-pulsar-adc-evaluation-board
- HDL project documentation: http://analogdevicesinc.github.io/hdl/projects/pulsar_adc/index.html

## Supported parts

| Part name                                      | Description                                                  |
|------------------------------------------------|--------------------------------------------------------------|
| [AD9081 (MxFE)](https://www.analog.com/ad9081) | Quad, 16-Bit, 12 GSPS RF DAC and Quad, 12-Bit, 4 GSPS RF ADC |

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

---

# Template for the carrier-specific README.md

! The following contents go in the carrier-specific folder.

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/ad9081_fmca_ebz/zcu102
make
```

! **Mention all the overwritable parameters from the environment and their possible values and what they mean! (Not the case for JESD parameters)**

! **Give link to the data sheet from where to take all the possible configurations.**

All of the RX/TX link modes can be found in the [AD9081 data sheet](https://www.analog.com/media/en/technical-documentation/user-guides/ad9081-ad9082-ug-1578.pdf). We offer support for only a few of them.

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed, as well as the Linux/no-OS project configurations.

The overwritable parameters from the environment:

- JESD_MODE - link layer encoder mode used; 
  - 8B10B - 8b10b link layer defined in JESD204B, uses ADI IP as Physical layer
  - 64B66B - 64b66b link layer defined in JESD204C, uses Xilinx IP as Physical layer
- [RX/TX]_LANE_RATE - lane rate of the [RX/TX] link (RX: MxFE to FPGA/TX: FPGA to MxFE)
- [RX/TX]_JESD_M - [RX/TX] number of converters per link
- [RX/TX]_JESD_L - [RX/TX] number of lanes per link
- [RX/TX]_JESD_S - [RX/TX] number of samples per converter per frame
- [RX/TX]_JESD_NP - [RX/TX] number of bits per sample, only 16 is supported
- [RX/TX]_NUM_LINKS - [RX/TX] number of links, which matches the number of MxFE devices
- [RX/TX]_TPL_WIDTH - [RX/TX] transport layer data width

### Example configurations

! **List all the possible configurations for which we have a Linux device tree.**

! **Take a look at the AD9081 README.md or at the PULSAR-ADC README.md for examples on READMEs.**

#### RX link mode 18 and TX link mode 17, subclass 1 (default)

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081.dts)

This specific command is equivalent to running "make" only:

```
make JESD_MODE=8B10B RX_LANE_RATE=10 TX_LANE_RATE=10 RX_JESD_M=8 RX_JESD_L=4 RX_JESD_S=1 TX_JESD_M=4 TX_JESD_L=8 TX_JESD_S=1
```

#### RX link mode 4, TX link mode 9, subclass 1

Corresponding device tree: [zynqmp-zcu102-rev10-ad9081-204b-txmode9-rxmode4.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-ad9081-204b-txmode9-rxmode4.dts)

```
make JESD_MODE=8B10B RX_LANE_RATE=2 TX_LANE_RATE=4 RX_JESD_M=8 RX_JESD_L=2 RX_JESD_S=1 TX_JESD_M=8 TX_JESD_L=4 TX_JESD_S=1
```
