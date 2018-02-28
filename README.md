# HDL Reference Designs

[Analog Devices Inc.](http://www.analog.com/en/index.html) HDL libraries and projects.

## Getting started

These projects currently supporting several different [FPGA development boards](https://github.com/analogdevicesinc/hdl/tree/master/projects) and [FMC boards](https://github.com/analogdevicesinc/hdl/tree/master/projects/common). 
First make sure that the current state of the repository support's your hardware.

### Prerequisites

 * [Vivado Design Suite](https://www.xilinx.com/support/download.html)

**or**

 * [Quartus Prime Design Suite](https://www.altera.com/downloads/download-center.html)
 
Please make sure that you have the [required](https://github.com/analogdevicesinc/hdl/releases) tool version.

### How to build a project

For building a projects, you have to use the GNU Make tool. If you're a 
Windows user please checkout this page, to see how you can install this tool.

To build a project, checkout the [latest release](https://github.com/analogdevicesinc/hdl/releases), after that just **cd** to the 
project that you want to build and run make:
```
 [~]cd projects/fmcomms2/zc706
 [~]make
```

A more comprehensive build guide can be found under the following link: 
<https://wiki.analog.com/resources/fpga/docs/build>

## Development workflow

The main branch is the master branch, which get's the latest features and updates 
first.

Releases are done two times a year. Each release has a unique branch. After the
release branch is created it will not get any additional new features. Until the
release branch is not fully tested, it stay's in a pre-released state.

Each feature has a topic or feature branch, which will be merged into master, as
soon as the feature is stable.

If you want to use the most stable code base, always use the latest release branch.

If you want to use the greatest and latest, check out the master branch.

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

See [HDL User Guide](https://wiki.analog.com/resources/fpga/docs/hdl) for a more
detailed guide.

## Support

Feel free to ask any question at [EngineerZone](https://ez.analog.com/community/fpga).

