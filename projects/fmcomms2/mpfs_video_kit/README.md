<!-- no_build_example, no_no_os -->

# FMCOMMS2/MPFS_VIDEO_KIT HDL Project

FMCOMMS2/3/4 on the Microchip PolarFire SoC Video Kit (MPFS250TS), on FMC1.

- VADJ with which it was tested in hardware: 2.5V (J40 = 7-8, J46 = 7-8)
- Tool: Libero SoC (version in `scripts/adi_env.tcl`), SoftConsole for the HSS

## Building the project

```
cd projects/fmcomms2/mpfs_video_kit
make
```

Outputs, in `_bld/prj/designer/system_top/export`:

- `system_top.job`: FlashPro Express job
- `fmcomms2_mpfs_video_kit.zip`: the job, the bitstream, the MSS configuration
  XML and the build information

With the HSS boot loader in the eNVM:

```
make hss-job
```

Output: `_bld/hss/system_top_hss.job`.

The system simulation (system_top with a testbench and the MSS bus functional
model):

```
make sim-cli
```

`make info` prints the build directories and the outputs; all targets are in
the header of `projects/scripts/project-microchip.mk`.

## Files

- `system_lb.tcl`: the block design: the carrier base design
  (`projects/common/mpfs_video_kit`) and `projects/fmcomms2/common/fmcomms2_lb.tcl`
- `system_top.v`: top level, the GPIO and I2C buffers
- `mss_base.cfg`: MSS configuration
- `system_constr.pdc`: pins and bank voltages; `system_constr.sdc`: AD9361 clocks
- `system_project_sim.tcl`, `verification/`: the simulation project
