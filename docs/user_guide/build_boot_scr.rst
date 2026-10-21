.. _build_boot_scr:

Build the boot script boot.scr / u-boot.scr
===============================================================================

Some platforms require a U-Boot boot script (``boot.scr`` or ``u-boot.scr``)
on the SD card BOOT partition to tell U-Boot how to load the kernel, device
tree, and (optionally) the FPGA bitstream into memory. This page explains how
to build that script from a plain-text source file using the ``mkimage`` tool.

.. note::

   The boot script is **not** the same as ``BOOT.BIN``.
   For AMD Xilinx Zynq/ZynqMP/Versal ``BOOT.BIN`` generation, see
   :ref:`build_boot_bin`.
   For Intel boot images, see :ref:`build_intel_boot_image`.

Prerequisites
-------------------------------------------------------------------------------

The ``mkimage`` utility is required. It is part of the **u-boot-tools**
package on most Linux distributions:

.. shell:: bash

   $sudo apt-get install u-boot-tools

Verify the installation:

.. shell:: bash

   $mkimage -V

Boot script source files
-------------------------------------------------------------------------------

We provide ready-made boot script source files (``*.txt``) for all
Kuiper-supported carriers in the
`analogdevicesinc/wiki-scripts <https://github.com/analogdevicesinc/wiki-scripts/tree/main/boot_txt_files>`__
repository, under the ``boot_txt_files/`` directory.

The following source files are available:

.. list-table::
   :header-rows: 1
   :widths: 30 40 30

   * - Source file
     - Platform / carrier
     - Output file name
   * - ``zynq.txt``
     - Zynq (e.g. ZED, ZC706)
     - ``boot.scr``
   * - ``zynqmp.txt``
     - Zynq UltraScale+ MPSoC (e.g. ZCU102)
     - ``boot.scr``
   * - ``k26.txt``
     - Kria K26 SOM
     - ``boot.scr``
   * - ``versal.txt``
     - Versal (e.g. VCK190)
     - ``boot.scr``
   * - ``vpk180.txt``
     - Versal Premium (VPK180)
     - ``boot.scr``
   * - ``cyclone5.txt``
     - Intel Cyclone V SoC (e.g. C5SoC)
     - ``u-boot.scr``
   * - ``jupiter_sdr.txt``
     - Jupiter SDR
     - ``boot.scr``
   * - ``no_bitfile_zynq.txt``
     - Zynq — without bitstream loading
     - ``boot.scr``
   * - ``no_bitfile_de10nano.txt``
     - DE10-Nano — without bitstream loading
     - ``u-boot.scr``

Download the source file that matches your platform:

.. shell:: bash

   $wget https://raw.githubusercontent.com/analogdevicesinc/wiki-scripts/main/boot_txt_files/<platform>.txt

Replace ``<platform>`` with one of the file names from the table above
(e.g. ``zynqmp``, ``versal``, ``cyclone5``).

Building the boot script
-------------------------------------------------------------------------------

The ``mkimage`` command converts the plain-text source into a U-Boot script
image. The general form is:

.. code-block:: bash

   mkimage -A <arch> -O linux -T script -C none -a 0 -e 0 \
       -n "<description>" \
       -d <input>.txt <output>.scr

Where:

- ``-A <arch>`` — target architecture (``arm`` for 32-bit, ``arm64`` for 64-bit)
- ``-O linux`` — operating system
- ``-T script`` — image type (boot script)
- ``-C none`` — no compression
- ``-a 0 -e 0`` — load and entry addresses (unused for scripts, set to 0)
- ``-n "<description>"`` — a human-readable description embedded in the image
- ``-d <input>.txt`` — the boot script source file
- ``<output>.scr`` — the output boot script image

For AMD Xilinx platforms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This applies to Zynq, Zynq UltraScale+ MPSoC, Kria K26, Versal, and VPK180
carriers. The output file is ``boot.scr``.

.. shell:: bash

   $mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
   $    -n "Boot script" \
   $    -d <platform>.txt boot.scr

For Intel platforms
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This applies to Cyclone V SoC and DE10-Nano carriers. The output file is
``u-boot.scr``.

.. shell:: bash

   $mkimage -A arm -O linux -T script -C none -a 0 -e 0 \
   $    -n "Boot script" \
   $    -d <platform>.txt u-boot.scr

.. note::

   Intel Cyclone V SoC projects expect the file name ``u-boot.scr``, not
   ``boot.scr``.

After building, copy the resulting script file to the BOOT (FAT32) partition
of the SD card.
