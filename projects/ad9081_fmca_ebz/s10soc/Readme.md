
# EVAL-AD9081 HDL reference design for S10SoC

## Build parameters

All build parameters listed below exist in pairs, one affecting the RX link (starting with `RX_`) and another affecting the TX link (starting with `TX_`).

| Parameter name         | Valid values                                                                  |
| ---------------------- | ----------------------------------------------------------------------------- |
| [RX/TX]_LANE_RATE      | Lane rate of the  link                                                        |
| [RX/TX]_JESD_M         | Number of converters per link                                                 |
| [RX/TX]_JESD_L         | Number of lanes per link                                                      |
| [RX/TX]_JESD_S         | Number of samples per frame                                                   |
| [RX/TX]_JESD_NP        | Number of bits per sample                                                     |
| [RX/TX]_NUM_LINKS      | Number of links                                                               |
| [RX/TX]_KS_PER_CHANNEL | Number of samples stored in internal buffers in kilosamples per converter (M) |

**Example:**

  `make RX_LANE_RATE=10 TX_LANE_RATE=10 RX_JESD_L=4 RX_JESD_M=8 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=4 TX_JESD_M=8 TX_JESD_S=1 TX_JESD_NP=16`

## Documentation

https://analogdevicesinc.github.io/hdl/projects/ad9081_fmca_ebz/index.html
