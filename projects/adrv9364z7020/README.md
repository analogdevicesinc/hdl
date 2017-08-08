# ADRV9364Z7020 SDR SOM 

This folder contains the ADRV9364Z7020 SOM projects for each of the carrier boards.

## Board Design Files

| Directory/File              | Description                            |
|-----------------------------|----------------------------------------|
| common/adrv9364z7020_bd.tcl | ADRV9364Z7020 SOM module board design file. |
| common/ccbob_bd.tcl         | carrier, break out board design file.  |
| common/ccusb_bd.tcl         | carrier, usb board design file.        |

BOB carrier design includes loopback daughtercards for connectivity testing.

## Board Constraint Files

| Directory/File                       | Description                                   |
|--------------------------------------|-----------------------------------------------|
| common/adrv9364z7020_constr.xdc      | ADRV9364Z7020 SOM base constraints file.           |
| common/adrv9364z7020_constr_cmos.xdc | ADRV9364Z7020 SOM CMOS mode constraints file.      |
| common/adrv9364z7020_constr_lvds.xdc | ADRV9364Z7020 SOM LVDS mode constraints file.      |
| common/ccbob_constr.xdc              | carrier, break out board constraints file.    |
| common/ccbox_constr.xdc              | carrier, box board constraints file.          |
| common/ccusb_constr.xdc              | carrier, usb board constraints file.          |


## Building, Generating Bit Files

[adrv9364z7020] cd ccbob_cmos

[adrv9364z7020/ccbob_cmos] make

The make in each carrier directory builds the corresponding project. The above example builds ADRV4CRR-BOB hardware bit files in CMOS mode.

## Documentation

 * [HDL Design User Guide]
 * [IP User Guide]
 * [ADRV4CRR Wiki page]
 
[HDL Design User Guide]:http://wiki.analog.com/resources/fpga/docs/hdl
[IP User Guide]:http://wiki.analog.com/resources/fpga/docs/axi_ad9361 
[ADRV4CRR Wiki page]:https://wiki.analog.com/resources/eval/user-guides/picozed_sdr

