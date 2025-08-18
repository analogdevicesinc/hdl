# AD-GMSL2ETH-SL/K26 HDL Project

## Building the project

This project uses [Corundum NIC](https://github.com/corundum/corundum) and it needs to be cloned alongside this repository.

```
hdl/../> git clone https://github.com/ucsdsysnet/corundum.git
corundum/> git checkout 37f2607
corundum/> git apply ../hdl/library/corundum/patch_axis_xgmii_rx_64.patch
cd hdl/projects/ad_gmsl2eth_sl/k26
make
```
