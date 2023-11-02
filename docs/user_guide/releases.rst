.. _releases:

Releases
===============================================================================

The HDL is released as git branches bi-annually. The release branches
are created first and then tested before being made official. That is,
the existence of a branch does not mean it is a fully tested release.

Also, the release branch is tested **only** on certain versions of the tools
and may **not** work with other versions of the tools.
The projects that are tested and supported in a release branch are listed
along with the ADI library cores that are used.

The release branch may contain other projects that are in development;
one must assume these are **not** tested, therefore **not** supported by
this release.

Porting a release branch to another Tool version
-------------------------------------------------------------------------------

It is possible to port a release branch to another tool version, though
not recommended. The ADI libraries should work across different versions
of the tools, but the projects may not. The issues are most likely with
the Intel and AMD Xilinx cores. If you must still do this, note the
following:

First, disable the version check of the scripts.

The ADI build scripts are making sure that the releases are being run on
the validated tool version. It will promptly notify the user if he or
she trying to use an unsupported version of tools. You need to disable
this check by setting the environment variable ``ADI_IGNORE_VERSION_CHECK``.

Second, make Intel and AMD IP cores version change.

The Intel projects should automatically be changed by Quartus. The
Vivado projects are a bit tricky. The GUI automatically updates the
cores, but the **Tcl flow does not**.

Thus, it may be easier to create the project file with the supported version
first, then opening it with the new version.
After which, update the Tcl scripts accordingly.

The versions are specified in the following format.

.. code-block:: tcl
   :linenos:

   add_instance sys_cpu altera_nios2_gen2 16.0
   set sys_mb [create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:9.5 sys_mb]

You should now be able to build the design and test things out. In most
cases, it should work without much effort. If it doesn't, do an
incremental update and debug accordingly.

Release branches
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. list-table::
   :widths: 20 20 20 20 20
   :header-rows: 1

   * - Releases
     - Intel
     - AMD Xilinx
     - Release notes
     - List of supported projects and IP cores
   * - :git-hdl:`main <main:/>`
     - Quartus Pro 23.2
     - Vivado 2023.1
     -
     -
   * - :git-hdl:`hdl_2021_r2 <hdl_2021_r2:>`
     - Quartus Pro 21.4
     - Vivado 2021.2
     - `Release notes 2021_R2 <https://github.com/analogdevicesinc/hdl/releases/tag/2021_R2>`_
     - `Wiki list for hdl_2021_r2 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2021_r2>`_
   * - :git-hdl:`hdl_2021_r1 <hdl_2021_r1:>`
     - Quartus Pro 21.2
     - Vivado 2021.1
     - `Release notes 2021_R1 <https://github.com/analogdevicesinc/hdl/releases/tag/2021_R1>`_
     - `Wiki list for hdl_2021_r1 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2021_r1>`_
   * - :git-hdl:`hdl_2019_r2 <hdl_2019_r2:>`
     - Quartus Pro 19.3
     - Vivado 2019.1
     - `Release notes 2019_R2 <https://github.com/analogdevicesinc/hdl/releases/tag/2019_R2>`_
     - `Wiki list for hdl_2019_r2 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2019_r2>`_
   * - :git-hdl:`hdl_2019_r1 <hdl_2019_r1:>`
     - Quartus Pro 18.1
     - Vivado 2018.3
     - `Release notes 2019_R1 <https://github.com/analogdevicesinc/hdl/releases/tag/2019_R1>`_
     - `Wiki list for hdl_2019_r1 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2019_r1>`_
   * - :git-hdl:`hdl_2018_r2 <hdl_2018_r2:>`
     - Quartus Pro 18.0
     - Vivado 2018.2
     - `Release notes 2018_R2 <https://github.com/analogdevicesinc/hdl/releases/tag/2018_R2>`_
     - `Wiki list for hdl_2018_r2 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2018_r2>`_
   * - :git-hdl:`hdl_2018_r1 <hdl_2018_r1:>`
     - Quartus Pro 17.1.1
     - Vivado 2017.4.1
     - `Release notes 2018_R1 <https://github.com/analogdevicesinc/hdl/releases/tag/2018_R1>`_
     - `Wiki list for hdl_2018_r1 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2018_r1>`_
   * - :git-hdl:`hdl_2017_r1 <hdl_2017_r1:>`
     - Quartus Pro 16.1
     - Vivado 2016.4
     - `Release notes 2017_R1 <https://github.com/analogdevicesinc/hdl/releases/tag/2017_R1>`_
     - `Wiki list for hdl_2017_r1 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2017_r1>`_
   * - :git-hdl:`hdl_2016_r2 <hdl_2016_r2:>`
     - Quartus Pro 16.0
     - Vivado 2016.2
     - `Release notes 2016_R2 <https://github.com/analogdevicesinc/hdl/releases/tag/2016_R2>`_
     - `Wiki list for hdl_2016_r2 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2016_r2>`_
   * - :git-hdl:`hdl_2016_r1 <hdl_2016_r1:>`
     - Quartus Pro 15.1
     - Vivado 2015.4.2
     - `Release notes 2016_R1 <https://github.com/analogdevicesinc/hdl/releases/tag/2016_R1>`_
     - `Wiki list for hdl_2016_r1 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2016_r1>`_
   * - :git-hdl:`hdl_2015_r2 <hdl_2015_r2:>`
     - Quartus Pro 15.0.2
     - Vivado 2015.2
     - `Release notes 2015_R2 <https://github.com/analogdevicesinc/hdl/releases/tag/2015_R2>`_
     - `Wiki list for hdl_2015_r2 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2015_r2>`_
   * - :git-hdl:`hdl_2015_r1 <hdl_2015_r1:>`
     - Quartus Pro 14.1
     - Vivado 2014.4.1
     - `Release notes 2015_R1 <https://github.com/analogdevicesinc/hdl/releases/tag/2015_R1>`_
     - `Wiki list for hdl_2015_r1 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2015_r1>`_
   * - :git-hdl:`hdl_2014_r2 <hdl_2014_r2:>`
     - Quartus Pro 14.0
     - Vivado 2014.2
     - `Release notes 2014_R2 <https://github.com/analogdevicesinc/hdl/releases/tag/2014_R2>`_
     - `Wiki list for hdl_2014_r2 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2014_r2>`_
   * - :git-hdl:`hdl_2014_r1 <hdl_2014_r1:>`
     - Quartus Pro 14.0
     - Vivado 2013.4
     - `Release notes 2014_R1 <https://github.com/analogdevicesinc/hdl/releases/tag/2014_R1>`_
     - `Wiki list for hdl_2014_r1 <https://wiki.analog.com/resources/fpga/docs/hdl/downloads_2014_r1>`_


About the tools we use
-------------------------------------------------------------------------------

When Intel or AMD have a new release, we usually follow them and update our
tools in a timely manner.

Changing the version of tool used on a branch is done by updating the
git-hdl:`adi_env.tcl <scripts/adi_env.tcl>` script.

If the tool version is not the one you want to use, keep in mind that when
making a setup, you will have to build the software files with the same
version, otherwise you might encounter problems in your setup.

For example, you want to use an older version of Vivado on the main branch
which uses a newer one. Then you will need to manually build the software
files from the main branch, with the same version of Vitis too. Or for
Linux, to use the proper version of CROSS_COMPILE, etc.
