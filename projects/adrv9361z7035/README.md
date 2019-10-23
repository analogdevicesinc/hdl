# ADRV9361Z7035 SDR SOM 

This folder contains the ADRV9361Z7035 SOM projects for each of the carrier boards.

# Supported SOM & Carriers

|Directory      | Description                                        |
|---------------|----------------------------------------------------|
|ccbob\_cmos    | ADRV9361Z7035\-SOM (CMOS Mode) \+ ADRV1CRR\-BOB    |
|ccbob\_lvds    | ADRV9361Z7035\-SOM (LVDS Mode) \+ ADRV1CRR\-BOB    |
|ccpackrf\_lvds | ADRV9361Z7035\-SOM (LVDS Mode) \+ ADRV1CRR\-PACKRF |
|ccfmc\_lvds    | ADRV9361Z7035\-SOM (LVDS Mode) \+ ADRV1CRR\-FMC    |
|ccpci\_lvds    | ADRV9361Z7035\-SOM (LVDS Mode) \+ ADRV1CRR\-PCI    |
|ccusb\_lvds    | ADRV9361Z7035\-SOM (LVDS Mode) \+ ADRV1CRR\-USB    |

## Board Design Files (Vivado IPI)

|Directory/File               | Description                            |
|-----------------------------|----------------------------------------|
|common/adrv9361z7035\_bd.tcl | ADRV9361Z7035\-SOM board design file.  |
|common/ccbob\_bd.tcl         | carrier, break out board design file.  |
|common/ccpackrf\_bd.tcl      | carrier, pack rf board design file.    |
|common/ccfmc\_bd.tcl         | carrier, fmc board design file.        |
|common/ccpci\_bd.tcl         | carrier, pci-e board design file.      |
|common/ccusb\_bd.tcl         | carrier, usb board design file.        |

FMC & BOB carrier designs includes loopback daughtercards for connectivity testing.

## Board Constraint Files (pin-out & io-standard)

|Directory/File                          | Description                                     |
|----------------------------------------|-------------------------------------------------|
|common/adrv9361z7035\_constr.xdc        | ADRV9361Z7035\-SOM base constraints file.       |
|common/adrv9361z7035\_constr\_cmos.xdc  | ADRV9361Z7035\-SOM CMOS mode constraints file.  |
|common/adrv9361z7035\_constr\_lvds.xdc  | ADRV9361Z7035\-SOM LVDS mode constraints file.  |
|common/ccbob\_constr.xdc                | carrier, break out board constraints file.      |
|common/ccpackrf\_constr.xdc             | carrier, packrf board constraints file.         |
|common/ccfmc\_constr.xdc                | carrier, fmc board constraints file.            |
|common/ccpci\_constr.xdc                | carrier, pci-e board constraints file.          |
|common/ccusb\_constr.xdc                | carrier, usb board constraints file.            |

FMC & BOB carrier designs includes loopback daughtercards for connectivity testing.

## Building, Generating Bit Files (easy & efficient method)
```
[some-directory]> git clone -b dev git@github.com:analogdevicesinc/hdl.git
[some-directory]> make -C hdl/projects/adrv9361z7035/ccbob_cmos
```

## Building, Generating Elf Files (easy & efficient method)
```
[some-directory]> git clone -b dev git@github.com:analogdevicesinc/no-OS.git
[some-directory]> make -C no-OS/adrv9361z7035/ccbob_cmos
```

## Running, a quick test (easy & efficient method)
```
[some-directory]> make -C no-OS/adrv9361z7035/ccbob_cmos run
```

## Documentation

 * [HDL Design User Guide]
 * [IP User Guide]
 * [ADRV9361Z7035 Wiki page]
 
[HDL Design User Guide]:http://wiki.analog.com/resources/fpga/docs/hdl
[IP User Guide]:http://wiki.analog.com/resources/fpga/docs/axi_ad9361 
[ADRV9361Z7035 Wiki page]:https://wiki.analog.com/resources/eval/user-guides/picozed_sdr

