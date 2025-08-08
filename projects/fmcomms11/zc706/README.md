<!-- no_build_example, no_no_os -->

# FMCOMMS11/ZC706 HDL Project

- VADJ with which it was tested in hardware: 2.5V

## Building the project

```
cd projects/fmcomms11/zc706
make
```

This project has a fixed configuration. The parameters from the environment are:
- [RX/TX]_NUM_OF_LANES: RX: **8**, TX :**8**; [RX/TX] number of lanes per link
- [RX/TX]_NUM_OF_CONVERTERS: RX: **1**, TX: **2**; [RX/TX] number of converters per link
- [RX/TX]_SAMPLES_PER_FRAME: RX: **4**, TX: **2**; [RX/TX] number of samples per converter per frame
- [RX/TX]_SAMPLE_WIDTH: RX: **16**, TX: **16**; [RX/TX] number of bits per sample, only 16 is supported

Corresponding device trees:
- [zynq-zc706-adv7511-fmcomms11.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zc706-adv7511-fmcomms11.dts)
- Revision A of the board [zynq-zc706-adv7511-fmcomms11-RevA.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm/boot/dts/xilinx/zynq-zc706-adv7511-fmcomms11-RevA.dts)
