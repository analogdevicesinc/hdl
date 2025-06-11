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

[Analog Devices, Inc.](http://www.analog.com/en/index.html) HDL libraries and
projects for various reference design and prototyping systems.
This repository contains HDL code (Verilog or VHDL) and the required Tcl
scripts to create and build a specific FPGA example design using the AMD
Xilinx and/or Intel tool chains.

## Support

The HDL is provided "AS IS". Support is only provided on
[EngineerZone](https://ez.analog.com/community/fpga).

If you feel you can not, or do not want to ask questions on
[EngineerZone](https://ez.analog.com/community/fpga), you should not use or
look at the HDL found in this repository. Just like you have the freedom and
rights to use this software in your products (with the obligations found in
individual licenses) and get support on
[EngineerZone](https://ez.analog.com/community/fpga), you have the freedom and
rights not to use this software and get data sheet level support from traditional
[ADI](http://www.analog.com/en/index.html) contacts that you may have.

There is no free replacement for consulting services. If you have questions
that are best handed one-on-one engagement, and are time sensitive, consider
hiring a consultant. If you want to find a consultant who is familiar with
the HDL found in this repository - ask on
[EngineerZone](https://ez.analog.com/community/fpga).

## Getting started

This repository supports reference designs for different
[Analog Devices boards](../main/projects) based on
[AMD Xilinx and Intel FPGA development boards](../main/projects/common)
or standalone.

### Prerequisites

- [AMD Xilinx Vivado Design Suite](https://www.xilinx.com/support/download.html)

**or**

- [Intel Quartus Prime Design Suite](https://www.altera.com/downloads/download-center.html)

Please make sure that you have the
[required](https://github.com/analogdevicesinc/hdl/releases) tool versions.

### How to build a project

For building a project (generate a bitstream), you have to use the
[GNU Make tool](https://www.gnu.org/software/make/). If you're a Windows user,
please checkout
[this page](https://analogdevicesinc.github.io/hdl/user_guide/build_hdl.html#environment),
to see how you can install this tool.

To build a project, checkout the
[latest release](https://github.com/analogdevicesinc/hdl/releases), after that
just **cd** to the project that you want to build and run make:

```
cd projects/fmcomms2/zcu102
make
```

A more comprehensive build guide can be found under the following link:
<https://analogdevicesinc.github.io/hdl/user_guide/build_hdl.html>

### Building documentation (developer purposes only)

<details>

<summary> Click here for details on how to build the documentation and open it locally on your machine. </summary>

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

</details>

## Which branch should I use?

- If you want to use the most stable code base, always use the
  [latest release branch](https://github.com/analogdevicesinc/hdl/releases).
- If you want to use the latest, but sometimes unstable, check out the
  [main branch](https://github.com/analogdevicesinc/hdl/tree/main).

The AMD Xilinx Vivado/Intel Quartus versions for each branch can be found
[here](https://analogdevicesinc.github.io/hdl/user_guide/releases.html), or in
[the script that sets these versions](https://github.com/analogdevicesinc/hdl/blob/main/scripts/adi_env.tcl),
while checked out on your desired branch.

## Use already built files

You can download already built files and use them as they are.
For the main branch, they are available at the link inside
[this document](https://swdownloads.analog.com/cse/boot_partition_files/main/latest_boot.txt).
Keep in mind that the ones from the main branch are not stable all the time.
We suggest using the latest release branch, see
[here](https://analogdevicesinc.github.io/hdl/user_guide/releases.html).
The files are built from [main branch](https://github.com/analogdevicesinc/hdl/tree/main)
whenever there are new commits in HDL or Linux repositories.

:warning: Pay attention when using already built files from the main branch,
as they are not tested in hardware!

## Software

In general, all the projects have no-OS (baremetal) and a Linux support.
See [no-OS](https://github.com/analogdevicesinc/no-OS) repository or
[Linux](https://github.com/analogdevicesinc/linux) repository for more information.

## License

In this HDL repository, there are many different and unique modules, consisting
of various HDL (Verilog or VHDL) components. The individual modules are
developed independently, and may be accompanied by separate and unique license
terms.

The user should read each of these license terms, and understand the
freedoms and responsibilities that he or she has by using this source/core.

See [LICENSE](../main/LICENSE) for more details. The separate license files
cab be found here:

- [LICENSE_ADIBSD](../main/LICENSE_ADIBSD)
- [LICENSE_GPL2](../main/LICENSE_GPL2)
- [LICENSE_LGPL](../main/LICENSE_LGPL)

## Comprehensive user guide

See [HDL User Guide](https://analogdevicesinc.github.io/hdl/user_guide/build_hdl.html)
for a more detailed guide.
