- Connect on FMC LPC
- VADJ = 1.8V to 3.3V
Make sure that all power supply source/voltage selection jumpers are
properly placed according to your use case on both the eval board and zed.

The default device at build is AD4858. To explicitly select a device:
set DEVICE "AD4858"

- make DEVICE="AD4858" for AD4858
- make DEVICE="AD4854" for AD4854

The default interface at build is CMOS. To explicitly select an interface:

- make LVDS_CMOS_N=0 for CMOS interface
- make LVDS_CMOS_N=1 for LVDS interface

E.g. for other combinations:

- make DEVICE="AD4857" LVDS_CMOS_N=0
- make DEVICE="AD4853" LVDS_CMOS_N=1
