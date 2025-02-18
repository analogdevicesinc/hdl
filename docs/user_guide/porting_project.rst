.. _porting_project:

Porting ADI's HDL reference designs
===============================================================================

In general, a given reference design for an FMC board is deployed to just a few
carriers, although several :git-hdl:`FPGA boards <projects/common>`
are supported in ADI's HDL repository. The simple reason behind this practice is
that it would create a tremendous maintenance workload, that would require a lot
of human resources, and would increase the required time for testing.

The general rule of thumb is to support a given project with a fairly popular
carrier (e.g. :xilinx:`ZC706` or
:intel:`A10SoC <content/www/us/en/products/details/fpga/development-kits/arria/10-sx.html>`),
which is powerful enough to showcase the board
features and maximum performance.

All the HDL projects were designed to maximize source code reuse, minimize
maintainability and simplify portability. The result of these design goals is
that porting a given project to another carrier is fairly simple if the user
respects a couple of guidelines.

The main scope of this wiki page is to discuss these guidelines and provide
simple indications for users who wants to port a project to a non-supported
carrier.

Quick Compatibility Check
-------------------------------------------------------------------------------

.. note::

   All ADI's FPGA Mezzanine Cards (FMC) are designed to respect all the
   specifications and requirements defined in the ANSI/VITA 57.1/57.4 FPGA
   Mezzanine Card Standard (if not otherwise stated on board's wiki page).

   If the new FPGA carrier is fully compliant with this standard, there
   will be no obstacles preventing the user to port the project to the required
   carrier card.

There are three types of FMC connectors: LPC (Low Pin Count), HPC (High Pin
Count) and FMC+ (VITA 57.4).

In general, an FMC board is using the FMC connector type that has enough
pins for the required interfaces between the I/O devices and FPGA. A carrier
with an FMC HPC connector can host FMC boards with an LPC or HPC connector, but
a carrier with an FMC LPC can host a board just with an FMC LPC connector.

.. tip::

   First, always check out the already available
   :git-hdl:`base designs <projects/common>`.
   If your board is present among our supported base designs, you do not need
   to verify the following things and you can jump to the Project creation
   section.

The most important things to check before porting are related to the ANSI/VITA
57.1/57.4 standard (the list is not necessarily exhaustive):

- Power and ground lines - 3P3V/3P3VAUX/12P0V/GND
- VADJ - adjustable voltage level power from the carrier, each board has a
  specific requirement for VADJ
- Dedicated pins for clock signals - all the clock dedicated pins should be
  connected to a clock capable pin of the FPGA (I/O pin which is capable to
  receive and/or transmit a clock signal)
- Dedicated pins for transceiver lines (DPx_[M2C|C2M]_[P|N])

.. attention::

   To check all the requirements, please refer to the ANSI/VITA 57.1/57.4
   standard.
   The above few hints do not cover all the FMC standards and you
   may miss something that can prevent the porting of the project.

.. tip::

   Make sure that you have reviewed all the documentation and design files in
   order to know the electrical specifications and/or requirements of the
   FMC board. If you're not sure, ask!

Base design files
-------------------------------------------------------------------------------

At :ref:`architecture` it is described a generic base design and possible
components of it. The user should look at it as a suggestion only.

.. tip::

   In :git-hdl:`projects/common <projects/common>`/<carrier_name>
   you can find templates for the *system_top.v*, *Makefile*, etc. to help you
   when creating a new project.

The entry point for project creation is ``system_project.tcl``. Some support
scripts are first loaded (:git-hdl:`scripts/adi_env.tcl`) then the project is
created (
:git-hdl:`adi_project_xilinx <projects/scripts/adi_project_xilinx.tcl#L51>`,
or :git-hdl:`adi_project_intel <projects/scripts/adi_project_intel.tcl#L18>`
or :git-hdl:`adi_project_lattice <projects/scripts/adi_project_lattice.tcl#L43>`).

Based on the suffix of the project name, the FPGA carrier board is automatically
detected, based on the ``adi_project`` procedures mentioned above.
The constraint files and custom modules instantiated directly in the
``system_top`` module must be added to the project files list, in
``system_project.tcl``.

Example with an AMD Xilinx board
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this section, we are presenting all the necessary steps to create a base
design for the AMD :xilinx:`ZCU102` development board.

First, you need to create a new directory in ``hdl/projects/common`` with the
name of the carrier.

The **zcu102** directory must contain the following files:

- **zcu102_system_bd.tcl** - this script describes the base block design
- **zcu102_system_constr.xdc** - I/O constraint file for the base design. It
  will contain I/O definitions for GPIO, switches, LEDs or other peripherals of
  the board
- MIG configuration file (if needed) - this file can be borrowed from the
  golden reference design of the board
- Other constraints files if needed

You should define the board and its device in the project flow script
:git-hdl:`projects/scripts/adi_project_xilinx.tcl`
by adding the following lines after the last device specified in
the **adi_project_create** process:

.. code:: tcl

   if [regexp "_zcu102" $project_name] {
     set device "xczu9eg-ffvb1156-2-e"
     set board [lindex [lsearch -all -inline [get_board_parts] *zcu102*] end]
     set sys_zynq 2
   }

.. tip::

   The valid board parts and parts can be retrieved by running the
   following commands in Tcl console: **get_parts** and **get_board_parts**.
   Run the commands like **join [get_parts] \\n**, so each part name will be
   listed on a separate line.

The **sys_zynq** constant variable should be set in the following way:

- 0 - 7 Series FPGA (e.g. Kintex7, Virtex7)
- 1 - Zynq-7000 SoC
- 2 - Zynq UltraScale+ MP SoC
- 3 - Versal

.. caution::

   In case you have a custom board based on an AMD Xilinx chip, let's say
   a Zynq UltraScale+ MP, then you would need to create the board files, similar
   to the ones we have for ZCU102 (projects/common/zcu102/zcu102\_\*)
   with the note that you need to manually enable all the functions needed in
   the system.

The entry point for project creation is ``system_project.tcl``. Some support
scripts are first loaded (:git-hdl:`scripts/adi_env.tcl`) then the project is
created (
:git-hdl:`adi_project_xilinx <projects/scripts/adi_project_xilinx.tcl#L51>`).

When the project is created, *system_bd.tcl* is sourced. *system_bd.tcl*
will generate the IP Integrator system. The resulting system will be
instantiated in the *system_top* module.

In our example we use this file:
:git-hdl:`projects/ad9081_fmca_ebz/zcu102/system_project.tcl`.

.. code-block:: tcl

   source ../../../scripts/adi_env.tcl
   source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
   source $ad_hdl_dir/projects/scripts/adi_board.tcl

.. collapsible:: Use ADC/DAC FIFOs in ZCU102 designs

   To use the ADC/DAC FIFOs, the corresponding Tcl files must be sourced in
   the *system_bd.tcl*.

   .. code-block:: tcl

      ## ADC FIFO depth in samples per converter
      set adc_fifo_samples_per_converter [expr 64*1024]

      ## DAC FIFO depth in samples per converter
      set dac_fifo_samples_per_converter [expr 64*1024]

      source $ad_hdl_dir/projects/common/zcu102/zcu102_system_bd.tcl
      source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl
      source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

      # the adc_fifo_samples_per_converter and dac_fifo_samples_per_converter will be used in the file below
      source $ad_hdl_dir/projects/ad9081_fmca_ebz/common/ad9081_fmca_ebz_bd.tcl
      source $ad_hdl_dir/projects/scripts/adi_pd.tcl

.. collapsible:: Use ADC/DAC FIFOs in ZC706 designs

   To use the ADC/DAC FIFOs, the corresponding Tcl files must be sourced in
   the *system_bd.tcl*.

   .. code-block:: tcl

      source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_adcfifo_bd.tcl
      source $ad_hdl_dir/projects/common/xilinx/dacfifo_bd.tcl

   If the user wants to swap the resources allocated to the FIFO, the following
   scripts should be sourced instead:

   .. code-block:: tcl

      source $ad_hdl_dir/projects/common/zc706/zc706_plddr3_dacfifo_bd.tcl
      source $ad_hdl_dir/projects/common/xilinx/adcfifo_bd.tcl

   The following parameters will define the FIFO's depth. Note, if the FIFO
   is using the PL side DDR interface, the address width parameter can be
   ignored, and the FIFO will have an equal depth with the DDR memory
   (e.g. in case of the :xilinx:`ZC706` board is 1Gbyte).

   .. code-block:: tcl

      # the DAC FIFO has a 500KSMP depth - 1 Mbyte
      set dac_fifo_address_width 15

      # by default PLDDR is used (1 Gbyte), this varible should be ignored
      set adc_fifo_address_width 15

Sometimes, to easily change between configurations of the project (whether
this is about changing the number of lanes, or from LVDS to CMOS interface,
etc.), it needs build parameters. They are specified like this, and used
when running the ``make`` command ("make RX_JESD_L=2 TX_JESD_L=2").

The "0" from :code:`adi_project ad9081_fmca_ebz_zcu102 0` is the project mode
justified by :git-hdl:`this <projects/scripts/adi_project_xilinx.tcl#L149>`
(or AMD UG892 user guide).

.. code-block::

   adi_project ad9081_fmca_ebz_zcu102 0 [list \
     JESD_MODE        [get_env_param JESD_MODE      8B10B ] \
     RX_LANE_RATE     [get_env_param RX_LANE_RATE      10 ] \
     RX_JESD_L        [get_env_param RX_JESD_L          4 ] \
     TX_LANE_RATE     [get_env_param TX_LANE_RATE      10 ] \
     TX_JESD_L        [get_env_param RX_JESD_L          4 ] \
   ]

   adi_project_files ad9081_fmca_ebz_zcu102 [list \
     "system_top.v" \
     "system_constr.xdc"\
     "timing_constr.xdc"\
     "../../../library/common/ad_3w_spi.v"\
     "$ad_hdl_dir/library/common/ad_iobuf.v" \
     "$ad_hdl_dir/projects/common/zcu102/zcu102_system_constr.xdc" ]

   adi_project_run ad9081_fmca_ebz_zcu102

When using the :ref:`JESD204 Framework <jesd204>` we need to source the
:git-hdl:`JESD204 support script <library/jesd204/scripts/jesd204.tcl>`.
:code:`source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl`.
In this script, several procedures which simplify the design are defined.

Example with an Intel board
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this section, we are presenting all the necessary steps to create a base
design for the Intel Arria 10 SoC development board (abbreviated,
:intel:`A10SoC <content/www/us/en/products/details/fpga/development-kits/arria/10-sx.html>`).

First, you need to create a new directory in ``hdl/projects/common`` with the
name of the carrier.

The **a10soc** directory must contain the following files:

- **a10soc_system_assign.tcl** - global and I/O assignments of the base design
- **a10soc_system_qsys.tcl** - the QSYS base design

You should define the board and its device in the flow script
:git-hdl:`projects/scripts/adi_project_intel.tcl`,
by adding the following lines after the last device specified in
the **adi_project** process:

.. code:: tcl

   if [regexp "_a10soc$" $project_name] {
     set family "Arria 10"
     set device 10AS066N3F40E2SG
     set system_qip_file system_bd/system_bd.qip
   }

Example with a Lattice board
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To create a new base design for a given Lattice FPGA carrier board, the following
steps should be taken (the `lfcpnx`_ carrier was used as an example).

The following files should be created or copied into the directory:

- **lfcpnx_system_constr.pdc** - global and I/O assignments of the base design
- **lfcpnx_system_pb.tcl** - this script describes the base block design

You should define the board and its device in the flow script
:git-hdl:`projects/scripts/adi_lattice_dev_select.tcl`,
by adding the following lines to the file:

.. code:: tcl

   if [regexp "_lfcpnx" $project_name] {
     set device "LFCPNX-100-9LFG672C"
     set speed "9_High-Performance_1.0V"
     set board "Certus Pro NX Evaluation Board"
   }

Project files
-------------------------------------------------------------------------------

Project files for AMD boards
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To follow the project framework as much as possible, the easiest way is to copy
all the projects files from an already existing project and to modify those
files to support the new carrier.

A project for an AMD FPGA board should contain the following files:

- **system_project.tcl** - this script is creating the actual Vivado project
  and runs the synthesis/implementation of the design. The name of the carrier
  from inside the file, must be updated.
- **system_bd.tcl** - in this file is sourced the **base** design's Tcl script
  and the **board** design's Tcl script. Again, the name of the carrier must be
  updated.
- **system_constr.xdc** - constraints file of the **board** design.
  Here are defined the FMC I/O pins and board specific clock signals.
  All the I/O definitions must be updated, with the new pin names.
- **system_top.v** - top wrapper file, in which the **system_wrapper.v**
  module is instantiated, and a few I/O macros are defined.
  The I/O port of this Verilog module will be connected to actual I/O pads
  of the FPGA. The simplest way to update the **system_top** is to let
  the synthesis fail and the tool will tell you which ports are missing
  or which ports are redundant.
  The first thing to do after the failure, is to verify the instantiation
  of the **system_wrapper.v**.
  This file is a tool-generated file and can be found at
  **<project_name>.srcs/sources_1/bd/system/hdl/system_wrapper.v**.
  Fixing the instantiation of the wrapper module in most cases eliminates
  all the errors.
- **Makefile** - this is an auto-generated file, but after updating the carrier
  name, should work with the new project without an issue.

Project files for Intel boards
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To follow the project framework as much as possible, the easiest way is to copy
all the projects file from an already existing project and to modify those
files to support the new carrier.

A project for an Intel FPGA board should contain the following files:

- **system_project.tcl** - this script is creating the actual Quartus project
  and runs the synthesis/implementation of the design. It also contains the I/O
  definitions for the interfaces between the FMC board and FPGA. The carrier
  name and all the I/O pin names inside the file, must be updated.
- **system_qsys.tcl** - in this file is sourced the **base** design's Tcl
  script and the **board** design's Tcl script. Again, the name of the carrier
  must be updated.
- **system_constr.sdc** - contains clock definitions and other path constraints
- **system_top.v** - top wrapper file of the project. The I/O ports of this
  Verilog module will be actual I/O pads of the FPGA. You must make sure that
  the base design's I/Os are updated (delete nonexistent I/Os or add new ones).
  The simplest way to update the *system_top* is to let the synthesis fail and
  the tool will you tell which ports are missing or which ports are redundant.
- **Makefile** - this is an auto-generated file, but after updating the carrier
  name, it should work with the new project without an issue.

Project files for Lattice boards
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A project for a Lattice FPGA board should contain the following files:

- **system_project_pb.tcl** - Used to build the Propel Builder project
  (block design). Linked in project-lattice.mk, run by propelbld (Windows),
  propelbldwrap (Linux).
- **system_project.tcl** - Used to build the Radiant project. Linked in
  project-lattice.mk, run by pnmainc (Windows), radiantc (Linux).
- **system_pb.tcl** - linker script for the projects, sourced in adi_project_pb
  procedure that is called in system_project_pb.tcl and it is
  defined in adi_project_lattice_pb.tcl. Sources the *base design first*,
  then the *board design*, and afterwards it contains all the IP instances and
  connections that must be added on top of the sourced files, to
  complete the design of the project (these are specific to the
  combination of this carrier and board).
- **system_constr.sdc** - Contains clock definitions and other path
  constraints.
- **system_constr.pdc** - Contains clock definitions and other path
  constraints + physical constraints.
- **system_top.v** - Contains everything about the HDL part of the
  project. It instantiates the **<project_name>.v** ``system_wrapper`` module,
  IO buffers, I/ODDRs, modules that transform signals from LVDS to single-ended,
  etc. The I/O ports of this Verilog module will be connected to actual
  I/O pads of the FPGA.
- **Makefile** - This is an auto-generated file, but after updating the project
  name, it should work with the new project without an issue.

Tips
-------------------------------------------------------------------------------

Generating the FMC I/O constraints
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The easiest way of writing the constraints for FMC I/O pins is making use
of the script :git-hdl:`projects/scripts/adi_fmc_constr_generator.tcl`.

Required setup:

- Carrier common FMC connections file
  (:git-hdl:`projects/common <projects/common>`/<carrier>/<carrier>_<fmc_port>.txt)
- Project common FMC connections file
  (:git-hdl:`projects`/<project>/common/<project>_fmc.txt)

.. tip::

  In cases where these files don't already exist, you can make your own
  by following some existing ones as an example.
  For project common files, you can easily make them following :ref:`creating_fmc`.

Calling the script:

To use this script you can source it in any Tcl shell or simply call the
adi_fmc_constr_generator.tcl **with argument(s) <fmc_port>**.
But before sourcing or calling it, your current directory needs to be
:git-hdl:`projects`/<project>/<carrier>.

For example:

- :code:`tclsh ../../scripts/adi_fmc_constr_generator.tcl fmc0`
  (the project uses only one FMC port at a time)
- :code:`tclsh ../../scripts/adi_fmc_constr_generator.tcl fmc0 fmc1`
  (the project uses two FMC ports at a time)

If sourced **without argument(s)**, then you can simply call ``gen_fmc_constr
<fmc_port>``.

For example:

- :code:`gen_fmc_constr fmc0` (the project uses only one FMC port at a time)
- :code:`gen_fmc_constr fmc0 fmc1` (the project uses two FMC ports at a time)

.. note::

   The fmc port name can be deduced from the common carrier file name
   (:git-hdl:`projects/common <projects/common>`/<carrier>/<carrier>_<fmc_port>.txt).

The generated file will appear in the current directory as **fmc_constr.xdc**
(AMD board) or **fmc_constr.tcl** (Intel board). If ran from an open Vivado
project, the generated file will be automatically added to the project.

.. _creating_fmc:

Creating carrier common FMC connections
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To create a carrier common FMC connections file:

#. Open the space divided .txt file corresponding to the desired connector type,
   either with a text editor or importing in a spreadsheet editor
   (with Excel, export as .prn).
   :git-hdl:`docs/user_guide/sources/fmc.txt`,
   :git-hdl:`docs/user_guide/sources/fmc_hpc.txt`,
   :git-hdl:`docs/user_guide/sources/fmc+.txt`.
#. Fill the table by replacing the **#**'s where it's needed.
#. Save as .txt inside :git-hdl:`projects`/<project_name>/common/.
#. Clean up the file by removing the lines containing **#** for system_top_name.
#. Rearrange the lines following one of the existing examples.
#. To generate empty lines, leave an empty line in the .txt file.
   To generate comments, the line should start with **#** sign.
#. Run the script as :code:`tclsh /path/to/script {fmc_conn}`
   (e.g. :code:`tclsh ../../scripts/adi_fmc_constr_generator.tcl fmc0`).

   * Current directory needs to be hdl/projects/<project_name>/<carrier>.
   * If used from an open project, the generated file would be added to the
     project; otherwise it will appear in the current directory.
   * If the carrier has only one FMC port, the script can be called without
     parameters.
   * If the carrier has more FMC ports, the script should be called with:

     * One parameter indicating the FMC port: fmc_lpc/hpc, fmc0/1, fmcp0/1
       (see **projects/common/<carrier>/\*.txt**).
     * Two parameters indicating both FMC ports in the desired order for
       projects that use both FMC connectors.

.. _lfcpnx: https://www.latticesemi.com/en/Products/DevelopmentBoardsAndKits/CertusPro-NXEvaluationBoard
