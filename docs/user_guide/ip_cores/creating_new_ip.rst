.. _creating_new_ip:

Creating a new IP
================================================================================

Here is a quick start guide about creating a new IP. You can start from these
files and modify them as you need.
Here is the code for a fan control IP: :git-hdl:`library/axi_fan_control`.
In this tutorial, we will make a led control IP, using AXI. In this case,
``<module_name>`` will be replaced in code with ``axi_led_control`` for Xilinx
and ``axi_led_control_intel`` for Intel.

Verilog File
--------------------------------------------------------------------------------

Lets say you want to make a new IP with the name ``<module_name>``.
You must edit the verilog file so that it has the same name (e.g. ``axi_led_control.v``).
After that, feel free to write the verilog code for your purpose.
You can also use other instances of modules, but be sure to include them after,
in the tcl file, under the ``<other_components>`` list.

Xilinx
--------------------------------------------------------------------------------

TCL File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The tcl file should be named ``<module_name_ip>.tcl`` (ex: ``axi_led_control_ip.tcl``).
Here you should keep the two lines that source our scripts :

.. code:: tcl

   source ../scripts/adi_env.tcl
   source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

Then take a look at the commands

.. code:: tcl

   adi_ip_create <module_name>
   adi_ip_files <module_name> [list <other_components>]

These commands create the IP and add the dependencies for it.
By ``<other_components>`` we refer to the modules we were talking about above,
that must be included in the tcl file. Also, ``<other_components>`` must include
the verilog file for the IP itself, named ``<module_name>.v``.

If your new IP uses AXI Lite for register control, then the next command is

.. code:: tcl

   adi_ip_properties <module_name>

It is used to initialize properties like memory and so on.
If the IP does not use AXI, then you should use

.. code:: tcl

   adi_ip_properties_lite <module_name>

At the end of the file don't forget to save the IP by using this command

.. code:: tcl

   ipx::save_core [ipx::currentcore]


If you need more help, here is an example of an IP called axi_led_control.
You can open it side by side with the tcl file from the original axi_fan_control
and apply the same logic to make your changes.

.. code::

   # ip

   source ../scripts/adi_env.tcl
   source $ad_hdl_dir/library/scripts/adi_ip_xilinx.tcl

   adi_ip_create axi_led_control
   adi_ip_files axi_led_control [list \
     "$ad_hdl_dir/library/common/up_axi.v" \
     "axi_led_control.v"]

   adi_ip_properties axi_led_control
   set cc [ipx::current_core]

   ipx::save_core $cc


Makefile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this file you will also have to change/add paths to every file in ``<other_components>``
list, using GENERIC_DEPS.
Make sure to also change LIBRARY_NAME and XILINX_DEPS to match the name for the new IP.

If you need more help, here is an example of an IP called axi_led_control.
You can open it side by side with the Makefile from the original axi_fan_control
and apply the same logic to make your changes.

.. code:: makefile

   LIBRARY_NAME := axi_led_control

   GENERIC_DEPS += ../common/up_axi.v
   GENERIC_DEPS += axi_led_control.v

   XILINX_DEPS += axi_led_control_ip.tcl

   include ../scripts/library.mk

Now you can run the famous ``make`` in command line from the IP directory.
After that, ``<module_name>`` will be accessible within vivado for future integrations.

Intel
--------------------------------------------------------------------------------

TCL File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The tcl file should be named <module_name_hw>.tcl (ex: axi_led_control_intel_hw.tcl)
These first 4 lines of code you should keep:

.. code:: tcl

   package require qsys 14.0
   package require quartus::device

   source ../scripts/adi_env.tcl
   source ../scripts/adi_ip_intel.tcl


After that, the next line creates the new IP:

.. code:: tcl

   ad_ip_create <module_name> {entity_name}.

The module_name is the name of the IP you are creating, but entity_name will be
the one visible inside Quartus IP Catalogue.

Next, you must add the other components used for creating the IP.
For this, we will use the ad_ip_files command:

.. code:: tcl

   ad_ip_files <module_name> [list <other_components>]

The ``<other_components>`` list is referring to any other verilog file imported
or used.
It must also include the verilog file for the IP itself (``<module_name>.v``).

Now let's add an instance of AXI:

.. code:: tcl

   ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 10

This command instantiates an interface using axi.
The parameters refer to the ports of the interface, while the number refers to
the width of the data bus.

There should be added an interface for every port of the IP.
In this example, there is only one port left: led_on.
This port is also external, so that's what conduit is there for.

.. code:: tcl

   add_interface led_on_if conduit end
   add_interface_port led_on_if led_on data Output 1


The last line is related to the port in the verilog file. In this case, led_on.
The other parameters refer to ``<signal_type> <direction> <width_expression>``.

In Quartus there is no need to save the core or run make afterwards.
It is smart enough to search for _hw.tcl in the library directory.
Although, you might need to add the path to the new IP in the IP Catalogue.


If you want to see the whole file, here is an example named axi_led_control_intel.

.. code::

   package require qsys 14.0
   package require quartus::device

   source ../scripts/adi_env.tcl
   source ../scripts/adi_ip_intel.tcl

   ad_ip_create axi_led_control_intel {AXI LED CONTROL}

   ad_ip_files axi_led_control_intel [list \
     $ad_hdl_dir/library/common/up_axi.v \
     axi_led_control_intel.v]

   #axi4 slave
   ad_ip_intf_s_axi s_axi_aclk s_axi_aresetn 10

   #output led
   add_interface led_on_if conduit end
   add_interface_port led_on_if led_on data Output 1

Makefile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You don't need to run make for the IP to be visible in the Catalogue.
Yet, here is the Makefile for the example mentioned before:

.. code:: makefile

   LIBRARY_NAME := axi_led_control_intel

   GENERIC_DEPS += ../common/up_axi.v
   GENERIC_DEPS += axi_led_control_intel.v


   INTEL_DEPS += axi_led_control_intel_hw.tcl


   include ../scripts/library.mk


This example was made starting from the axi_ad9361 IP found in our repo, under the library directory:
:git-hdl:`ibrary/axi_ad9361`.
