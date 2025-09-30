.. _build_boot_bin:

Build the boot image BOOT.BIN
===============================================================================

.. caution::

   :red:`This flow is not supported by us in Cygwin!` Use Linux terminal or
   `WSL <https://learn.microsoft.com/en-us/windows/wsl/install>`__ instead, or
   the **not recommended** option ->
   :ref:`Building the BOOT.BIN in Vivado GUI <build_hdl cygwin>`.

The boot image ``BOOT.BIN`` is built using the
:xilinx:`AMD Xilinx Bootgen tool <support/documents/sw_manuals/xilinx2022_2/ug1283-bootgen-user-guide.pdf>`
which requires several input files.

For **ease of use**, we provide a bash shell script which allows
building the BOOT.BIN from ``system_top.xsa`` (generated from building the
project) and ``u-boot.elf`` (from the SD card with Kuiper image).

.. warning::

   You need to have the AMD Xilinx Vivado, Vitis and Bootgen tool paths in
   the ``$PATH`` environment variable.

   Check the :ref:`Enviroment <build_hdl environment>` section of :ref:`build_hdl`.

As prerequisites, you need to have ``xlsclients`` from the ``x11-utils`` package
installed in your Linux/WSL system.

.. _build_boot_bin zynq:

For Zynq
-------------------------------------------------------------------------------

This section applies to the Zynq-based carriers from
:ref:`our list <architecture amd-platforms>`.

Make sure that AMD Xilinx Vivado and Vitis are included in the path and a
cross-compiler for ``arm`` exists before running the script.
For more information about cross compilers, see
:dokuwiki:`Building the Zynq Linux kernel and devicetrees from source <resources/tools-software/linux-build/generic/zynq>`.

The script used is
`build_boot_bin.sh <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/main/zynq_boot_bin/build_boot_bin.sh>`__,
which needs to be downloaded on your computer.

The script can take 3 parameters:

- the path to the ``system_top.xsa``;
- the path to the ``u-boot.elf``;
- the ``name`` of the tar.gz output archive (``name``.tar.gz) (optional).

.. important::

   The u-boot can be taken from the *bootgen_sysfiles.tgz* archive located in
   the project folder of the ADI Kuiper Linux image from the SD card.

   Keep in mind that **the u-boot is FPGA-specific**!

   See this :external+adi-kuiper-gen:ref:`tutorial <quick-start>` for
   instructions on how to obtain the ADI Kuiper image and use it.

If you didn't use ``make`` parameters when building the project, then
the script can be saved in the **folder local to the project** (for
example, hdl/projects/$ADI_PART/$CARRIER) and **to be run from there**.

If you did use ``make`` parameters, then you need to go to the build folder
that was created based on the parameters you gave,
(would look like this hdl/projects/$ADI_PART/$CARRIER/$param1_param2),
save it there and **run it from there**.

.. shell:: bash

   $cd hdl/projects/fmcomms2/zed
   $chmod +x build_boot_bin.sh
   $./build_boot_bin.sh fmcomms2_zed.sdk/system_top.xsa path/to/u-boot.elf [output-archive]

The build output (``BOOT.BIN``) can be found in the local directory
``output_boot_bin`` where you ran the command.

The folder follows the following pattern if ``make`` parameters were not used
*hdl/projects/$ADI_PART/$CARRIER/output_boot_bin*, and this pattern if
parameters were used
*hdl/projects/$ADI_PART/$CARRIER/$PARAM1_PARAM2/output_boot_bin*.

.. _build_boot_bin zynqmp:

For Zynq UltraScale+ MP
-------------------------------------------------------------------------------

This section applies to the ZynqMP-based carriers (`Zynq UltraScale+ MPSoC`_),
usually :xilinx:`ZCU102` in our systems, but not limited to this one only.

Make sure that AMD Xilinx Vivado and Vitis are included in the path and a
cross-compiler for ``arm64`` exists before running the script.
For more information about cross compilers, see
:dokuwiki:`Building the ZynqMP / MPSoC Linux kernel and devicetrees from source <resources/tools-software/linux-build/generic/zynqmp>`.

The script used is
`build_zynqmp_boot_bin.sh <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/main/zynqmp_boot_bin/build_zynqmp_boot_bin.sh>`__,
which needs to be downloaded on your computer.

The script can take 4 parameters (the last one is optional):

- the path to the ``system_top.xsa``;
- the path to the ``u-boot.elf``;
- the path to the ``bl31.elf``;
- the ``name`` of the tar.gz output archive (``name``.tar.gz) (optional).

.. important::

   The u-boot and the bl31.elf can be taken from the *bootgen_sysfiles.tgz*
   archive located in the project folder of the ADI Kuiper Linux image from
   the SD card.

   Keep in mind that **the u-boot is FPGA-specific**!

   See this :external+adi-kuiper-gen:ref:`tutorial <quick-start>` for
   instructions on how to obtain the ADI Kuiper image and use it.

If you didn't use ``make`` parameters when building the project, then
the script can be saved in the **folder local to the project** (for
example, hdl/projects/$ADI_PART/$CARRIER) and **to be run from there**.

If you did use ``make`` parameters, then you need to go to the build folder
that was created based on the parameters you gave,
(would look like this hdl/projects/$ADI_PART/$CARRIER/$param1_param2),
save it there and **run it from there**.

.. shell:: bash

   $cd hdl/projects/fmcomms2/zcu102
   $chmod +x build_zynqmp_boot_bin.sh
   $./build_zynqmp_boot_bin.sh fmcomms2_zcu102.sdk/system_top.xsa path/to/u-boot.elf path/to/bl31.elf

The build output (``BOOT.BIN``) can be found in the local directory
``output_boot_bin`` where you ran the command.
The folder follows the following pattern if ``make`` parameters were not used
*hdl/projects/$ADI_PART/$CARRIER/output_boot_bin*, and this pattern if
parameters were used
*hdl/projects/$ADI_PART/$CARRIER/$PARAM1_PARAM2/output_boot_bin*.

.. _build_boot_bin versal:

For Versal
-------------------------------------------------------------------------------

This section applies only to the Versal carriers: :xilinx:`VCK190` and
:xilinx:`VPK180`.

Make sure that AMD Xilinx Vivado and Vitis are included in the path and a
cross-compiler for ``arm64`` exists before running the script.
For more information about cross compilers, see
:dokuwiki:`Building the ZynqMP / MPSoC Linux kernel and devicetrees from source <resources/tools-software/linux-build/generic/zynqmp>`.

The script used is
`build_versal_boot_bin.sh <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/refs/heads/main/versal_boot_bin/build_versal_boot_bin.sh>`__,
which needs to be downloaded on your computer.

The script can take 4 parameters:

- the path to the ``system_top.xsa``;
- the path to the ``u-boot.elf``;
- the path to the ``bl31.elf``;
- the ``name`` of the tar.gz output archive (``name``.tar.gz) (**optional**).

.. important::

   The u-boot and the bl31.elf can be taken from the *bootgen_sysfiles.tgz*
   archive located in the project folder of the ADI Kuiper Linux image from
   the SD card.

   Keep in mind that **the u-boot is FPGA-specific**!

   See this :external+adi-kuiper-gen:ref:`tutorial <quick-start>` for
   instructions on how to obtain the ADI Kuiper image and use it.

If you didn't use ``make`` parameters when building the project, then
the script can be saved in the **folder local to the project** (for
example, hdl/projects/$ADI_PART/$CARRIER) and **to be run from there**.

If you did use ``make`` parameters, then you need to go to the build folder
that was created based on the parameters you gave,
(would look like this hdl/projects/$ADI_PART/$CARRIER/$param1_param2),
save it there and **run it from there**.

.. shell:: bash

   $cd hdl/projects/ad9081_fmca_ebz/vck190
   $chmod +x build_versal_boot_bin.sh
   $./build_versal_boot_bin.sh ad9081_fmca_ebz.vck190.sdk/system_top.xsa (download | u-boot.elf) (download | bl31.elf | <path-to-arm-trusted-firmware-source>) [output-archive]

The build output (``BOOT.BIN``) can be found in the local directory
``output_boot_bin`` where you ran the command.
The folder follows the following pattern if ``make`` parameters were not used
*hdl/projects/$ADI_PART/$CARRIER/output_boot_bin*, and this pattern if
parameters were used
*hdl/projects/$ADI_PART/$CARRIER/$PARAM1_PARAM2/output_boot_bin*.


More information
-------------------------------------------------------------------------------

(NOT RECOMMENDED) If you're in for the long story, check out the
`AMD Xilinx wiki <https://xilinx-wiki.atlassian.net/wiki/spaces/A/overview>`__ pages.

.. collapsible:: For more details on the long story (NOT RECOMMENDED)

   - `How to build the FSBL <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841798/Build+FSBL>`__
   - `How to build the BOOT image <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841976/Prepare+boot+image>`__
   - `How to build the PMU firmware (for ZynqMP) <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842462/Build+PMU+Firmware>`__
   - `How to build the Arm Trusted Firmware (for ZynqMP) <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842305/Build+ARM+Trusted+Firmware+ATF>`__

.. _Zynq UltraScale+ MPSoC: https://www.amd.com/en/products/adaptive-socs-and-fpgas/soc/zynq-ultrascale-plus-mpsoc.html
