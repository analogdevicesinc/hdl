- Connect on FMC LPC
- VADJ = 1.8V to 3.3V
Make sure that all power supply source/voltage selection jumpers are
properly placed according to your use case on both the eval board and zed.

The default interface at build is CMOS. To explicitly select an interface:

- make LVDS_CMOS_N=0 for CMOS interface
- make LVDS_CMOS_N=1 for LVDS interface
