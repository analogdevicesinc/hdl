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
git clone https://github.com/corundum/corundum.git
git checkout ed4a26e2cbc0a429c45d5cd5ddf1177f86838914
cd hdl/projects/ad_gmsl2eth_sl/k26
make
```
