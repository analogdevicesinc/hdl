<p align="center">
<img src="docs/sources/HDL_logo.png" width="500" alt="ADI HDL Logo"> </br>
</p>

<p align="center">
<a href="https://github.com/analogdevicesinc/hdl/actions">
<img src="https://github.com/analogdevicesinc/hdl/actions/workflows/check_for_guideline_rules.yml/badge.svg" alt="Build Status">
</a>

<a href="https://github.com/analogdevicesinc/hdl/actions">
<img src="https://github.com/analogdevicesinc/hdl/actions/workflows/test_n_lint.yml/badge.svg" alt="Build Status">
</a>
</p>

<p align="center">
<a href="http://analogdevicesinc.github.io/hdl/">
<img alt="GitHub Pages" src="https://img.shields.io/badge/docs-GitHub%20Pages-blue.svg">
</a>

<a href="https://ez.analog.com/fpga/f/q-a">
<img alt="EngineerZone" src="https://img.shields.io/badge/Support-on%20EngineerZone-blue.svg">
</a>

<a href="https://wiki.analog.com/resources/fpga/docs/hdl">
<img alt="Analog Wiki" src="https://img.shields.io/badge/Wiki-on%20wiki.analog.com-blue.svg">
</a>
</p>

---
# HDL Reference Designs

[Analog Devices Inc.](http://www.analog.com/en/index.html) HDL libraries and projects for various reference design and prototyping systems.
This repository contains HDL code (Verilog or VHDL) and the required Tcl scripts to create and build a specific FPGA 
example design using Xilinx and/or Intel tool chain.

## Support

The HDL is provided "AS IS", support is only provided on [EngineerZone](https://ez.analog.com/community/fpga).

If you feel you can not, or do not want to ask questions on [EngineerZone](https://ez.analog.com/community/fpga), you should not use or look at the HDL found in this repository. Just like you have the freedom and rights to use this software in your products (with the obligations found in individual licenses) and get support on [EngineerZone](https://ez.analog.com/community/fpga), you have the freedom and rights not to use this software and get datasheet level support from traditional ADI contacts that you may have.

There is no free replacement for consulting services. If you have questions that are best handed one-on-one engagement, and are time sensitive, consider hiring a consultant. If you want to find a consultant who is familiar with the HDL found in this repository - ask on [EngineerZone](https://ez.analog.com/community/fpga).

## Getting started

This repository supports reference designs for different [Analog Devices boards](../master/projects) based on [Intel and Xilinx FPGA development boards](../master/projects/common) or standalone.

### Building documentation

Install the documentation tools.
```
(cd docs ; pip install -r requirements.txt)
```
Build the libraries (recommended).
```
(cd library ; make)
```
Build the documentation with Sphinx.
```
(cd docs ; make html)
```
The generated documentation will be available at `docs/_build/html`.

### Prerequisites

 * [Vivado Design Suite](https://www.xilinx.com/support/download.html)

**or**

 * [Quartus Prime Design Suite](https://www.altera.com/downloads/download-center.html)
 
Please make sure that you have the [required](https://github.com/analogdevicesinc/hdl/releases) tool version.

### How to build a project

For building a project (generate a bitstream), you have to use the [GNU Make tool](https://www.gnu.org/software/make/). If you're a 
Windows user please checkout [this page](https://wiki.analog.com/resources/fpga/docs/build#windows_environment_setup), to see how you can install this tool.

To build a project, checkout the [latest release](https://github.com/analogdevicesinc/hdl/releases), after that just **cd** to the 
project that you want to build and run make:
```
cd projects/fmcomms2/zc706
make
```

A more comprehensive build guide can be found under the following link: 
<https://wiki.analog.com/resources/fpga/docs/build>

## Software

In general all the projects have no-OS (baremetal) and a Linux support. See [no-OS](https://github.com/analogdevicesinc/no-OS) or [Linux](https://github.com/analogdevicesinc/Linux) for
more information.

## Which branch should I use?

  * If you want to use the most stable code base, always use the [latest release branch](https://github.com/analogdevicesinc/hdl/releases).

  * If you want to use the greatest and latest, check out the [master branch](https://github.com/analogdevicesinc/hdl/tree/master).

## Use already built files

You can download already built files and use them as they are. They are available on [this link]( https://swdownloads.analog.com/cse/hdl_builds/master/latest_boot_partition.tar.gz).  
The files are built from [master branch](https://github.com/analogdevicesinc/hdl/tree/master) whenever there are new commits in HDL or Linux repositories.  

> :warning: Pay attention when using already built files, since they are not tested in HW!

## License

In this HDL repository, there are many different and unique modules, consisting
of various HDL (Verilog or VHDL) components. The individual modules are
developed independently, and may be accompanied by separate and unique license
terms.

The user should read each of these license terms, and understand the
freedoms and responsibilities that he or she has by using this source/core.

See [LICENSE](../master/LICENSE) for more details. The separate license files
cab be found here:

 * [LICENSE_ADIBSD](../master/LICENSE_ADIBSD)

 * [LICENSE_GPL2](../master/LICENSE_GPL2)

 * [LICENSE_LGPL](../master/LICENSE_LGPL)

## Comprehensive user guide

See [HDL User Guide](https://wiki.analog.com/resources/fpga/docs/hdl) for a more detailed guide.

| Projects | Status | 
| --- | --- | 
| ad3552r_evb.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad3552r_evb.zed/badge/icon) | 
| ad40xx_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad40xx_fmc.zed/badge/icon) | 
| ad4110.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad4110.zed/badge/icon) | 
| ad4134_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad4134_fmc.zed/badge/icon) | 
| ad4630_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad4630_fmc.zed/badge/icon) | 
| ad469x_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad469x_fmc.zed/badge/icon) | 
| ad4858_fmcz.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad4858_fmcz.zed/badge/icon) | 
| ad5758_sdz.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad5758_sdz.zed/badge/icon) | 
| ad5766_sdz.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad5766_sdz.zed/badge/icon) | 
| ad6676evb.vc707 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad6676evb.vc707/badge/icon) | 
| ad6676evb.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad6676evb.zc706/badge/icon) | 
| ad7134_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad7134_fmc.zed/badge/icon) | 
| ad719x_asdz.coraz7s | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad719x_asdz.coraz7s/badge/icon) | 
| ad738x_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad738x_fmc.zed/badge/icon) | 
| ad7405_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad7405_fmc.zed/badge/icon) | 
| ad7606x_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad7606x_fmc.zed/badge/icon) | 
| ad7616_sdz.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad7616_sdz.zc706/badge/icon) | 
| ad7616_sdz.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad7616_sdz.zed/badge/icon) | 
| ad77681evb.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad77681evb.zed/badge/icon) | 
| ad7768evb.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad7768evb.zed/badge/icon) | 
| ad777x_ardz.de10nano | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad777x_ardz.de10nano/badge/icon) | 
| ad777x_ardz.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad777x_ardz.zed/badge/icon) | 
| ad9081_fmca_ebz.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.a10soc/badge/icon) | 
| ad9081_fmca_ebz.a10soc_np12 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.a10soc_np12/badge/icon) | 
| ad9081_fmca_ebz.vck190 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vck190/badge/icon) | 
| ad9081_fmca_ebz.vcu118 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu118/badge/icon) | 
| ad9081_fmca_ebz.vcu118_204c-txmode10-rxmode11 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu118_204c-txmode10-rxmode11/badge/icon) | 
| ad9081_fmca_ebz.vcu118_204c-txmode10-rxmode11-24-75Gbps | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu118_204c-txmode10-rxmode11-24-75Gbps/badge/icon) | 
| ad9081_fmca_ebz.vcu118_204c-txmode23-rxmode25 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu118_204c-txmode23-rxmode25/badge/icon) | 
| ad9081_fmca_ebz.vcu118_204c-txmode23-rxmode25-24-75Gbps | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu118_204c-txmode23-rxmode25-24-75Gbps/badge/icon) | 
| ad9081_fmca_ebz.vcu118_204c-txmode24-rxmode26-24-75Gbps | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu118_204c-txmode24-rxmode26-24-75Gbps/badge/icon) | 
| ad9081_fmca_ebz.vcu118_m4_l8 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu118_m4_l8/badge/icon) | 
| ad9081_fmca_ebz.vcu128 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu128/badge/icon) | 
| ad9081_fmca_ebz.vcu128_m4_l8 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.vcu128_m4_l8/badge/icon) | 
| ad9081_fmca_ebz.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.zc706/badge/icon) | 
| ad9081_fmca_ebz.zc706_np12 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.zc706_np12/badge/icon) | 
| ad9081_fmca_ebz.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.zcu102/badge/icon) | 
| ad9081_fmca_ebz.zcu102_204b-txmode9-rxmode4 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.zcu102_204b-txmode9-rxmode4/badge/icon) | 
| ad9081_fmca_ebz.zcu102_204c-txmode0-rxmode1 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.zcu102_204c-txmode0-rxmode1/badge/icon) | 
| ad9081_fmca_ebz.zcu102_m4_l8 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz.zcu102_m4_l8/badge/icon) | 
| ad9081_fmca_ebz_x_band.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9081_fmca_ebz_x_band.zcu102/badge/icon) | 
| ad9082_fmca_ebz.vck190 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9082_fmca_ebz.vck190/badge/icon) | 
| ad9082_fmca_ebz.vcu118 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9082_fmca_ebz.vcu118/badge/icon) | 
| ad9082_fmca_ebz.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9082_fmca_ebz.zc706/badge/icon) | 
| ad9082_fmca_ebz.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9082_fmca_ebz.zcu102/badge/icon) | 
| ad9083_evb.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9083_evb.a10soc/badge/icon) | 
| ad9083_evb.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9083_evb.zcu102/badge/icon) | 
| ad9083_vna.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9083_vna.zcu102/badge/icon) | 
| ad9208_dual_ebz.vcu118 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9208_dual_ebz.vcu118/badge/icon) | 
| ad9209_fmca_ebz.vck190 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9209_fmca_ebz.vck190/badge/icon) | 
| ad9213_dual_ebz.s10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9213_dual_ebz.s10soc/badge/icon) | 
| ad9213_evb.vcu118 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9213_evb.vcu118/badge/icon) | 
| ad9265_fmc.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9265_fmc.zc706/badge/icon) | 
| ad9434_fmc.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9434_fmc.zc706/badge/icon) | 
| ad9467_fmc.kc705 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9467_fmc.kc705/badge/icon) | 
| ad9467_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9467_fmc.zed/badge/icon) | 
| ad9656_fmc.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9656_fmc.zcu102/badge/icon) | 
| ad9695_fmc.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9695_fmc.zcu102/badge/icon) | 
| ad9739a_fmc.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9739a_fmc.zc706/badge/icon) | 
| ad9783_ebz.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad9783_ebz.zcu102/badge/icon) | 
| ad_fmclidar1_ebz.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad_fmclidar1_ebz.a10soc/badge/icon) | 
| ad_fmclidar1_ebz.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad_fmclidar1_ebz.zc706/badge/icon) | 
| ad_fmclidar1_ebz.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad_fmclidar1_ebz.zcu102/badge/icon) | 
| ad_quadmxfe1_ebz.vcu118 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/ad_quadmxfe1_ebz.vcu118/badge/icon) | 
| adaq7980_sdz.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adaq7980_sdz.zed/badge/icon) | 
| adaq8092_fmc.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adaq8092_fmc.zed/badge/icon) | 
| adrv9001.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9001.a10soc/badge/icon) | 
| adrv9001.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9001.zc706/badge/icon) | 
| adrv9001.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9001.zcu102/badge/icon) | 
| adrv9001.zcu102_lvds | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9001.zcu102_lvds/badge/icon) | 
| adrv9001.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9001.zed/badge/icon) | 
| adrv9009.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9009.a10soc/badge/icon) | 
| adrv9009.s10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9009.s10soc/badge/icon) | 
| adrv9009.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9009.zc706/badge/icon) | 
| adrv9009.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9009.zcu102/badge/icon) | 
| adrv9009zu11eg.adrv2crr_fmc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9009zu11eg.adrv2crr_fmc/badge/icon) | 
| adrv9009zu11eg.adrv2crr_fmcomms8 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9009zu11eg.adrv2crr_fmcomms8/badge/icon) | 
| adrv9009zu11eg.adrv2crr_fmcxmwbr1 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9009zu11eg.adrv2crr_fmcxmwbr1/badge/icon) | 
| adrv9009zu11eg.adrv2crr_xmicrowave | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9009zu11eg.adrv2crr_xmicrowave/badge/icon) | 
| adrv9361z7035.ccbob_cmos | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9361z7035.ccbob_cmos/badge/icon) | 
| adrv9361z7035.ccbob_lvds | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9361z7035.ccbob_lvds/badge/icon) | 
| adrv9361z7035.ccfmc_lvds | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9361z7035.ccfmc_lvds/badge/icon) | 
| adrv9361z7035.ccpackrf_lvds | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9361z7035.ccpackrf_lvds/badge/icon) | 
| adrv9364z7020.ccbob_cmos | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9364z7020.ccbob_cmos/badge/icon) | 
| adrv9364z7020.ccbob_lvds | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9364z7020.ccbob_lvds/badge/icon) | 
| adrv9364z7020.ccpackrf_lvds | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9364z7020.ccpackrf_lvds/badge/icon) | 
| adrv9371x.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9371x.a10soc/badge/icon) | 
| adrv9371x.kcu105 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9371x.kcu105/badge/icon) | 
| adrv9371x.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9371x.zc706/badge/icon) | 
| adrv9371x.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adrv9371x.zcu102/badge/icon) | 
| adv7511.zc702 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adv7511.zc702/badge/icon) | 
| adv7511.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adv7511.zc706/badge/icon) | 
| adv7511.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adv7511.zed/badge/icon) | 
| adv7513.de10nano | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/adv7513.de10nano/badge/icon) | 
| arradio.c5soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/arradio.c5soc/badge/icon) | 
| cn0363.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0363.zed/badge/icon) | 
| cn0501.coraz7s | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0501.coraz7s/badge/icon) | 
| cn0506.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.a10soc/badge/icon) | 
| cn0506.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zc706/badge/icon) | 
| cn0506.zc706_mii | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zc706_mii/badge/icon) | 
| cn0506.zc706_rmii | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zc706_rmii/badge/icon) | 
| cn0506.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zcu102/badge/icon) | 
| cn0506.zcu102_mii | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zcu102_mii/badge/icon) | 
| cn0506.zcu102_rmii | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zcu102_rmii/badge/icon) | 
| cn0506.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zed/badge/icon) | 
| cn0506.zed_mii | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zed_mii/badge/icon) | 
| cn0506.zed_rmii | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0506.zed_rmii/badge/icon) | 
| cn0540.coraz7s | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0540.coraz7s/badge/icon) | 
| cn0540.de10nano | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0540.de10nano/badge/icon) | 
| cn0561.coraz7s | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0561.coraz7s/badge/icon) | 
| cn0561.de10nano | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0561.de10nano/badge/icon) | 
| cn0561.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0561.zed/badge/icon) | 
| cn0577.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0577.zed/badge/icon) | 
| cn0579.coraz7s | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0579.coraz7s/badge/icon) | 
| cn0579.de10nano | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/cn0579.de10nano/badge/icon) | 
| dac_fmc_ebz.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/dac_fmc_ebz.a10soc/badge/icon) | 
| dac_fmc_ebz.vcu118 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/dac_fmc_ebz.vcu118/badge/icon) | 
| dac_fmc_ebz.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/dac_fmc_ebz.zc706/badge/icon) | 
| dac_fmc_ebz.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/dac_fmc_ebz.zcu102/badge/icon) | 
| daq2.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq2.a10soc/badge/icon) | 
| daq2.kc705 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq2.kc705/badge/icon) | 
| daq2.kcu105 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq2.kcu105/badge/icon) | 
| daq2.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq2.zc706/badge/icon) | 
| daq2.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq2.zcu102/badge/icon) | 
| daq3.kcu105 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq3.kcu105/badge/icon) | 
| daq3.vcu118 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq3.vcu118/badge/icon) | 
| daq3.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq3.zc706/badge/icon) | 
| daq3.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/daq3.zcu102/badge/icon) | 
| dc2677a.c5soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/dc2677a.c5soc/badge/icon) | 
| fmcadc2.vc707 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcadc2.vc707/badge/icon) | 
| fmcadc2.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcadc2.zc706/badge/icon) | 
| fmcadc5.vc707 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcadc5.vc707/badge/icon) | 
| fmcjesdadc1.kc705 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcjesdadc1.kc705/badge/icon) | 
| fmcjesdadc1.vc707 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcjesdadc1.vc707/badge/icon) | 
| fmcjesdadc1.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcjesdadc1.zc706/badge/icon) | 
| fmcomms11.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms11.zc706/badge/icon) | 
| fmcomms2.kc705 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms2.kc705/badge/icon) | 
| fmcomms2.kcu105 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms2.kcu105/badge/icon) | 
| fmcomms2.vc707 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms2.vc707/badge/icon) | 
| fmcomms2.zc702 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms2.zc702/badge/icon) | 
| fmcomms2.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms2.zc706/badge/icon) | 
| fmcomms2.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms2.zcu102/badge/icon) | 
| fmcomms2.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms2.zed/badge/icon) | 
| fmcomms5.zc702 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms5.zc702/badge/icon) | 
| fmcomms5.zc706 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms5.zc706/badge/icon) | 
| fmcomms5.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms5.zcu102/badge/icon) | 
| fmcomms8.a10soc | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms8.a10soc/badge/icon) | 
| fmcomms8.zcu102 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/fmcomms8.zcu102/badge/icon) | 
| imageon.zed | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/imageon.zed/badge/icon) | 
| jupiter_sdr | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/jupiter_sdr/badge/icon) | 
| m2k.standalone | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/m2k.standalone/badge/icon) | 
| pluto | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/pluto/badge/icon) | 
| pulsar_adc_pmdz.coraz7s | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/pulsar_adc_pmdz.coraz7s/badge/icon) | 
| sidekiqz2 | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/sidekiqz2/badge/icon) | 
| usrpe31x | ![Build Status](https://largely-growing-salmon.ngrok-free.app/job/master/job/hdl_jobs/job/history/job/master_latest_commit/job/projects/job/usrpe31x/badge/icon) |
