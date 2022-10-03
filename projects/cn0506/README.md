# CN0506 HDL Project

Here are some pointers to help you:
  * [Board Product Page](https://www.analog.com/cn0506)
  * Parts : [Robust, Industrial, Low Latency and Low Power 10 Mbps, 100 Mbps, and 1 Gbps Ethernet PHY](https://www.analog.com/adin1300)
  * Project Doc: https://wiki.analog.com/resources/eval/user-guides/circuits-from-the-lab/cn0506
  * HDL Doc: https://wiki.analog.com/resources/eval/user-guides/circuits-from-the-lab/cn0506/hdl
  * Linux Drivers: https://wiki.analog.com/resources/tools-software/linux-drivers/net-phy/adin
## Building, Generating Bit Files 

IMPORTANT: Set CN0506 MAC to PHY interface

How to use over-writable parameters from the environment:
```
hdl/projects/cn0506/zed> make INTF_CFG=MII
``  - Defines the MAC to PHY interface: MII, RGMII or RMII.
INTF_CFG  - Defines the MAC to PHY interface: MII, RGMII or RMII.
