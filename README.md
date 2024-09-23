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

This repository supports reference designs for different [Analog Devices boards](../main/projects) based on [Intel and Xilinx FPGA development boards](../main/projects/common) or standalone.

### Building documentation

Ensure pip is newer than version 23.
```
pip install pip --upgrade
```
Install the documentation tools.
```
(cd docs ; pip install -r requirements.txt --upgrade)
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

  * If you want to use the greatest and latest, check out the [main branch](https://github.com/analogdevicesinc/hdl/tree/main).

## Use already built files

You can download already built files and use them as they are.
For the main branch, they are available at the link inside [this document](https://swdownloads.analog.com/cse/boot_partition_files/main/latest_boot.txt). Keep in mind that the ones from the main branch are not stable all the time.
We suggest using the latest release branch [2022_r2, here](https://swdownloads.analog.com/cse/boot_partition_files/2022_r2/latest_boot.txt).  
The files are built from [main branch](https://github.com/analogdevicesinc/hdl/tree/main) whenever there are new commits in HDL or Linux repositories.  

> :warning: Pay attention when using already built files, since they are not tested in HW!

## License

In this HDL repository, there are many different and unique modules, consisting
of various HDL (Verilog or VHDL) components. The individual modules are
developed independently, and may be accompanied by separate and unique license
terms.

The user should read each of these license terms, and understand the
freedoms and responsibilities that he or she has by using this source/core.

See [LICENSE](../main/LICENSE) for more details. The separate license files
cab be found here:

 * [LICENSE_ADIBSD](../main/LICENSE_ADIBSD)

 * [LICENSE_GPL2](../main/LICENSE_GPL2)

 * [LICENSE_LGPL](../main/LICENSE_LGPL)

## Comprehensive user guide

See [HDL User Guide](https://wiki.analog.com/resources/fpga/docs/hdl) for a more detailed guide.

### Contributors

<img src="https://markupgo.com/github/analogdevicesinc/hdl/contributors?count=0&circleSize=40&circleRadius=40&center=true" width="100%" /> 
