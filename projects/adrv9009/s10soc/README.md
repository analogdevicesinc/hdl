# ADRV9009/S10SOC HDL Project

## Building the project

This project is not parameterizable, it has a fixed configuration:

- TX_JESD_M: **4**; TX number of converters per link
- TX_JESD_L: **4**; TX number of lanes per link
- TX_JESD_S: **1**; TX number of samples per converter per frame
- RX_JESD_M: **4**; RX number of converters per link
- RX_JESD_L: **2**; RX number of lanes per link
- RX_JESD_S: **1**; RX number of samples per converter per frame
- RX_OS_JESD_M: **2**; RX_OS number of converters per link
- RX_OS_JESD_L: **2**; RX_OS number of lanes per link
- RX_OS_JESD_S: **1**; RX_OS number of samples per converter per frame

RX_OS means RX Observation path.

```
cd projects/adrv9009/s10soc
make
```
