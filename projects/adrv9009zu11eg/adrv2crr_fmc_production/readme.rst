=========
GPIO test
=========
 
This folder contains a project which tests the FMC lvds LA lines of the Talise SOM + Carrier ensemble. The test is performed using the ApisSys FMC loopback card (P01-0010B). The card connects the LA lines as following:

+----------+----+-----------+
| LA_P[0]  |=>  | LA_P[17]  |
+----------+----+-----------+
| LA_N[0]  |=>  | LA_N[17]  |
+----------+----+-----------+
| LA_P[1]  |=>  | LA_P[18]  |
+----------+----+-----------+
| LA_N[1]  |=>  | LA_N[18]  |
+----------+----+-----------+
| ...      |    | ...       |
+----------+----+-----------+
| LA_P[16] |=>  | LA_P[33]  |
+----------+----+-----------+
| LA_N[16] |=>  | LA_N[33]  |
+----------+----+-----------+

In total there are 68 individual signals which need to be tested for short-circuit or continuity defects. To do this, 2 GPIO IP cores are used and each signal is driven as a single ended (LVCMOS) signal instead of a p/n differential pair. 

The software will test for electrical shorts between the lines with the FMC loopback removed and a continuity test with the FMC loopback plugged in.

+-------------+---------+-----+--------+--------+
|GPIO Instance|Channel  |Size |From    |To      |
+=============+=========+=====+========+========+
|fmc_gpio_0   |1        | 32  |LA_P[0] |LA_N[24]|
+-------------+---------+-----+--------+--------+
|             |2        | 32  |LA_P[8] |LA_N[32]|
+-------------+---------+-----+--------+--------+
|fmc_gpio_0   |1        | 4   |LA_P[16]|LA_N[33]|
+-------------+---------+-----+--------+--------+
    
All signals must have pull-up resistors activated.

Building, Generatig Bit and Elf files
-------------------------------------

`[some-directory]> make`

Building individually 
=====================

`[some-directory]> make hdf`

`[some-directory]> make sdk`

Removing all generated project files
====================================

`[some-directory]> make wipe`

Note: The project also contains hardware required for I2S.
