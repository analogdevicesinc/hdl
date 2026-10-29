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

DDR
---

The Talise SOM (schematic 02-048949-01 rev I) has nine DDR4 parts (MT40A512M16TD-062E, 8 Gb x16).

The PL DDR is driven by two MIG (Xilinx Memory Interface Generator) DDR4 controller IPs in the PL:

* MIG 0 is the ddr4_0 instance (prod_bd.tcl), connected to U30 and U31.
* MIG 1 is the ddr4_1 instance (../common/adrv9009zu11eg_bd.tcl), connected to U41 and U42.

Each MIG drives two x16 parts as a single rank 32-bit bus. The address, command and clock signals of a MIG are
shared by both of its parts. The init_calib_complete outputs of the two MIGs are read through ddr_calib_gpio
(0x43A00000): bit 0 is MIG 0, bit 1 is MIG 1. A 0 on a bit identifies the failing MIG (pair of parts), not the
individual part.

The MIG 0 pins are constrained in prod_constr.xdc and the MIG 1 pins in ../common/adrv9009zu11eg_constr.xdc.
MIG 0 is accessed only by the PS through M_AXI_HPM0_FPD. MIG 1 is used by the TX DAC FIFO (axi_tx_fifo).

The PS DDR is configured in sys_ps8 as a 64-bit interface with ECC. Its calibration status is not exported to the PL.

+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| Interface      | Calib bit | Part | DQ              | DQS      | DM        | FPGA bank | Sheet |
+================+===========+======+=================+==========+===========+===========+=======+
| MIG 0 (ddr4_0) | 0         | U30  | dq[15:0]        | dqs[1:0] | dm_n[1:0] | 69        | 11    |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| MIG 0 (ddr4_0) | 0         | U31  | dq[31:16]       | dqs[3:2] | dm_n[3:2] | 70        | 11    |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| MIG 1 (ddr4_1) | 1         | U41  | dq[15:0]        | dqs[1:0] | dm_n[1:0] | 70        | 12    |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| MIG 1 (ddr4_1) | 1         | U42  | dq[31:16]       | dqs[3:2] | dm_n[3:2] | 71        | 12    |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| PS DDR         | -         | U2   | DQ[15:0]        | DQS[1:0] | DM[1:0]   | 504       | 8     |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| PS DDR         | -         | U3   | DQ[31:16]       | DQS[3:2] | DM[3:2]   | 504       | 8     |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| PS DDR         | -         | U4   | DQ[47:32]       | DQS[5:4] | DM[5:4]   | 504       | 9     |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| PS DDR         | -         | U5   | DQ[63:48]       | DQS[7:6] | DM[7:6]   | 504       | 9     |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+
| PS DDR         | -         | U6   | DQ[71:64] (ECC) | DQS[8]   | DM[8]     | 504       | 9     |
+----------------+-----------+------+-----------------+----------+-----------+-----------+-------+

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
