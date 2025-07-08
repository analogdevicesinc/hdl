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

Consider you want to make a new IP with the name ``<module_name>``.
You must edit the verilog file so that it has the same name (e.g. ``axi_led_control.v``).
After that, feel free to write the verilog code for your purpose.
You can also use other instances of modules, but be sure to include them after,
in the tcl file, under the ``<other_components>`` list.

.. _adi-regmap:

Register Map
--------------------------------------------------------------------------------

The register map is defined in a *docs/regmap/adi_regmap_\*.txt* file and
follows a special syntax.

One file can have more than one register map, and they are bounded by the header:

.. code::

   TITLE
   [USING <regmap_to_inherit> ...]
   <title> (<ip_name>)
   <unique_id>
   ENDTITLE

Example:

.. code::

   TITLE
   SPI Engine (axi_spi_engine)
   AXI_SPI_ENGINE
   ENDTITLE

The ``USING`` method is only present if the register map imports other register
maps :ref:`for look-up <hdl-regmap-using>`.

The register and fields are defined with the following syntax:

.. code::


   REG
   <address>
   [WHERE n IS ...]
   <name>
   <description>
   ENDREG

   FIELD
   [31:0] <default>
   [WHERE n IS ...]
   <description>
   <access>
   ENDFIELD

For example:

.. code::

   REG
   0x00000001
   VERSION
   Version of the peripheral.
   Follows semantic versioning. Current version 1.00.71.
   ENDREG

   FIELD
   [31:16] 0x00000001
   VERSION_MAJOR
   RO
   ENDFIELD

   FIELD
   [15:8] 0x00000001
   VERSION_MINOR
   RO
   ENDFIELD

   FIELD
   [7:0] 0x00000071
   VERSION_PATCH
   RO
   ENDFIELD

The ``WHERE`` line is only present if using ranged :ref:`register/fields <hdl-regmap-ranged>`.

Noticed that the description can be multi-line and can also include Sphinx
syntax, parsed during build.
The file content is always 90-columns wide.
There are multiple ways to define the default value for a field.
All parameter values used for defining or calculating the default
value of a field must be a configuration parameter.
In cases where expressions are used to calculate the field values, these
must be compatible SystemVerilog, as the expressions are used in the
simulation environment as well.

.. code::

   FIELD
   [31:0]
   SCRATCH
   RO
   Value of the Scratch field is undefined.
   In a simulation environment this value appears as X for all bits.
   ENDFIELD

   FIELD
   [31:0] 0x12345678
   VERSION
   RO
   Value of the Version is hardcoded in the IP.
   ENDFIELD

   FIELD
   [31:0] ID
   PERIPHERAL_ID
   RO
   Value of the ID configuration parameter.
   In case of multiple instances, each instance will have a unique ID.
   ENDFIELD

   FIELD
   [31:0] SPECIAL = (VALUE1+(VALUE2-VALUE3)*VALUE4)/VALUE5
   SPECIAL
   RO
   Value of the SPECIAL field is calculated using an expression.
   Example of simple operations
   ENDFIELD

   FIELD
   [31:0] SPECIAL = (VALUE1>VALUE2)?VALUE3:VALUE4
   SPECIAL
   RO
   Value of the SPECIAL field is calculated using an expression.
   Example of conditional calculation
   ENDFIELD

   FIELD
   [31:0] SPECIAL = `MAX(VALUE1,`MIN(VALUE2,VALUE3))
   SPECIAL
   RO
   Value of the SPECIAL field is calculated using an expression.
   Example of min and max value calculation
   ENDFIELD

   FIELD
   [31:0] SPECIAL = $clog2(VALUE1**VALUE2)
   SPECIAL
   RO
   Value of the SPECIAL field is calculated using an expression.
   Example of log2 and exponentiation calculation
   ENDFIELD

Examples:

* :git-hdl:`docs/regmap/adi_regmap_spi_engine.txt`
* :git-hdl:`docs/regmap/adi_regmap_adc.txt`, uses ``WHERE``
* :git-hdl:`docs/regmap/adi_regmap_axi_ad3552r.txt`, uses ``USING``

.. _hdl-regmap-using:

Importing with Using Method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``USING`` method allows looking up a register map to import register and
fields.
A register map can look up multiple register maps by repeating the method for
each register map, for example:

.. code::

   TITLE
   USING COMMON_REGS
   USING COMMON_REGS_EXTRA
   My IP (my_ip)
   MY_IP
   ENDTITLE

If using the ``USING`` method for look-up, registers and fields are imported
with the following syntax:

.. code::

   REG
   <reg_to_import>
   ENDREG

   FIELD
   [<field_to_import> ...]
   ENDFIELD

That means, only include the register/field name, and nothing else.
For example:

.. code::

   REG
   CNTRL_1
   ENDREG

   FIELD
   SDR_DDR_N
   SYMB_8_16B
   ENDFIELD

If inheriting registers from multiple register maps, consider explicitly
setting the source register map:

.. code::

   REG
   COMMON_EXTRA.CTRL
   ENDREG

   FIELD
   SOME_FIELD
   ENDFIELD

Some considerations:

* Imported registers shall have non-imported fields, for example, when importing
  a register that is reserved for custom implementation.
* Imported fields must be inside an imported register, since the field name is not
  unique.
* Multiple fields can be imported from a single ``FIELD`` group.
* Multiple register maps can be used for lookup. Add each in a different ``USING``
  method.

.. _hdl-regmap-ranged:

Ranged Registers and Fields
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Registers and fields can use a special ``n`` variable and the ``WHERE`` method
to define an incrementing/repeating register/field. There is an option increase
the address increment value by an additional parameter. This parameter must be
in hexadecimal format as well.
The syntax is ``WHERE n IS FROM <lower> TO <UPPER>``, for example, for registers:

.. code::

    REG
    0x0102 + n
    WHERE n IS FROM 0 TO 15
    CHAN_CNTRLn_3
    DAC Channel Control & Status (channel - 0)
    ENDREG

    REG
    0x0102 + 0x16*n
    WHERE n IS FROM 0 TO 15
    CHAN_CNTRLn_3
    DAC Channel Control & Status (channel - 0)
    ENDREG

And for fields:

.. code::

   FIELD
   [n]
   WHERE n IS FROM 0 TO 31
   ES_RESETn
   RW
   Controls the EYESCANRESET pin of the GTH/GTY transceivers for lane n.
   ENDFIELD

To ease the process of creating a new regmap with imported registers you can
use the generic adc/dac templates that include all available registers:

* :git-hdl:`docs/regmap/adi_regmap_common_template.txt`
* :git-hdl:`docs/regmap/adi_regmap_axi_adc_template.txt`
* :git-hdl:`docs/regmap/adi_regmap_axi_dac_template.txt`

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

   #axi4 subordinate
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

Lattice
--------------------------------------------------------------------------------

TCL File
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The tcl file which creates the IP must be named by the following standard:
``<top_module_name>_ltt.tcl``. We set the ``LIBRARY_NAME := <top_module_name>``
in the Makefile and run the tcl script based on that naming standard.

The tcl file must start with two tcl dependencies:

.. code:: tcl

   source ../../scripts/adi_env.tcl
   source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

The ``adi_env.tcl`` sets some build related and versioning variables, and the
default hdl directory variable. The ``adi_ip_lattice.tcl`` file contains all the
procedures for creating IPs in the ``ipl`` namespace. The IP procedures can be
called like: ``ipl::<procedure_name>``.

Namespace for Lattice IP packaging
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There are two main parts of procedures and structures in this namespace:

1. **IP related procedures and descriptors for users:**

   * ``$::ipl::ip`` - This describes an IP itself. It is used to set a new IP
     instance like: ``set ip $::ipl::ip``. After the instance is correctly
     configured, it is used to generate an actual IP on a specified path.
     This instance is updated by every IP related procedure like:
     ``set ip [<some_ip_procedure> -ip $ip]`` except the
     ``ipl::generate_ip`` and ``ipl::parse_module``. You will see later on in
     example.
   * ``ipl::general`` - Sets the IP structure with the specified general IP
     parameters.
   * ``ipl::parse_module`` - This module is used to parse the data of the IP top
     module, it's input parameter is the file path of the top module and it
     returns a structure with the top module's data which is parameter for
     other procedures.
   * ``ipl::add_ports_from_module`` - It is used to set the IP structure with
     the port's data from the module data which is set by ``ipl::parse_module``
   * ``ipl::add_memory_map`` - Sets the IP structure with a new memory map,
     the name of this memory map must be used for slave memory mapped interface
     configuration.
   * ``ipl::add_address_space`` - Sets the IP structure with an address space,
     the name of this address space must be used for master memory mapped
     interface configuration.
   * ``ipl::add_axi_interfaces`` - Automatically adds AXI interfaces based on
     parsed module data from top module.
   * ``ipl::add_interface`` - Sets the IP structure with an interface instance.
   * ``ipl::add_interface_by_prefix`` - Sets the IP structure with an interface
     by filtering ports by prefix from module data parsed with
     ``ipl::parse_module`` when a naming standard like
     ``<verilog_prefix>_<standard_port_name>`` is used.
   * ``ipl::add_ip_files`` - Sets the IP structure with IP file dependencies
   * ``ipl::add_ip_files_auto`` - Sets the IP structure with the specified file
     dependencies by searching them in the specified ``-spath`` folder
     ``-sdepth`` deep.
   * ``ipl::set_parameter`` - Sets the IP structure with a configuration
     parameter which will appear in the IP GUI also.
   * ``ipl::ignore_ports`` - Ignores/Hides a list of ports by a Python
     expression which usually depends on the value of a Verilog parameter.
   * ``ipl::ignore_ports_by_prefix`` - Ignores/Hides ports which are matching
     with a specified prefix from the ports' names in the parsed ports from
     the top module, by a Python expression which usually depends on the value of
     a Verilog parameter.
   * ``ipl::generate_ip`` - Generates the IP on specified path, if no path
     parameter then in default IP download directory of Lattice Propel Builder.

2. **Custom IP interface related descriptors and procedures for users:**

   * ``$::ipl::if`` - This describes an IP interface structure, it is used to
     set a new interface instance like: ``set if $::ipl::if``
   * ``ipl::create_interface`` - Creates a custom interface.
   * ``ipl::generate_interface`` - Generates a custom interface from the
     structure set by ``ipl::create_interface``.

Example for creating an IP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following section is a generic example for creating IPs which is
trying to simulate most of the available options when creating a new IP.

.. collapsible:: Detailed template for the <top_module_name>_ltt.tcl file

   .. code::

      source ../../scripts/adi_env.tcl
      source $ad_hdl_dir/library/scripts/adi_ip_lattice.tcl

      # Parsing ports and parameters from top module.
      # In order to this procedure to work correctly please define your top module
      # by following the HDL coding guideline.
      set mod_data [ipl::parse_module ./<top_module_name>.v]

      # Initializing the IP structure.
      set ip $::ipl::ip

      # Adding all the ports to the IP from $mod_data.
      set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]

      # Adding parameters from the $mod_data. This procedure automatically adds
      # all the parameters found in top module, but it is useful only if we use
      # them as they are and the ordering and grouping of them does not count.
      # NOTE: Do not use it if you want to organize the GUI parameters, in that
      # case you should add the parameters manually by the following
      # ipl::set_parameter procedure.
      set ip [ipl::add_parameters_from_module -ip $ip -mod_data $mod_data]

      #Getting the name of the top module. <top_module_name>
      set mod_name [dict get $mod_data mod_name]

      # Setting the general IP parameters.
      # There are two optional parameters for this procedure: -max_radiant_version
      #                                                       -max_esi_version
      set ip [ipl::general \
         -vlnv "analog.com:ip:$mod_name:1.0" \
         -display_name "<Display name of the IP>" \
         -supported_products {*} \
         -supported_platforms {esi radiant} \
         -category "<IP Category>" \
         -keywords "<keywords related to the IP>" \
         -min_radiant_version "2023.2" \
         -min_esi_version "2023.2" \
         -href "<https://example_webpage/ip>" \
         -ip $ip]

      # If the IP has AXI interfaces and the naming standard
      # <interface_name>_<standard_ip_portname> is used then you can use the
      # following procedure to add all the AXI interfaces to the IP.
      # The supported interfaces are AXI4, AXI4-Lite and AXI4-Stream.
      set ip [ipl::add_axi_interfaces -ip $ip -mod_data $mod_data]

      # You can define memory maps for every slave memory mapped interface.
      # You must use its name in the following 'ipl::add_interface' procedure at
      # '-mem_map_ref' option, then the memory map defined here will be used
      # for the memory mapped interface we are following to define.
      set ip [ipl::add_memory_map -ip $ip \
         -name "<interface_name>_mem_map" \
         -description "<interface description>" \
         -baseAddress 0 \
         -range 65536 \
         -width 32]

      # You can add interface manually by defining it with a portmap.
      # Make sure that the standard port names match the port names in defined
      # interfaces. You must define a '-mem_map_ref' anytime you add a memory mapped
      # interface, otherwise the option is not used. If no memory map with that
      # reference is created the procedure creates a default memory map
      # automatically with the specified '-mem_map_ref'.
      set ip [ipl::add_interface -ip $ip \
         -inst_name <interface_name> \
         -display_name "<interface display name>" \
         -description "<interface description>" \
         -master_slave slave \
         -portmap [list {"s_apb_paddr" "PADDR"} \
                        {"s_apb_penable" "PENABLE"} \
                        {"s_apb_prdata" "PRDATA"} \
                        {"s_apb_pready" "PREADY"} \
                        {"s_apb_pselx" "PSELx"} \
                        {"s_apb_pslverr" "PSLVERR"} \
                        {"s_apb_pwdata" "PWDATA"} \
                        {"s_apb_pwrite" "PWRITE"}] \
         -mem_map_ref <interface_name>_mem_map \
         -vlnv {amba.com:AMBA3:APB:r1p0}]
      # In most of the cases the containing folder names are describing the vlnv
      # for the existing interfaces as in the following example:
      # lscc/propel/<tool_version>/builder/rtf/ip/interfaces/amba.com/AMBA3/APB/r1p0

      # If you want to update a memory map you can use this anytime.
      # The identifier of a memory map is its '-name' which is referred as
      # '-mem_map_ref' at ipl::add_interface procedure.
      set ip [ipl::add_memory_map -ip $ip \
         -name "<interface_name>_mem_map" \
         -description "<interface description>" \
         -baseAddress 0 \
         -range 65536 \
         -width 32]

      # When you add a master memory mapped interface you can define a memory map
      # for it. If you do not define it separately it will be created automatically
      # when you add the interface and specify the '-addr_space_ref' option
      # at ipl::add_interface procedure.
      set ip [ipl::add_address_space -ip $ip \
         -name "<interface_name>_aspace" \
         -range 0x100000000 \
         -width 32]

      # Example adding a master memory mapped interface.
      set ip [ipl::add_interface -ip $ip \
         -inst_name <interface_name> \
         -display_name "<interface display name>" \
         -description "<interface description>" \
         -master_slave master \
         -portmap [list {"s_apb_paddr" "PADDR"} \
                        {"s_apb_penable" "PENABLE"} \
                        {"s_apb_prdata" "PRDATA"} \
                        {"s_apb_pready" "PREADY"} \
                        {"s_apb_pselx" "PSELx"} \
                        {"s_apb_pslverr" "PSLVERR"} \
                        {"s_apb_pwdata" "PWDATA"} \
                        {"s_apb_pwrite" "PWRITE"}] \
         -addr_space_ref <interface_name>_aspace \
         -vlnv {amba.com:AMBA3:APB:r1p0}]

      # Example adding parameters to the IP.
      # You must use the Verilog parameter name at '-id' option.
      # You can check the Lattice Propel IP Packager documentation for parameter
      # use cases as Setting Nodes at:
      #                https://www.latticesemi.com/view_document?document_id=54003
      # The same options in the tables are used here as options for the procedure.
      # If you want parameters to appear in the same <Subgoup> in the same <Tabgroup>
      # you must add them one after another in the preferred order.
      set ip [ipl::set_parameter -ip $ip \
         -id <verilog_parameter> \
         -type param \
         -value_type int \
         -conn_mod <verilog_module_name> \
         -title {<Title>} \
         -options {[('Option 1', 0), ('Option 2', 1), ('Option 3', 2)]} \
         -editable {(<some_parameter> == 0)} \
         -default 0 \
         -output_formatter nostr \
         -group1 {<Subgoup>} \
         -group2 {<Tabgroup>}]
      set ip [ipl::set_parameter -ip $ip \
         -id DATA_WIDTH \
         -type param \
         -value_type int \
         -conn_mod <verilog_module_name> \
         -title {<Title>} \
         -options {[16, 32, 64, 128, 256, 512, 1024, 2048]} \
         -default 64 \
         -output_formatter nostr \
         -group1 {<Subgoup>} \
         -group2 {<Tabgroup>}]
      set ip [ipl::set_parameter -ip $ip \
         -id ENABLE \
         -type param \
         -value_type int \
         -conn_mod <verilog_module_name> \
         -title {<Title>} \
         -options {[(True, 1), (False, 0)]} \
         -default 0 \
         -output_formatter nostr \
         -group1 {<Subgoup>} \
         -group2 {<Tabgroup>}]

      # Two options to ignore and hide ports in the GUI.
      set ip [ipl::ignore_ports_by_prefix -ip $ip \
         -mod_data $mod_data \
         -v_prefix s_apb \
         -expression {(ENABLE == 0)}]
      set ip [ipl::ignore_ports -ip $ip \
         -portlist {s_apb_paddr s_apb_pwdata} \
         -expression {(ENABLE == 0)}]

      # Defining the rtl file dependencies. The files defined here will be copied
      # to 'rtl' folder in the generated IP directory. The 'rtl' output directory
      # must be used for the rtl files.
      # For constraint files the 'ldc' folder must be used at '-dpath' option.
      # The following are the standard directories by purpose:
      # eval, plugin, doc, rtl, testbench, driver, ldc.
      # You can check the Lattice Propel IP Packager documentation for more
      # information at: https://www.latticesemi.com/view_document?document_id=54003
      set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
         "<path>/<dependency0>.v" \
         "<path>/<dependency1>.sv"]

      # You can also create your own interfaces.
      # The options for ports are the following:
      #     -n <logical_name>
      #     -d <in/out> #direction
      #     -p <required/optional> #presence
      #     -w <port_width>
      #     -q <clock/reset/data/address> #qualifier #default is data
      # We usually put these in a separate script for make, but you can use it here.
      set if [ipl::create_interface
         -vlnv {analog.com:ADI:fifo_wr:1.0}
         -directConnection true \
         -isAddressable false \
         -description "ADI fifo wr interface" \
         -ports {
            {-n DATA -d out -p required}
            {-n EN -d out -p required -w 1}
            {-n OVERFLOW -w 1 -p optional -d in}
            {-n SYNC -p optional -w 1 -d out}
            {-n XFER_REQ -p optional -w 1 -d in}
         }]
      # This will generate the interface in ./<vendor> directory and in
      # the default interface directory of Lattice Propel Builder
      # (~/PropelIPLocal/interfaces) if the LATTICE_DEFAULT_PATHS env variable
      # is exported like: 'export LATTICE_DEFAULT_PATHS=1' before running the 
      # script or running make.
      # You can remove it by deleting the interface folder from this directory.
      # You can use a second path parameter to generate it on a specified path.
      # For make it is a dedicated file for generating interfaces namely
      # 'library/interfaces_ltt/interfaces_ltt.tcl' where you can add new
      # interfaces and edit the 'library/interfaces_ltt/Makefile' to work
      # correspondingly.
      ipl::generate_interface $if

      # You can add it to the IP.
      set ip [ipl::add_interface -ip $ip \
      -inst_name fifo_wr \
      -display_name fifo_wr \
      -description fifo_wr \
      -master_slave slave \
      -portmap { \
         {"fifo_wr_en" "EN"} \
         {"fifo_wr_din" "DATA"} \
         {"fifo_wr_overflow" "OVERFLOW"} \
         {"fifo_wr_xfer_req" "XFER_REQ"} \
      } \
      -vlnv {analog.com:ADI:fifo_wr:1.0}]

      # Generating the IP given as first parameter on the path given as the second
      # parameter. Without the second parameter the IP will be generated in
      # ./ltt directory and in the default IP download directory of
      # Lattice Propel Builder (~/PropelIPLocal) if the LATTICE_DEFAULT_PATHS
      # env variable is exported like:
      # 'export LATTICE_DEFAULT_PATHS=1' before running the script or running make.
      ipl::generate_ip $ip

Makefile
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In this file you will also have to change/add paths to every file dependency for
the IP, using ``GENERIC_DEPS`` for generic dependencies, ``LATTICE_DEPS`` for
Lattice specific file dependencies, ``LATTICE_INTERFACE_DEPS`` for Lattice
interface dependencies. We set the Lattice interface dependencies when we need
custom interfaces to ``LATTICE_INTERFACE_DEPS := interfaces_ltt`` where
``interfaces_ltt`` means the ``hdl/library/interfaces_ltt`` directory where the
make script will enter in order to generate the interfaces defined there. If you
want to add a new interface, you can add it to
``hdl/library/interfaces_ltt/interfaces_ltt.tcl`` file then update the
``hdl/library/interfaces_ltt/Makefile`` correspondingly.
Make sure you set the ``LIBRARY_NAME`` correctly.

The following is an example for ``Makefile``:

.. code:: makefile

   LIBRARY_NAME := <top_module_name>

   GENERIC_DEPS += ../common/up_axi.v
   GENERIC_DEPS += <top_module_name>.v

   LATTICE_DEPS += <top_module_name>_ltt.tcl
   LATTICE_INTERFACE_DEPS += interfaces_ltt

   include ../scripts/library.mk

Now you can run ``make`` from the IP directory.
After that the IP will be accessible in Lattice Propel Builder.
