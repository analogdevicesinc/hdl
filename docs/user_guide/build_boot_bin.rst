.. _build_boot_bin:

Build the boot image BOOT.BIN
===============================================================================

.. caution::

   :red:`This flow is not supported by us in Cygwin!` Use Linux terminal or
   `WSL <https://learn.microsoft.com/en-us/windows/wsl/install>`__ instead.

The boot image ``BOOT.BIN`` is built using the
:xilinx:`AMD Xilinx Bootgen tool <support/documents/sw_manuals/xilinx2022_2/ug1283-bootgen-user-guide.pdf>`
which requires several input files.

(RECOMMENDED) For **ease of use**, we provide a bash shell script which allows building the
BOOT.BIN from ``system_top.xsa`` and ``u-boot.elf``.

But if you're in for the long story, all further steps are lengthy explained
on the
`AMD Xilinx wiki <https://xilinx-wiki.atlassian.net/wiki/A>`__ pages.

.. collapsible:: For more details on the long story (build u-boot, FSBL, PMU firmware, etc.)

   - `How to build the u-boot <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841973/Build+U-Boot>`__
   - `How to build the FSBL <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841798/Build+FSBL>`__
   - `How to build the BOOT image <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841976/Prepare+boot+image>`__
   - `How to build the PMU firmware (for ZynqMP) <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842462/Build+PMU+Firmware>`__
   - `How to build the Arm Trusted Firmware (for ZynqMP) <https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18842305/Build+ARM+Trusted+Firmware+ATF>`__

.. warning::

   You need to have the AMD Xilinx Vivado, Vitis and Bootgen tool paths in
   the ``$PATH`` environment variable.

   Check the :ref:`Enviroment <build_hdl environment>` section of :ref:`build_hdl`.

.. _build_boot_bin zynq:

For Zynq
-------------------------------------------------------------------------------

This section applies to the Zynq-based carriers from
:ref:`our list <architecture amd-platforms>`, but not limited to them only.

The ``build_boot_bin.sh`` script can be downloaded from
`here <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/main/zynq_boot_bin/build_boot_bin.sh>`__.

The script can take 3 parameters:

- the path to the ``system_top.xsa`` file (**mandatory**).
- the path to the ``u-boot.elf`` file (**mandatory**);
  :red:`see the note below`.
- the ``name`` of the tar.gz output archive (``name``.tar.gz) (**optional**);
  :red:`see the note below`.

The script can be saved in the folder local to the project (for
example, hdl/projects/fmcomms2/zed) and to be run from there.

.. shell:: bash

   $cd hdl/projects/fmcomms2/zed
   $chmod +x build_boot_bin.sh
   $./build_boot_bin.sh fmcomms2_zed.sdk/system_top.xsa path/to/u-boot.elf [output-archive]

The build output (``BOOT.BIN``) can be found in the local directory
``output_boot_bin`` where you ran the command.
The folder follows the pattern: *hdl/projects/$ADI_PART/$CARRIER/output_boot_bin*.

.. important::

   For those of you who **don't want to build the u-boot themselves** or
   want to provide the *.tar.gz* output archive, both can be extracted from
   the *bootgen_sysfiles.tgz* located in the project folder of the Kuiper
   Linux image from the SD card.

   Keep in mind that **the u-boot is specific to the FPGA**, so if you will use
   another evaluation board in the future, again with Zed (let's say), you
   can use this exact file.

   See the beginning of :external+documentation:ref:`kuiper sdcard` for
   instructions on how to obtain the ADI Kuiper image.

There is also a version of script that works in Windows Powershell:
`build_boot_bin.ps1 <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/main/zynq_boot_bin/build_boot_bin.ps1>`__.

.. _build_boot_bin zynqmp:

For ZynqMP
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
  :red:`see the note below`
- the third parameter is either (**mandatory**):

  - ``download`` (will git clone the ATF repository)
  - or ``bl31.elf``
  - or ``<path-to-arm-trusted-firmware-source>`` (the file system path to the
    ATF source code repository); :red:`see the note below`

- the ``name`` of the tar.gz output archive (``name``.tar.gz) (**optional**);
  :red:`see the note below`.

.. shell:: bash

   $cd hdl/projects/fmcomms2/zcu102
   $chmod +x build_zynqmp_boot_bin.sh
   $./build_zynqmp_boot_bin.sh fmcomms2_zcu102.sdk/system_top.xsa path/to/u-boot.elf (download | bl31.elf | <path-to-arm-trusted-firmware-source>) [output-archive]

The build output (``BOOT.BIN``) can be found in the local directory
``output_boot_bin`` where you ran the command.
The folder follows the pattern: *hdl/projects/$ADI_PART/$CARRIER/output_boot_bin*.

.. important::

   For those of you who **don't want to build the u-boot themselves** or
   want to provide the *.tar.gz* output archive, both can be extracted from
   the *bootgen_sysfiles.tgz* located in the project folder of the Kuiper
   Linux image from the SD card.

   Keep in mind that **the u-boot is specific to the FPGA**, so if you will use
   another evaluation board in the future, again with ZCU102 (let's say), you
   can use this exact file.

   See the beginning of :external+documentation:ref:`kuiper sdcard` for
   instructions on how to obtain the ADI Kuiper image.

.. _build_boot_bin versal:

For Versal
-------------------------------------------------------------------------------

This section applies only to the Versal carriers: :xilinx:`VCK190` and
:xilinx:`VPK180`.

Make sure that AMD Xilinx Vivado and Vitis are included in the path and a
cross-compiler for ``arm64`` exists before running the script.
For more information about cross compilers, see
:dokuwiki:`Building the ZynqMP / MPSoC Linux kernel and devicetrees from source <resources/tools-software/linux-build/generic/zynqmp>`.

The ``build_versal_boot_bin.sh`` script can be downloaded from
`here <https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/refs/heads/main/versal_boot_bin/build_versal_boot_bin.sh>`__

The script can take 4 parameters:

- the path to the ``system_top.xsa`` file (**mandatory**)
- the second parameter is either:

  - ``download`` (will git clone the u-boot repository) (**default**)
  - or ``u-boot.elf``

- the third parameter is either:

  - ``download`` (will git clone the ATF repository) (**default**)
  - or ``bl31.elf``
  - or ``<path-to-arm-trusted-firmware-source>`` (the file system path to the
    ATF source code repository)

- the ``name`` of the tar.gz output archive (``name``.tar.gz) (**optional**)

.. shell:: bash

   $cd hdl/projects/ad9081_fmca_ebz/vck190
   $chmod +x build_versal_boot_bin.sh
   $./build_versal_boot_bin.sh ad9081_fmca_ebz.vck190.sdk/system_top.xsa (download | u-boot.elf) (download | bl31.elf | <path-to-arm-trusted-firmware-source>) [output-archive]

The build output (``BOOT.BIN``) can be found in the local directory
``output_boot_bin`` where you ran the command.
The folder follows the pattern: *hdl/projects/$ADI_PART/$CARRIER/output_boot_bin*.

.. important::

   For those of you who **don't want to build the u-boot themselves** or
   want to provide the *.tar.gz* output archive, both can be extracted from
   the *bootgen_sysfiles.tgz* located in the project folder of the Kuiper
   Linux image from the SD card.

   Keep in mind that **the u-boot is specific to the FPGA**, so if you will use
   another evaluation board in the future, again with VCK190 (let's say), you
   can use this exact file.

   See the beginning of :external+documentation:ref:`kuiper sdcard` for
   instructions on how to obtain the ADI Kuiper image.