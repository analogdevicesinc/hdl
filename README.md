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
 [~]cd projects/fmcomms2/zc706
 [~]make
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
