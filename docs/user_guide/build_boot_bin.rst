.. _build_boot_bin:

Build the boot image BOOT.BIN
===============================================================================

The boot image ``BOOT.BIN`` is built using the
:xilinx:`AMD Xilinx Bootgen tool <support/documents/sw_manuals/xilinx2022_2/ug1283-bootgen-user-guide.pdf>`
which requires several input files.

All further steps are lengthy explained on the
`AMD Xilinx wiki <https://xilinx-wiki.atlassian.net/wiki/A>`__ pages:

- `How to build the u-boot <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841973/Build+U-Boot>`__
- `How to build the FSBL <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841798/Build+FSBL>`__
- `How to build the BOOT image <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841976/Prepare+boot+image>`__
- `How to build the PMU firmware (for ZynqMP) <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842462/Build+PMU+Firmware>`__
- `How to build the Arm Trusted Firmware (for ZynqMP) <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842305/Build+ARM+Trusted+Firmware+ATF>`__

For ease of use, we provide a bash shell script which allows building BOOT.BIN
from system_top.xsa and u-boot.elf.

.. warning::

   You need to have the AMD Xilinx Vivado, Vitis and Bootgen tool paths in
   the ``$PATH`` environment variable.

   Check the :ref:`Enviroment <build_hdl environment>` section of :ref:`build_hdl`.

.. _build_boot_bin zynq:

For Zynq carriers
-------------------------------------------------------------------------------

This section applies to the Zynq-based carriers from
:ref:`our list <architecture amd-platforms>`, but not limited to them only.

The ``build_boot_bin.sh`` script can be downloaded from
`here <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/main/zynq_boot_bin/build_boot_bin.sh>`__.

The script can take 3 parameters:

- the path to the ``system_top.xsa`` file (**mandatory**).
- the path to the ``u-boot.elf`` file (**mandatory**);
  see the note below.
- the ``name`` of the tar.gz output archive (``name``.tar.gz) (**optional**);
  see the note below.

.. shell:: bash

   $build_boot_bin.sh system_top.xsa u-boot.elf [output-archive]

The build output can be found in the local directory ``output_boot_bin``
where you ran the command. The folder follows the pattern:
*hdl/projects/$ADI_PART/$CARRIER/output_boot_bin*.

.. note::

   For those who don't want to build the u-boot themselves or want to provide
   the *.tar.gz* output archive, both can be extracted from
   the *bootgen_sysfiles.tgz* located in the project folder of the Kuiper Linux
   image.

   See the beginning of :external+documentation:ref:`kuiper sdcard` for
   instructions on how to obtain the image.

There is also a version of script that works in Windows Powershell:
`build_boot_bin.ps1 <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/main/zynq_boot_bin/build_boot_bin.ps1>`__.

.. _build_boot_bin zynqmp:

For ZynqMP carriers
-------------------------------------------------------------------------------

This section applies to the ZynqMP-based carriers, usually :xilinx:`ZCU102`
but not limited to this one only.

Make sure that AMD Xilinx Vivado and Vitis are included in the path and a
cross-compiler for ``arm64`` exists before running the script.
For more information about cross compilers, see
:dokuwiki:`Building the ZynqMP / MPSoC Linux kernel and devicetrees from source <resources/tools-software/linux-build/generic/zynqmp>`.

The ``build_zynqmp_boot_bin.sh`` script can be downloaded from
`here <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/main/zynqmp_boot_bin/build_zynqmp_boot_bin.sh>`__

The script can take 4 parameters:

- the path to the ``system_top.xsa`` file (**mandatory**)
- the path to the ``u-boot.elf`` file (**mandatory**);
  see the note below
- the third parameter is either (**mandatory**):

  - ``download`` (will git clone the ATF repository)
  - or ``bl31.elf``
  - or ``<path-to-arm-trusted-firmware-source>`` (the file system path to the
    ATF source code repository); see note below

- the ``name`` of the tar.gz output archive (``name``.tar.gz) (**optional**);
  see the note below.

.. shell:: bash

   $build_zynqmp_boot_bin.sh system_top.xsa u-boot.elf (download | bl31.elf | <path-to-arm-trusted-firmware-source>) [output-archive]

The build output can be found in the local directory ``output_boot_bin``
where you ran the command. The folder follows the pattern:
*hdl/projects/$ADI_PART/$CARRIER/output_boot_bin*.

.. note::

   For those who don't want to build the u-boot or bl31.elf themselves
   or want to provide the *.tar.gz* output archive, they can be extracted from
   the *bootgen_sysfiles.tgz* located in the project folder of the Kuiper Linux
   image.

   u-boot.elf may have a different name, rename that .elf file to u-boot.elf
   before using.

   See the beginning of :external+documentation:ref:`kuiper sdcard` for
   instructions on how to obtain the image.
