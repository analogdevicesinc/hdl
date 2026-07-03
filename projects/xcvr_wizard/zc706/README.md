<!-- no_build_example, no_dts, no_no_os -->

# XCVR-WIZARD/ZC706 HDL Project

- Transceiver type: GTXE2

## Building the project

```
cd projects/xcvr_wizard/zc706
make
```

If other configurations are desired, then the parameters from the HDL project (see below) need to be changed.

The overwritable parameters from the environment:

- LANE_RATE: Value of lane rate [gbps]
- REF_CLK: Value of the reference clock [MHz] (usually LANE_RATE/20 or LANE_RATE/40)
- PLL_TYPE: The PLL used for driving the link [CPLL/QPLL]
- JESD_MODE: Link layer encoding mode [8B10B] (Optional, default: 8B10B)
- XCVR_RX_LANE_RATE: Value of lane rate for the RX link [gbps] (Optional)
- XCVR_RX_REF_CLK: Value of the reference clock for the RX link [MHz] (usually
  XCVR_RX_LANE_RATE/20 or XCVR_RX_LANE_RATE/40) (Optional)
- XCVR_RX_PLL_TYPE: The PLL used for driving the RX link [CPLL/QPLL1/QPLL0]
  (Optional)

Note: When running make with parameters, a new folder specific to the chosen
configuration is created under the project directory. The generated IPs and
the corresponding configuration files (e.g. *_cfng.txt) will be placed there.

- Generated files: `<config_folder>/<project_name>.gen/sources_1/ip/*_cfng.txt`
