# TEMPLATE HDL Project

  * Evaluation board product page: [EVAL-AD400x-FMCZ](https://www.analog.com/eval-ad400x-fmcz)
  * System documentation: https://wiki.analog.com/resources/eval/10-lead-pulsar-adc-evaluation-board
  * HDL project documentation: [source code](../../docs/projects/pulsar_adc/index.rst)
    or [online](http://analogdevicesinc.github.io/hdl/projects/pulsar_adc/index.html)

## Supported parts

| Part name                                   | Resolution | On CoraZ7S | On Zed | Description                                                      |
|---------------------------------------------|:----------:|:----------:|:------:|------------------------------------------------------------------|
| [AD4000](https://www.analog.com/ad4000)     | 16-bit     |            | Yes    | 2 MSPS/1 MSPS/500 kSPS, Precision, Pseudo Differential, SAR ADCs |

## Involved parts (if applicable)

| Part name                                      | Description                                                  |
|------------------------------------------------|--------------------------------------------------------------|
| [AD9081 (MxFE)](https://www.analog.com/ad9081) | Quad, 16-Bit, 12 GSPS RF DAC and Quad, 12-Bit, 4 GSPS RF ADC |
| [AD9082 (MxFE)](https://www.analog.com/ad9082) | Quad, 16-Bit, 12 GSPS RF DAC and Dual, 12-Bit, 6 GSPS RF ADC |
| [ADF4371](https://www.analog.com/adf4371)      | Microwave Wideband Synthesizer with Integrated VCO |
| [HMC7043](https://www.analog.com/hmc7043)      | High Performance, 3.2 GHz, 14-Output Fanout Buffer with JESD204B/JESD204C |

## Building the project

:warning: Make sure that you set up your required ADC resolution in [../common/pulsar_adc_bd.tcl](../common/pulsar_adc_bd.tcl)

> [!NOTE]
> * For the ALERT functionality, the following parameters will be used in make command: ALERT_SPI_N

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
```

### CoraZ7S

```
// default configuration
hdl/projects/pulsar_adc/coraz7s> make
```

### Zed

How to use overwritable parameter from the environment:

**AD40XX_ADAQ400X_N** - selects the evaluation board to be used:
  * 1 - EVAL-AD40XX-FMCZ (default option)
  * 0 - EVAL-ADAQ400x

```
// default option (1), building project for EVAL-AD40XX-FMCZ
hdl/projects/pulsar_adc/zed> make AD40XX_ADAQ400X_N

// building project for EVAL-ADAQ400x
hdl/projects/pulsar_adc/zed> make AD40XX_ADAQ400X_N=0
```
