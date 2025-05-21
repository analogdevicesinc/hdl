# ADRV9364Z7020 HDL Project

- Evaluation board product page: [ADRV9364-Z7020](https://www.analog.com/adrv9364-z7020)
- System documentation: https://wiki.analog.com/resources/eval/user-guides/adrv9364-z7020
- HDL project documentation: https://analogdevicesinc.github.io/hdl/projects/adrv9364z7020/index.html

### ADRV9364Z7020 SOM 

This folder contains the ADRV9364Z7020 SOM projects for each of the carrier boards.

### Supported SOM & Carriers

|Directory      | Description                                        |
|---------------|----------------------------------------------------|
|ccbob\_cmos    | ADRV9364Z7020\-SOM (CMOS Mode) \+ ADRV1CRR\-BOB    |
|ccbob\_lvds    | ADRV9364Z7020\-SOM (LVDS Mode) \+ ADRV1CRR\-BOB    |
|ccpackrf\_lvds | ADRV9364Z7020\-SOM (LVDS Mode) \+ ADRV1CRR\-PACKRF |

### Board Design Files

|Directory/File               | Description                            |
|-----------------------------|----------------------------------------|
|common/ADRV9364Z7020\_bd.tcl | ADRV9364Z7020\-SOM board design file.  |
|common/ccbob\_bd.tcl         | carrier, break out board design file.  |
|common/ccpackrf\_bd.tcl      | carrier, packrf board design file.     ||

### Board Constraint Files (pin-out & io-standard)

|Directory/File                          | Description                                     |
|----------------------------------------|-------------------------------------------------|
|common/ADRV9364Z7020\_constr.xdc        | ADRV9364Z7020\-SOM base constraints file.       |
|common/ADRV9364Z7020\_constr\_cmos.xdc  | ADRV9364Z7020\-SOM CMOS mode constraints file.  |
|common/ADRV9364Z7020\_constr\_lvds.xdc  | ADRV9364Z7020\-SOM LVDS mode constraints file.  |
|common/ccbob\_constr.xdc                | carrier, break out board constraints file.      |
|common/ccpackrf\_constr.xdc             | carrier, packrf board constraints file.         |

FMC & BOB carrier designs includes loopback daughtercards for connectivity testing.

## Supported parts

| Part name                               | Description          |
|-----------------------------------------|----------------------|
| [AD9364](https://www.analog.com/ad9364) | RF Agile Transceiver |

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.