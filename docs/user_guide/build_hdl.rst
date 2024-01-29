.. _build_hdl:

Build an HDL project
===============================================================================

**Please note that ADI only provides the source files necessary to create
and build the designs. This means that you are responsible for modifying
and building these projects.**

Here, we are giving you a quick rundown on how we build things. That said,
the steps below are **not a recommendation**, but a suggestion.
How you want to build these projects is entirely up to you.
The only catch is that if you run into problems, you have to resolve them independently.

The build process depends on certain software and tools, which you could use in many ways.
We use **command line** and mostly **Linux systems**. On Windows, we use **Cygwin**.

Setup and check your environment
-------------------------------------------------------------------------------

This section contains a guide about how to setup your environment to build any
HDL project from the repository:

#. Install the required FPGA design suite. We use `AMD Xilinx Vivado`_ and
   `Intel Quartus Prime Pro and Standard`_.
   You can find information about the proper version in our
   `release notes <https://github.com/analogdevicesinc/hdl/releases>`__.
   Make sure that you're always using the latest release.
#. The proper Vivado/Quartus version can be found in:

   -  Starting with ``hdl_2021_r1`` release branch:
      :git-hdl:`scripts/adi_env.tcl`
   -  For ``hdl_2019_r2`` and older:
      :git-hdl:`hdl/projects/scripts/adi_project_xilinx.tcl <hdl_2019_r2:projects/scripts/adi_project_xilinx.tcl>` for Vivado, and
      :git-hdl:`hdl/projects/scripts/adi_project_intel.tcl <hdl_2019_r2:projects/scripts/adi_project_intel.tcl>` for Quartus.

#. Download the tools from the following links:

   -  `AMD tools <https://www.xilinx.com/support/download.html>`__ (make sure you're
      downloading the proper installer. For full installation, it is
      better to choose the one that downloads and installs both Vivado
      and Vitis at the same time)
   -  `Intel
      tools <https://www.intel.com/content/www/us/en/programmable/downloads/download-center.html>`__

#. After you have installed the above-mentioned tools, you will need the
   paths to those directories in the following steps, so have them in a
   note.
#. We are using `git <https://git-scm.com/>`__ for version control and
   `GNU Make <https://www.gnu.org/software/make/>`__ to build the
   projects. Depending on what OS you're using, you have these options:

.. collapsible::  For Windows environment with Cygwin

   Because GNU Make is not supported on Windows, you need to install
   `Cygwin <https://www.cygwin.com/>`__, which is a UNIX-like environment
   and command-line interface for Microsoft Windows. You do not need to
   install any special package, other than ``git`` and ``make``.

   After you have installed Cygwin, you need to add your FPGA Design Tools
   installation directory to your PATH environment variable. You can do
   that by modifying your **.bashrc** file, by adding the following lines
   (**changed accordingly to your installation directories**). For example:

   .. code-block:: bash
      :linenos:

      export PATH=$PATH:/cygdrive/path_to/Xilinx/Vivado/202x.x/bin
      export PATH=$PATH:/cygdrive/path_to/Xilinx/Vivado_HLS/202x.x/bin
      export PATH=$PATH:/cygdrive/path_to/Xilinx/Vitis/202x.x/bin
      export PATH=$PATH:/cygdrive/path_to/Xilinx/Vitis/202x.x/gnu/microblaze/nt/bin
      export PATH=$PATH:/cygdrive/path_to/Xilinx/Vitis/202x.x/gnu/arm/nt/bin
      export PATH=$PATH:/cygdrive/path_to/Xilinx/Vitis/202x.x/gnu/microblaze/linux_toolchain/nt64_be/bin
      export PATH=$PATH:/cygdrive/path_to/Xilinx/Vitis/202x.x/gnu/microblaze/linux_toolchain/nt64_le/bin
      export PATH=$PATH:/cygdrive/path_to/Xilinx/Vitis/202x.x/gnu/aarch32/nt/gcc-arm-none-eabi/bin
      export PATH=$PATH:/cygdrive/path_to/intelFPGA_pro/2x.x/quartus/bin

   Replace the **path_to** string with your path to the installation folder
   and the **tools version** with the proper one.


.. collapsible::  How to verify your environment setup

   Run any of the following commands. These commands will return a valid path
   if your setup is good.

   .. code-block:: bash

      [~] which git
      [~] which make
      [~] which vivado
      [~] which quartus

Setup the HDL repository
-------------------------------------------------------------------------------
These designs are built upon ADI's generic HDL reference designs framework.
ADI does not distribute the bit/elf files of these projects so they
must be built from the sources available :git-hdl:`here </>`. To get
the source you must
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the repository. This is the best method to get the sources. Here, we are
cloning the repository inside a directory called **adi**. Please refer
to the :ref:`git_repository` section for more details.

.. code-block:: bash

   [~] mkdir adi
   [~] cd adi
   [~] git clone git@github.com:analogdevicesinc/hdl.git

.. warning::

   Cloning the HDL repository is done now using SSH, because of
   GitHub security reasons. Check out this documentation on `how to deal
   with SSH keys in
   GitHub <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent>`__.
   Both for `Cygwin <https://www.cygwin.com/>`__ and
   `WSL <https://learn.microsoft.com/en-us/windows/wsl/install/>`__ it is
   necessary to create a unique SSH key. If you use WSL,to get the best
   performance, you must clone your hdl repository in the WSL file system.
   For example: (:code:`\\\\wsl.localhost\\Ubuntu\\home\\username\\hdl`)

The above command clones the **default** branch, which is the **main** for
HDL. The **main** branch always points to the latest stable release
branch, but it also has features **that are not fully tested**. If you
want to switch to any other branch you need to checkout that branch:

.. code-block:: bash

   [~] cd hdl/
   [~] git status
   [~] git checkout hdl_2021_r2

If this is your first time cloning, you have all the latest source
files. If not, you can simply pull the latest sources
using ``git pull`` or ``git rebase`` if you have local changes.

.. code-block:: bash

   [~] git fetch origin               # this shows you what changes will be pulled on your local copy
   [~] git rebase origin/hdl_2021_r2  # this updates your local copy

Building the projects
-------------------------------------------------------------------------------

.. caution::

   Before building any project, you must have the environment prepared and the
   proper tools. See `Tools`_ section on what you need to download and
   `Environment`_ section on how to set-up your environment.

Building an Intel project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An Intel project build is relatively easy. There is no need to build any
library components. Go to the directory of the project of interest,
then inside the desired carrier run ``make`` to build
the project. In this example, I am only interested in the
**ADRV9371X** project on the **A10SOC** carrier.

.. code-block:: bash

   cd projects/adrv9371x/a10soc
   make

This assumes that you have the tools and licenses setup correctly. If
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
output to a log file. In this case it is called **adrv9371_a10soc_quartus.log**
and is inside the **projects/adrv9371x/a10soc** directory.

Do a quick (or detailed) check on files. If you are seeking support from us,
this contains the most relevant information that you need to provide.

.. warning::

   Do NOT copy-paste ``make`` command line text

.. code-block:: bash

   ls -ltr projects/adrv9371x/a10soc
   tail projects/adrv9371x/a10soc/adrv9371x_a10soc_quartus.log

And finally, if the project was built is successfully, the **.sopcinfo** and
**.sof** files should be in the same folder.

.. code-block:: bash

   ls -ltr projects/adrv9371x/a10soc/*.sopcinfo
   ls -ltr projects/adrv9371x/a10soc/*.sof

You may now use this **sopcinfo** file as the input to your no-OS and/or
Linux build. The **sof** file is used to program the device.

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

   .. code-block:: bash

      :~$ sudo fallocate -l "memory size (e.g 1G, 2G, 8G, etc.)" /swapfile
      :~$ sudo chmod 600 /swapfile
      :~$ sudo mkswap /swapfile
      :~$ sudo swapon /swapfile

   If you want to make the change permanent:

   .. code-block:: bash

      # in /etc/fstab file type the command:
      /swapfile swap swap defaults 0 0

   If you want to deactivate the swap memory:

   .. code-block:: bash

      :~$ sudo swapoff -v /swapfile

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

   .. code-block:: bash

      cd c:/github/hdl/projects/daq2/a10soc
      source ./system_project.tcl

   You will see commands being executed, the script uses a board design in
   QSYS, generate all the IP targets, synthesize the netlist and
   implementation.

Building an AMD project
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An AMD project is built the same way as an Intel project. The only
exception is that there are a few 'sub-make(s)' for the library
components. The way of building a project in Cygwin and WSL is almost the same.
In this example, it is building the **DAQ2**
project on the **ZC706** carrier.

.. code-block:: bash

   cd projects/daq2/zc706
   make

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

.. code-block:: bash

   export ADI_USE_OOC_SYNTHESIS=y
   export ADI_MAX_OOC_JOBS=8
   cd projects/daq2/zc706
   make

This will synthesize each IP from the block design individually and will
store it in a common cache for future re-use. The cache is located in
the **ipcache** folder and is common for all the projects, this way
speeding up re-compile of the same project or compile time of common
blocks used in base designs. Example: a MicroBlaze base design for
VCU118 once compiled, it will be reused on other projects. Using the IP
cache will speed up the re-compiles of every project in OOC mode since
the cache is not cleared as with normal compile flow.

.. caution::

   Starting with Vivado 2020.2, Out-of-Context is the
   default mode. There is no need to set ADI_USE_OOC_SYNTHESIS variable.

   Set:

   .. code-block:: bash

      export ADI_USE_OOC_SYNTHESIS=n

   only in case you want to use Project Mode.

Checking the build and analyzing results of library components
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If you look closely, you see what it is actually doing. It enters a
library component folder then calls **Vivado** in batch mode. The IP
commands are in the source Tcl file and output is redirected to a log
file. In the below example that is **axi_ad7768_ip.log** inside the
**library/axi_ad7768** directory.

.. code-block:: bash

   make[1]: Entering directory '/home/RKutty/gitadi/hdl/library/axi_ad7768'
   rm -rf *.cache *.data *.xpr *.log component.xml *.jou xgui *.ip_user_files *.srcs *.hw *.sim .Xil
   vivado -mode batch -source axi_ad7768_ip.tcl  >> axi_ad7768_ip.log 2>&1

If the ``make`` command returns an error (and stops), **you must first check
the contents of the log file**. You may also check the generated files for more information.

.. code-block:: bash

   ls -ltr library/axi_ad7768
   tail library/axi_ad7768/axi_ad7768_ip.log

Checking the build and analyzing results of projects
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The last thing that ``make`` does in this above example is building the project.
It is exactly the same **rule** as the library component. The log file, in
this example, is called **daq2_zc706_vivado.log** and is inside the
**projects/daq2/zc706** directory.

.. code-block:: bash

   rm -rf *.cache *.data *.xpr *.log *.jou xgui *.runs *.srcs *.sdk *.hw *.sim .Xil *.ip_user_files
   vivado -mode batch -source system_project.tcl >> daq2_zc706_vivado.log 2>&1
   make: Leaving directory '/home/RKutty/gitadi/hdl/projects/daq2/zc706'

Do a quick (or detailed) check on files.

.. warning::

   Do NOT copy-paste ``make`` command line text

.. code-block:: bash

   ls -ltr projects/daq2/zc706
   tail projects/daq2/zc706/daq2_zc706_vivado.log

And finally, if the project build is successful, the **.xsa** file should be
in the **.sdk** folder.

.. code-block:: bash

   ls -ltr projects/daq2/zc706/daq2_zc706.sdk

You may now use this **.xsa** file as the input to your no-OS and/or Linux
build.

Starting with Vivado 2019.3, the output file extension was changed from
**.hdf** to **.xsa**.

.. collapsible:: Building an AMD project in WSL - known issues

   For some projects it is very possible to face the following error when you make a
   build:

   .. warning::

      ``$RDI_PROG" "$@" crash" "Killed "$RDI_PROG" "$@"``

      This error may appear because your device does not have enough
      RAM memory to build your FPGA design.

   For example, the project AD-FMCDAQ3-EBZ with Virtex UltraScale+ VCU118
   (XCVU9P device) requires 20GB (typical memory) and a peak of 32GB RAM
   memory. The following link shows the typical and peak Vivado memory usage
   per target device: `MemoryUsage
   <https://www.xilinx.com/products/design-tools/vivado/vivado-ml.html#memory>`__.

   This problem can be solved if a linux Swap file is created. You can
   find more information about what a swap file is at this link:
   `SwapFile <https://linuxize.com/post/create-a-linux-swap-file/>`__

   To create a swap file you can use the following commands:

   .. code-block:: bash

      :~$ sudo fallocate -l "memory size (e.g 1G, 2G, 8G, etc.)" /swapfile
      :~$ sudo chmod 600 /swapfile
      :~$ sudo mkswap /swapfile
      :~$ sudo swapon /swapfile

   If you want to make the change permanent:

   .. code-block:: bash

      # in /etc/fstab file type the command:
      /swapfile swap swap defaults 0 0

   If you want to deactivate the swap memory:

   .. code-block:: bash

      :~$ sudo swapoff -v /swapfile

.. collapsible:: Building manually in Vivado GUI

   .. warning::

      We do not recommend using this flow, in general people are losing a lot
      of valuable time and nerve during this process.

   In Vivado (AMD projects), **you must build all the required libraries**
   for your targeted project. Open the GUI and at the TCL console change
   the directory to where the libraries are, then source the **\_ip.tcl**
   file.

   .. code-block::

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

   .. code-block:: bash

      cd c:/github/hdl/projects/cn0577/zed
      source ./system_project.tcl

   Same behavior as above, the GUI will change into a project window. The
   script will create a board design in IPI (IP Integrator), generate all the
   IP targets, synthesize the netlist and implementation.

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
inside its sub-folders. What this means is that if you run ``make`` inside
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

Tools and their versions
-------------------------------------------------------------------------------

Tools
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ADI provides reference designs for both Intel and AMD. Please note
that we have no preference over Intel or AMD; if possible, we try to
port the designs on both platforms. However, there are a few things you
should be aware of when building the projects.

This is NOT a comparison (generic or otherwise)- this is what you should
expect and understand when using ADI HDL repository on these tools.
**A red text indicates that you must pay extra attention.**

.. list-table:: Tools
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


Tool versions
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Though the ADI libraries work across different versions of the tools,
the projects we provide **may not**. The AMD and Intel IPs may or may not
work across versions. We can only assure you that they are tested and
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
   in the base Tcl script ./hdl/scripts/adi_env.tcl
   (:git-hdl:`for Vivado version <scripts/adi_env.tcl#L18>`)
   or
   (:git-hdl:`or for Quartus version <scripts/adi_env.tcl#L34>`),
   which build the projects.

Environment
-------------------------------------------------------------------------------

As said above, our recommended build flow is to use ``make`` and the
command line version of the tools. This method facilitates our
overall build and release process as it automatically builds the
required libraries and dependencies.

Linux environment setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

All major distributions should have ``make`` installed by default. If not,
if you try the command, it should tell you how to install it with the
package name.

You may have to install ``git`` (``sudo apt-get install git``)
and the Intel and AMD tools. These tools come with certain
**settings*.sh** scripts that you may source in your **.bashrc** file to
set up the environment. You may also do this manually (for better or
worse); the following snippet is from a **.bashrc** file. Please note
that unless you are an expert at manipulating these things, it is best to leave it to
the tools to set up the environment.

.. code-block:: bash

   export PATH=$PATH:/opt/Xilinx/Vivado/202x.x/bin:/opt/Xilinx/Vitis/202x.x/bin
   export PATH=$PATH:/opt/intelFPGA_pro/2x.x/quartus/bin

Windows environment setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The best option on Windows is to use
`Cygwin <https://www.cygwin.com>`__. When installing it, select the
``make`` and ``git`` packages. The manual changes to your **.bashrc** do a lot
look like that of the Linux environment.

.. code-block:: bash

   export PATH=$PATH:/cygdrive/d/Xilinx/Vivado/202x.x/bin:/cygdrive/d/Xilinx/Vitis/202x.x/bin
   export PATH=$PATH:/cygdrive/d/intelFPGA_pro/2x.x/quartus/bin64

A very good alternative to Cygwin is
`WSL <https://learn.microsoft.com/en-us/windows/wsl/install/>`__. The
manual changes to your **.bashrc** should look like:

.. code-block:: bash

   export PATH=$PATH:/opt/path_to/Vivado/202x.x/bin:/opt/Vitis/202x.x/bin
   export PATH=$PATH:/opt/path_to/quartus/bin

If you do not want to install Cygwin, there might still be some
alternative. There are ``make`` alternatives for **Windows Command
Prompt**, minimalist GNU for Windows (**MinGW**), or the **Cygwin
variations** installed by the tools itself.

Some of these may not be fully functional with our scripts and/or projects.
If you are an Intel user, the **Nios II Command Shell** does support make.
If you are an AMD user, use the **gnuwin** installed as part of the SDK,
usually at ``C:\Xilinx\Vitis\202x.x\gnuwin\bin``.

Preparing the SD card
-------------------------------------------------------------------------------

Firstly, you have to check this
`tutorial <https://wiki.analog.com/resources/tools-software/linux-software/zynq_images/windows_hosts>`__
on how to put the Linux image on your SD card. Once you are done with
that, you can go on with the following steps.

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

Next, what your project needs, is the **uImage** (for Zynq based
carriers) or **Image** (for Zynq UltraScale - ZCU102 and ADRV9009-ZU11EG
carriers) or **zImage** (for Intel based carriers) file that you will find
in the **zynq-common** or **zynqmp-common**, **socfpga_arria10_common** or
**socfpga_cyclone5_common** on your **boot** partition. Copy this file also in
the root directory of your project.

More info on how to generate this file you will find in the
`References`_ section or in the **ReadMe.txt** file from **boot** partition.

.. collapsible:: How to build the boot image BOOT.BIN in WSL

   After obtaining **.xsa** file, you must be sure that you have done source for
   Vivado and Vitis. To create **boot.bin** is recommended to run
   ``build_boot_bin.sh`` in terminal.To do this, the file can be called in the
   following manner:

   .. code-block:: bash

        chmod +x build_boot_bin.sh
        usage: build_boot_bin.sh system_top.xsa u-boot.elf [output-archive]

   You can download the script by accessing the following link:
   `build_boot_bin.sh <https://wiki.analog.com/resources/tools-software/linux-software/build-the-zynq-boot-image>`__.

References
-------------------------------------------------------------------------------

-  `How to build the Zynq boot image
   BOOT.BIN <https://wiki.analog.com/resources/tools-software/linux-software/build-the-zynq-boot-image>`__
-  `How to build the ZynqMP boot image
   BOOT.BIN <https://wiki.analog.com/resources/tools-software/linux-software/build-the-zynqmp-boot-image>`__
-  `Building the ADI Linux
   kernel <https://wiki.analog.com/resources/tools-software/linux-drivers-all>`__

Errors, Warnings and Notes
-------------------------------------------------------------------------------

Assuming the right to make an honest comment, the tools (both Quartus
and Vivado) are not that useful or friendly when it comes to messages.
In most cases, you may see **hacked-in** debugging ``printf`` sort of
messages (AMD notoriously ranks high in this regard). So you are
going to see a lot of **warnings** and some **critical-warnings** (critical
to what could be hard to answer). Here are some of the commonly asked
EngineerZone questions and their explanations.

AMD: Vivado
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
