<!-- no_no_os -->

# CN0506/ZCU102 HDL Project

- Connect on FMC1
- VADJ with which it was tested in hardware: 1.8V

## Building the project

The parameters configurable through the `make` command, can be found below, as well as in the **system_project.tcl** file; it contains the default configuration.

```
cd projects/cn0506/zcu102
make
```

The overwritable parameter from the environment:

- INTF_CFG - defines the MAC to PHY interface type (MII, RGMII or RMII)

### Example configurations

#### RGMII mode (default)

- RGMII mode uses a GMII-to-RGMII converter, connected to PS8's Ethernet 0(PHY 0) and Ethernet 1(PHY 1)

This specific command is equivalent to running `make` only:

```
cd projects/cn0506/zcu102
make INTF_CFG=RGMII
```

Corresponding device tree: [zynqmp-zcu102-rev10-cn0506-rgmii.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-cn0506-rgmii.dts)

#### MII mode

- Connected to PS8's Ethernet 0(PHY 0) and Ethernet 1(PHY 1)

```
cd projects/cn0506/zcu102
make INTF_CFG=MII
```

Corresponding device tree: [zynqmp-zcu102-rev10-cn0506-mii.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-cn0506-mii.dts)

#### RMII mode

- RMII mode uses a MII-to-RMII converter, connected to PS8's Ethernet 0(PHY 0) and Ethernet 1(PHY 1)

```
cd projects/cn0506/zcu102
make INTF_CFG=RMII
```

Corresponding device tree: [zynqmp-zcu102-rev10-cn0506-rmii.dts](https://github.com/analogdevicesinc/linux/blob/main/arch/arm64/boot/dts/xilinx/zynqmp-zcu102-rev10-cn0506-rmii.dts)
