.. _git_repository:

HDL Git repository
===============================================================================

All the HDL sources can be found in the following git repository:

:git-hdl:`/`

We assume that the user is familiar with `git <https://git-scm.com/>`__.
Knows how to
`clone <https://git-scm.com/book/en/v2/Git-Basics-Getting-a-Git-Repository>`__
the repository, how to check its
`status <https://git-scm.com/docs/git-status>`__ or how to
`switch <https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging>`__
between branches.

.. note::

   A basic git knowledge is required in order to work with these source files,
   if you do not have any, don't worry!

   There are a lot of great resources and tutorials about git all over the
   `web <http://lmgtfy.com/?q=git+tutorial>`__.


If you want to pull down the sources as soon as possible, just do the
following few steps:

#. Install Git from `here <https://git-scm.com/>`__
#. Open up Git bash, change your current directory to a place where you
   want to keep the hdl source
#. Clone the repository using
   `these <https://help.github.com/articles/cloning-a-repository/>`__
   instructions

Folder structure
-------------------------------------------------------------------------------

The root of the HDL repository has the following structure:

.. code-block::

   .
   +-- .github
   +-- docs
   +-- library
   +-- projects
   +-- scripts
   +-- Makefile
   +-- README.md
   +-- LICENSE

The repository is divided into 5 separate sections:

-  **.github** with all our automations regarding coding checks, GitHub actions
-  **docs** with our GitHubIO documentation and regmap source files
-  **library** with all the Analog Devices Inc. proprietary IP cores and
   hdl modules, which are required to build the projects
-  **projects** with all the currently supported projects
-  **scripts** with our environment scripts that set tools versions, etc.

The file **.gitattributes** is used to properly `handle
different <https://help.github.com/articles/dealing-with-line-endings/>`__
line endings. And the **.gitignore** specifies intentionally untracked
files that Git should ignore. The root **Makefile** can be used to build
all the project of the repository. To learn more about hdl **Makefiles**
visit the :ref:`Building & Generating programming files <build_hdl>` section.

The projects are structured as follows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

   .
   +-- docs
   +-- library
   +-- projects
   ¦   +-- ad40xx_fmc
   ¦   +-- ad4110
   ¦   .
   ¦   +-- common
   ¦   +-- dac_fmc_ebz
   ¦   ¦   +-- common
   ¦   ¦   +-- a10soc
   ¦   ¦   +-- vcu118
   ¦   ¦   .
   ¦   ¦   +-- zcu102
   ¦   ¦   +-- Makefile
   ¦   ¦   +-- Readme.md
   ¦   .
   ¦   +-- scripts
   ¦   .
   ¦   +-- Readme.md
   ¦   +-- Makefile
   ¦   +-- wiki_summary.sh
   +-- README.md

Besides the project folders, there are two special folders inside the
**/hdl/projects**:

-  **common**: This folder contains all the base designs, for all
   currently supported FPGA development boards. Be aware if you see your
   board on this list, it does not necessarily mean that you can use it
   with your FMC board.
-  **scripts**: In all cases, we are interacting with the development
   tools (Vivado/Quartus) using Tcl scripts. In this folder are defined
   all the custom Tcl processes, which are used to create a project,
   define the system and generate programming files for the FPGA.

Inside a project folder, you can find folders with an FPGA carrier name
(e.g. ZC706) which in general contains all the carrier board specific
files, and a folder called **common** which contains the project
specific files. If you can not find your FPGA board name in a project
folder, that means your FPGA board with that particular FMC board is not
supported.

The library are structured as follows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. code-block::

   .
   +-- library
   ¦   +-- ad463x_data_capture
   ¦   +-- axi_ad3552r
   ¦   +-- axi_ad4858
   ¦   +-- axi_ad5766
   ¦   +-- axi_ad7606x
   ¦   +-- axi_ad7616
   ¦   +-- axi_ad7768
   ¦   +-- axi_ad777x
   ¦   +-- axi_ad9122
   ¦   .
   ¦   +-- common
   ¦   .
   ¦   +-- interfaces
   ¦   +-- jesd204
   ¦   +-- scripts
   ¦   .
   ¦   +-- Makefile
   +-- projects
   +-- README.md

The library folder contains all the IP cores and common modules. An IP,
in general, contains Verilog files, which describe the hardware logic,
constraint files, to ease timing closure, and Tcl scripts, which
generate all the other files required for IP integration (\*_ip.tcl for
Vivado and \*_hw.tcl for Quartus) .

.. note::

   Regarding Vivado, all the IPs must be 'packed' before being used in a
   design.

   To find more information about how to build the libraries, please visit
   the :ref:`Building & Generating programming files <build_hdl>` section.


Repository releases and branches
-------------------------------------------------------------------------------

The repository may contain multiple branches and tags. The
:git-hdl:`main </>` branch
is the development branch (latest sources, but not stable). If you check
out this branch, some builds may fail. If you are not into any kind of
experimentation, you should only check out one of the release branch.

All our release branches have the following naming convention:
**hdl\_**\ [year_of_release]\ **\_r**\ [1 or 2]. (e.g.
:git-hdl:`hdl_2014_r2 <hdl_2014_r2:>`)

ADI does two releases each year when all the projects get an update to
support the latest tools and get additional new features. \*\* The
main branch is always synchronized with the latest release.*\* If you
are in doubt, ask us on :ez:`fpga`.

.. note::

   You can find the release notes on the GitHub page of the
   repository:

   https://github.com/analogdevicesinc/hdl/releases

   The latest version of tools used on main can be found at:
   :git-hdl:`scripts/adi_env.tcl` (*required_vivado_version* and
   *required_quartus_version* variables). For Intel Quartus Standard, the version
   is specified in each project that uses it, depending on the carrier.
