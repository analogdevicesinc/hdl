# QUAD-MxFE Platform HDL Project

  * Evaluation board product page: [QUAD-MxFE](https://www.analog.com/quad-mxfe)
  * User guide: https://wiki.analog.com/resources/eval/user-guides/quadmxfe
  * System documentation: https://wiki.analog.com/resources/eval/user-guides/quadmxfe/quick-start
  * HDL project documentation: [on wiki](https://wiki.analog.com/resources/eval/user-guides/ad_quadmxfe1_ebz/ad_quadmxfe1_ebz_hdl)

## Involved parts

| Part name                                      | Description                                                  |
|------------------------------------------------|--------------------------------------------------------------|
| [AD9081 (MxFE)](https://www.analog.com/ad9081) | Quad, 16-Bit, 12 GSPS RF DAC and Quad, 12-Bit, 4 GSPS RF ADC |
| [AD9082 (MxFE)](https://www.analog.com/ad9082) | Quad, 16-Bit, 12 GSPS RF DAC and Dual, 12-Bit, 6 GSPS RF ADC |
| [ADF4371](https://www.analog.com/adf4371)      | Microwave Wideband Synthesizer with Integrated VCO |
| [HMC7043](https://www.analog.com/hmc7043)      | High Performance, 3.2 GHz, 14-Output Fanout Buffer with JESD204B/JESD204C |
| [LTM4633](https://www.analog.com/ltm4633)      | Triple 10A Step-Down DC/DC μModule (Power Module) Regulator | 
| [LTM8063](https://www.analog.com/ltm8063)      | 40 VIN, 2A Silent Switcher µModule Regulator | 
| [LTM8053](https://www.analog.com/ltm8053)      | 40 VIN, 3.5A/6A Step-Down Silent Switcher μModule Regulator | 

## Building the project

This project is supported only on FPGA AMD Xilinx VCU118.

This project is parameterized, and it can have many configurations.
For detailed information, check the HDL project documentation.

The parameters configurable through the `make` command, can be found in the **system_project.tcl** file;
it contains the default configuration.

```
// default configuration
hdl/projects/ad_quadmxfe1_ebz/vcu118> make
```

### Example configurations

```
hdl/projects/ad_quadmxfe1_ebz/vcu118> make JESD_MODE=8B10B  RX_JESD_L=4 RX_JESD_M=8 TX_JESD_L=4 TX_JESD_M=8

hdl/projects/ad_quadmxfe1_ebz/vcu118> make JESD_MODE=64B66B RX_JESD_L=2 RX_JESD_M=8 TX_JESD_L=4 TX_JESD_M=16

hdl/projects/ad_quadmxfe1_ebz/vcu118> make JESD_MODE=64B66B RX_LANE_RATE=24.75 TX_LANE_RATE=24.75 REF_CLK_RATE=250 RX_JESD_M=4 RX_JESD_L=4 RX_JESD_S=2 RX_JESD_NP=12 TX_JESD_M=4 TX_JESD_L=4 TX_JESD_S=2 TX_JESD_NP=12 RX_PLL_SEL=1 TX_PLL_SEL=1
```
