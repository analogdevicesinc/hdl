<!-- no_build_example, no_dts, no_no_os -->

# AD-GMSL2ETH-SL/K26 HDL Project

The +VCC_SOM voltage is 5V and the SOM connectors voltages can be found in the table below:

| SOM connector name | Power supply              | Voltage level |
|--------------------|---------------------------|---------------|
| SOM_CONN1          | HDA                       | 3.3V          |
|                    | HPA                       | 1.8V          |
| SOM_CONN2          | HPB                       | 1.2V          |
|                    | HDB                       | 1.8V          |
|                    | HPC                       | 1.2V          |
|                    | HDC                       | 1.8V          |

## Building the project

This project uses [Corundum NIC](https://github.com/corundum/corundum) and it needs to be cloned alongside this repository.

```
hdl/../> git clone https://github.com/ucsdsysnet/corundum.git
corundum/> git checkout 37f2607
corundum/> git apply ../hdl/library/corundum/patch_axis_xgmii_rx_64.patch
cd hdl/projects/ad_gmsl2eth_sl/k26
make
```
