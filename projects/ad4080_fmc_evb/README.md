# AD4080-FMC-EVB HDL Project

- Evaluation board product page: [EVAL-AD4080-FMC](https://www.analog.com/eval-ad4080-fmc)
- System documentation: TO BE ADDED
- HDL project documentation: https://analogdevicesinc.github.io/hdl/projects/ad4080_fmc_evb/index.html
- Evaluation board VADJ: 2.5V

## Supported parts

| Part name                                     | Description                                                        |
|-----------------------------------------------|--------------------------------------------------------------------|
| [AD4080](https://www.analog.com/ad4080)       | 20-Bit, 40 MSPS, Differential SAR ADC                              |
| [AD4083](https://www.analog.com/ad4083)       | 16-Bit, 40 MSPS, Differential SAR ADC                              |
| [AD4086](https://www.analog.com/ad4086)       | 14-Bit, 40 MSPS, Differential SAR ADC                              |

**Note:** This design is compatible with AD4080, AD4083, and AD4086 devices. The appropriate ADC resolution is configured using the `ADC_N_BITS` build parameter.

## Building the project

The design is built upon ADI's generic HDL reference design framework.
ADI distributes the bit/elf files of these projects as part of the
[ADI Kuiper Linux](https://wiki.analog.com/resources/tools-software/linux-software/kuiper-linux).
If you want to build the sources, ADI makes them available on the
[HDL repository](https://github.com/analogdevicesinc/hdl).
To get the source you must
[clone](https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository)
the HDL repository.

Please enter the folder for the FPGA carrier you want to use and read the README.md.

### Parameters

| Parameter      | Description                                                 | Default value |
|----------------|-------------------------------------------------------------|---------------|
| ADC_N_BITS     | ADC resolution                                              | 20            |
|                | - 20: for AD4080                                            |               |
|                | - 16: for AD4083                                            |               |
|                | - 14: for AD4086                                            |               |
| DDR_OR_SDR_N   | Interface type (1=DDR, 0=SDR)                               | 1             |

### Example build

```bash
cd hdl/projects/ad4080_fmc_evb/zed
make ADC_N_BITS=20 DDR_OR_SDR_N=1
```

For AD4083:
```bash
cd hdl/projects/ad4080_fmc_evb/zed
make ADC_N_BITS=16 DDR_OR_SDR_N=1
```

For AD4086:
```bash
cd hdl/projects/ad4080_fmc_evb/zed
make ADC_N_BITS=14 DDR_OR_SDR_N=1
```
