.. _build_intel_boot_bin:

Generating HDL boot image for Intel projects
===============================================================================

This page is dedicated to the building process of boot image for supported
Intel/Altera projects. One of the key files that is specific to this
projects is the ``bootloader``. It's role is to initialize the system after the
BootROM runs. It bridges the gap between the limited functionality of the
BootROM and the end user application, configuring the system as needed before
the larger application can run


In the following links you can find more details on the process and the necessary components:

-  `Booting and Configuration <https://www.intel.com/content/dam/support/us/en/programmable/support-resources/bulk-container/pdfs/literature/hb/arria-v/av-5400a.pdf>`__
-  `SocBootFromFPGA <https://community.intel.com/t5/FPGA-Wiki/SocBootFromFPGA/ta-p/735773>`__
-  `Intel Bootloader <https://www.intel.com/content/www/us/en/support/programmable/support-resources/design-guidance/soc-bootloader.html>`__

Necessary files for booting up a HDL project
-------------------------------------------------------------------------------

.. warning::
   
   We **do not** provide any scripts to automate this process, so please read
   carefully and follow all the steps to obtain the boot file.

When booting a system with Linux + HDL (depending on the project), you will need
to write the following files on the root of the BOOT FAT32 partition. After that,
you must write the **preloader image** in a specific card partition, depending on
the case. 

-  For Arria10 SoC projects:

   -  ``socfpga_arria10-common/zImage``
   -  ``<target>/fit_spl_fpga.itb``
   -  ``<target>/socfpga_arria10_socdk_sdmmc.dtb``
   -  ``<target>/u-boot.img``
   -  ``<target>/extlinux.conf → extlinux /extlinux.conf``
   -  ``<target>/u-boot-splx4.sfp`` to the corresponding SD card partition
      (e.g. ``dd if=preloader_bootloader.bin of=/dev/mmcblk0p3``,
      usually it is the 3rd partition, which is only a couple of MB in size)

-  For Cyclone5 SoC projects:

   -  ``<target>/soc_system.rbf``
   -  ``<target>/socfpga.dtb``
   -  ``<target>/uImage``
   -  ``<target>/preloader_bootloader.img`` to the corresponding SD card
      partition (e.g. ``dd if=preloader_bootloader.img of=/dev/mmcblk0p3``)

-  For De10Nano SoC project:

   -  ``socfpga_cyclone5_common/zImage``
   -  ``<target>/extlinux.conf → extlinux /extlinux.conf``
   -  ``<target>/u-boot.scr``
   -  ``<target>/socfpga.dtb``
   -  ``<target>/soc_system.rbf``
   -  ``<target>/u-boot-with-spl.sfp`` to the corresponding SD card partition
      (e.g. ``dd if=u-boot-with-spl.sfp of=/dev/sdd3``)

Examples of building the boot image
-------------------------------------------------------------------------------

This is a list of projects supported by us for each carrier. The purpose is to
illustrate how to build and showcase the different files that are involved in
the process. Each project has its own characteristics (some files may differ
from one project to the other).

.. note::

   Each project has its own specific Linux Kernel Image & Devicetree to be
   build. Follow these instructions to write the file to your SD card, depending
   on the operating system that you use (Windows or Linux):

   -  :dokuwiki:`[Wiki] Building the Intel SoC-FPGA kernel and devicetrees from source <resources/tools-software/linux-build/generic/socfpga>`
   -  :dokuwiki:`[Wiki] Linux Download and setting up the image <resources/tools-software/linux-software/zynq_images/linux_hosts>`
   -  :dokuwiki:`[Wiki] Formatting and Flashing SD Cards using Windows <resources/tools-software/linux-software/zynq_images/windows_hosts>`

Proceed by cloning the kernel tree, point environment to an arm architecture
cross compiler, build the configuration file, build the image, and lastly build
the project and board specific device tree.

ADRV9371/Arria10
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  HDL Project: :git-hdl:`here <projects/adrv9371x/a10soc>`
-  Linux kernel: :git-linux:`here <>`

Building the Linux Kernel image and the Devicetree
```````````````````````````````````````````````````````````````````````````````

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ git clone https://github.com/analogdevicesinc/linux.git
   user@analog:~$ cd linux/
   user@analog:~/linux$ export ARCH=arm
   user@analog:~/linux$ export CROSS_COMPILE=/path_to_cross_compiler/arm-linux-gnueabihf
   user@analog:~/linux$ make socfpga_adi_defconfig
   user@analog:~/linux$ make zImage
   user@analog:~/linux$ make socfpga_arria10_socdk_adrv9371.dtb

Building the Hardware Design
```````````````````````````````````````````````````````````````````````````````

If you skipped the instruction on “Building the Linux Kernel image and the
Devicetree” above, it is still necessary to do the step regarding cross 
compilers. Pay attention to change directory to where the project is located.
Clone the HDL repository if it does not exist yet in local directory. Then build
the project.

.. code-block::

   user@analog:~$ git clone https:github.com/analogdevicesinc/hdl.git 
   user@analog:~$ cd hdl/projects/adrv9371x/a10soc
   user@analog:~/hdl$ make

After the design was built, the resulted SRAM Object File (.sof) file shall be
converted to a Raw Binary File (.rbf).

.. code-block::

   user@analog:~/hdl/projects/adrv9371x/a10soc$ quartus_cpf -c --hps -o bitstream_compression=on ./adrv9371x_a10soc.sof soc_system.rbf

Building the Preloader and Bootloader Image
```````````````````````````````````````````````````````````````````````````````

This flow applies starting with release 2021_R1 / Quartus Pro version 20.1.
For older versions of the flow see previous versions of this page on wiki :dokuwiki:`Altera SOC Quick Start Guide <resources/tools-software/linux-software/altera_soc_images>`.
In HDL project directory, create the software/bootloader folder and clone the
``u-boot-socfpga`` image:

.. code-block::

   user@analog:~/hdl/projects/adrv9371x/a10soc$ mkdir -p software/bootloader
   user@analog:~/hdl/projects/adrv9371x/a10soc$ cd software/bootloader
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader$ git clone https://github.com/altera-opensource/u-boot-socfpga.git

Then run the qts filter and build the preloader and bootloader images:

.. code-block::
   
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader$ cd u-boot-socfpga
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ git checkout rel_socfpga_v2021.07_22.02.02_pr
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ ./arch/arm/mach-socfpga/qts-filter-a10.sh ../../../hps_isw_handoff/hps.xml arch/arm/dts/socfpga_arria10_socdk_sdmmc_handoff.h
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ make socfpga_arria10_defconfig
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ make

Create the SPL image:

.. code-block::
   
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ ln -s ../../../soc_system.core.rbf .
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ ln -s ../../../soc_system.periph.rbf .
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ sed -i 's/ghrd_10as066n2/soc_system/g' board/altera/arria10-socdk/fit_spl_fpga.its
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ ./tools/mkimage -E -f board/altera/arria10-socdk/fit_spl_fpga.its fit_spl_fpga.itb

Last but not least, create the extlinux.conf linux configuration file. This
extlinux folder shall be copied to /BOOT partition of the SD Card

.. code-block::
   
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ mkdir extlinux
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ echo "    LABEL Linux Default" } > extlinux/extlinux.conf
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ echo "    KERNEL ../zImage" >> extlinux/extlinux.conf
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ echo "    FDT ../socfpga_arria10_socdk_sdmmc.dtb" >> extlinux/extlinux.conf
   user@analog:~/hdl/projects/adrv9371x/a10soc/software/bootloader/u-boot-socfpga$ echo "    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8" >> extlinux/extlinux.conf

Creating the Preloader and Bootloader partition
```````````````````````````````````````````````````````````````````````````````

.. code-block::

   user@analog:~$ time sudo dd if=2022-07-08-ADI-Kuiper-full.img of=/dev/mmcblk0 bs=4194304
   1895+0 records in
   1895+0 records out
   7948206080 bytes (7.9 GB) copied, 503.909 s, 15.8 MB/s
   
   real	8m23.919s
   user	0m0.020s
   sys	0m6.376s
   user@analog:~$ sync
   user@analog:~$ sudo fdisk /dev/mmcblk0 
   
   Welcome to fdisk (util-linux 2.25.2).
   
   Command (m for help): p
   Disk /dev/mmcblk0: 14.9 GiB, 15931539456 bytes, 31116288 sectors
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disklabel type: dos
   Disk identifier: 0x00096174
   
   Device         Boot    Start      End  Sectors  Size Id Type
   /dev/mmcblk0p1          8192  1056767  1048576  2.0G c W95 FAT32 (LBA)
   /dev/mmcblk0p2       1056768 14497791 13441024  6.4G 83 Linux
   /dev/mmcblk0p3      14497792 14499839     2048    1M a2 unknown
   
   
   Command (m for help): d
   Partition number (1-3, default 3): 3
   
   Partition 3 has been deleted.
   
   Command (m for help): n
   Partition type
      p   primary (2 primary, 0 extended, 2 free)
      e   extended (container for logical partitions)
   Select (default p): p
   Partition number (3,4, default 3): 3
   First sector (2048-31116287, default 2048): 4096
   Last sector, +sectors or +size{K,M,G,T,P} (4096-8191, default 8191): +1M
   
   Created a new partition 3 of type 'Linux' and of size 1 MiB.
   
   Command (m for help): t
   Partition number (1-3, default 3): 3
   Hex code (type L to list all codes): a2
   
   Changed type of partition 'Linux' to 'unknown'.
   
   Command (m for help): p
   Disk /dev/mmcblk0: 14.9 GiB, 15931539456 bytes, 31116288 sectors
   Units: sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disklabel type: dos
   Disk identifier: 0x00096174
   
   Device         Boot   Start      End  Sectors  Size Id Type
   /dev/mmcblk0p1         8192  1056767  1048576  2.0G  c W95 FAT32 (LBA)
   /dev/mmcblk0p2      1056768 14497791 13441024  6.4G 83 Linux
   /dev/mmcblk0p3         4096     6143     2048    1M a2 unknown
   
   Partition table entries are not in disk order.
   
   Command (m for help): w
   The partition table has been altered.
   
   The kernel still uses the old table. The new table will be used at the next reboot or after you run partprobe(8) or kpartx(8).
   
   user@analog:~$ sync
   user@analog:~$ time sudo dd if=uboot_w_dtb-mkpimage.bin of=/dev/mmcblk0p3
   2048+0 records in
   2048+0 records out
   1048576 bytes (1.0 MB) copied, 0.199898 s, 5.2 MB/s
   
   real	0m0.206s
   user	0m0.000s
   sys	0m0.004s
   user@analog:~$ sync

ARRADIO/Terasic
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  HDL Project: :git-hdl:`here <projects/arradio/c5soc>`
-  Linux kernel: :git-linux:`here <>`

Building the Linux Kernel image and the Devicetree
```````````````````````````````````````````````````````````````````````````````

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ git clone https://github.com/analogdevicesinc/linux.git
   user@analog:~$ cd linux/
   user@analog:~/linux$ export ARCH=arm
   user@analog:~/linux$ export CROSS_COMPILE=/path_to_cross_compiler/arm-linux-gnueabihfr
   user@analog:~/linux$ make socfpga_adi_defconfig
   user@analog:~/linux$ make zImage
   user@analog:~/linux$ make socfpga_cyclone5_sockit_arradio.dtb

Building the Hardware Design
```````````````````````````````````````````````````````````````````````````````

If you skipped the instruction on “Building the Linux Kernel image and the
Devicetree” above, it is still necessary to do the step regarding cross 
compilers. Pay attention to change directory to where the project is located.
Clone the HDL repository if it does not exist yet in local directory. Then build
the project.

.. code-block::

   user@analog:~$ git clone https:github.com/analogdevicesinc/hdl.git 
   user@analog:~$ cd hdl/projects/arradio/c5soc
   user@analog:~/hdl$ make

After the design was built, the resulted SRAM Object File (.sof) file shall be
converted to a Raw Binary File (.rbf).

.. code-block::

   user@analog:~/hdl/projects/arradio/c5soc$ quartus_cpf -c -o bitstream_compression=on ./arradio_c5soc.sof soc_system.rbf

Building the Preloader and Bootloader Image
```````````````````````````````````````````````````````````````````````````````

This flow applies starting with release 2021_R1 / Quartus Pro version 20.1.
For older versions of the flow see previous versions of this page on wiki :dokuwiki:`Altera SOC Quick Start Guide <resources/tools-software/linux-software/altera_soc_images>`.
In HDL project directory, create the software/bootloader folder and clone the
``u-boot-socfpga`` image. Before that create a new BSP settings file.

.. code-block::

   user@analog:~/hdl/projects/arradio/c5soc$ mkdir -p software/bootloader
   user@analog:~/hdl/projects/arradio/c5soc$ embedded_command_shell.sh bsp-create-settings --type spl --bsp-dir software/bootloader --preloader-settings-dir "hps_isw_handoff/system_bd_sys_hps" --settings software/bootloader/settings.bsp
   user@analog:~/hdl/projects/arradio/c5soc$ cd software/bootloader
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader$ git clone https://github.com/altera-opensource/u-boot-socfpga.git

Then run the qts filter and build the preloader and bootloader images:

.. code-block::
   
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader$ cd u-boot-socfpga
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ ./arch/arm/mach-socfpga/qts-filter.sh cyclone5 ../../../../../board/altera/cyclone5-socdk/qts/
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ make socfpga_arria10_defconfig
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ make

Make u-boot.scr file - this file shall be copied to /BOOT partition of the SD Card

.. code-block::
   
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ echo "load mmc 0:1 \${loadaddr} soc_system.rbf;" > u-boot.txt
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ echo "fpga load 0 \${loadaddr} \$filesize;" >> u-boot.txt
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ sed -i 's/ghrd_10as066n2/soc_system/g' board/altera/arria10-socdk/fit_spl_fpga.its
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ ./tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Cyclone V script" -d u-boot.txt u-boot.scr

Last but not least, create the extlinux.conf linux configuration file. This
extlinux folder shall be copied to /BOOT partition of the SD Card

.. code-block::
   
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ mkdir extlinux
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ echo "    LABEL Linux Default" } > extlinux/extlinux.conf
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ echo "    KERNEL ../zImage" >> extlinux/extlinux.conf
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ echo "    FDT ../socfpga.dtb" >> extlinux/extlinux.conf
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ echo "    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8" >> extlinux/extlinux.conf

Jumper setup
```````````````````````````````````````````````````````````````````````````````

.. list-table::
   :widths: 45 45
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

-  JP2: 2.5V or 1.8V

Creating the Preloader and Bootloader partition
```````````````````````````````````````````````````````````````````````````````

.. code-block::

   user@analog:~$ sudo fdisk /dev/sdb
   
   Command (m for help): p
   
   Disk /dev/sdb: 7948 MB, 7948206080 bytes
   245 heads, 62 sectors/track, 1021 cylinders, total 15523840 sectors
   Units = sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disk identifier: 0x00096174
   
      Device Boot      Start         End      Blocks   Id  System
   /dev/sdb1            8192      532479      262144    b  W95 FAT32
   /dev/sdb2          532480    15521791     7494656   83  Linux
   
   Command (m for help): n
   Partition type:
      p   primary (2 primary, 0 extended, 2 free)
      e   extended
   Select (default p): p
   Partition number (1-4, default 3): 3
   First sector (2048-15523839, default 2048): 15521792
   Last sector, +sectors or +size{K,M,G} (15521792-15523839, default 15523839): 15523839
   
   Command (m for help): t
   Partition number (1-4): 3
   Hex code (type L to list codes): a2
   Changed system type of partition 3 to a2 (Unknown)
   
   Command (m for help): p
   
   Disk /dev/sdb: 7948 MB, 7948206080 bytes
   245 heads, 62 sectors/track, 1021 cylinders, total 15523840 sectors
   Units = sectors of 1 * 512 = 512 bytes
   Sector size (logical/physical): 512 bytes / 512 bytes
   I/O size (minimum/optimal): 512 bytes / 512 bytes
   Disk identifier: 0x00096174
   
      Device Boot      Start         End      Blocks   Id  System
   /dev/sdb1            8192      532479      262144    b  W95 FAT32
   /dev/sdb2          532480    15521791     7494656   83  Linux
   /dev/sdb3        15521792    15523839        1024   a2  Unknown
   
   Command (m for help): w
   The partition table has been altered!
   
   Calling ioctl() to re-read partition table.
   
   WARNING: Re-reading the partition table failed with error 16: Device or resource busy.
   The kernel still uses the old table. The new table will be used at
   the next reboot or after you run partprobe(8) or kpartx(8)
   Syncing disks.
   
   user@analog:~$ sudo dd of=/dev/sdb3 bs=512 if=boot-partition.img
   949+1 records in
   949+1 records out
   486376 bytes (486 kB) copied, 1.2313 s, 395 kB/s
   user@analog:~$ sync

CN0540/DE10Nano
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

-  HDL Project: :git-hdl:`here <projects/cn0540/de10nano>`
-  Linux kernel: :git-linux:`here <>`

Building the Linux Kernel image and the Devicetree
```````````````````````````````````````````````````````````````````````````````

**Linux/Cygwin/WSL**

.. code-block::

   user@analog:~$ git clone https://github.com/analogdevicesinc/linux.git
   user@analog:~$ cd linux/
   user@analog:~/linux$ export ARCH=arm
   user@analog:~/linux$ export CROSS_COMPILE=/path_to_cross_compiler/arm-linux-gnueabihf
   user@analog:~/linux$ make socfpga_adi_defconfig
   user@analog:~/linux$ make zImage
   user@analog:~/linux$ make socfpga_cyclone5_de10_nano_cn0540.dtb

Building the Hardware Design
```````````````````````````````````````````````````````````````````````````````

If you skipped the instruction on “Building the Linux Kernel image and the
Devicetree” above, it is still necessary to do the step regarding cross 
compilers. Pay attention to change directory to where the project is located.
Clone the HDL repository if it does not exist yet in local directory. Then build
the project.

.. code-block::

   user@analog:~$ git clone https:github.com/analogdevicesinc/hdl.git 
   user@analog:~$ cd hdl/projects/cn0540/de10nano
   user@analog:~/hdl$ make

After the design was built, the resulted SRAM Object File (.sof) file shall be
converted to a Raw Binary File (.rbf).

.. code-block::

   user@analog:~/hdl/projects/cn0540/de10nano$ quartus_cpf -c -o bitstream_compression=on ./cn0540_de10nano.sof soc_system.rbf

Building the Preloader and Bootloader Image
```````````````````````````````````````````````````````````````````````````````

This flow applies starting with release 2021_R1 / Quartus Pro version 20.1.
For older versions of the flow see previous versions of this page on wiki :dokuwiki:`Altera SOC Quick Start Guide <resources/tools-software/linux-software/altera_soc_images>`.
In HDL project directory, create the software/bootloader folder and clone the
``u-boot-socfpga`` image. Before that create a new BSP settings file.

.. code-block::

   user@analog:~/hdl/projects/cn0540/de10nano$ mkdir -p software/bootloader
   user@analog:~/hdl/projects/cn0540/de10nano$ embedded_command_shell.sh bsp-create-settings --type spl --bsp-dir software/bootloader --preloader-settings-dir "hps_isw_handoff/system_bd_sys_hps" --settings software/bootloader/settings.bsp
   user@analog:~/hdl/projects/cn0540/de10nano$ cd software/bootloader
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader$ git clone https://github.com/altera-opensource/u-boot-socfpga.git

Then run the qts filter and build the preloader and bootloader images:

.. code-block::
   
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader$ cd u-boot-socfpga
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ git checkout socfpga_v2021.10
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ ./arch/arm/mach-socfpga/qts-filter.sh cyclone5 ../../../../../board/altera/cyclone5-socdk/qts/
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ make socfpga_cyclone5_defconfig
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ make

Make u-boot.scr file - this file shall be copied to /BOOT partition of the SD Card

.. code-block::
   
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ echo "load mmc 0:1 \${loadaddr} soc_system.rbf;" > u-boot.txt
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ echo "fpga load 0 \${loadaddr} \$filesize;" >> u-boot.txt
   user@analog:~/hdl/projects/arradio/c5soc/software/bootloader/u-boot-socfpga$ ./tools/mkimage -A arm -O linux -T script -C none -a 0 -e 0 -n "Cyclone V script" -d u-boot.txt u-boot.scr

Last but not least, create the extlinux.conf linux configuration file. This
extlinux folder shall be copied to /BOOT partition of the SD Card

.. code-block::
   
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ mkdir extlinux
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ echo "LABEL Linux Cyclone V Default" > extlinux/extlinux.conf
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ echo "    KERNEL ../zImage" >> extlinux/extlinux.conf
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ echo "    FDT ../socfpga.dtb" >> extlinux/extlinux.conf
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ echo "    APPEND root=/dev/mmcblk0p2 rw rootwait earlyprintk console=ttyS0,115200n8" >> extlinux/extlinux.conf

Configuring the Micro-SD Card
```````````````````````````````````````````````````````````````````````````````

.. code-block::

   user@analog:~$ time sudo dd if=2023-12-13-ADI-Kuiper-full.img of=/dev/sdd bs=4194304
   2952+0 records in
   2952+0 records out
   12381585408 bytes (12 GB, 12 GiB) copied, 838.353 s, 14.8 MB/s
   
   real	14m7.938s
   user	0m0.006s
   sys	0m0.009s
   user@analog:~$ sync
   user@analog:~$ lsblk
   
   NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
   sdd           8:48   1  29.1G  0 disk 
   ├─sdd1        8:49   1     2G  0 part 
   ├─sdd2        8:50   1  27.1G  0 part 
   └─sdd3        8:51   1     8M  0 part 
      
   user@analog:~$ sudo mount /dev/sdd1 /media/data/BOOT/
   user@analog:~$ lsblk
   
   NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINT
   sdd           8:48   1  29.1G  0 disk 
   ├─sdd1        8:49   1     2G  0 part /media/data/BOOT
   ├─sdd2        8:50   1  27.1G  0 part 
   └─sdd3        8:51   1     8M  0 part 
   
   
   user@analog:~/hdl/projects/cn0540/de10nano$ sudo cp soc_system.rbf /media/data/BOOT/
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ sudo cp u-boot.scr /media/data/BOOT/
   user@analog:~/linux/arch/arm/boot/dts$ sudo cp socfpga_cyclone5_de10_nano_cn0540.dtb /media/data/BOOT/socfpga.dtb
   user@analog:~/linux/arch/arm/boot$ sudo cp zImage /media/data/BOOT
   user@analog:/media/data/BOOT$ sudo mkdir extlinux
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga/extlinux$ sudo cp extlinux.conf /media/data/BOOT/extlinux/
   user@analog:~/hdl/projects/cn0540/de10nano/software/bootloader/u-boot-socfpga$ sudo dd if=u-boot-with-spl.sfp of=/dev/sdd3
   
   1697+1 records in
   1697+1 records out
   868996 bytes (869 kB, 849 KiB) copied, 0.21262 s, 4.1 MB/s
   
   user@analog:~$ sudo umount /dev/sdd1
   user@analog:~$ lsblk 
    
   NAME        MAJ:MIN RM  SIZE  RO TYPE MOUNTPOINT
   sdd           8:48  1   29.1G  0 disk 
   ├─sdd1        8:49  1      2G  0 part 
   ├─sdd2        8:50  1   27.1G  0 part 
   └─sdd3        8:51  1      8M  0 part 