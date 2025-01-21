.. _build_intel_boot_image:

Generating HDL boot image for Intel projects
===============================================================================

This page is dedicated to the building process of boot image for supported
Intel/Altera projects. One key file specific to these projects is
the ``bootloader``. Its role is to initialize the system after the
BootROM runs. It bridges the gap between the limited functionality of the
BootROM and the end user application, configuring the system as needed before
the larger application can run.

In the following links you can find more details on the process and the
necessary components:

- `Booting and Configuration <https://www.intel.com/content/dam/support/us/en/programmable/support-resources/bulk-container/pdfs/literature/hb/arria-v/av-5400a.pdf>`__
- `SocBootFromFPGA <https://community.intel.com/t5/FPGA-Wiki/SocBootFromFPGA/ta-p/735773>`__
- `Intel Bootloader <https://www.intel.com/content/www/us/en/support/programmable/support-resources/design-guidance/soc-bootloader.html>`__

Necessary files for booting up an HDL project
-------------------------------------------------------------------------------

.. warning::

   We **do not** provide any scripts to automate this process, so please read
   carefully and follow all the steps to obtain the boot file. We recommend
   using the latest version of Quartus. Te build flow is the same for the
   recent versions of Quartus.

To boot a system with Linux + HDL on an Intel board, you need the following
files:

- For Arria 10 SoC projects (:ref:`build example <build_intel_boot_image arria10>`):

  - ``<boot_mountpoint>/u-boot.img``
  - ``<boot_mountpoint>/fit_spl_fpga.itb``
  - ``<boot_mountpoint>/extlinux/extlinux.conf`` (keep the directory)
  - ``<boot_mountpoint>/socfpga_arria10_socdk_sdmmc.dtb``
  - ``<boot_mountpoint>/socfpga_arria10-common/zImage``
  - ``<boot_mountpoint>/u-boot-splx4.sfp`` (preloader image)

- For Cyclone5 SoC project (build examples:
  :ref:`Terasic C5 <build_intel_boot_image c5soc>`,
  :ref:`DE10Nano <build_intel_boot_image de10nano>`):

  - ``<boot_mountpoint>/u-boot.scr``
  - ``<boot_mountpoint>/soc_system.rbf``
  - ``<boot_mountpoint>/extlinux/extlinux.conf`` (keep the directory)
  - ``<boot_mountpoint>/socfpga_arria10-common/socfpga.dtb``
  - ``<boot_mountpoint>/zImage``
  - ``<boot_mountpoint>/u-boot-with-spl.sfp`` (preloader image)

- For Agilex 7 SoC projects (:ref:`build example <build_intel_boot_image fm87>`):

  - ``<boot_mountpoint>/agilex.core.rbf``
  - ``<boot_mountpoint>/u-boot.itb``
  - ``<boot_mountpoint>/socfpga_agilex_socdk.dtb``
  - ``<boot_mountpoint>/Image``

.. note::

   Some files, like **fit_spl_fpga.itb** or **extlinux**, were introduced
   later in the Intel boot flow with the U-Boot image update.

Using Kuiper Linux pre-built images
-------------------------------------------------------------------------------

The built and tested files can be found in our ADI Kuiper Linux release, which
can be obtained from
:dokuwiki:`here <resources/tools-software/linux-software/adi-kuiper_images/release_notes>`.

.. note::

   Make sure to always use the latest version of Kuiper Linux. If the desired
   project is not supported anymore, use the last version of Kuiper where it's
   present.

The files need to be copied on the BOOT FAT32 partition, with the exception of
the **preloader image**, which needs to be written to the third partition
of the mounted device, and **extlinux.conf**, which should also be in BOOT FAT32
partition, in a folder called 'extlinux'. That folder may not exist by default
(it is deleted automatically in some cases, when the image is build, because
it is empty and unused). Pay attention that **extlinux.conf** for Arria10 and
Cyclone5 is slightly different.

Supposing your host is a Linux system, your carrier is an Arria10, the
eval board/project is AD9081 and you are using the built files from the Kuiper
image mounted at ``/mnt/BOOT``, then you would:

.. shell:: bash

   $cd /mnt/BOOT
   $cp socfpga_arria10_socdk_ad9081/u-boot.img .
   $cp socfpga_arria10_socdk_ad9081/fit_spl_fpga.itb .
   $mkdir -p extlinux
   $cp socfpga_arria10_socdk_ad9081/extlinux.conf extlinux/
   $cp socfpga_arria10_socdk_ad9081/socfpga_arria10_socdk_sdmmc.dtb .
   $cp socfpga_arria10_common/zImage .

Writing the boot preloader partition requires special attention,
first look for the device with BOOT mountpoint and annotate the third partition
from the same device:

.. shell:: bash

   $lsblk

Then, clear the partition with zeros and write the preloader image
(in this example, Arria10 SoC's *./u-boot-splx4.sfp*):

.. shell:: bash
   :no-path:

   $DEV=mmcblk0p3
   $cd /mnt/BOOT/socfpga_arria10_socdk_ad9081
   $sudo dd if=/dev/zero of=/dev/$DEV oflag=sync status=progress \
   $    bs=$(sudo blockdev --getsize64 /dev/$DEV) count=1
    1+0 records in
    1+0 records out
    8388608 bytes (8.4 MB, 8.0 MiB) copied, 0.359183 s, 23.4 MB/s
   $sudo dd if=./u-boot-splx4.sfp of=/dev/$DEV oflag=sync status=progress bs=64k
    1697+1 records in
    1697+1 records out
    868996 bytes (869 kB, 849 KiB) copied, 0.21262 s, 4.1 MB/s

.. tip::

   The snippet below can infer the device based on the *BOOT* partition
   mountpoint

   .. shell:: bash

      $DEV=$(lsblk | sed -n 's/.*\(\b[s][d-z][a-z][0-9]\)\s*.*\/BOOT/\1/p' | sed 's/^\(...\).*/\1/')
      $if [ -z "$DEV" ] ; then \
      $   echo BOOT not found, couldn\'t infer block device ; \
      $else \
      $   echo The preloader image partition path likely is /dev/"$DEV"3 ; \
      $fi

Examples of building the boot image
-------------------------------------------------------------------------------

This is a list of projects supported by us for each carrier. The purpose is to
illustrate how to build the different files involved in the process. Each
project has its own characteristics (some files may differ from one project to
the other).

.. note::

   Each project has its own Linux Kernel Image & Devicetree which needs to be
   built. Follow these instructions to write the file to your SD card, depending
   on the operating system that you use (Windows or Linux):

   - :dokuwiki:`[Wiki] Building the Intel SoC-FPGA kernel and devicetrees from source <resources/tools-software/linux-build/generic/socfpga>`
   - :dokuwiki:`[Wiki] Linux Download and setting up the image <resources/tools-software/linux-software/zynq_images/linux_hosts>`
   - :dokuwiki:`[Wiki] Formatting and Flashing SD Cards using Windows <resources/tools-software/linux-software/zynq_images/windows_hosts>`

Proceed by cloning the repository, setting the environment to an ARM architecture
cross compiler, build the configuration file, build the Kernel image, and
lastly build the device tree (specific to each combination of carrier and eval
board).

You may notice that in the ``export CROSS_COMPILE`` examples there is a
"trailing" dash ``-``. That is because within the Makeiles, this path becomes
/path/to/arm-linux-gnueabihf-gcc (with ``gcc`` appended).

.. shell:: bash

   $export CROSS_COMPILE=/path/to/arm-linux-gnueabihf-


If your environment already has the compiler in the path
(test if :code:`which arm-linux-gnueabihf-gcc` returns the expected path),
you can set ``CROSS_COMPILE`` to:

.. shell:: bash

   $export CROSS_COMPILE=arm-linux-gnueabihf-

The difference between ``arm-linux-gnueabi-gcc`` and
``arm-linux-gnueabihf-gcc`` is that the latter has hardware floating-point
support and may not be available in your default package manager.

.. caution::

   Pay attention to the Quartus version. Based on these versions, different
   u-boot branches should be checked out.  In the coming examples, we used the
   latest Quartus version available so the corresponding u-boot branches
   were checked-out.

.. _build_intel_boot_image arria10:

ADRV9371/Arria 10
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- HDL Project: :git-hdl:`projects/adrv9371x/a10soc`
- ADI's Linux kernel: :git-linux:`arch/arm/boot/dts/socfpga_arria10_socdk_adrv9371.dts`

Building the Linux Kernel image and the Devicetree
```````````````````````````````````````````````````````````````````````````````

**Linux/Cygwin/WSL**

.. shell:: bash

   $git clone https://github.com/analogdevicesinc/linux.git
   $cd linux/
   # Set architecture and compiler
   $export ARCH=arm
   $export CROSS_COMPILE=/path/to/arm-linux-gnueabihf-
   # Apply kconfig settings
   $make socfpga_adi_defconfig
   # Build the kernel
   $make zImage
   # Build the devicetree
   $make socfpga_arria10_socdk_adrv9371.dtb

Building the Hardware Design
```````````````````````````````````````````````````````````````````````````````

Clone the HDL repository, then build the project:

.. shell:: bash

   $git clone https://github.com/analogdevicesinc/hdl.git
   $cd hdl/projects/adrv9371x/a10soc
   $make

After the design is built, the resulting SRAM Object File (.sof) file shall be
converted to a Raw Binary File (.rbf).

If you skipped the last section, ensure to set the architecture and cross
compiler environment variables.

.. caution::

   Pay attention to directoy changes to where the commands are run from,
   and always confirm with ``pwd`` to show the current path at you terminal.

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/adrv9371x/a10soc ; pwd
    ~/hdl/projects/adrv9371x/a10soc
   $quartus_cpf -c --hps -o bitstream_compression=on \
   $    ./adrv9371x_a10soc.sof soc_system.rbf

Building the Preloader and Bootloader Image
```````````````````````````````````````````````````````````````````````````````

This flow applies starting with release :git-hdl:`2021_R1 <hdl_2021_r1:>` /
Quartus Pro version 20.1. For older versions of the flow see previous versions
of this page on wiki
:dokuwiki:`Altera SOC Quick Start Guide <resources/tools-software/linux-software/altera_soc_images>`.

In the HDL project directory, create the ``software/bootloader`` folder and
clone the ``u-boot-socfpga`` image:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/adrv9371x/a10soc ; pwd
    ~/hdl/projects/adrv9371x/a10soc
   $mkdir -p software/bootloader
   $cd software/bootloader
   $git clone https://github.com/altera-opensource/u-boot-socfpga.git

Then run the qts filter and build the preloader and bootloader images:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/adrv9371x/a10soc/software/bootloader ; pwd
    ~/hdl/projects/adrv9371x/a10soc/software/bootloader
   $cd u-boot-socfpga ; pwd
    ~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga
   $git checkout rel_socfpga_v2021.07_22.02.02_pr
   $./arch/arm/mach-socfpga/qts-filter-a10.sh ../../../hps_isw_handoff/hps.xml \
   $   arch/arm/dts/socfpga_arria10_socdk_sdmmc_handoff.h
   $make socfpga_arria10_defconfig
   $make

Create the SPL image:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga
   $ln -s ../../../soc_system.core.rbf .
   $ln -s ../../../soc_system.periph.rbf .
   $sed -i 's/ghrd_10as066n2/soc_system/g' board/altera/arria10-socdk/fit_spl_fpga.its
   $./tools/mkimage -E -f board/altera/arria10-socdk/fit_spl_fpga.its fit_spl_fpga.itb

Last but not least, create the **extlinux.conf** Linux configuration file,
which will be copied to /BOOT partition of the SD Card, in a folder
named ``extlinux``:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga
   $mkdir extlinux
   $printf "\
   $LABEL Linux Arria10 Default\n\
   $KERNEL ../zImage\n\
   $    FDT ../socfpga_arria10_socdk_sdmmc.dtb\n\
   $    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8" \
   $    > extlinux/extlinux.conf

Configuring the SD Card
```````````````````````````````````````````````````````````````````````````````

Below are the commands to create the preloader and bootloader partition using
the Kuiper Linux image as a starting point.
Please check every command before running, especially configuring target
device mountpoints accordingly
(here as ``/dev/sdz`` with partition 1 mounted at ``/media/BOOT/``).

Flash the SD Card with the Kuiper Linux image:

.. shell:: bash

   $time sudo dd if=./2023-12-13-ADI-Kuiper-full.img of=/dev/sdz status=progress bs=4194304
    2952+0 records in
    2952+0 records out
    12381585408 bytes (12 GB, 12 GiB) copied, 838.353 s, 14.8 MB/s

    real	14m7.938s
    user	0m0.006s
    sys	0m0.009s
   $sync

Mount the /BOOT partition:

.. shell:: bash
   :no-path:

   $lsblk
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sdz           8:48   1  29.1G  0 disk
    ├─sdz1        8:49   1     2G  0 part
    ├─sdz2        8:50   1  27.1G  0 part
    └─sdz3        8:51   1     8M  0 part

   $mkdir -p /media/BOOT/
   $sudo mount /dev/sdz1 /media/BOOT/
   $lsblk
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sdz           8:48   1  29.1G  0 disk
    ├─sdz1        8:49   1     2G  0 part /media/BOOT
    ├─sdz2        8:50   1  27.1G  0 part
    └─sdz3        8:51   1     8M  0 part

Copy the built files to the /BOOT partition:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/adrv9371x/a10soc ; pwd
    ~/hdl/projects/adrv9371x/a10soc
   $cp ./software/bootloader/u-boot-socfpga/u-boot.img /media/BOOT/
   $cp ./software/bootloader/u-boot-socfpga/fit_spl_fpga.itb /media/BOOT/
   $mkdir -p /media/BOOT/extlinux
   $cp ./software/bootloader/u-boot-socfpga/extlinux/extlinux.conf /media/BOOT/extlinux/
   ~
   $cp ~/linux/arch/arm/boot/dts/socfpga_arria10_socdk_sdmmc.dtb /media/BOOT/
   $cp ~/linux/arch/arm/boot/zImage /media/BOOT/

Unmount the /BOOT partition:

.. shell:: bash
   :no-path:

   $sudo umount /dev/sdz1
   $lsblk
    NAME        MAJ:MIN RM  SIZE  RO TYPE MOUNTPOINT
    sdz           8:48  1   29.1G  0 disk
    ├─sdz1        8:49  1      2G  0 part
    ├─sdz2        8:50  1   27.1G  0 part
    └─sdz3        8:51  1      8M  0 part

Flash the preloader boot partition:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga
   $sudo dd if=/dev/zero of=/dev/sdz3 oflag=sync status=progress \
   $    bs=$(sudo blockdev --getsize64 /dev/sdz3) count=1
    1+0 records in
    1+0 records out
    8388608 bytes (8.4 MB, 8.0 MiB) copied, 0.359183 s, 23.4 MB/s
   $sudo dd if=./u-boot-splx4.sfp of=/dev/sdz3
    1697+1 records in
    1697+1 records out
    868996 bytes (869 kB, 849 KiB) copied, 0.21262 s, 4.1 MB/s

.. _build_intel_boot_image c5soc:

ARRADIO/Terasic C5 SoC
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- HDL Project: :git-hdl:`projects/arradio/c5soc`
- ADI's Linux kernel: :git-linux:`arch/arm/boot/dts/socfpga_cyclone5_sockit_arradio.dts`

Building the Linux Kernel image and the Devicetree
```````````````````````````````````````````````````````````````````````````````

**Linux/Cygwin/WSL**

.. shell:: bash

   $git clone https://github.com/analogdevicesinc/linux.git
   $cd linux/
   # Set architecture and compiler
   $export ARCH=arm
   $export CROSS_COMPILE=/path/to/arm-linux-gnueabihf-
   # Apply kconfig settings
   $make socfpga_adi_defconfig
   # Build the kernel
   $make zImage
   # Build the devicetree
   $make socfpga_cyclone5_sockit_arradio.dtb

Building the Hardware Design
```````````````````````````````````````````````````````````````````````````````

Clone the HDL repository, then build the project:

.. shell:: bash

   $git clone https://github.com/analogdevicesinc/hdl.git
   $cd hdl/projects/arradio/c5soc
   $make

After the design is built, the resulting SRAM Object File (.sof) file shall be
converted to a Raw Binary File (.rbf).

If you skipped the last section, ensure to set the architecture and cross
compiler environment variables.

.. caution::

   Pay attention to directory changes to where the commands are run from,
   and always confirm with ``pwd`` to show the current path at you terminal.

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/arradio/c5soc ; pwd
    ~/hdl/projects/arradio/c5soc
   $quartus_cpf -c -o bitstream_compression=on --hps \
   $    ./arradio_c5soc.sof soc_system.rbf

Building the Preloader and Bootloader Image
```````````````````````````````````````````````````````````````````````````````

This flow applies starting with release :git-hdl:`2021_R1 <hdl_2021_r1:>` /
Quartus Pro version 20.1. For older versions of the flow see previous versions
of this page on wiki
:dokuwiki:`Altera SOC Quick Start Guide <resources/tools-software/linux-software/altera_soc_images>`.

In the HDL project directory, create the ``software/bootloader`` folder and
clone the ``u-boot-socfpga`` image. Before that, create a new BSP settings file:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/arradio/c5soc ; pwd
    ~/hdl/projects/arradio/c5soc
   $mkdir -p software/bootloader
   $embedded_command_shell.sh bsp-create-settings --type spl \
   $    --bsp-dir software/bootloader \
   $    --preloader-settings-dir "hps_isw_handoff/system_bd_sys_hps" \
   $    --settings software/bootloader/settings.bsp
   $cd software/bootloader ; pwd
    ~/hdl/projects/arradio/c5soc/software/bootloader
   $git clone https://github.com/altera-opensource/u-boot-socfpga.git
   $git checkout socfpga_v2021.10

Then run the qts filter and build the preloader and bootloader images:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/arradio/c5soc/software/bootloader ; pwd
    ~/hdl/projects/arradio/c5soc/software/bootloader
   $cd u-boot-socfpga ; pwd
    ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga
   $./arch/arm/mach-socfpga/qts-filter.sh cyclone5 ../../../../../board/altera/cyclone5-socdk/qts/
   $make socfpga_cyclone5_defconfig
   $make

Make u-boot.scr file - this file shall be copied to /BOOT partition of the SD Card:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga
   $echo "load mmc 0:1 \${loadaddr} soc_system.rbf;" > u-boot.txt
   $echo "fpga load 0 \${loadaddr} \$filesize;" >> u-boot.txt
   $./tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Cyclone V script" -d u-boot.txt u-boot.scr

Last but not least, create the **extlinux.conf** Linux configuration file,
which will be copied to /BOOT partition of the SD Card, in a folder
named ``extlinux``:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga
   $mkdir extlinux
   $printf "\
   $LABEL Linux C5 SoC Default\n\
   $KERNEL ../zImage\n\
   $    FDT ../socfpga.dtb\n\
   $    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8" \
   $    > extlinux/extlinux.conf

Jumper setup
```````````````````````````````````````````````````````````````````````````````

Here is the jumper configuration for ARRADIO/C5SoC to boot the image from the
SD Card:

.. list-table::
   :widths: 50 50
   :header-rows: 1

   * - Jumper
     - Position
   * - CLOCKSEL0
     - 2-3
   * - CLOCKSEL1
     - 2-3
   * - BOOTSEL0
     - 2-3
   * - BOOTSEL1
     - 2-3
   * - BOOTSEL2
     - 1-2
   * - MSEL0
     - 0
   * - MSEL1
     - 1
   * - MSEL2
     - 0
   * - MSEL3
     - 1
   * - MSEL4
     - 0
   * - CODEC_SEL
     - 0

And **set JP2 to 2.5V or 1.8V**.

Configuring the SD Card
```````````````````````````````````````````````````````````````````````````````

Below are the commands to create the preloader and bootloader partition using
the Kuiper Linux image as a starting point.
Please check every command before running, especially configuring target
device mountpoints accordingly
(here as ``/dev/sdz`` with partition 1 mounted at ``/media/BOOT/``).

Flash the SD Card with the Kuiper Linux image:

.. shell:: bash

   $time sudo dd if=./2023-12-13-ADI-Kuiper-full.img of=/dev/sdz status=progress bs=4194304
    2952+0 records in
    2952+0 records out
    12381585408 bytes (12 GB, 12 GiB) copied, 838.353 s, 14.8 MB/s

    real	14m7.938s
    user	0m0.006s
    sys	0m0.009s
   $sync

Mount the /BOOT partition:

.. shell:: bash
   :no-path:

   $lsblk
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sdz           8:48   1  29.1G  0 disk
    ├─sdz1        8:49   1     2G  0 part
    ├─sdz2        8:50   1  27.1G  0 part
    └─sdz3        8:51   1     8M  0 part

   $mkdir -p /media/BOOT/
   $sudo mount /dev/sdz1 /media/BOOT/
   $lsblk
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sdz           8:48   1  29.1G  0 disk
    ├─sdz1        8:49   1     2G  0 part /media/BOOT
    ├─sdz2        8:50   1  27.1G  0 part
    └─sdz3        8:51   1     8M  0 part

Copy the built files to the /BOOT partition:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/arradio/c5soc ; pwd
    ~/hdl/projects/arradio/c5soc
   $cp ./software/bootloader/u-boot-socfpga/u-boot.scr /media/BOOT/
   $cp soc_system.rbf /media/BOOT/
   $mkdir -p /media/BOOT/extlinux
   $cp ./software/bootloader/u-boot-socfpga/extlinux/extlinux.conf /media/BOOT/extlinux/
   ~
   $cp ~/linux/arch/arm/boot/dts/socfpga_cyclone5_sockit_arradio.dtb /media/BOOT/socfpga.dtb
   $cp ~/linux/arch/arm/boot/zImage /media/BOOT/

Unmount the /BOOT partition:

.. shell:: bash
   :no-path:

   $sudo umount /dev/sdz1
   $lsblk
    NAME        MAJ:MIN RM  SIZE  RO TYPE MOUNTPOINT
    sdz           8:48  1   29.1G  0 disk
    ├─sdz1        8:49  1      2G  0 part
    ├─sdz2        8:50  1   27.1G  0 part
    └─sdz3        8:51  1      8M  0 part

Flash the preloader boot partition:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga
   $sudo dd if=/dev/zero of=/dev/sdz3 oflag=sync status=progress \
   $    bs=$(sudo blockdev --getsize64 /dev/sdz3) count=1
    1+0 records in
    1+0 records out
    8388608 bytes (8.4 MB, 8.0 MiB) copied, 0.359183 s, 23.4 MB/s
   $sudo dd if=./u-boot-with-spl.sfp of=/dev/sdz3
    1697+1 records in
    1697+1 records out
    868996 bytes (869 kB, 849 KiB) copied, 0.21262 s, 4.1 MB/s

.. _build_intel_boot_image de10nano:

CN0540/DE10Nano
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- HDL Project: :git-hdl:`projects/cn0540/de10nano`
- ADI's Linux kernel: :git-linux:`arch/arm/boot/dts/socfpga_cyclone5_de10_nano_cn0540.dts`

Building the Linux Kernel image and the Devicetree
```````````````````````````````````````````````````````````````````````````````

**Linux/Cygwin/WSL**

.. shell:: bash

   $git clone https://github.com/analogdevicesinc/linux.git
   $cd linux/
   # Set architecture and compiler
   $export ARCH=arm
   $export CROSS_COMPILE=/path/to/arm-linux-gnueabihf-
   # Apply kconfig settings
   $make socfpga_adi_defconfig
   # Build the kernel
   $make zImage
   # Build the devicetree
   $make socfpga_cyclone5_de10_nano_cn0540.dtb

Building the Hardware Design
```````````````````````````````````````````````````````````````````````````````

Clone the HDL repository, then build the project:

.. shell:: bash

   $git clone https://github.com/analogdevicesinc/hdl.git
   $cd hdl/projects/cn0540/de10nano
   $make

After the design is built, the resulting SRAM Object File (.sof) file shall be
converted to a Raw Binary File (.rbf).

If you skipped the last section, ensure to set the architecture and cross
compiler environment variables.

.. caution::

   Pay attention to directory changes to where the commands are run from,
   and always confirm with ``pwd`` to show the current path at you terminal.

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/cn0540/de10nano ; pwd
    ~/hdl/projects/cn0540/de10nano
   $quartus_cpf -c -o bitstream_compression=on \
   $    ./cn0540_de10nano.sof soc_system.rbf

Building the Preloader and Bootloader Image
```````````````````````````````````````````````````````````````````````````````

This flow applies starting with release :git-hdl:`2021_R1 <hdl_2021_r1:>` /
Quartus Pro version 20.1. For older versions of the flow see previous versions
of this page on wiki
:dokuwiki:`Altera SOC Quick Start Guide <resources/tools-software/linux-software/altera_soc_images>`.

In the HDL project directory, create the ``software/bootloader`` folder and
clone the ``u-boot-socfpga`` image. Before that, create a new BSP settings file:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/cn0540/de10nano ; pwd
    ~/hdl/projects/cn0540/de10nano
   $mkdir -p software/bootloader
   $embedded_command_shell.sh bsp-create-settings --type spl \
   $    --bsp-dir software/bootloader \
   $    --preloader-settings-dir "hps_isw_handoff/system_bd_sys_hps" \
   $    --settings software/bootloader/settings.bsp
   $cd software/bootloader ; pwd
    ~/hdl/projects/cn0540/de10nano/software/bootloader
   $git clone https://github.com/altera-opensource/u-boot-socfpga.git
   $git checkout socfpga_v2021.10

Then run the qts filter and build the preloader and bootloader images:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/cn0540/de10nano/software/bootloader ; pwd
    ~/hdl/projects/cn0540/de10nano/software/bootloader
   $cd u-boot-socfpga ; pwd
    ~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga
   $./arch/arm/mach-socfpga/qts-filter.sh cyclone5 ../../../../../board/altera/cyclone5-socdk/qts/
   $make socfpga_cyclone5_defconfig
   $make

Make u-boot.scr file - this file shall be copied to /BOOT partition of the SD Card:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga
   $echo "load mmc 0:1 \${loadaddr} soc_system.rbf;" > u-boot.txt
   $echo "fpga load 0 \${loadaddr} \$filesize;" >> u-boot.txt
   $./tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Cyclone V script" -d u-boot.txt u-boot.scr

Last but not least, create the **extlinux.conf** Linux configuration file,
which will be copied to /BOOT partition of the SD Card, in a folder
named ``extlinux``:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga
   $mkdir extlinux
   $printf "\
   $LABEL Linux DE10Nano Default\n\
   $KERNEL ../zImage\n\
   $    FDT ../socfpga.dtb\n\
   $    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8" \
   $    > extlinux/extlinux.conf

Configuring the SD Card
```````````````````````````````````````````````````````````````````````````````

Below is the commands to create the preloader and bootloader partition using
the Kuiper Linux image as a starting point.
Please check every command before running, especially configuring target
device mountpoints accordingly
(here as ``/dev/sdz`` with partition 1 mounted at ``/media/BOOT/``).

Flash the SD Card with the Kuiper Linux image:

.. shell:: bash

   $time sudo dd if=./2023-12-13-ADI-Kuiper-full.img of=/dev/sdz status=progress bs=4194304
    2952+0 records in
    2952+0 records out
    12381585408 bytes (12 GB, 12 GiB) copied, 838.353 s, 14.8 MB/s

    real	14m7.938s
    user	0m0.006s
    sys	0m0.009s
   $sync

Mount the /BOOT partition:

.. shell:: bash
   :no-path:

   $lsblk
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sdz           8:48   1  29.1G  0 disk
    ├─sdz1        8:49   1     2G  0 part
    ├─sdz2        8:50   1  27.1G  0 part
    └─sdz3        8:51   1     8M  0 part

   $mkdir -p /media/BOOT/
   $sudo mount /dev/sdz1 /media/BOOT/
   $lsblk
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sdz           8:48   1  29.1G  0 disk
    ├─sdz1        8:49   1     2G  0 part /media/BOOT
    ├─sdz2        8:50   1  27.1G  0 part
    └─sdz3        8:51   1     8M  0 part

Copy the built files to the /BOOT partition:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/cn0540/de10nano ; pwd
    ~/hdl/projects/cn0540/de10nano
   $cp ./software/bootloader/u-boot-socfpga/u-boot.scr /media/BOOT/
   $cp soc_system.rbf /media/BOOT/
   $mkdir -p /media/BOOT/extlinux
   $cp ./software/bootloader/u-boot-socfpga/extlinux/extlinux.conf /media/BOOT/extlinux/
   ~
   $cp ~/linux/arch/arm/boot/dts/socfpga_cyclone5_de10_nano_cn0540.dtb /media/BOOT/socfpga.dtb
   $cp ~/linux/arch/arm/boot/zImage /media/BOOT/

Unmount the /BOOT partition:

.. shell:: bash
   :no-path:

   $sudo umount /dev/sdz1
   $lsblk
    NAME        MAJ:MIN RM  SIZE  RO TYPE MOUNTPOINT
    sdz           8:48  1   29.1G  0 disk
    ├─sdz1        8:49  1      2G  0 part
    ├─sdz2        8:50  1   27.1G  0 part
    └─sdz3        8:51  1      8M  0 part

Flash the preloader boot partition:

.. shell:: bash
   :no-path:

   $cd ~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga ; pwd
    ~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga
   $sudo dd if=/dev/zero of=/dev/sdz3 oflag=sync status=progress \
   $    bs=$(sudo blockdev --getsize64 /dev/sdz3) count=1
    1+0 records in
    1+0 records out
    8388608 bytes (8.4 MB, 8.0 MiB) copied, 0.359183 s, 23.4 MB/s
   $sudo dd if=./u-boot-with-spl.sfp of=/dev/sdz3
    1697+1 records in
    1697+1 records out
    868996 bytes (869 kB, 849 KiB) copied, 0.21262 s, 4.1 MB/s
   $sync

.. _build_intel_boot_image fm87:

AD9081/Agilex 7
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- HDL Project: :git-hdl:`projects/ad9081_fmca_ebz/fm87`
- ADI's Linux kernel: :git-linux:`../agilex/arch/arm64/boot/dts/intel/socfpga_agilex_socdk_ad9081_jesd204c.dts`

Get aarch64-none-linux-gnu and set CROSS_COMPILE and ARCH variables
```````````````````````````````````````````````````````````````````````````````

.. shell:: bash
   :no-path:

   $mkdir tools
   $cd tools
   $wget https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz
   $tar xvf gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu.tar.xz
   $export CROSS_COMPILE=`pwd`/gcc-arm-10.3-2021.07-x86_64-aarch64-none-linux-gnu/bin/aarch64-none-linux-gnu-
   $export ARCH=arm64
   $cd ..

Building the Linux Kernel image and the Devicetree
```````````````````````````````````````````````````````````````````````````````

.. shell:: bash
   :no-path:

   $git clone -b agilex https://github.com/analogdevicesinc/linux
   $cd linux
   $make adi_zynqmp_defconfig
   $make Image
   $make intel/socfpga_agilex_socdk_ad9081_jesd204c.dtb
   $cd ..

Build the ARM Trusted Firmware
```````````````````````````````````````````````````````````````````````````````

.. shell:: bash
   :no-path:

   $git clone -b QPDS24.1_REL_GSRD_PR https://github.com/altera-opensource/arm-trusted-firmware
   $cd arm-trusted-firmware
   $make bl31 PLAT=agilex DEPRECATED=1
   $cd ..

Build U-Boot
```````````````````````````````````````````````````````````````````````````````

.. shell:: bash
   :no-path:

   $git clone -b QPDS24.1_REL_GSRD_PR https://github.com/altera-opensource/u-boot-socfpga
   $cd u-boot-socfpga
   $ln -sf ../arm-trusted-firmware/build/agilex/release/bl31.bin .
   $sed -i 's/earlycon panic=-1/earlycon panic=-1 console=ttyS0,115200 root=\/dev\/mmcblk0p2 rw rootwait/g' configs/socfpga_agilex_defconfig
   $sed -i '/^CONFIG_NAND_BOOT=y/d' configs/socfpga_agilex_defconfig
   $sed -i '/^CONFIG_SPL_NAND_SUPPORT=y/d' configs/socfpga_agilex_defconfig
   $sed -i '/^CONFIG_CMD_UBI=y/d' configs/socfpga_agilex_defconfig
   $echo 'CONFIG_USE_BOOTCOMMAND=y' >> configs/socfpga_agilex_defconfig
   $echo 'CONFIG_BOOTCOMMAND="load mmc 0:1 \${loadaddr} agilex.core.rbf; bridge disable; fpga load 0 \${loadaddr} \${filesize}; bridge enable; load mmc 0:1 ${kernel_addr_r} Image; load mmc 0:1 ${fdt_addr_r} socfpga_agilex_socdk.dtb; booti ${kernel_addr_r} - ${fdt_addr_r}"' >> configs/socfpga_agilex_defconfig
   $make socfpga_agilex_defconfig
   $make
   $cd ..

Building the Hardware Design
```````````````````````````````````````````````````````````````````````````````

Clone the HDL repository, then build the project:

.. shell:: bash
   :no-path:

   $git clone https://github.com/analogdevicesinc/hdl.git
   $cd projects/ad9081_fmca_ebz/fm87
   $make
   Building ad9081_fmca_ebz_fm87 [/home/analog/hdl/projects/ad9081_fmca_ebz/fm87/ad9081_fmca_ebz_fm87_quartus.log] ... OK

After the design is built, the resulting SRAM Object File (.sof) file shall be converted to a Raw Binary File (.rbf)
and a Jtag Indirect Configuration (.jic) file.

If you skipped the last section, ensure to set the architecture and cross compiler environment variables and have the U-boot files built.

.. shell:: bash
   :no-path:

   $quartus_pfg -c ad9081_fmca_ebz_fm87.sof ad9081_fmca_ebz_fm87.jic \
   $  -o hps_path=../../../../u-boot-socfpga/spl/u-boot-spl-dtb.hex \
   $  -o device=MT25QU02G \
   $  -o flash_loader=AGIB027R31B1E1V \
   $  -o mode=ASX4 \
   $  -o hps=1

Configuring the SD Card
```````````````````````````````````````````````````````````````````````````````

Below are the commands to create the preloader and bootloader partition using
the Kuiper Linux image as a starting point.
Please check every command before running, especially configuring target
device mountpoints accordingly
(here as ``/dev/sdz`` with partition 1 mounted at ``/media/BOOT/``).

Flash the SD Card with the Kuiper Linux image:

.. shell:: bash

   $time sudo dd if=./2023-12-13-ADI-Kuiper-full.img of=/dev/sdz status=progress bs=4194304
    2952+0 records in
    2952+0 records out
    12381585408 bytes (12 GB, 12 GiB) copied, 838.353 s, 14.8 MB/s

    real	14m7.938s
    user	0m0.006s
    sys	0m0.009s
   $sync

Mount the /BOOT partition:

.. shell:: bash
   :no-path:

   $lsblk
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sdz           8:48   1  29.1G  0 disk
    ├─sdz1        8:49   1     2G  0 part
    ├─sdz2        8:50   1  27.1G  0 part
    └─sdz3        8:51   1     8M  0 part

   $mkdir -p /media/BOOT/
   $sudo mount /dev/sdz1 /media/BOOT/
   $lsblk
    NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
    sdz           8:48   1  29.1G  0 disk
    ├─sdz1        8:49   1     2G  0 part /media/BOOT
    ├─sdz2        8:50   1  27.1G  0 part
    └─sdz3        8:51   1     8M  0 part

Copy the built files to the /BOOT partition:

.. shell:: bash
   :no-path:

   $cp u-boot-socfpga/u-boot.itb /media/BOOT/
   $cp linux/arch/arm64/boot/Image /media/BOOT/
   $cp linux/arch/arm64/boot/dts/intel/socfpga_agilex_socdk_ad9081_jesd204c.dtb /media/BOOT/socfpga_agilex_socdk.dtb
   $cp hdl/projects/ad9081_fmca_ebz/fm87/ad9081_fmca_ebz_fm87.core.rbf /media/BOOT/agilex.core.rbf

Unmount the /BOOT partition:

.. shell:: bash
   :no-path:

   $sudo umount /dev/sdz1
   $lsblk
    NAME        MAJ:MIN RM  SIZE  RO TYPE MOUNTPOINT
    sdz           8:48  1   29.1G  0 disk
    ├─sdz1        8:49  1      2G  0 part
    ├─sdz2        8:50  1   27.1G  0 part
    └─sdz3        8:51  1      8M  0 part

Programming steps
```````````````````````````````````````````````````````````````````````````````

- Set **S9** to JTAG
- Power on the FPGA
- Open the Quartus Programmer and flash the ad9081_fmca_ebz_fm87.jic
- Power off the FPGA
- Set **S9** to QSPI
- Insert the SD-card and power up the board

**S9** 4-bit DIP Switch

========== =====  =====  =====  =====
Switch Bit 1      2      3      4
Name       MSEL0  MSEL1  MSEL2  MSEL3
JTAG Mode  ON     ON     ON     OFF
QSPI Mode  ON     OFF    OFF    OFF
========== =====  =====  =====  =====

Default Switch Positions for the AD9081 project

================ =====  =====  =====  =====
4-bit DIP Switch 1      2      3      4
S4               ON     ON     ON     ON
S15              ON     ON     ON     OFF
S10              ON     ON     ON     ON
S23              ON     ON     ON     ON
S6               OFF    OFF    OFF    OFF
S1               OFF    OFF    OFF    OFF
S22              OFF    ON     ON     ON
S19              OFF    OFF    ON     ON
S20              ON     ON     ON     ON
================ =====  =====  =====  =====
