.. _build_hdl:

Build an HDL project
===============================================================================

.. warning::

   Please note that ADI only provides the source files necessary to create
   and build the reference designs &
   :dokuwiki:`already-built files <resources/tools-software/linux-software/adi-kuiper_images/release_notes>`
   for booting up the setup with the reference design.

   You are responsible for modifying and building the modified projects.

Here we are giving you a quick rundown on how we build things. That said,
the steps below are **not a recommendation**, but a suggestion.
**How you want to build these projects is entirely up to you.**
The only catch is that if you run into problems, **you have to resolve them
independently.**

In case you **don't want to manually build** the reference design projects,
you can get the already built & tested files from our ADI Kuiper Linux
release (contains HDL + Linux boot files) from
:dokuwiki:`here <resources/tools-software/linux-software/adi-kuiper_images/release_notes>`.

The build process depends on certain software and tools, which you could use
in many ways. We use **command line** and mostly **Linux systems**.

.. important::

   The user **must** be familiar with common Linux commands such as:
   **cd, make, mkdir, ls, touch, source, export**

   and simple git command line commands (or the equivalent in GUI):
   **clone, status, checkout, log, fetch, rebase**.

Overview
-------------------------------------------------------------------------------

This is a detailed guide with lots of information regarding everything.
Careful reading is needed. To put it in few words, the following steps will
be described:

#. :ref:`install the needed tools <build_hdl needed-tools>`
#. :ref:`clone the hdl repository <build_hdl setup-repo>`
#. :ref:`source the paths to the tools <build_hdl environment>`
#. :ref:`build the project <build_hdl build>`
#. :ref:`build the hdl boot file <build_hdl boot-file>`

.. _build_hdl needed-tools:

1. Needed tools
-------------------------------------------------------------------------------

#. Install the required FPGA design suite. We use `AMD Xilinx Vivado`_,
   `Intel Quartus Prime Pro and Standard`_, `Lattice Radiant`_ and
   `Lattice Propel`_.
   You can find information about the proper version in the section
   :ref:`build_hdl tool-versions`.
   Make sure that you're always using the latest release.
#. The **required** Vivado/Quartus/Propel/Radiant version can be found in:

   -  :git-hdl:`scripts/adi_env.tcl`
   -  or in the `release notes <https://github.com/analogdevicesinc/hdl/releases>`__

#. Download the tools from the following links:

   -  :xilinx:`AMD tools <support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools.html>`
      (make sure you're downloading the proper installer.
      For full installation, it is better to choose the one that downloads
      and installs both Vivado and Vitis at the same time)
   -  :intel:`Intel tools <content/www/us/en/programmable/downloads/download-center.html>`
   -  `Lattice tools <https://www.latticesemi.com/en/Products/DesignSoftwareAndIP>`__

#. After you have installed the above-mentioned tools, you will need the
   paths to those directories in the following steps, so have them in a
   note.
#. We are using `git <https://git-scm.com/>`__ for version control and
   `GNU Make <https://www.gnu.org/software/make/>`__ to build the
   projects. Depending on what OS you're using, you have these options:

.. _build_hdl setup-repo:

2. Setup the HDL repository
-------------------------------------------------------------------------------

These designs are built upon ADI's generic HDL reference designs framework.
ADI distributes the bit/elf files of these projects as part of the
:dokuwiki:`ADI Kuiper Linux <resources/tools-software/linux-software/kuiper-linux>`.
If you want to build the sources, ADI makes them available on the
:git-hdl:`HDL repository </>`. To get the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the repository. This is the best method to get the sources.

Here, we are cloning the repository inside a directory called **adi**.
Please refer to the :ref:`git_repository` section for more details.

.. shell:: bash

   $git clone git@github.com:analogdevicesinc/hdl.git

.. collapsible:: Cloning is done now using SSH

   .. warning::

      Cloning the HDL repository is done now using SSH, because of
      GitHub security reasons. Check out this documentation on `how to deal
      with SSH keys in
      GitHub <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>`__.
      Both for `Cygwin <https://www.cygwin.com/>`__ and
      `WSL <https://learn.microsoft.com/en-us/windows/wsl/install/>`__ it is
      necessary to create a unique SSH key. If you use WSL, to get the best
      performance, you must clone your HDL repository in the WSL file system.
      For example: (:code:`\\\\wsl.localhost\\Ubuntu\\home\\username\\hdl`)

The above command clones the **default** branch, which is the **main** for
HDL repo. The **main** branch always points to the latest stable release
branch, but it also has features **that are not fully tested**. If you
want to switch to any other branch you need to checkout that branch:

.. shell:: bash

   ~/hdl
   $git checkout hdl_2022_r2

If this is your first time cloning, you have the latest source files.
If not, you can simply pull the latest sources using ``git pull`` or
``git rebase`` if you have local changes.

.. shell:: bash

   ~/hdl
   $git fetch origin               # shows what changes will be pulled on your local copy
   $git rebase origin/hdl_2022_r2  # updates your local copy

.. _build_hdl environment:

3. Environment
-------------------------------------------------------------------------------

Our recommended build flow involves using ``make`` and the command line versions
of the FPGA design tools.
This approach streamlines our overall build and release process, as it
automatically builds the necessary libraries and dependencies.

Each vendor tool requires their environment loaded before executing `make`.
For details on loading the appropriate environment, consult the vendor documentation.
Typically, they provide source scripts (**settings*.sh**) for this purpose.

To simplify setting up the environment, consider adding a wrapper for the correct
method in your **~/.bashrc** file as follows:

.. code-block:: bash

   XVERSION=2023.2
   load_amd ()
   {
       source /opt/Xilinx/Vivado/$XVERSION/settings64.sh
   }

.. tip::

   Even though it's convenient, we discourage adding the source scripts to
   .bashrc files outside of wrapper methods, as multiple vendor environments
   may conflict with each other.

Then, `re-source your bashrc <https://linuxcommand.org/lc3_man_pages/sourceh.html>`__
for the current session (or open a new one) and call the defined method:

.. shell:: bash

   $source ~/.bashrc
   $load_amd

Check out the following sections for the paths you need to export.

3a. Linux environment setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All major distributions should have ``make`` installed by default. If not,
when trying the command, it should tell you how to install it with the
package name.

.. caution::

   Change the path and the tool version accordingly to your installation!

For AMD Xilinx Vivado:

.. shell:: bash

   ~/hdl
   $source /opt/Xilinx/Vivado/202x.x/settings64.sh

   $export PATH=$PATH:/opt/Xilinx/Vivado/202x.x/bin:/opt/Xilinx/Vitis/202x.x/bin
   $export PATH=$PATH:/opt/Xilinx/Vitis/202x.x/gnu/microblaze/nt/bin

For Intel Quartus:

.. shell:: bash

   ~/hdl
   $export PATH=$PATH:/opt/intelFPGA_pro/2x.x/quartus/bin

For Lattice:

.. shell:: bash

   ~/hdl
   $export PATH=$PATH:/opt/lscc/propel/202x.x/builder/rtf/bin/lin64
   $export PATH=$PATH:/opt/lscc/radiant/202x.x/bin/lin64

3b. Windows environment setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Because GNU Make is not supported on Windows, you need to install
`Cygwin <https://www.cygwin.com/>`__, which is a UNIX-like environment
and command-line interface for Microsoft Windows.

.. caution::

   Change the path and the tool version accordingly to your installation!

For AMD Xilinx Vivado:

.. shell:: bash

   ~/hdl
   $source /cygdrive/path_to/Xilinx/Vivado/202x.x/settings64.sh

   $export PATH=$PATH:/cygdrive/c/Xilinx/Vivado/202x.x/bin
   $export PATH=$PATH:/cygdrive/c/Xilinx/Vivado_HLS/202x.x/bin
   $export PATH=$PATH:/cygdrive/c/Xilinx/Vitis/202x.x/bin
   $export PATH=$PATH:/cygdrive/c/Xilinx/Vitis/202x.x/gnu/microblaze/nt/bin
   $export PATH=$PATH:/cygdrive/c/Xilinx/Vitis/202x.x/gnu/arm/nt/bin
   $export PATH=$PATH:/cygdrive/c/Xilinx/Vitis/202x.x/gnu/microblaze/linux_toolchain/nt64_be/bin
   $export PATH=$PATH:/cygdrive/c/Xilinx/Vitis/202x.x/gnu/microblaze/linux_toolchain/nt64_le/bin
   $export PATH=$PATH:/cygdrive/c/Xilinx/Vitis/202x.x/gnu/aarch32/nt/gcc-arm-none-eabi/bin

For Intel Quartus:

.. shell:: bash

   ~/hdl
   $export PATH=$PATH:/cygdrive/c/intelFPGA_pro/2x.x/quartus/bin64

For Lattice:

.. shell:: bash

   ~/hdl
   $export PATH=$PATH:/cygdrive/c/lscc/propel/202x.x/builder/rtf/bin/nt64
   $export PATH=$PATH:/cygdrive/c/lscc/radiant/202x.x/bin/nt64

.. collapsible:: Alternatives to Cygwin/Linux terminal

   A very good alternative to Cygwin -- **but not supported by us** -- is
   `WSL <https://learn.microsoft.com/en-us/windows/wsl/install/>`__.

   If you do not want to use neither Cygwin nor WSL, there might still be some
   alternative. There are ``make`` alternatives for **Windows Command
   Prompt**, minimalist GNU for Windows (**MinGW**), or the **Cygwin
   variations** installed by the tools itself.
   **But note that we do not support it!**

   Some of these may not be fully functional with our scripts and/or projects.
   If you are an Intel user, the **Nios II Command Shell** does support make.
   If you are an AMD user, use the **gnuwin** installed as part of the SDK,
   usually at ``C:\Xilinx\Vitis\202x.x\gnuwin\bin``.

**How to verify your environment setup**

Use the ``which`` command to locate the command which would be executed in the
current environment, for example:

.. shell:: bash

   $which git
    /usr/bin/git
   $which make
    /usr/bin/make
   $which vivado
    /opt/Xilinx/Vivado/2023.1/bin/vivado
   $which quartus
    /opt/intelFPGA/23.1/quartus/bin/quartus

.. _build_hdl build:

4. Building the projects
-------------------------------------------------------------------------------

.. caution::

   Before building any project, you **must**:

   #. check the Vivado version needed by entering the
      :git-hdl:`hdl/scripts/adi_env.tcl <scripts/adi_env.tcl>` file. If you do
      not want to use that (although **we strongly advise you to use it**)
      then you have the alternative of setting ``export ADI_IGNORE_VERSION_CHECK=1``
      before building the project. Otherwise your project will fail.

   #. have the environment prepared and the proper tools. See
      `Tools`_ section on what you need to download and
      :ref:`build_hdl environment` section on how to set-up your environment.

If you're not using the Vivado version we recommend, just know that **we do not
guarantee** that the project will build ok. The projects are built and tested
in hardware using the Vivado version
:ref:`specific for that branch <build_hdl needed-tools>`.

Simply put, to build a project you just run ``make`` in your Linux terminal
or in Cygwin. For more details, please read the rest of the documentation.

To clean only a project or an IP core before building it again,
run ``make clean``.
To clean both the already built IP cores which the project depends on and the project,
run ``make clean-all``.

4a. Building an AMD project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An AMD project is built the same way as an Intel project. The only
exception is that there are a few 'sub-make(s)' for the library
components. The way of building a project in Cygwin and WSL is almost the same.

You just need to go to the hdl/projects folder, choose the ADI part that you
want to use, then enter the folder of the FPGA carrier that you want, and run
``make`` to build the project.

A generic path where you want to build the project would look like:
``hdl/projects/$ADI_part/$FPGA_carrier``.

**EXAMPLE**: Here we are building the **DAQ2** project on the **ZC706** carrier.

.. shell:: bash

   ~/hdl
   $cd projects/daq2/zc706
   $make

The ``make`` builds all the libraries first and then builds the project.
This assumes that you have the tools and licenses setup correctly. If
you don't get to the last line, the make failed to build one or more
targets: it could be a library component or the project itself. There is
nothing you can gather from the ``make`` output (other than which one
failed). The actual information about the failure is in a log file inside
the project directory.

On projects which support this, some ``make`` parameters can be added, to
configure the project (you can check the **system_project.tcl** file
to see if your project supports this).

If parameters were used, the result of the build will be in a folder named
by the configuration used. Here are some examples:

**Example 1**

Running the command below will create a folder named
**RXRATE2_5_TXRATE2_5_RXL8_RXM4_RXS1_RXNP16_TXL8_TXM4_TXS1_TXNP16**
because of truncation of some keywords so the name will not exceed the limits
of the Operating System (**JESD**, **LANE**, etc. are removed) of 260
characters.

.. code-block:: bash

   make RX_LANE_RATE=2.5 TX_LANE_RATE=2.5 RX_JESD_L=8 RX_JESD_M=4 RX_JESD_S=1 RX_JESD_NP=16 TX_JESD_L=8 TX_JESD_M=4 TX_JESD_S=1 TX_JESD_NP=16

**Example 2**

Running the command below will create a folder named **LVDSCMOSN1**.

.. code-block:: bash

   make LVDS_CMOS_N=1

Enabling Out-of-Context synthesis
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can opt in for out-of-context synthesis during the build by defining
the ``ADI_USE_OOC_SYNTHESIS`` system variable. By setting the
``ADI_MAX_OOC_JOBS`` system variable you can adjust the number of
maximum parallel out-of-context synthesis jobs. If not set, the default
parallel job number is set to 4.

.. shell:: bash

   ~/hdl
   $export ADI_USE_OOC_SYNTHESIS=y
   $export ADI_MAX_OOC_JOBS=8
   $cd projects/daq2/zc706
   $make

This will synthesize each IP from the block design individually and will
store it in a common cache for future re-use. The cache is located in
the **ipcache** folder and is common for all the projects; this way
speeding up re-compile of the same project or compile time of common
blocks used in base designs.

Example: a MicroBlaze base design for VCU118 once compiled, it will be reused
on other projects. Using the IP cache will speed up the re-compiles of every
project in OOC mode since the cache is not cleared as with normal compile flow.

.. caution::

   Starting with Vivado 2020.2, Out-of-Context is the
   default mode. There is no need to set ADI_USE_OOC_SYNTHESIS variable.

   Set:

   .. shell:: bash

      ~/hdl
      $export ADI_USE_OOC_SYNTHESIS=n

   only in case you want to use Project Mode.

Checking the build and analyzing results of library components
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you look closely, you see what it is actually doing. It enters a
library component folder then calls **Vivado** in batch mode. The IP
commands are in the source Tcl file and output is redirected to a log
file. In the below example that is **axi_ad7768_ip.log** inside the
**library/axi_ad7768** directory.

.. shell:: bash

   ~/hdl
   $make -C library/axi_ad7768
    make[1]: Entering directory '/path/to/hdl/library/axi_ad7768'
    rm -rf *.cache *.data *.xpr *.log component.xml *.jou xgui *.ip_user_files *.srcs *.hw *.sim .Xil
    vivado -mode batch -source axi_ad7768_ip.tcl  >> axi_ad7768_ip.log 2>&1

If the ``make`` command returns an error (and stops), **you must first check
the contents of the log file**.
You may also check the generated files for more information.

.. shell:: bash

   ~/hdl
   $ls -ltr library/axi_ad7768
   $tail library/axi_ad7768/axi_ad7768_ip.log

Checking the build and analyzing results of projects
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The last thing that ``make`` does in this above example is building the project.
It is exactly the same **rule** as the library component. The log file, in
this example, is called **daq2_zc706_vivado.log** and is inside the
**projects/daq2/zc706** directory.

.. shell:: bash

   ~/hdl/projects/daq2/zc706
   $make
    [ -- snip --]
    rm -rf *.cache *.data *.xpr *.log *.jou xgui *.runs *.srcs *.sdk *.hw *.sim .Xil *.ip_user_files
    vivado -mode batch -source system_project.tcl >> daq2_zc706_vivado.log 2>&1
    make: Leaving directory '/path/to/hdl/projects/daq2/zc706'

Do a quick (or detailed) check on files.

.. shell:: bash

   ~/hdl
   $ls -ltr projects/daq2/zc706
   $tail projects/daq2/zc706/daq2_zc706_vivado.log

.. caution::

   Do NOT copy-paste ``make`` command line text when asking us questions.

And finally, if the project build is successful, the **system_top.xsa** file
should be in the **.sdk** folder.

.. shell:: bash

   ~/hdl
   $ls -ltr projects/daq2/zc706/daq2_zc706.sdk

You may now use this **system_top.xsa** file as the input to your no-OS and/or Linux
build.

Starting with Vivado 2019.3, the output file extension was changed from
**.hdf** to **.xsa**.

.. collapsible:: Building an AMD project in WSL - known issues

   For some projects it is possible to face the following error when you make a
   build:

   .. warning::

      ``$RDI_PROG" "$@" crash" "Killed "$RDI_PROG" "$@"``

      This error may appear because your device does not have enough
      RAM memory to build your FPGA design.

   For example, the project AD-FMCDAQ3-EBZ with Virtex UltraScale+ VCU118
   (XCVU9P device) requires 20GB (typical memory) and a peak of 32GB RAM
   memory. The following link shows the typical and peak Vivado memory usage
   per target device:
   :xilinx:`MemoryUsage <products/design-tools/vivado/vivado-ml.html#memory>`.

   This problem can be solved if a linux Swap file is created. You can
   find more information about what a swap file is at this link:
   `SwapFile <https://linuxize.com/post/create-a-linux-swap-file/>`__

   To create a swap file you can use the following commands:

   .. shell:: bash

      $sudo fallocate -l "memory size (e.g 1G, 2G, 8G, etc.)" /swapfile
      $sudo chmod 600 /swapfile
      $sudo mkswap /swapfile
      $sudo swapon /swapfile

   If you want to make the change permanent, add this line to */etc/fstab*:

   .. shell:: bash

      $/swapfile swap swap defaults 0 0

   If you want to deactivate the swap memory:

   .. shell:: bash

      $sudo swapoff -v /swapfile

.. collapsible:: Building manually in Vivado GUI

   .. warning::

      We do not recommend using this flow, in general people are losing a lot
      of valuable time and nerve during this process.

   In Vivado (AMD projects), **you must build all the required libraries**
   for your targeted project. Open the GUI and at the TCL console change
   the directory to where the libraries are, then source the **\_ip.tcl**
   file.

   .. code-block:: tcl

      cd c:/github/hdl/library/axi_ltc2387
      source ./axi_ltc2387_ip.tcl

   You will see commands being executed, and the GUI will change into a
   project window. There is nothing to do here, you could browse the source
   if you prefer to do synthesis as stand-alone and such things. After
   you're done, quit and change the directory to the next library and
   continue the process.

   After you built all the required libraries for your project, you can run
   the project (generate bitstream and export the design to SDK). This is
   the same procedure as above except for changes in path and Tcl file
   names:

   .. code-block:: tcl

      cd c:/github/hdl/projects/cn0577/zed
      source ./system_project.tcl

   Same behavior as above, the GUI will change into a project window. The
   script will create a board design in IPI (IP Integrator), generate all the
   IP targets, synthesize the netlist and implementation.

4b. Building an Intel project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An Intel project build is relatively easy. There is no need to build any
library components.

You just need to go to the hdl/projects folder, choose the ADI part that you
want to use, then enter the folder of the FPGA carrier that you want, and run
``make`` to build the project.

A generic path where you want to build the project would look like:
``hdl/projects/$ADI_part/$FPGA_carrier``.

**EXAMPLE**: Here we are building the **ADRV9371X** project on the
**Arria 10 SoC** carrier.

.. shell:: bash

   ~/hdl
   $cd projects/adrv9371x/a10soc
   $make

This assumes that you have the tools and licenses set up correctly. If
you don't get to the last line, the make failed to build the project.
There is nothing you can gather from the ``make`` output (other than the
build failed or not), the actual failure is in a log file. So, let's see
how to analyze the build log files and results.

.. note::

   If you want to use a NIOS-II based project with no-OS
   software, you have to turn off the MMU feature of the NIOS_II processor.
   In that case, the make will get an additional attribute:
   ``make NIOS2_MMU=0``

Checking the build and analyzing results
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you look closely at the **rule** for this target, you see it is just
calling ``quartus_sh`` with the project TCL file and redirecting the
output to a log file.

**EXAMPLE**: In this case it is called **adrv9371_a10soc_quartus.log**
and is inside the **projects/adrv9371x/a10soc** directory.

Do a quick (or detailed) check on files. If you are seeking support from us,
this contains the most relevant information that you need to provide.

.. warning::

   Do NOT copy-paste ``make`` command line text

.. shell:: bash

   ~/hdl
   $ls -ltr projects/adrv9371x/a10soc
   $tail projects/adrv9371x/a10soc/adrv9371x_a10soc_quartus.log

And finally, if the project was built is successfully, the **.sopcinfo** and
**.sof** files should be in the same folder.

.. shell:: bash

   ~/hdl
   $ls -ltr projects/adrv9371x/a10soc/*.sopcinfo
   $ls -ltr projects/adrv9371x/a10soc/*.sof

You may now use this **sopcinfo** file as the input to your :git-no-os:`no-OS <>`
and/or :git-linux:`Linux <>` build.

The **sof** file is used to program the device.

.. collapsible:: Building an Intel project in WSL - known issues

   For a10Soc and s10Soc projects it's very possible to face the following
   error when you try to build the project:

   .. warning::

      Current module quartus_fit was
      unexpectedly terminated by signal 9. This may be because some system
      resource has been exhausted, or quartus_fit performed an illegal
      operation.

   It can also happen that ``make`` gets stuck when
   synthesizing some IPs. These errors may appear because your device does
   not have enough RAM memory to build your FPGA design. This problem can
   be solved if you create a Linux Swap file.

   You can find more information about what a swap file is at this link:
   `SwapFile <https://linuxize.com/post/create-a-linux-swap-file/>`__.

   Depending on the size of the project, more or less virtual memory must
   be allocated. If you type in the search bar **System Information**, you
   can see Total Physical Memory and Total Virtual Memory of your system.
   For example, for the AD9213 with S10SoC project, it was necessary to
   allocate 15 GB of virtual memory, to be able to make a build for the
   project. To create a swap file you can use the following commands:

   .. shell:: bash

      $sudo fallocate -l "memory size (e.g 1G, 2G, 8G, etc.)" /swapfile
      $sudo chmod 600 /swapfile
      $sudo mkswap /swapfile
      $sudo swapon /swapfile

   If you want to make the change permanent, add this line to */etc/fstab*:

   .. shell:: bash

      $/swapfile swap swap defaults 0 0

   If you want to deactivate the swap memory:

   .. shell:: bash

      $sudo swapoff -v /swapfile

.. collapsible:: Building manually in Quartus GUI

   .. warning::

      We do not recommend using this flow, in general people are losing a lot
      of valuable time and nerve during this process.

   There is no need to build any library for Quartus. However, you do need
   to specify the IP search path for QSYS. This is a global property, so
   only need to do it once. If you have multiple paths simply add to it.
   You get to this menu from the **Tools->Options**. The tool then parses
   these directories and picks up a **\_hw.tcl** file (e.g.
   **axi_ad9250_hw.tcl**). The peripherals should show up on QSYS library.

   You may now run the project (generate the sof and software hand-off
   files) on Quartus. Open the GUI and select TCL console. At the prompt
   change the directory to where the project is, and source the
   **system_project.tcl** file.

   .. code-block:: tcl

      cd c:/github/hdl/projects/daq2/a10soc
      source ./system_project.tcl

   You will see commands being executed, the script uses a board design in
   QSYS, generate all the IP targets, synthesize the netlist and
   implementation.

4c. Building a Lattice project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. warning::

   Instantiating IPs in Propel Builder CLI or GUI does not work in WSL for an
   unknown compatibility reason. You can use Cygwin on Windows or a normal
   Linux installation.

The Lattice build is in a very early version. It does not support any ADI
library builds, yet. We're just starting to develop the library build part.
Currently, we only have a single early-version base design that builds almost
like the other ones. For Lattice, there are separate tools for creating
a block design **(Propel Builder)** and building an HDL design **(Radiant)**.

The build for any supported project works with ``make``, same as the others.
First, you have to open the **Propel Builder GUI** and download the necessary
Lattice-provided IPs manually. You can check the **necessary Lattice IPs** and
and their versions in the
**<project_name>_system_pb.tcl** script or follow the error messages in the
**<project_name>_propel_builder.log** after running ``make`` and you get
a FAILED message.

Then, simply go to the carrier folder and run ``make``. For now, you can try
to build the only base design we have available for
**CertusPro-NX Evaluation Board** by entering the base design directory and
running ``make``.

Required Lattice Provided IPs to download for projects/common/lfcpnx
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

==================== ============================= =======
IP name              Display name                  Version
==================== ============================= =======
riscv_rtos           RISC-V RX                      2.3.0
gpio                 GPIO                           1.6.2
spi_controller       SPI Controller                 2.1.0
i2c_controller       I2C Controller                 2.0.1
axi_interconnect     AXI4 Interconnect              1.2.2
axi2ahb_bridge       AXI4 to AHB-Lite Bridge        1.1.1
axi2apb_bridge       AXI4 to APB Bridge             1.1.1
gp_timer             Timer-Counter                  1.3.1
==================== ============================= =======

.. shell:: bash

   ~/hdl
   $cd projects/common/lfcpnx
   $make

This, assuming that you have the tools and licenses set up correctly. If
you don't get to the last line, the make failed to build the project.
There is nothing you can gather from the ``make`` output (other than if the
build failed or not); the actual failure message is in a log file.

Checking the build and analyzing results
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The make script for Lattice projects is the **projects/scripts/project-lattice.mk**
that is included in **Makefile** after setting the project dependencies.
If you check this make script, you can note that we have two rules we run by the
**all:** rule: one that runs the **Propel Builder** targets (for the block
design) and one that runs the  **Radiant** targets (for HDL build).
For this reason, we have two log files as well, the first one
**$(PROJECT_NAME)_propel_builder.log**, and the second one is
**$(PROJECT_NAME)_radiant.log**.

If you are seeking support from us, do a quick (or detailed) check on files.
This contains the most relevant information that you need to provide.

.. warning::

   Do NOT copy-paste ``make`` command line text!

.. shell:: bash

   ~/hdl
   $ls -ltr <ADI_carrier_proj_dir>
   $ls -ltr <ADI_carrier_proj_dir>/_bld/<project_name>
   $ls -ltr <ADI_carrier_proj_dir>/_bld/<project_name>/<project_name>
   $tail <ADI_carrier_proj_dir>/_bld/<project_name>_propel_builder.log
   $tail <ADI_carrier_proj_dir>/_bld/<project_name>_radiant.log

Note that if the **Propel Builder** project fails to build, the
**$(PROJECT_NAME)_radiant.log** may not exist.

If the Propel Builder project was built successfully, the **sge**
folder should appear in the **<ADI_carrier_proj_dir>/** or in the
**<ADI_carrier_proj_dir>/_bld/<project_name>**.
The **sge** folder contains the **bsp** folder (Base Support
Package) and the SoC configuration files.

The **bsp** folder contains the
available Lattice-provided drivers for the IPs used in the design (sometimes
these drivers are more like some basic examples to modify for your specific
application) and the **sys_platform.h** file.

You should find a **sys_env.xml** file in the same **sge** folder. This file is
used to create a **no-OS** project with the current **bsp**.

When running the Propel Builder targets, we call ``propelbld system_project_pb.tcl``
on Windows or ``propelbldwrap system_project_pb.tcl`` on Linux.

After running the Propel Builder targets we call ``pnmainc system_project.tcl``
on Windows or ``radiantc system_project.tcl``
on Linux.

The **system_project_pb.tcl** runs first. This file is used to create the
**block design project** (Propel Builder) and source the **system_pb.tcl**
which is used for linking one or more corelated block design '.tcl' scripts.

The **system_pb.tcl** is sourced in **adi_project_pb** procedure.

The **system_project.tcl** runs second. This file is used to create and build
the **HDL project** (Radiant). Here we use the output of the Propel Builder
project as the **configured IPs** that can be found in the
*<ADI_carrier_proj_dir>/_bld/<project_name>/<project_name>/lib* folder and the
**default block design wrapper** that is the
*<ADI_carrier_proj_dir>/_bld/<project_name>/<project_name>/<project_name>.v*.

We add them to the Radiant project, then add our **system_top.v** wrapper,
the **constraint files** and build the project.

The output is a **.bit** file that by default will appear in the
**<ADI_carrier_proj_dir>/_bld/<project_name>/impl_1** folder if the project was
successfully built.

Supported targets of ``make`` command
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. note::

   `Make <https://www.gnu.org/software/make/manual/make.html>`__ is a build
   automation tool, which uses **Makefile(s)** to define a set of
   directives ('rules') about how to compile and/or link a program
   ('targets').

In general, always run ``make`` within a project folder such as
**hdl/projects/daq2/a10soc** or **hdl/projects/daq2/zc706**. There should
not be a need for you to run ``make`` inside the library or root folders.
The ``make`` framework passes the top level 'targets' to any sub-makes
inside its sub-folders. What this means, is that if you run ``make`` inside
**hdl/projects/daq2**, it builds all the carriers (**kc705**, **a10soc**,
**kcu105**, **zc706** to **zcu102**) instead of just the target carrier.

The following targets/arguments are supported:

* ``all``:
  This builds everything in the current folder and its sub-folders, for example:

  * ``make -C library/axi_ad9122 all; # build AD9122 library component (AMD only).``
  * ``make -C library all; # build ALL library components inside 'library' (AMD only).``
  * ``make -C projects/daq2/zc706 all; # build DAQ2_ZC706 (AMD) project.``
  * ``make -C projects/daq2/a10soc all; # build DAQ2_A10SOC (Intel) project.``
  * ``make -C projects/daq2 all; # build DAQ2 ALL carrier (Intel & AMD) projects.``
  * ``make -C projects all; # build ALL projects (not recommended).``

* ``clean``:
  Removes all tool and temporary files in the current folder and its
  sub-folders, same context as above.
* ``clean-all``:
  This removes all tool and temporary files in the current folder, its
  sub-folders and from all the IPs that are specified in the Makefile file;
  same context as above.
* ``lib``: This is same as ``all`` in the library folder, ignored inside project
  folders.
* ``projects.platform``: This is a special target available only in the 'hdl' root
  folder and is ignored everywhere else, see syntax:

  * ``make daq2.a10soc ; # build projects/daq2/a10soc.``
  * ``make daq2.zc706 ; # build projects/daq2/zc706.``

To speed up the building process, especially libraries, you can use the ``-j``
option to run the targets in parallel, e.g. ``make -j4``.

All artifacts generated by the build process should be "git"-ignored,
e.g. ``component.xml`` and ``.lock`` files.

.. _build_hdl boot-file:

5. Preparing the SD card
-------------------------------------------------------------------------------

First, you have to write the SD card with the
:external+documentation:doc:`ADI Kuiper image <linux/kuiper/index>`.
Check this
:external+documentation:ref:`tutorial <kuiper sdcard>`.

Once you are done with that, you can go on with the following steps.

For AMD FPGAs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

On the BOOT partition recently created, you will find folders for each
carrier that we support, and each of these folders contain an archive
called **bootgen_sysfiles.tgz**. These have all the files needed to
generate the **BOOT.BIN**.

Copy the corresponding archive (checking for the name of your carrier
and components) into the root folder of your project, unzip it twice,
and there you will find the files that are needed to generate the
**BOOT.BIN**. Copy them to be in the root directory.

#. fsbl.elf
#. zynq.bif
#. u-boot.elf
#. and if you're using ZCU102, then bl31.elf and pmu.elf

Next, what your project needs, is the:

- *uImage* (for Zynq-based carriers), found in *zynq-common* folder
- or *Image* (for Zynq UltraScale - ZCU102 and ADRV9009-ZU11EG carriers)
  found in *zynqmp-common*
- or *Image* (for Versal carriers), found in *versal-common* folder

on your BOOT partition. Copy this file also in the root directory of your project.

More info on how to generate this file you will find in the
`References`_ section or in the **README.txt** file from BOOT partition.

.. note::

   For building the BOOT.BIN, check out this page: :ref:`build_boot_bin`

5b. For Intel FPGAs
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Check out :dokuwiki:`this guide <resources/tools-software/linux-software/altera_soc_images>`.

Tools and their versions
-------------------------------------------------------------------------------

Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ADI provides reference designs for Intel, AMD and soon Lattice.

Please note that this is NOT a comparison (generic or otherwise).
This is what you should expect and understand when using ADI HDL repository
on these tools.

**A red text indicates that you must pay extra attention.**

.. collapsible:: Click here to see the tools from Intel, AMD and Lattice

   .. list-table:: Tools from Intel and AMD
      :widths: auto
      :header-rows: 1

      * - Notes
        - Intel
        - AMD
      * - Main tools
        - Quartus
        - Vivado
      * - EDK tools
        - QSys
        - IP Integrator
      * - SDK tools
        - Eclipse-Nios, Eclipse-DS5
        - Eclipse
      * - Building library
        - :green:`Do nothing. Quartus only needs the _hw.tcl and QSys parses them
          whenever invoked`
        - :red:`Need to build each and every library component. Vivado has its
          own way of identifying library components. This means you must build
          ALL the library components first before starting the project. You must
          re-run these scripts if there are any modifications`
      * - Building the project
        - Source the system_project.tcl file
        - Source the system_project.tcl file
      * - Timing analysis
        - The projects are usually tested and should be free of timing errors.
          There is no straightforward method to verify a timing pass (it usually
          involves writing a TCL proc by itself) on both the tools. The make
          build will fail and return with an error if the timing is not met.
        - The projects are usually tested and should be free of timing errors.
          There is no straightforward method to verify a timing pass (it usually
          involves writing a TCL proc by itself) on both the tools. The make
          build will fail and return with an error if the timing is not met.
      * - SDK (Microblaze/Nios)
        - Use SOPCINFO and SOF files
        - Use XSA file
      * - SDK (ARM/FPGA combo)
        - :red:`Not so well-thought procedure. Need to run different tools,
          manually edit build files etc. The steps involved are running
          bsp-editor, running make, modifying linker scripts, makefiles and
          sources, importing to SDK`
        - :green:`Same procedure as Microblaze`
      * - Upgrading/Version changes (non-ADI cores)
        - :green:`Quartus automatically updates the cores. Almost hassle-free for
          most of the cores`
        - :red:`Vivado does not automatically update the revisions in TCL flow
          (it does on GUI). It will stop at the first version mismatch (a rather
          slow and frustrating process)`

   .. list-table:: Tools from Lattice
      :widths: auto
      :header-rows: 1

      * - Notes
        - Lattice
      * - Main tools
        - Radiant
      * - EDK tools
        - Propel Builder
      * - SDK tools
        - Propel (Eclipse)
      * - Building library
        - :red:`Not supported yet.`
      * - Building the project
        - Source the system_project_pb.tcl file in Propel Builder tclsh, source the
          system_project.tcl file in Radiant tclsh after.
      * - Timing analysis
        - The projects are usually tested and should be free of timing errors.
          There is no straightforward method to verify a timing pass (it usually
          involves writing a TCL proc by itself) on both the tools. The make
          build will fail and return with an error if the timing is not met.
      * - SDK (Lattice riscv-rx)
        - Use the generated sge folder that contains the bsp and the SoC
          configuration files. You can create a Propel SDK project using the
          sys_env.xml file (currently only no-OS and rtos, but not linked yet to
          ADI no-OS infrastructure)
      * - SDK (ARM/FPGA combo)
        - :red:`Not supported or nonexistent yet.`
      * - Upgrading/Version changes (non-ADI cores)
        - :red:`You have to update the IP versions manually in GUI and copy the config
          from the tcl console to the '.tcl' block design file, or update directly
          in the '.tcl' block design file. Note that first you have to download the
          new version of IPs using the GUI. An ip_upgrade tcl command exists, but
          still the IPs have to be downloaded manually, and it only works if the old
          IP's name is the same as the new (sometimes it changes by version).`

.. _build_hdl tool-versions:

Tool versions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Though the ADI libraries work across different versions of the tools,
the projects we provide **may not**. The AMD, Intel and Lattice IPs may or may
not work across versions. We can only assure you that they are tested and
**work only for the versions we specify**.

The projects are usually upgraded to the latest tools after they are
publicly released. The used tool versions can be found in the
`release notes <https://github.com/analogdevicesinc/hdl/releases>`__
for each branch. The script, which builds the project always double
checks the used tools version, and notifies the user if he or she is trying
to use an unsupported version of tools.

.. note::

   There are several ways to find out which tool version you should use.
   The easiest way is to check the `release
   notes <https://github.com/analogdevicesinc/hdl/releases>`__. You may
   also check out or browse the desired branch, and verify the tool version
   in the base Tcl script or in hdl/scripts/adi_env.tcl
   (:git-hdl:`for Vivado version <scripts/adi_env.tcl#L18>`
   :git-hdl:`or for Quartus version <scripts/adi_env.tcl#L34>`),
   which builds the projects.

References
-------------------------------------------------------------------------------

- :dokuwiki:`Altera SoC quick start guide <resources/tools-software/linux-software/altera_soc_images>`
- :dokuwiki:`Arria 10 SoC quick start guide <resources/eval/user-guides/ad-fmcomms8-ebz/quickstart/a10soc>`
- :dokuwiki:`Building the ADI Linux
  kernel <resources/tools-software/linux-drivers-all>`

Errors, warnings and notes
-------------------------------------------------------------------------------

Assuming the right to make an honest comment, the tools (both Quartus
and Vivado) are not that useful or friendly when it comes to messages.
In most cases, you may see **hacked-in** debugging ``printf`` sort of
messages (AMD notoriously ranks high in this regard). So you are
going to see a lot of **warnings** and some **critical-warnings** (critical
to what could be hard to answer). Here are some of the commonly asked
EngineerZone questions and their explanations.

AMD Xilinx Vivado
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

   ERROR: [BD 5-216] VLNV <analog.com:user:axi_clkgen:1.0> is not supported for the current part.

   ERROR: [Common 17-39] 'create_bd_cell' failed due to earlier errors while executing
   "create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen" invoked from within
   "set axi_hdmi_clkgen [create_bd_cell -type ip -vlnv analog.com:user:axi_clkgen:1.0 axi_hdmi_clkgen]" (file "../../../projects/common/zc706/zc706_system_bd.tcl" line 57)

You haven't generated the library component or have the wrong user IP
repository setting. If you were using the GUI flow, now is a good time
to evaluate the ``make`` flow.

.. code-block::

   CRITICAL WARNING: [IP_Flow 19-459] IP file 'C:/Git/hdl/library/common/ad_pnmon.v' appears to be outside of the
   project area 'C:/Git/hdl/library/axi_ad9467'. You can use the
   ipx::package_project -import_files option to copy remote files into the IP directory.

These warnings appear because the libraries are using common modules
which are located under the **./library/common/**. These warnings can be
ignored, they won't affect the functionality of the IP or the project.
However, you may not be able to archive these projects. The irony is
that it does copy these files to the project area, but ignores them.

.. _AMD Xilinx Vivado: https://www.xilinx.com/support/download.html

.. _Intel Quartus Prime Pro and Standard: https://www.intel.com/content/www/us/en/products/details/fpga/development-tools/quartus-prime/resource.html

.. _Lattice Propel: https://www.latticesemi.com/Products/DesignSoftwareAndIP/FPGAandLDS/LatticePropel

.. _Lattice Radiant: https://www.latticesemi.com/Products/DesignSoftwareAndIP/FPGAandLDS/Radiant
