<!-- no_build_example, no_no_os -->

# ADAR3000/ZCU102 HDL Project

- VADJ with which it was tested in hardware: 1.8V
- The EVAL-ADAR3000 connects to the ZCU102 via the [SDP-I-FMC](https://www.analog.com/sdp-i-fmc) interposer on the **FMC HPC1** connector.

## Building the project

```
cd projects/adar3000/zcu102
make
```

Corresponding device tree: [adi-adar3000-evb.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/adi-adar3000-evb.dts)
