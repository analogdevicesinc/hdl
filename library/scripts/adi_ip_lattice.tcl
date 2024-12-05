###############################################################################
## Copyright (C) 2025 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

################################################################################
## Namespace for Lattice IP packaging:
#  * These are mainly some xml tree manipulator procedures.
#  * The base descriptors for Lattice IP xml's and interface xml's.
#  * The Lattice IP specific procedures to configure these descriptors.
#  * There is another xml generator procedure and the folder generator
#    procedures for IPs and IP interfaces.
#  * There are mainly four descriptor structures for IP related xml's.
#  * These four structures are wrapped up in a $::ipl::ip structure with file
#    dependencies added to them for holding all the necessary IP data.
#  * There are two more descriptors for interface xml's wich are wrapped up too
#    in a single $::ipl::if structure and hold all the necessary interface data.
#
# There are two main parts of procedures and structures in this namespace:
#
#  1. IP related procedures and descriptors for users:
#     * $::ipl::ip
#       - This describes an IP itself. It is used to set a new IP instance like:
#                                                            'set ip $::ipl::ip'
#       - After the instance is correctly configured, it is used to generate an
#         actual IP on a specified path.
#       - This instance is updated by every IP related procedure like:
#         set ip [<some_ip_procedure> -ip $ip]' except the 'ipl::generate_ip'
#         and 'ipl::parse_module'.
#     * ipl::general
#       - sets the IP structure with the specified general IP parameters.
#     * ipl::parse_module
#       - This module is used to parse the data of the IP top module, it's input
#         parameter is the file path of the top module and it returns a structure
#         with the top module's data which is parameter for other procedures.
#     * ipl::add_ports_from_module
#       - it is used to set the IP structure with the port's data from the
#         module data which is set by 'ipl::parse_module'
#     * ipl::add_memory_map
#       - sets the IP structure with a new memory map, the name of this memory
#         map must be used for slave memory mapped interface configuration
#     * ipl::add_address_space
#       - sets the IP structure with an address space, the name of this address
#         space must be used for master memory mapped interface configuration
#     * ipl::add_axi_interfaces
#       - automatically adds AXI interfaces based on parsed module data from top
#         module
#     * ipl::add_interface
#       - sets the IP structure with an interface instance.
#     * ipl::add_interface_by_prefix
#       - sets the IP structure with an interface by filtering ports by prefix
#         from module data parsed with ipl::parse_module when a naming standard
#         like <verilog_prefix>_<standard_port_name> is used.
#     * ipl::add_ip_files
#       - sets the IP structure with IP file dependencies
#     * ipl::add_ip_files_auto
#       - sets the IP structure with the specified file dependencies by
#         searching them in the specyfied '-spath' folder '-sdepth' deep.
#     * ipl::set_parameter
#       - sets the IP structure with a configuration parameter which will appear
#         in the IP GUI also.
#     * ipl::ignore_ports
#       - ignores/hides a list of ports by a Python expression which usually
#         depends on the value of a Verilog parameter.
#     * ipl::ignore_ports_by_prefix
#       - ignores/hides ports which are matching with a specified prefix from
#         the ports' names in the parsed ports from the top module, by a
#         Python expression which usually depends on the value of a Verilog
#         parameter.
#     * ipl::generate_ip
#       - generates the IP on specified path, if no path parameter, then in
#         default IP download directory of Lattice Propel Builder.
#
#  2. Custom IP interface related descriptors and procedures for users:
#     * $::ipl::if
#       - This describes an IP interface structure, it is used to set a new
#         interface instance like: 'set if $::ipl::if'
#     * ipl::create_interface
#       - creates a custom interface
#     * ipl::generate_interface
#       - generates a custom interface from the structure set by
#         ipl::create_interface
################################################################################
namespace eval ipl {

    set check [catch {exec cygpath --version}]
    if {$check == 0} {
        set PropelIPLocal_path [exec cygpath -H]/[exec whoami]/PropelIPLocal
        if {[info exists env(LATTICE_INTERFACE_SEARCH_PATH)]} {
            set interfaces_paths_list \
                [split $env(LATTICE_INTERFACE_SEARCH_PATH) ";"]

            foreach file $interfaces_paths_list {
                if {[regexp {^.+\/PropelIPLocal} $file PropelIPLocal_path]} {
                    puts $file
                    set PropelIPLocal_path
                }
            }
        }
    } else {
        set PropelIPLocal_path $env(HOME)/PropelIPLocal
    }

    #node: {name attributes content childs}
    #attributes: {{id0} {att0} {id1} {att1}}
    set ip_desc {{lsccip:ip}
        {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"
    xmlns:xi="http://www.w3.org/2001/XInclude" version="1.0"}} {} {
            {lsccip:general} {{lsccip:general} {} {} {
                    {lsccip:vendor} {{lsccip:vendor} {} {analog.com} {}}
                    {lsccip:library} {{lsccip:library} {} {ip} {}}
                    {lsccip:name} {{lsccip:name} {} {} {}}
                    {lsccip:display_name} {{lsccip:display_name} {} {} {}}
                    {lsccip:version} {{lsccip:version} {} {1.0} {}}
                    {lsccip:category} {{lsccip:category} {} {ADI} {}}
                    {lsccip:keywords} {{lsccip:keywords} {} {ADI IP} {}}
                    {lsccip:min_radiant_version}
                        {{lsccip:min_radiant_version} {} {2023.2} {}}
                    {lsccip:max_radiant_version} {{} {} {} {}}
                    {lsccip:min_esi_version}
                        {{lsccip:min_esi_version} {} {1.0} {}}
                    {lsccip:max_esi_version} {{} {} {} {}}
                    {lsccip:supported_products}
                        {{lsccip:supported_products} {} {} {}}
                    {lsccip:supported_platforms}
                        {{lsccip:supported_platforms} {} {} {}}
                    {href} {{} {}
                        {https://wiki.analog.com/resources/fpga/docs/ip_cores}
                        {}}
                }
            }
            {lsccip:settings} {{lsccip:settings} {} {} {}}
            {lsccip:ports} {{} {} {} {}}
            {lsccip:outFileConfigs} {{} {} {} {
                wrapper_type {{} {} {} {}}
            }}
            {xi:include} {{} {} {} {}}
            {lsccip:componentGenerators} {{} {} {} {}}
        }
    }
    set componentGenerator_desc {{lsccip:componentGenerator} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:generatorExe} {{lsccip:generatorExe} {} {} {}}
        }
    }
    set busInterfaces_desc {{lsccip:busInterfaces} {{0}
        {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}} {} {}}
    set busInterface_desc {{lsccip:busInterface} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:displayName} {{lsccip:displayName} {} {} {}}
            {lsccip:description} {{lsccip:description} {} {} {}}
            {lsccip:busType} {{lsccip:busType} {} {} {}}
            {lsccip:abstractionTypes} {{lsccip:abstractionTypes} {} {} {
                    {lsccip:abstractionType} {{lsccip:abstractionType} {} {} {
                            {lsccip:abstractionRef}
                                {{lsccip:abstractionRef} {} {} {}}
                            {lsccip:portMaps} {{lsccip:portMaps} {} {} {}}
                        }
                    }
                }
            }
            {lsccip:master_slave} {{} {} {} {}}
        }
    }
    set portMap_desc {{lsccip:portMap} {} {} {
            {lsccip:logicalPort} {{lsccip:logicalPort} {} {} {
                    {lsccip:name} {{lsccip:name} {} {} {}}
                }
            }
            {lsccip:physicalPort} {{lsccip:physicalPort} {} {} {
                    {lsccip:name} {{lsccip:name} {} {} {}}
                }
            }
        }
    }
    set addressSpaces_desc {{lsccip:addressSpaces}
        {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}}
        {} {}}
    set addressSpace_desc {{lsccip:addressSpace} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:range} {{lsccip:range} {} {0x100000000} {}}
            {lsccip:width} {{lsccip:width} {} {32} {}}
        }
    }
    set memoryMaps_desc {{lsccip:memoryMaps}
        {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}}
        {} {}}
    set memoryMap_desc {{lsccip:memoryMap} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:description} {{lsccip:description} {} {} {}}
            {lsccip:addressBlock} {{lsccip:addressBlock} {} {} {}}
        }
    }
    set addressBlock_desc {{lsccip:addressBlock} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:baseAddress} {{lsccip:baseAddress} {} {0} {}}
            {lsccip:range} {{lsccip:range} {} {4096} {}}
            {lsccip:width} {{lsccip:width} {} {32} {}}
        }
    }

    set abstractionDefinition_desc {
        {ipxact:abstractionDefinition}
        {{0} {xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ipxact="http://www.accellera.org/XMLSchema/IPXACT/1685-2014"
    xsi:schemaLocation="http://www.accellera.org/XMLSchema/IPXACT/1685-2014
    http://www.accellera.org/XMLSchema/IPXACT/1685-2014/index.xsd"}}
        {} {{ipxact:vendor} {{ipxact:vendor} {} {} {}}
            {ipxact:library} {{ipxact:library} {} {} {}}
            {ipxact:name} {{ipxact:name} {} {} {}}
            {ipxact:version} {{ipxact:version} {} {} {}}
            {ipxact:busType} {{ipxact:busType} {} {} {}}
            {ipxact:ports} {{ipxact:ports} {} {} {}}
            {ipxact:description} {{ipxact:description} {} {} {}}
        }
    }

    set busDefinition_desc {
        {ipxact:busDefinition}
        {{0} {xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:ipxact="http://www.accellera.org/XMLSchema/IPXACT/1685-2014"
    xsi:schemaLocation="http://www.accellera.org/XMLSchema/IPXACT/1685-2014
    http://www.accellera.org/XMLSchema/IPXACT/1685-2014/index.xsd"}}
        {} {{ipxact:vendor} {{ipxact:vendor} {} {} {}}
            {ipxact:library} {{ipxact:library} {} {} {}}
            {ipxact:name} {{ipxact:name} {} {} {}}
            {ipxact:version} {{ipxact:version} {} {} {}}
            {ipxact:directConnection} {{ipxact:directConnection} {} {} {}}
            {ipxact:isAddressable} {{ipxact:isAddressable} {} {} {}}
            {ipxact:description} {{ipxact:description} {} {} {}}
        }
    }

    set if { {} {} {} {
            abstractionDefinition_desc {{} {} {} {}}
            busDefinition_desc {{} {} {} {}}
        }
    }

    set port_desc {
        {ipxact:port} {} {} {
            {ipxact:logicalName} {{ipxact:logicalName} {} {} {}}
            {ipxact:description} {{ipxact:description} {} {} {}}
            {ipxact:wire} {{ipxact:wire} {} {} {
                    {ipxact:qualifier} {{ipxact:qualifier} {} {} {
                            {ipxact:isClock} {{} {} {} {}}
                            {ipxact:isReset} {{} {} {} {}}
                            {ipxact:isAddress} {{} {} {} {}}
                            {ipxact:isData} {{} {} {} {}}
                        }
                    }
                    {ipxact:onMaster} {{ipxact:onMaster} {} {} {
                            {ipxact:presence}
                                {{ipxact:presence} {} {optional} {}}
                            {ipxact:width} {{} {} {} {}}
                            {ipxact:direction}
                                {{ipxact:direction} {} {out} {}}
                        }
                    }
                    {ipxact:onSlave} {{ipxact:onSlave} {} {} {
                            {ipxact:presence}
                                {{ipxact:presence} {} {optional} {}}
                            {ipxact:width} {{} {} {} {}}
                            {ipxact:direction} {{ipxact:direction} {} {in} {}}
                        }
                    }
                    {ipxact:requiresDriver} {{} {} {} {}}
                }
            }
        }
    }

###############################################################################
## Sets an interface structure by the specified options.
## The returned structure can be used to generate the actual interface in the
## specified output folder with 'ipl::generate_interface' procedure.
## Quick usage: 'ipl::generate_interface [ipl::create_interface <options>] ./'
#
# \opt[if] -if $if
# \opt[vlnv] -vlnv {analog.com:<lib_name>:<interface_name>:<interface_version>}
# \opt[directConnection] -directConnection true
# \opt[isAddressable] -isAddressable false
# \opt[description] -description "description of the interface"
# \opt[ports] -ports {{-n DATA -d <in/out> -p <required/optional> -w 16}
#                     {-n CLK -d <in/out> -p <required/optional> -w 1}}
#            NOTE: -n means logicalName if the port
#                  -d means direction
#                  -p means presence
#                  -w means width (use it only when you want to force the width)
###############################################################################
    proc create_interface {args} {
        array set opt [list -if "$::ipl::if" \
            -vlnv "" \
            -vendor "" \
            -library "" \
            -name "" \
            -version "" \
            -directConnection "" \
            -isAddressable "" \
            -description "" \
            -ports ""  \
        {*}$args]

        set if $opt(-if)
        set ports $opt(-ports)
        set vlnv $opt(-vlnv)

        set vlnv [split $vlnv ":"]
        set ll [llength $vlnv]
        if {$ll == 4} {
            set vendor [lindex $vlnv 0]
            set library [lindex $vlnv 1]
            set name [lindex $vlnv 2]
            set version [lindex $vlnv 3]
            set opt(-vendor) [lindex $vlnv 0]
            set opt(-library) [lindex $vlnv 1]
            set opt(-name) [lindex $vlnv 2]
            set opt(-version) [lindex $vlnv 3]
        } else {
            puts {WARNING: vlnv is not correct!}
        }

        set optla {
            vendor
            library
            name
            version
            description
        }
        set optlb {
            vendor
            library
            name
            version
            directConnection
            isAddressable
            description
        }

        if {[ipl::getnchilds {} abstractionDefinition_desc $if] == ""} {
            set abst $::ipl::abstractionDefinition_desc
            set if [ipl::setnode {} abstractionDefinition_desc $abst $if]
        }
        if {[ipl::getnchilds {} busDefinition_desc $if] == ""} {
            set busd $::ipl::busDefinition_desc
            set if [ipl::setnode {} busDefinition_desc $busd $if]
        }

        set atts [list library "library=\"$library\"" \
            name "name=\"$name\"" \
            vendor "vendor=\"$vendor\"" \
            version "version=\"$version\""]
        set if [ipl::setatts abstractionDefinition_desc \
            ipxact:busType $atts $if]

        foreach op $optla {
            set val $opt(-$op)
            if {$val != ""} {
                set gtnm [ipl::getnname abstractionDefinition_desc \
                    "ipxact:$op" $if]
                if {$gtnm != ""} {
                    set if [ipl::setncont abstractionDefinition_desc \
                        "ipxact:$op" $val $if]
                } else {
                    set if [ipl::setnode abstractionDefinition_desc \
                        "ipxact:$op" [list "ipxact:$op" {} $val {}] $if]
                }
            }
        }
        foreach op $optlb {
            set val $opt(-$op)
            if {$val != ""} {
                if {[ipl::getnname busDefinition_desc "ipxact:$op" $if] != ""} {
                    set if [ipl::setncont busDefinition_desc \
                        "ipxact:$op" $val $if]
                } else {
                    set if [ipl::setnode busDefinition_desc \
                        "ipxact:$op" [list "ipxact:$op" {} $val {}] $if]
                }
            }
        }
        set if [ipl::add_interface_ports $if $ports]
        return $if
    }

    proc add_interface_port {args} {
        array set opt [list -if "$::ipl::if" \
            -logicalName "" \
            -description "" \
            -qualifier "data" \
            -presence "" \
            -width "" \
            -direction "" \
        {*}$args]

        set if $opt(-if)
        set logicalName $opt(-logicalName)
        set description $opt(-description)
        set qualifier $opt(-qualifier)
        set presence $opt(-presence)
        set width $opt(-width)
        set direction $opt(-direction)
        set port $::ipl::port_desc

        if {$logicalName != ""} {
            set port [ipl::setncont {} ipxact:logicalName $logicalName $port]
        }
        if {$description != ""} {
            set port [ipl::setncont {} ipxact:description $description $port]
        } else {
            set port \
                [ipl::setncont {} ipxact:description "$logicalName port" $port]
        }

        switch $qualifier {
            clock {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier \
                    ipxact:isClock ipxact:isClock $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier \
                    ipxact:isClock true $port]
            }
            reset {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier \
                    ipxact:isReset ipxact:isReset $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier \
                    ipxact:isReset true $port]
            }
            data {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier \
                    ipxact:isData ipxact:isData $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier \
                    ipxact:isData true $port]
            }
            address {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier \
                    ipxact:isAddress ipxact:isAddress $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier \
                    ipxact:isAddress true $port]
            }
            add {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier \
                    ipxact:isAddress ipxact:isAddress $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier \
                    ipxact:isAddress true $port]
            }
        }
        if {$presence != ""} {
            set port [ipl::setncont \
                ipxact:wire/ipxact:onMaster ipxact:presence $presence $port]
            set port [ipl::setncont \
                ipxact:wire/ipxact:onSlave ipxact:presence $presence $port]
        }
        if {$width != ""} {
            set port [ipl::setnname \
                ipxact:wire/ipxact:onMaster ipxact:width ipxact:width $port]
            set port [ipl::setnname \
                ipxact:wire/ipxact:onSlave ipxact:width ipxact:width $port]
            set port [ipl::setncont \
                ipxact:wire/ipxact:onMaster ipxact:width $width $port]
            set port [ipl::setncont \
                ipxact:wire/ipxact:onSlave ipxact:width $width $port]
        }
        if {$direction != ""} {
            if {$direction == "in"} {
                set port [ipl::setncont \
                    ipxact:wire/ipxact:onMaster ipxact:direction in $port]
                set port [ipl::setncont \
                    ipxact:wire/ipxact:onSlave ipxact:direction out $port]
            }
            if {$direction == "out"} {
                set port [ipl::setncont \
                    ipxact:wire/ipxact:onMaster ipxact:direction out $port]
                set port [ipl::setncont \
                    ipxact:wire/ipxact:onSlave ipxact:direction in $port]
            }
        }
        if {$qualifier == "clock" || $qualifier == "reset"} {
            set port [ipl::setncont \
                ipxact:wire/ipxact:onMaster ipxact:direction in $port]
            set port [ipl::setncont \
                ipxact:wire/ipxact:onSlave ipxact:direction in $port]
            set port [ipl::setnname \
                ipxact:wire ipxact:requiresDriver ipxact:requiresDriver $port]
            switch $qualifier {
                clock {
                    set port [ipl::setatt ipxact:wire ipxact:requiresDriver \
                        driverType "driverType=\"clock\"" $port]
                }
                reset {
                    set port [ipl::setatt ipxact:wire ipxact:requiresDriver \
                        driverType "driverType=\"singleShot\"" $port]
                }
            }
            set port \
                [ipl::setncont ipxact:wire ipxact:requiresDriver true $port]
        }
        if {[ipl::getnchilds {} abstractionDefinition_desc $if] == ""} {
            set abst $::ipl::abstractionDefinition_desc
            set if [ipl::setnode {} abstractionDefinition_desc $abst $if]
        }

        set if [ipl::setnode abstractionDefinition_desc/ipxact:ports \
            $logicalName $port $if]

        return $if
    }

    proc add_interface_ports {if ports} {
        foreach port $ports {
            set opts {}
            if {[dict keys $port -n] != ""} {
                dict set opts -logicalName [dict get $port -n]
            }
            if {[dict keys $port -d] != ""} {
                dict set opts -direction [dict get $port -d]
            }
            if {[dict keys $port -w] != ""} {
                dict set opts -width [dict get $port -w]
            }
            if {[dict keys $port -q] != ""} {
                dict set opts -qualifier [dict get $port -q]
            }
            if {[dict keys $port -p] != ""} {
                dict set opts -presence [dict get $port -p]
            }
            set if [ipl::add_interface_port -if $if {*}$opts]
        }
        return $if
    }

###############################################################################
## Generates an interface by the input interface structure and a given path.
## Quick usage: 'ipl::generate_interface [ipl::create_interface <options>] ./'
#               or 'set if [ipl::create_interface <options>]'
#                  'ipl::generate_interface $if ./'
#
# \parameter[if] $if
# \parameter[dpath] ./ (if no path is given it generates the interface in the
#                       default interface directory of Propel Builder IP
#                       download directory which is included in Propel Builder
#                       in default)
###############################################################################
    proc generate_interface {if {dpath ""}} {
        if {$dpath == ""} {
            if {[info exists ::env(LATTICE_DEFAULT_PATHS)] && \
                $::env(LATTICE_DEFAULT_PATHS) == 1} {
                set dpaths [list ./ $ipl::PropelIPLocal_path/interfaces]
            } else {
                set dpaths ./
            }
            foreach dp $dpaths {
                generate_interface_on_path $if $dp
            }
        } else {
            generate_interface_on_path $if $dpath
        }
    }

    proc generate_interface_on_path {if {dpath ""}} {
        if {$dpath == ""} {
            set dpath $ipl::PropelIPLocal_path/interfaces
        }

        set abstractionDefinition [ipl::getnode \
            {} abstractionDefinition_desc $if]
        set busDefinition [ipl::getnode {} busDefinition_desc $if]

        set vendor [ipl::getncont busDefinition_desc ipxact:vendor $if]
        set library [ipl::getncont busDefinition_desc ipxact:library $if]
        set name [ipl::getncont busDefinition_desc ipxact:name $if]
        set version [ipl::getncont busDefinition_desc ipxact:version $if]

        if {[file exist $dpath/$vendor/$library/$name/$version] != 1} {
            file mkdir $dpath/$vendor/$library/$name/$version
        }

        set busdef \
            [open "$dpath/$vendor/$library/$name/$version/${name}.xml" w]
        puts $busdef {<?xml version="1.0" encoding="UTF-8"?>}
        puts $busdef [ipl::generate_xml $busDefinition]
        close $busdef
        set abstdef \
            [open "$dpath/$vendor/$library/$name/$version/${name}_rtl.xml" w]
        puts $abstdef {<?xml version="1.0" encoding="UTF-8"?>}
        puts $abstdef [ipl::generate_xml $abstractionDefinition]
        close $abstdef
    }

    set ip [list {} {} {} [list fdeps {{fdeps} {} {} {
                {eval} {}
                {plugin} {}
                {doc} {}
                {rtl} {}
                {testbench} {}
                {driver} {}
                {ldc} {}
            }} \
        ip_desc $ip_desc addressSpaces_desc {} \
        busInterfaces_desc {} \
        memoryMaps_desc {}]]

    proc generate_xml {node {nid "0"} {index 0}} {
        set name [lindex $node 0]
        set attr [lindex $node 1]
        set content [lindex $node 2]
        set childs [lindex $node 3]

        if {$name == ""} {
            set xmlstring ""
            foreach {id child} $childs {
                set xmlstring "$xmlstring[generate_xml $child $id $index]"
            }
        } else {
            set xmlstring "[string repeat "    " $index]<$name"
            if {$name == "lsccip:port" || $name == "lsccip:setting"} {
                set rep [expr [string length $name] + 1]
                foreach {id att} $attr {
                    set xmlstring "$xmlstring $att\n[string repeat "    " \
                        $index][string repeat " " $rep]"
                }
            } else {
                foreach {id att} $attr {
                    set xmlstring "$xmlstring $att"
                }
            }
            if {$content == "" && $childs == ""} {
                set xmlstring "$xmlstring/>\n"
            } elseif {$content != "" && $childs == ""} {
                set xmlstring "$xmlstring>$content</$name>\n"
            } else {
                set xmlstring "$xmlstring>$content\n"
                foreach {id child} $childs {
                    set xmlstring \
                        "$xmlstring[generate_xml $child $id [expr $index + 1]]"
                }
                set xmlstring \
                    "$xmlstring[string repeat "    " $index]</$name>\n"
            }
        }
        return $xmlstring
    }

    proc setnode {path id node {desc {"" "" "" ""}}} {
        set debug 0
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]
        if {$debug} {
            puts "pth: $pth"
            puts "pth0: $pth0"
            puts "pt: $pt"
        }
        if {[llength $pth] != 0 } {
            if {$debug} {
                puts "dict keys childs pth0: [dict keys $childs $pth0]"
                puts "childs: $childs"
            }
            if {[dict keys $childs $pth0] != ""} {
                if {$debug} {
                    puts "childs(pth0): [dict get $childs $pth0]"
                }
                dict set childs $pth0 \
                    [setnode $pt $id $node [dict get $childs $pth0]]
                lset desc 3 $childs
                if {$debug} {
                    puts "childs: $childs"
                }
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                setnode {path id node {desc {}}} process!}
            }
        } else {
            dict set childs $id $node
            lset desc 3 $childs
        }
        return $desc
    }

    proc getnode {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                return [getnode $pt $id [dict get $childs $pth0]]
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                getnode {path id node {desc {}}} process!}
                exit 2
            }
        } else {
            if {[dict keys $childs $id] != ""} {
                return [dict get $childs $id]
            }
        }
    }

    proc rmnode {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                dict set childs $pth0 [rmnode $pt $id [dict get $childs $pth0]]
                lset desc 3 $childs
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                rmnode {path id node {desc {}}} process!}
                exit 2
            }
        } else {
            if {[dict keys $childs $id] != ""} {
                dict unset childs $id
                lset desc 3 $childs
            } else {
                puts "rmnode:"
                puts "WARNING, no element with id:$id found!"
            }
        }
        return $desc
    }

    proc getnchilds {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                return [getnchilds $pt $id [dict get $childs $pth0]]
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                getnode {path id node {desc {}}} process!}
                exit 2
            }
        } else {
            if {[dict keys $childs $id] != ""} {
                set node [dict get $childs $id]
                return [lindex $node 3]
            }
        }
    }

    proc rmnchilds {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                dict set childs $pth0 \
                    [rmnchilds $pt $id [dict get $childs $pth0]]
                lset desc 3 $childs
            } else {
                puts {ERROR: Wrong path, please check the path in the \
                rmnode {path id node {desc {}}} process!}
                exit 2
            }
        } else {
            if {[dict keys $childs $id] != ""} {
                set node [dict get $childs $id]
                lset node 3 {}
                dict set childs $id $node
                lset desc 3 $childs
            } else {
                puts "rmnchilds:"
                puts "WARNING, no element with id:$id found!"
            }
        }
        return $desc
    }

    proc getatts {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        return [lindex $node 1]
    }
    proc getatt {path nodeid attid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        set atts [lindex $node 1]
        return [dict get $atts $attid]
    }
    proc setatts {path nodeid atts {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 1 $atts
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc setatt {path nodeid attid att {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        set atts [lindex $node 1]
        dict set atts $attid $att
        lset node 1 $atts
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc rmatts {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 1 {}
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc rmatt {path nodeid attid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        set atts [lindex $node 1]
        dict unset atts $attid
        lset node 1 $atts
        return [ipl::setnode $path $nodeid $node $desc]
    }

    proc getnname {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        return [lindex $node 0]
    }
    proc setnname {path nodeid nname {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 0 $nname
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc rmnname {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 0 {}
        return [ipl::setnode $path $nodeid $node $desc]
    }

    proc getncont {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        return [lindex $node 2]
    }
    proc setncont {path nodeid cont {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 2 $cont
        return [ipl::setnode $path $nodeid $node $desc]
    }
    proc rmncont {path nodeid {desc {"" "" "" ""}}} {
        set node [ipl::getnode $path $nodeid $desc]
        lset node 2 {}
        return [ipl::setnode $path $nodeid $node $desc]
    }

###############################################################################
## Sets the IP structure with the specified general IP parameters.
## You can check the Lattice Propel IP Packager documentation for parameter
## use cases at: https://www.latticesemi.com/view_document?document_id=54003
#
## Quick usage: 'set ip [ipl::general -ip $ip <options>]'
#
# \opt[ip] -ip $ip
# \opt[vlnv] -vlnv {analog.com:<lib_name>:<ip_name>:<ip_version>}
# \opt[display_name] -display_name "AXI_DMA ADI"
# \opt[category] -category "DATA_TRANSFER"
# \opt[keywords] -keywords "<some descriptive words>"
# \opt[min_radiant_version] -min_radiant_version 2022.1
# \opt[max_radiant_version] -max_radiant_version 2023.2
# \opt[min_esi_version] -min_esi_version 2022.1
# \opt[max_esi_version] -max_esi_version 2023.2
# \opt[supported_products] -supported_products {LIFCL LFD2NX LFCPNX}
#                          -supported_products {*} #<this means all devices>#
# \opt[supported_platforms] -supported_platforms {esi radiant}
# \opt[href] -href "https://analogdevicesinc.github.io/hdl/library/axi_dmac/index.html"
###############################################################################
    proc general {args} {
        array set opt [list -ip "$::ipl::ip" \
            -vlnv "" \
            -vendor "analog.com" \
            -library "ip" \
            -name "" \
            -display_name "" \
            -version "1.0" \
            -category "ADI" \
            -keywords "ADI IP" \
            -min_radiant_version "2022.1" \
            -max_radiant_version "" \
            -type "" \
            -min_esi_version "2022.1" \
            -max_esi_version "" \
            -supported_products "" \
            -supported_platforms "" \
            -href "" \
        {*}$args]

        set vlnv $opt(-vlnv)

        set vlnv [split $vlnv ":"]
        set ll [llength $vlnv]
        if {$ll == 4} {
            set opt(-vendor) [lindex $vlnv 0]
            set opt(-library) [lindex $vlnv 1]
            set opt(-name) [lindex $vlnv 2]
            set opt(-version) [lindex $vlnv 3]
        } else {
            puts {WARNING: vlnv is not correct!}
        }

        set optl {
            vendor
            library
            name
            display_name
            version
            category
            keywords
            min_radiant_version
            max_radiant_version
            type
            min_esi_version
            max_esi_version
        }
        set ip $opt(-ip)
        set href $opt(-href)
        set supported_products $opt(-supported_products)
        set supported_platforms $opt(-supported_platforms)

        if {$href != ""} {
            set ip [ipl::setncont ip_desc/lsccip:general href $href $ip]
        }

        foreach op $optl {
            set val $opt(-$op)
            if {$val != ""} {
                set gtnm [ipl::getnname ip_desc/lsccip:general "lsccip:$op" $ip]
                if {$gtnm != ""} {
                    set ip [ipl::setncont \
                        ip_desc/lsccip:general "lsccip:$op" $val $ip]
                } else {
                    set ip [ipl::setnode \
                        ip_desc/lsccip:general "lsccip:$op" \
                        [list "lsccip:$op" {} $val {}] $ip]
                }
            }
        }
        foreach family $supported_products {
            set sfamily [list lsccip:supported_family \
                [list name "name=\"$family\""] {} {}]
            set ip [ipl::setnode \
                ip_desc/lsccip:general/lsccip:supported_products \
                $family $sfamily $ip]
        }
        foreach platform $supported_platforms {
            set splatform [list lsccip:supported_platform \
                [list name "name=\"$platform\""] {} {}]
            set ip [ipl::setnode \
                ip_desc/lsccip:general/lsccip:supported_platforms \
                $platform $splatform $ip]
        }
        return $ip
    }

    proc set_wrapper_type {args} {
        array set opt [list -ip "$::ipl::ip" \
            -file_ext "v" \
        {*}$args]

        set ip $opt(-ip)
        set file_ext $opt(-file_ext)

        if {[ipl::getnname ip_desc lsccip:outFileConfigs $ip] == ""} {
            set ip [ipl::setnname \
                ip_desc lsccip:outFileConfigs lsccip:outFileConfigs $ip]
        }

        if {$file_ext == "v"} {
            set atts {name {name="wrapper"} \
                file_suffix {file_suffix="v"} \
                file_description {file_description="top_level_verilog"}}
        } elseif {$file_ext == "sv"} {
            set atts {name {name="wrapper"} \
                file_suffix {file_suffix="sv"} \
                file_description {file_description="top_level_system_verilog"}}
        }

        set node [list lsccip:fileConfig $atts {} {}]
        set ip [ipl::setnode \
            ip_desc/lsccip:outFileConfigs wrapper_type $node $ip]

        return $ip
    }

###############################################################################
## Sets the IP structure with a configuration parameter which will appear
## in the IP GUI also.
## You can check the Lattice Propel IP Packager documentation for parameter
## use cases as Setting Nodes at:
##                   https://www.latticesemi.com/view_document?document_id=54003
## Quick usage: 'set ip [ipl::create_interface -ip $ip <options>]'
#
# \opt[ip] -ip $ip
# \opt[id] -id DMA_DATA_WIDTH_SRC
# \opt[title] -title {Bus Width}
# \opt[type] -type param
# \opt[value_type] -value_type int
# \opt[conn_mod] -conn_mod axi_dmac
# \opt[default] -default 64
# \opt[value_expr] -value_expr <check the IP Packager manual>
# \opt[options] -options {[16, 32, 64, 128, 256, 512, 1024, 2048]}
#               -options {[(True, 1), (False, 0)]}
#               -options {[('OPT1', 0), ('OPT2', 1), ('OPT3', 2)]}
# \opt[output_formatter] -output_formatter nostr
# \opt[bool_value_mapping] -bool_value_mapping <check the IP Packager manual>
# \opt[editable] -editable {(<python expression based on the top module parameters>)}
# \opt[hidden] -hidden {(<python expression based on the top module parameters>)}
# \opt[drc] -drc <check the IP Packager manual>
# \opt[regex] -regex <check the IP Packager manual>
# \opt[value_range] -value_range {(0, 255)}
# \opt[config_groups] -config_groups <check the IP Packager manual>
# \opt[group1] -group1 {Sub Group}
# \opt[group2] -group2 {Tab Group}
# \opt[macro_name] -macro_name <check the IP Packager manual>
###############################################################################
    proc set_parameter {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -id "" \
            -title "" \
            -type "" \
            -value_type "" \
            -conn_mod "" \
            -default "" \
            -value_expr "" \
            -options "" \
            -output_formatter "" \
            -bool_value_mapping "" \
            -editable "" \
            -hidden "" \
            -drc "" \
            -regex "" \
            -value_range "" \
            -config_groups "" \
            -description "" \
            -group1 "" \
            -group2 "" \
            -macro_name "" \
        {*}$args]
        # TODO: maybe -optional for entering exact xml attribute string

        set optl {
            id
            type
            value_type
            conn_mod
            title
            default
            value_expr
            options
            output_formatter
            bool_value_mapping
            editable
            hidden
            drc
            regex
            value_range
            config_groups
            description
            group1
            group2
            macro_name
        }

        set ip $opt(-ip)
        set id $opt(-id)

        set c {"}
        set atts {}
        foreach attid $optl {
            set att $opt(-$attid)
            if {$att != ""} {
                set atts [list {*}$atts $attid "${attid}=$c$att$c"]
            }
        }
        set stnode [ipl::getnode ip_desc lsccip:settings $ip]
        if {$debug} {
            puts $stnode
        }
        if {[lindex $stnode 0] == ""} {
            lset stnode 0 {lsccip:settings}
            if {$debug} {
                puts $stnode
            }
            set ip [ipl::setnode ip_desc lsccip:settings $stnode $ip]
        }
        if {$id != ""} {
            if {[ipl::getnode ip_desc/lsccip:settings $id $ip] != ""} {
                foreach attid $optl {
                    set att $opt(-$attid)
                    if {$att != ""} {
                        set ip [ipl::setatt ip_desc/lsccip:settings $id $attid \
                            "${attid}=$c$att$c" $ip]
                    }
                }
            } else {
                set node [list lsccip:setting $atts {} {}]
                set ip [ipl::setnode ip_desc/lsccip:settings $id $node $ip]
            }
        } else {
            puts "WARNING, you must define '-id'"
        }
        return $ip
    }

    proc set_port {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -dir "" \
            -range "" \
            -conn_mod "" \
            -conn_port "" \
            -conn_range "" \
            -stick_high "" \
            -stick_low "" \
            -stick_value "" \
            -dangling "" \
            -bus_interface "" \
            -attribute "" \
            -port_type "" \
        {*}$args]
        # TODO: maybe -optional for entering exact xml attribute string

        set ip $opt(-ip)
        set id $opt(-name)

        set optl {
            name
            dir
            conn_mod
            range
            conn_port
            conn_range
            stick_high
            stick_low
            stick_value
            dangling
            bus_interface
            attribute
            port_type
        }

        set c {"}
        set atts {}
        foreach attid $optl {
            set att $opt(-$attid)
            if {$att != ""} {
                set atts [list {*}$atts $attid "${attid}=$c$att$c"]
            }
        }
        set ptnode [ipl::getnode ip_desc lsccip:ports $ip]
        if {$debug} {
            puts $ptnode
        }
        if {[lindex $ptnode 0] == ""} {
            lset ptnode 0 {lsccip:ports}
            if {$debug} {
                puts $ptnode
            }
            set ip [ipl::setnode ip_desc lsccip:ports $ptnode $ip]
        }
        if {$id != ""} {
            if {[ipl::getnode ip_desc/lsccip:ports $id $ip] != ""} {
                foreach attid $optl {
                    set att $opt(-$attid)
                    if {$att != ""} {
                        set ip [ipl::setatt ip_desc/lsccip:ports $id $attid \
                            "${attid}=$c$att$c" $ip]
                    }
                }
            } else {
                set node [list lsccip:port $atts {} {}]
                set ip [ipl::setnode ip_desc/lsccip:ports $id $node $ip]
            }
        } else {
            puts "WARNING, you must define '-name'"
        }
        return $ip
    }

###############################################################################
## Ignores and hides ports from GUI when a Python expression based on module
## parameters becomes true.
#
# \opt[ip] -ip $ip
# \opt[portlist] -portlist {sync}
# \opt[expression] -expression {not((SYNC_TRANSFER_START == 1) and
#                                  (DMA_TYPE_SRC != 1 or AXIS_TUSER_SYNC != 1))}
###############################################################################
    proc ignore_ports {args} {
        array set opt [list -ip "$::ipl::ip" \
            -portlist "" \
            -expression "" \
        {*}$args]

        set ip $opt(-ip)
        set portlist $opt(-portlist)
        set expression $opt(-expression)

        foreach port $portlist {
            set ip [ipl::set_port -ip $ip -name $port -dangling $expression]
        }
        return $ip
    }

    proc get_ports_by_prefix {args} {
        array set opt [list -mod_data "" \
            -v_prefix "" \
            -xptn_portlist "" \
            -regexp "" \
        {*}$args]

        set mod_data $opt(-mod_data)
        set v_prefix $opt(-v_prefix)
        set xptn_portlist $opt(-xptn_portlist)
        set regexp $opt(-regexp)
        set ports [dict get $mod_data portlist]

        set portlist {}
        set regx [list ${v_prefix}_.+]
        if {$regexp != ""} {
            set regx $regexp
        }
        foreach line $ports {
            set pname [dict get $line name]
            set existpn [lsearch $xptn_portlist $pname]
            if {$existpn == -1 && [regexp $regx $pname]} {
                set portlist [list {*}$portlist $pname]
            }
        }
        return $portlist
    }

###############################################################################
## Ignores and hides ports from GUI when a Python expression based on module
## parameters becomes true. Uses the parsed module data from top module to
## find a list of ports with a specified -v_prefix like <some_prefix>_aclk.
## An other option is to use a tcl -regexp expression to filter the ports.
## When the -regexp option is used the -v_prefix option is ignored.
#
# \opt[ip] -ip $ip
# \opt[mod_data] -mod_data $mod_data
# \opt[v_prefix] -v_prefix <verilog_prefix>
# \opt[xptn_portlist] -xptn_portlist {<exeption_port0> <exeption_port1>}
# \opt[expression] -expression {not(DMA_TYPE_DEST == 2)}
# \opt[regexp] -regexp {fifo_wr_.+}
###############################################################################
    proc ignore_ports_by_prefix {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
            -v_prefix "" \
            -xptn_portlist "" \
            -expression "" \
            -regexp "" \
        {*}$args]

        set ip $opt(-ip)
        set mod_data $opt(-mod_data)
        set expression $opt(-expression)
        set regexp $opt(-regexp)
        set v_prefix $opt(-v_prefix)
        set xptn_portlist $opt(-xptn_portlist)

        set portlist [ipl::get_ports_by_prefix \
            -mod_data $mod_data \
            -v_prefix $v_prefix \
            -xptn_portlist $xptn_portlist \
            -regexp $regexp]
        set ip [ipl::ignore_ports \
            -ip $ip \
            -expression $expression \
            -portlist $portlist]
        return $ip
    }

    proc add_component_generator {args} {
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -generator "" \
        {*}$args]

        set ip $opt(-ip)
        set name $opt(-name)
        set generator $opt(-generator)

        if {$name != ""} {
            if {[ipl::getnname ip_desc lsccip:componentGenerators $ip] == ""} {
                set ip [ipl::setnname ip_desc lsccip:componentGenerators \
                    lsccip:componentGenerators $ip]
            }
            set cpgen $::ipl::componentGenerator_desc
            set cpgen [ipl::setncont {} lsccip:name $name $cpgen]
            set cpgen [ipl::setncont {} lsccip:generatorExe $generator $cpgen]
            set ip [ipl::setnode \
                ip_desc/lsccip:componentGenerators $name $cpgen $ip]
        }
        return $ip
    }

###############################################################################
## Sets an address space in the IP structure.
## The name of this address space must be used when adding a master memory
## mapped interface like:
## 'set ip [ipl::add_interface -ip $ip <other opts> -addr_space_ref <addr_space_name>]'
#
## Quick usage: 'set ip [ipl::add_address_space -ip $ip <options>]'
#
# \opt[ip] -ip $ip
# \opt[name] -name "some_address_space"
# \opt[range] -range 0x100000000
# \opt[width] -width 32
###############################################################################
    proc add_address_space {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -range "" \
            -width "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-name)
        set name $opt(-name)
        set range $opt(-range)
        set width $opt(-width)

        if {$name != ""} {
            set adnode [ipl::getnode "" addressSpaces_desc $ip]
            if {$debug} {
                puts $adnode
            }
            if {[lindex $adnode 0] == ""} {
                set adnode $::ipl::addressSpaces_desc
                if {$debug} {
                    puts $adnode
                }
                set ip [ipl::setnode "" addressSpaces_desc $adnode $ip]
            }
            set addrsp $::ipl::addressSpace_desc
            set addrsp [ipl::setncont {} lsccip:name $name $addrsp]
            if {$range != ""} {
                set addrsp [ipl::setncont {} lsccip:range $range $addrsp]
            }
            if {$width != ""} {
                set addrsp [ipl::setncont {} lsccip:width $width $addrsp]
            }

            set ip [ipl::setnode addressSpaces_desc $id $addrsp $ip]
        }

        return $ip
    }

###############################################################################
## Sets a memory map in the IP structure.
## The name of this memory map must be used when adding a slave memory mapped
## interface like:
## 'set ip [ipl::add_interface -ip $ip <other opts> -mem_map_ref <mem_map_name>]'
## Quick usage: 'set ip [ipl::add_memory_map -ip $ip <options>]'
#
# \opt[ip] -ip $ip
# \opt[name] -name "axi_dmac_mem_map"
# \opt[description] -description "axi_dmac_mem_map"
# \opt[baseAddress] -baseAddress 0
# \opt[range] -range 65536
# \opt[width] -width 32
###############################################################################
    proc add_memory_map {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -description "" \
            -baseAddress "" \
            -range "" \
            -width "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-name)
        set name $opt(-name)
        set description $opt(-description)
        set baseAddress $opt(-baseAddress)
        set range $opt(-range)
        set width $opt(-width)

        if {$name != ""} {
            set mmapsnode [ipl::getnode "" memoryMaps_desc $ip]
            if {$debug} {
                puts $mmapsnode
            }
            if {[lindex $mmapsnode 0] == ""} {
                set mmapsnode $::ipl::memoryMaps_desc
                if {$debug} {
                    puts $mmapsnode
                }
                set ip [ipl::setnode "" memoryMaps_desc $mmapsnode $ip]
            }
            set mmapn $::ipl::memoryMap_desc
            set mmapn [ipl::setncont {} lsccip:name $name $mmapn]
            set mmapn [ipl::setncont {} lsccip:description $description $mmapn]
            set adbln $::ipl::addressBlock_desc
            set adbln [ipl::setncont {} lsccip:name ${name}_reg_space $adbln]
            if {$baseAddress != ""} {
                set adbln \
                    [ipl::setncont {} lsccip:baseAddress $baseAddress $adbln]
            }
            if {$range != ""} {
                set adbln [ipl::setncont {} lsccip:range $range $adbln]
            }
            if {$width != ""} {
                set adbln [ipl::setncont {} lsccip:width $width $adbln]
            }

            set mmapn [ipl::setnode {} lsccip:addressBlock $adbln $mmapn]
            set ip [ipl::setnode memoryMaps_desc $id $mmapn $ip]
        }

        return $ip
    }

    set inclid 0
    proc include {args} {
        set debug 0
        array set opt [list -ip "$::ipl::ip" \
            -id "" \
            -include "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-id)
        set include $opt(-include)

        if {$include != ""} {
            set c {"}
            set node [list xi:include \
                [list href href=$c$include$c parse {parse="xml"}] {} {}]
            if {$debug} {
                puts $node
            }
            if {$id == ""} {
                set ip \
                    [ipl::setnode ip_desc/xi:include $::ipl::inclid $node $ip]
                incr ipl::inclid
            } else {
                set ip [ipl::setnode ip_desc/xi:include $id $node $ip]
            }
        }
        return $ip
    }

    proc generate_ip {ip {dpath ""} {ip_name ""}} {
        if {$dpath == ""} {
            if {[info exists ::env(LATTICE_DEFAULT_PATHS)] && \
                $::env(LATTICE_DEFAULT_PATHS) == 1} {
                set dpaths [list ./ ltt $ipl::PropelIPLocal_path {}]
            } else {
                set dpaths [list ./ ltt]
            }
            foreach {dp ipn} $dpaths {
                generate_ip_on_path $ip $dp $ipn
            }
        } else {
            generate_ip_on_path $ip $dpath $ip_name
        }
    }

    proc generate_ip_on_path {ip {dpath ""} {ip_name ""}} {
        if {$ip_name == ""} {
            set ip_name [ipl::getncont ip_desc/lsccip:general lsccip:name $ip]
        }
        if {$ip_name == ""} {
            puts "ERROR: You must define ip_name or '-name' at ipl::general!"
            exit 2
        }
        if {$dpath == ""} {
            set dpath $ipl::PropelIPLocal_path
        }
        if {[file exist $dpath] != 1} {
            file mkdir $dpath
        }
        if {[file exist $dpath/$ip_name/doc] != 1} {
            file mkdir $dpath/$ip_name/doc
        }
        set file [open "$dpath/$ip_name/doc/introduction.html" w]
        foreach line [ipl::docsgen $ip] {
            puts $file $line
        }
        close $file
        set fdeps [ipl::getnchilds {} fdeps $ip]
        foreach {folder flist} $fdeps {
            if {$flist != ""} {
                if {[file exists $dpath/$ip_name/$folder] != 1} {
                    file mkdir $dpath/$ip_name/$folder
                }
                file copy -force {*}$flist $dpath/$ip_name/$folder
            }
        }

        set busInterfaces_desc [ipl::getnode {} busInterfaces_desc $ip]
        if {$busInterfaces_desc != ""} {
            set ip [ipl::include -ip $ip -include bus_interface.xml]
            set file [open "$dpath/$ip_name/bus_interface.xml" w]
            puts [generate_xml $busInterfaces_desc]
            puts $file [generate_xml $busInterfaces_desc]
            close $file
        } else {
            puts "WARNING, No busInterfaces_desc defined!"
        }
        set addressSpaces_desc [ipl::getnode {} addressSpaces_desc $ip]
        if {$addressSpaces_desc != ""} {
            set ip [ipl::include -ip $ip -include address_space.xml]
            set file [open "$dpath/$ip_name/address_space.xml" w]
            puts [generate_xml $addressSpaces_desc]
            puts $file [generate_xml $addressSpaces_desc]
            close $file
        } else {
            puts "WARNING, No addressSpaces_desc defined!"
        }
        set memoryMaps_desc [ipl::getnode {} memoryMaps_desc $ip]
        if {$memoryMaps_desc != ""} {
            set ip [ipl::include -ip $ip -include memory_map.xml]
            set file [open "$dpath/$ip_name/memory_map.xml" w]
            puts [generate_xml $memoryMaps_desc]
            puts $file [generate_xml $memoryMaps_desc]
            close $file
        } else {
            puts "WARNING, No memoryMaps_desc defined!"
        }
        set ip_desc [ipl::getnode {} ip_desc $ip]
        if {$ip_desc != ""} {
            set file [open "$dpath/$ip_name/metadata.xml" w]
            puts [generate_xml $ip_desc]
            puts $file [generate_xml $ip_desc]
            close $file
        } else {
            puts "ERROR, No ip_desc defined!"
        }
    }

###############################################################################
## Parses a modules data into a specified structure, this structure then can
## be used in other procedures which simplify the IP generation.
## Quick usage: 'set mod_data [ipl::parse_module ./axi_dmac.v]'
#
# \parameter[path] ./axi_dmac.v
###############################################################################
    proc parse_module {path} {
        set debug 0
        set file [open $path]
        set data [read $file]
        close $file

        set index [string first "\n" $data]

        if {$index == -1} {
            set first_line $data
        } else {
            set first_line [string range $data 0 $index]
        }

        if {[regexp {\s*module\s+[^;#(\n]+} $first_line match]} {
            set mod_name [string map {" " ""} [lindex $match 1]]
        } elseif {[regexp {\n\s*module\s+[^;#(\n]+} $data match]} {
            set mod_name [string map {" " ""} [lindex $match 1]]
        } else {
            puts {ERROR, no module found in the verilog file!}
            exit 2
        }

        set portlist {}
        set parlist {}

        set param_lines [regexp -all -inline {\n\s*parameter[^\n]+} $data]
        set last_param_line [lindex $param_lines end]
        set param_lines [lrange $param_lines 0 end-1]

        set port_lines [regexp -all -inline \
            {\n\s*input[^\n]+|\n\s*output[^\n]+|\n\s*inout[^\n]+} $data]

        # to match {dir, type, size, name}
        set regx_port \
            {\s*(input|output|inout)\s+(\w+\s+)?(\[.+:.+\]\s+)?(\w+)\s*}
        # to match {type, size, name, sign, value}
        set regx_param \
            {\s*parameter\s+(\w+\s+)?(\[.+:.+\]\s+)?(\w+)\s*(=\s*)?([^,;]+)?\s*}

        foreach line $port_lines {
            set captures [split $line {,;}]
            foreach cap $captures {
                if {$cap != ""} {
                    if {[regexp $regx_port $cap -> direction type size name]} {
                        set portlist [list {*}$portlist \
                            [ipl::format_port $direction $type $size $name]]
                    }
                }
            }
        }

        foreach line $param_lines {
            set captures [split $line {,;}]
            foreach cap $captures {
                if {$cap != ""} {
                    if {[regexp $regx_param $cap -> type size name sign value]} {
                        set parlist [list {*}$parlist \
                            [ipl::format_parameter $type $size $name $value]]
                    }
                }
            }
        }
        set captures [split $last_param_line {,;}]
        foreach cap $captures {
            if {$cap != ""} {
                if {[regexp $regx_param $cap -> type size name sign value]} {
                    if {[regexp {(|)} $value]} {
                        set value [ipl::get_balanced_section $value]
                    }
                    set parlist [list {*}$parlist \
                        [ipl::format_parameter $type $size $name $value]]
                }
            }
        }

        set mod_data [list portlist $portlist parlist $parlist \
            mod_name $mod_name]
        return $mod_data
    }

    proc get_balanced_section {str {open {(}} {close {)}}} {
        set diff 0
        set last_index 0

        for {set i 0} {$i < [string length $str]} {incr i} {
            set char [string index $str $i]
            if {$char == $open} {
                incr diff
            } elseif {$char == $close} {
                if {$diff == 0} {
                    set last_index $i
                    break
                }
                incr diff -1
            }
            if {$diff == 0} {
                set last_index [expr {$i + 1}]
            }
        }
        return [string range $str 0 [expr {$last_index - 1}]]
    }

    proc format_parameter {type size name value} {
        if {$type != ""} {
            set type [string map {" " ""} $type]
            dict set param type $type
        }
        if {$size != ""} {
            set size [string map {"[" "" "]" "" " " ""} $size]
            set size [split $size {:}]
            set from [lindex $size 0]
            set to [lindex $size 1]
            dict set param from $from
            dict set param to $to
        }
        dict set param name $name
        if {$value != ""} {
            set value [string map {" " ""} $value]
            dict set param value $value
        }
        return $param
    }

    proc format_port {direction type size name} {
        dict set port dir $direction
        if {$type != ""} {
            set type [string map {" " ""} $type]
            dict set port type $type
        }
        if {$size != ""} {
            set size [string map {"[" "" "]" "" " " ""} $size]
            set size [split $size {:}]
            set from [lindex $size 0]
            set to [lindex $size 1]
            dict set port from $from
            dict set port to $to
        }
        dict set port name $name
        return $port
    }

###############################################################################
## Adds a predefined interface to the IP structure.
## Creates memory map or address space by default if there is no memory map
## or address space added to the IP if the address space or memory map
## refference is specified. The address space is created for the full range of
## 32 bit address. The default memory map range is 64k. If you want to specify
## separately you can add them manually then use the memory map or address space
## name at -mem_map_ref -addr_space_ref. you can even update later using the
## reference name specified here by using: ipl::add_memory_map or
## ipl::add_address_space. As summary you must specify -mem_map_ref or
## -addr_space_ref depending on slave or master whenever you add a memory mapped
## interface to the IP.
#
# \opt[ip] -ip $ip
# \opt[inst_name] -inst_name fifo_wr
# \opt[display_name] -display_name fifo_wr
# \opt[description] -description fifo_wr
# \opt[master_slave] -master_slave slave
# \opt[portmap] -portmap {{"fifo_rd_en" "EN"} {"fifo_rd_dout" "DATA"}}
# \opt[mem_map_ref] -mem_map_ref s_axi_mem_map
# \opt[addr_space_ref] -addr_space_ref m_axi_aspace_ref
# \opt[vlnv] -vlnv {analog.com:<lib_name>:<interface_name>:<interface_version>}
###############################################################################
    proc add_interface {args} {
        array set opt [list -ip "$::ipl::ip" \
            -vlnv "" \
            -inst_name "" \
            -display_name "" \
            -description "" \
            -master_slave "" \
            -mem_map_ref "" \
            -addr_space_ref "" \
            -portmap "" \
        {*}$args]

        set c {"}
        set vlnv $opt(-vlnv)
        set ip $opt(-ip)
        set inst_name $opt(-inst_name)
        set display_name $opt(-display_name)
        set description $opt(-description)
        set master_slave $opt(-master_slave)
        set mem_map_ref $opt(-mem_map_ref)
        set addr_space_ref $opt(-addr_space_ref)
        set portmap $opt(-portmap)

        set vlnv [split $vlnv ":"]
        set ll [llength $vlnv]
        if {$ll == 4} {
            set vendor [lindex $vlnv 0]
            set library [lindex $vlnv 1]
            set name [lindex $vlnv 2]
            set version [lindex $vlnv 3]
        } else {
            puts {WARNING: vlnv is not correct!}
        }

        if {$master_slave == "slave" && $mem_map_ref != ""} {
            if {[ipl::getnode memoryMaps_desc $mem_map_ref $ip] == ""} {
                set ip [ipl::add_memory_map -ip $ip \
                    -name $mem_map_ref \
                    -description $mem_map_ref \
                    -baseAddress 0 \
                    -range 65536 \
                    -width 32]
            }
        }
        if {$master_slave == "master" && $addr_space_ref != ""} {
            if {[ipl::getnode addressSpaces_desc $addr_space_ref $ip] == ""} {
                set ip [ipl::add_address_space -ip $ip \
                    -name $addr_space_ref \
                    -range 0x100000000 \
                    -width 32]
            }
        }

        set atts [list library "library=\"$library\"" \
            name "name=\"$name\"" \
            vendor "vendor=\"$vendor\"" \
            version "version=\"$version\""]

        set bif $::ipl::busInterface_desc
        set bif [ipl::setncont {} lsccip:name $inst_name $bif]
        set bif [ipl::setncont {} lsccip:displayName $display_name $bif]
        set bif [ipl::setncont {} lsccip:description $description $bif]
        set bif [ipl::setatts {} lsccip:busType $atts $bif]
        dict set atts name "name=\"${name}_rtl\""
        set bif [ipl::setatts lsccip:abstractionTypes/lsccip:abstractionType \
            lsccip:abstractionRef $atts $bif]
        set bif [ipl::setnname {} lsccip:master_slave lsccip:$master_slave $bif]

        if {$master_slave == "slave" && $mem_map_ref != ""} {
            set mmap_ref_node [list lsccip:memoryMapRef \
                [list memoryMapRef "memoryMapRef=\"$mem_map_ref\""] {} {}]
            set bif [ipl::setnode \
                lsccip:master_slave lsccip:memoryMapRef $mmap_ref_node $bif]
        }
        if {$master_slave == "master" && $addr_space_ref != ""} {
            set aspace_ref_node [list lsccip:addressSpaceRef \
                [list addressSpaceRef "addressSpaceRef=\"$addr_space_ref\""] \
                {} {}]
            set bif [ipl::setnode lsccip:master_slave lsccip:addressSpaceRef \
                $aspace_ref_node $bif]
        }

        foreach line $portmap {
            set pname [lindex $line 0]
            set logic [lindex $line 1]
            set pmap [ipl::setncont \
                lsccip:logicalPort lsccip:name $logic $::ipl::portMap_desc]
            set pmap [ipl::setncont \
                lsccip:physicalPort lsccip:name $pname $pmap]
            set bif [ipl::setnode \
                lsccip:abstractionTypes/lsccip:abstractionType/lsccip:portMaps \
                $pname $pmap $bif]
            set ip [ipl::set_port \
                -ip $ip \
                -name $pname \
                -bus_interface $inst_name]
        }
        set bifs [ipl::getnode {} busInterfaces_desc $ip]
        if {$bifs == ""} {
            set bifs $::ipl::busInterfaces_desc
        }
        set bifsl [lindex $bifs 3]
        dict set bifsl $inst_name $bif
        lset bifs 3 $bifsl
        set ip [ipl::setnode {} busInterfaces_desc $bifs $ip]

        return $ip
    }

###############################################################################
## Adds an interface by filtering ports by prefix when a naming standard
## like <verilog_prefix>_<standard_port_name> is used.
## Creates memory map or address space by default if there is no memory map
## or address space added to the IP if the address space or memory map
## refference is specified. The address space is created for the full range of
## 32 bit address. The default memory map range is 64k. If you want to specify
## separately you can add them manually then use the memory map or address space
## name at -mem_map_ref -addr_space_ref. you can even update later using the
## reference name specified here by using: ipl::add_memory_map or
## ipl::add_address_space. As summary you must specify -mem_map_ref or
## -addr_space_ref depending on slave or master whenever you add a memory mapped
## interface to the IP.
#
# \opt[ip] -ip $ip
# \opt[inst_name] -inst_name fifo_wr
# \opt[display_name] -display_name fifo_wr
# \opt[description] -description fifo_wr
# \opt[master_slave] -master_slave slave
# \opt[vendor] -vendor analog.com
# \opt[library] -library ADI
# \opt[name] -name fifo_wr
# \opt[version] -version 1.0
# \opt[mod_data] -mod_data $mod_data
# \opt[v_prefix] -v_prefix fifo_wr
# \opt[xptn_portlist] -xptn_portlist {<exeption_port0> <exeption_port1>}
# \opt[t] -t t <- works like this: ${t}ready completes the portname to standard
# tready if only a prefix is a difference and the
# <verilog_prefix>_${t}<partially_standard_portname> completes the portname
# to <verilog_prefix>_<standard_port_name>
###############################################################################
    proc add_interface_by_prefix {args} {
        array set opt [list -ip "$::ipl::ip" \
            -vlnv "" \
            -inst_name "" \
            -display_name "" \
            -description "" \
            -master_slave "" \
            -mem_map_ref "" \
            -addr_space_ref "" \
            -mod_data "" \
            -v_prefix "" \
            -xptn_portlist "" \
            -t "" \
        {*}$args]

        set optl {
            -ip
            -inst_name
            -display_name
            -description
            -vlnv
            -master_slave
            -mem_map_ref
            -addr_space_ref
        }
        set argl {}
        foreach op $optl {
            set argl [list {*}$argl $op $opt($op)]
        }

        set mod_data $opt(-mod_data)
        set v_prefix $opt(-v_prefix)
        set xptn_portlist $opt(-xptn_portlist)
        set t $opt(-t)

        set portmap {}
        set portlist [ipl::get_ports_by_prefix \
            -mod_data $mod_data \
            -v_prefix $v_prefix \
            -xptn_portlist $xptn_portlist]

        foreach pname $portlist {
            set logic \
                [string toupper "$t[string map [list ${v_prefix}_ ""] $pname]" ]
            set portmap [list {*}$portmap [list $pname $logic]]
        }
        return [ipl::add_interface {*}$argl -portmap $portmap]
    }

###############################################################################
## Sets the IP structure with ports' data from top module.
## Quick usage: 'set mod_data [ipl::parse_module ./axi_dmac.v]'
#               'set ip $::ipl::ip'
#               'set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]'
#
# \opt[ip] -ip $ip
# \opt[mod_data] -mod_data $mod_data
###############################################################################
    proc add_ports_from_module {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
        {*}$args]
        set ip $opt(-ip)
        set mod_data $opt(-mod_data)
        # to do: check the input parameters
        set mod_name [dict get $mod_data mod_name]

        foreach data [dict get $mod_data portlist] {
            set dir [dict get $data dir]
            switch $dir {
                input {
                    set dir in
                }
                output {
                    set dir out
                }
                inout {
                    set dir inout
                }
            }
            set name [dict get $data name]
            set op {(}
            set cl {)}

            set from ""
            set to ""
            if {[dict keys $data from] != ""} {
                set from [dict get $data from]
            }
            if {[dict keys $data to] != ""} {
                set to [dict get $data to]
            }

            if {$from != "" && $to != ""} {
                set ip [ipl::set_port -ip $ip -name $name \
                    -dir $dir -range "${op}int$op$from$cl,$to$cl" \
                    -conn_port $name \
                    -conn_mod $mod_name]
            } else {
                set ip [ipl::set_port -ip $ip -name $name \
                    -dir $dir \
                    -conn_port $name \
                    -conn_mod $mod_name]
            }
        }
        return $ip
    }

###############################################################################
## Sets the IP structure with parameters' data from top module.
## This is only recomended if you have few parameters in top module but you
## don't care the ordering and grouping of them. You can additionally edit the
## GUI appearance of a parameter by using ipl_set_parameter but not the
## ordering and grouping of them.
## Quick usage: 'set mod_data [ipl::parse_module ./axi_dmac.v]'
#               'set ip $::ipl::ip'
#               'set ip [ipl::add_parameters_from_module -ip $ip -mod_data $mod_data]'
#
# \opt[ip] -ip $ip
# \opt[mod_data] -mod_data $mod_data
###############################################################################
    proc add_parameters_from_module {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
        {*}$args]
        set ip $opt(-ip)
        set mod_data $opt(-mod_data)

        set mod_name [dict get $mod_data mod_name]
        foreach data [dict get $mod_data parlist] {
            set name [dict get $data name]

            set value ""
            if {[dict keys $data value] != ""} {
                set value [dict get $data value]
            }
            if {$value != ""} {
                set value [dict get $data value]
                set regxf {^\s*-?[0-9]*\.[0-9]+\s*$}
                set regxi {^\s*-?[0-9]+\s*$}
                set regxstr {^\".*\"$}
                if {[regexp $regxf $value]} {
                    set value_type float
                } elseif {[regexp $regxi $value]} {
                    set value_type int
                } elseif {[regexp $regxstr $value]} {
                    set value_type string
                }

                set ip [ipl::set_parameter -ip $ip -id $name \
                    -type param -value_type $value_type \
                    -conn_mod $mod_name -title $name \
                    -default $value \
                    -output_formatter nostr \
                    -group1 PARAMS -group2 GLOB]
            } else {
                set ip [ipl::set_parameter -ip $ip -id $name \
                    -type param -value_type int \
                    -conn_mod $mod_name -title $name \
                    -output_formatter nostr \
                    -group1 PARAMS \
                    -group2 GLOB]
            }
        }
        return $ip
    }

    proc docsgen {ip} {
        set display_name [ipl::getncont \
            ip_desc/lsccip:general lsccip:display_name $ip]
        set name [ipl::getncont ip_desc/lsccip:general lsccip:name $ip]
        set version [ipl::getncont ip_desc/lsccip:general lsccip:version $ip]
        set keywords [ipl::getncont ip_desc/lsccip:general lsccip:keywords $ip]
        set href [ipl::getncont ip_desc/lsccip:general href $ip]

        set supported_products [ipl::getnchilds \
            ip_desc/lsccip:general lsccip:supported_products $ip]
        set devices {}
        foreach {id product} $supported_products {
            append devices $id
        }

        set doc {}
        lappend doc "<HEAD>"
        lappend doc "  <TITLE> $name </TITLE>"
        lappend doc "</HEAD>"
        lappend doc "<BODY>"
        lappend doc "  <H1> $display_name </H1>"
        lappend doc "  <H2> Keywords </H2>"
        lappend doc "  <P> $keywords </P>"
        lappend doc "  <H2> Devices Supported </H2>"
        lappend doc "  <P> $devices </P>"
        lappend doc "  <H2> Reference </H2>"
        lappend doc "  <UL>"
        lappend doc "    <P>"
        lappend doc "      <LI><A HREF=\"$href\" CLASS=\"URL\">Documentation</A>"
        lappend doc "  </UL>"
        lappend doc "  <H2> Version </H2>"
        lappend doc "  <TABLE cellpadding=\"10\">"
        lappend doc "    <TR>"
        lappend doc "      <TD><B> $version </B></TD> <TD> $keywords </TD>"
        lappend doc "    </TR>"
        lappend doc "  </TABLE>"
        lappend doc "</BODY>"
        return $doc
    }

###############################################################################
## Sets the IP structure with the specified file dependencies by searching them
## in the specyfied '-spath' folder '-sdepth' deep.
## We need to specify the files destination folder which is relative to the
## IP output directory. These directories are specific to some file types or
## purpose and must be used corresponding to the Lattice IP Packager
## documentation: https://www.latticesemi.com/view_document?document_id=54003.
## Currently automatically selects the wrapper type from .v and .sv, but
## the VHDL wrapper type is not currently supported by this script.
#
# \opt[ip] -ip $ip
# \opt[spath] -spath ./
# \opt[sdepth] -sdepth 7
# \opt[regex] -regex <you can apply a tcl regexp here to filter the files>
# \opt[extl] -extl {csacsi.v a_szamar.v *.sv}
# \opt[dpath] -dpath rtl
###############################################################################
    proc add_ip_files_auto {args} {
        array set opt [list -ip "$::ipl::ip" \
            -spath "" \
            -sdepth 0 \
            -regex "" \
            -extl {*.v} \
            -dpath "rtl" \
        {*}$args]

        set ip $opt(-ip)
        set spath $opt(-spath)
        set sdepth $opt(-sdepth)
        set regex $opt(-regex)
        set extl $opt(-extl)
        set dpath $opt(-dpath)

        if {$extl != ""} {
            set flist [ipl::get_file_list $spath $extl $sdepth]
        }

        set checkext {^.+\.sv$}
        foreach file $flist {
            if {[regexp $checkext $file]} {
                set ip [ipl::set_wrapper_type -ip $ip -file_ext sv]
            }
        }

        if {$regex != ""} {
            set flist [regexp -all -inline $regex $flist]
        }
        set node [ipl::getnode fdeps $dpath $ip]
        if {$node != ""} {
            set flist [list {*}$node {*}$flist]
        }
        return [ipl::setnode fdeps $dpath $flist $ip]
    }

    proc get_file_list {path {extension_list {*.v}} {depth 0}} {
        set file_list {}
        foreach ext $extension_list {
            set file_list [list {*}$file_list \
            {*}[glob -nocomplain -type f -directory $path $ext]]
        }
        if {$depth > 0} {
            foreach dir [glob -nocomplain -type d -directory $path *] {
            set file_list [list {*}$file_list \
                {*}[get_file_list $dir $extension_list [expr {$depth-1}]]]
            }
        }
        return $file_list
    }

###############################################################################
## Sets the IP structure with the specified file dependencies.
## We need to specify the files destination folder which is relative to the
## IP output directory. These directories are specific to some file types or
## purpose and must be used corresponding to the Lattice IP Packager
## documentation: https://www.latticesemi.com/view_document?document_id=54003.
## Currently automatically selects the wrapper type from .v and .sv, but
## the VHDL wrapper type is not currently supported by this script.
#
## Quick usage:
##   'set ip [ipl::add_ip_files -ip $ip -dpath rtl -flist [list \
##      "$ad_hdl_dir/library/common/ad_mem_asym.v" \
##      "$ad_hdl_dir/library/common/up_axi.v"]'
#
# \opt[ip] -ip $ip
# \opt[dpath] -dpath rtl
# \opt[flist] -flist [list file1.v file2.sv]
###############################################################################
    proc add_ip_files {args} {
        array set opt [list -ip "$::ipl::ip" \
            -flist "" \
            -dpath "rtl" \
        {*}$args]

        set ip $opt(-ip)
        set flist $opt(-flist)
        set dpath $opt(-dpath)

        set checkext {^.+\.sv$}
        foreach file $flist {
            if {[regexp $checkext $file]} {
                set ip [ipl::set_wrapper_type -ip $ip -file_ext sv]
            }
        }

        set node [ipl::getnode fdeps $dpath $ip]
        if {$node != ""} {
            set flist [list {*}$node {*}$flist]
        }
        return [ipl::setnode fdeps $dpath $flist $ip]
    }

    set axi4_ports {
        awid awaddr awlen awsize awburst awlock awcache
        awprot awqos awvalid awready wid wdata wstrb wlast wvalid wready bid
        bresp bvalid bready arid araddr arlen arsize arburst arlock arcache
        arprot arqos arvalid arready rid rdata rresp rlast rvalid rready
    }

    set axi4_lite_ports {
        awaddr awprot awvalid awready wdata wstrb wvalid wready bresp bvalid
        bready araddr arprot arvalid arready rdata rresp rvalid rready
    }

    set axi4_stream_ports {
        tvalid tready tdata tstrb tkeep tlast tid tdest tuser
    }

    set axi4_sream_pors {
        valid ready data strb keep last id dest user
    }

    proc filter_ports {args} {
        array set opt [list -mod_data "" \
            -portlist [concat $ipl::axi4_ports \
                $ipl::axi4_lite_ports \
                $ipl::axi4_stream_ports \
                $ipl::axi4_sream_pors] \
        {*}$args]

        set mod_data $opt(-mod_data)
        set portlist $opt(-portlist)
        set portdict {}
        foreach port $portlist {
            set portdict [list {*}$portdict $port 1]
        }
        set portlist_out {}

        set ports [dict get $mod_data portlist]

        foreach line $ports {
            set name [dict get $line name]
            set regx {^.+_([a-zA-Z0-9]+)$}
            if {[regexp $regx $name match capt]} {
                set regx $capt
                if {[dict keys $portdict $regx] != ""} {
                    set portlist_out [list {*}$portlist_out $line]
                }
            }
        }
        dict set mod_data portlist $portlist_out
        return $mod_data
    }

    proc list_interfaces_by_clock {mod_data {clock "aclk"}} {
        set ports [dict get $mod_data portlist]
        set clk_list {}
        puts "--------------------------clocks------------------------------"
        foreach line $ports {
            set name [dict get $line name]
            set regexp ".+_${clock}$"
            if {[regexp $regexp $name]} {
                set clk_list [list {*}$clk_list $name]
                puts $name
            }
        }
        puts "-------------------------------------------------------------"

        foreach pname $clk_list {
            set interface_name [string map [list _${clock} ""] $pname]
            foreach line $ports {
                set reg [list ${interface_name}_.+]
                set name [dict get $line name]
                if {[regexp $reg $name]} {
                    puts $line
                }
            }
            puts "-------------------------------------------------------------"
        }
    }

###############################################################################
## Adds the AXI interfaces to the IP structure based on the parsed module
## data from the top module.
## Quick usage: 'set mod_data [ipl::parse_module ./axi_dmac.v]'
#               'set ip $::ipl::ip'
#               'set ip [ipl::add_ports_from_module -ip $ip -mod_data $mod_data]'
#               'set ip [ipl::add_axi_interfaces -ip $ip -mod_data $mod_data]'
#
# \opt[ip] -ip $ip
# \opt[mod_data] -mod_data $mod_data
# \opt[clock] -clock aclk
# \opt[reset] -reset aresetn
# \opt[xptn_portlist] -xptn_portlist {exeption_port0 exeption_port1 ...}
###############################################################################
    proc add_axi_interfaces {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
            -clock "aclk" \
            -reset "aresetn" \
            -xptn_portlist {} \
        {*}$args]

        set ip $opt(-ip)
        set mod_data $opt(-mod_data)
        set clock $opt(-clock)
        set reset $opt(-reset)
        set xptn_portlist $opt(-xptn_portlist)

        set ports [dict get $mod_data portlist]
        set clk_list {}
        puts "--------------------------clocks------------------------------"
        foreach line $ports {
            set name [dict get $line name]
            set regexp ".+_${clock}$"
            if {[regexp $regexp $name]} {
                set clk_list [list {*}$clk_list $name]
                puts $name
            }
        }
        puts "-------------------------------------------------------------"

        foreach pname $clk_list {
            set interface_name [string map [list _${clock} ""] $pname]
            set counter 0
            foreach line $ports {
                set reg [list ${interface_name}_.+]
                set name [dict get $line name]
                if {[regexp $reg $name]} {
                    incr counter
                }
            }
            dict set ports_num $pname $counter
        }

        set mod_data [filter_ports -mod_data $mod_data]

        puts "Ports number by clocks: $ports_num\n"

        foreach pname $clk_list {
            set interface_name [string map [list _${clock} ""] $pname]

            set arid ${interface_name}_arid
            set awid ${interface_name}_awid
            set araddr ${interface_name}_araddr
            set awaddr ${interface_name}_awaddr
            set tvalid ${interface_name}_tvalid
            set tready ${interface_name}_tready
            set valid ${interface_name}_valid
            set ready ${interface_name}_ready

            set brk ""
            foreach line $ports {
                set name [dict get $line name]
                set dir [dict get $line dir]
                if {[regexp $arid $name]} {
                    if {$dir == "input"} {set brk slave}
                    if {$dir == "output"} {set brk master}
                    break
                } elseif {[regexp $awid $name]} {
                    if {$dir == "input"} {set brk slave}
                    if {$dir == "output"} {set brk master}
                    break
                }
            }
            if {$brk != ""} {
                if {$brk == "slave"} {
                    set ip [ipl::add_interface_by_prefix \
                        -ip $ip \
                        -mod_data $mod_data \
                        -inst_name $interface_name \
                        -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist \
                            ${interface_name}_$clock \
                            ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave slave \
                        -mem_map_ref ${interface_name}_mem_map \
                        -vlnv {amba.com:AMBA4:AXI4:r0p0}]
                } elseif {$brk == "master"} {
                    set ip [ipl::add_interface_by_prefix \
                        -ip $ip \
                        -mod_data $mod_data \
                        -inst_name $interface_name \
                        -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist \
                            ${interface_name}_$clock \
                            ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave master \
                        -addr_space_ref ${interface_name}_aspace \
                        -vlnv {amba.com:AMBA4:AXI4:r0p0}]
                }
                continue
            }

            foreach line $ports {
                set name [dict get $line name]
                set dir [dict get $line dir]
                if {[regexp $araddr $name]} {
                    if {$dir == "input"} {set brk slave}
                    if {$dir == "output"} {set brk master}
                    break
                } elseif {[regexp $awaddr $name]} {
                    if {$dir == "input"} {set brk slave}
                    if {$dir == "output"} {set brk master}
                    break
                }
            }
            if {$brk != ""} {
                if {$brk == "slave"} {
                    set ip [ipl::add_interface_by_prefix \
                        -ip $ip \
                        -mod_data $mod_data \
                        -inst_name $interface_name \
                        -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist \
                            ${interface_name}_$clock \
                            ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave slave \
                        -mem_map_ref ${interface_name}_mem_map \
                        -vlnv {amba.com:AMBA4:AXI4-Lite:r0p0}]
                } elseif {$brk == "master"} {
                    set ip [ipl::add_interface_by_prefix \
                        -ip $ip \
                        -mod_data $mod_data \
                        -inst_name $interface_name \
                        -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist \
                            ${interface_name}_$clock \
                            ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave master \
                        -addr_space_ref ${interface_name}_aspace \
                        -vlnv {amba.com:AMBA4:AXI4-Lite:r0p0}]
                }
                continue
            }

            foreach line $ports {
                set name [dict get $line name]
                set dir [dict get $line dir]
                if {[regexp $tvalid $name]} {
                    if {$dir == "input"} {set brk slave}
                    if {$dir == "output"} {set brk master}
                    break
                } elseif {[regexp $tready $name]} {
                    if {$dir == "input"} {set brk master}
                    if {$dir == "output"} {set brk slave}
                    break
                }
            }
            if {$brk != ""} {
                if {$brk == "slave"} {
                    set ip [ipl::add_interface_by_prefix \
                        -ip $ip \
                        -mod_data $mod_data \
                        -inst_name $interface_name \
                        -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist \
                            ${interface_name}_$clock \
                            ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave slave \
                        -vlnv {amba.com:AMBA4:AXI4Stream:r0p0}]
                } elseif {$brk == "master"} {
                    set ip [ipl::add_interface_by_prefix \
                        -ip $ip \
                        -mod_data $mod_data \
                        -inst_name $interface_name \
                        -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist \
                            ${interface_name}_$clock \
                            ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave master \
                        -vlnv {amba.com:AMBA4:AXI4Stream:r0p0}]
                }
                continue
            }

            foreach line $ports {
                set name [dict get $line name]
                set dir [dict get $line dir]
                if {[regexp $valid $name]} {
                    if {$dir == "input"} {set brk slave}
                    if {$dir == "output"} {set brk master}
                    break
                } elseif {[regexp $ready $name]} {
                    if {$dir == "input"} {set brk master}
                    if {$dir == "output"} {set brk slave}
                    break
                }
            }
            if {$brk != ""} {
                if {$brk == "slave"} {
                    set ip [ipl::add_interface_by_prefix \
                        -ip $ip \
                        -mod_data $mod_data \
                        -inst_name $interface_name \
                        -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist \
                            ${interface_name}_$clock \
                            ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave slave \
                        -t t \
                        -vlnv {amba.com:AMBA4:AXI4Stream:r0p0}]
                } elseif {$brk == "master"} {
                    set ip [ipl::add_interface_by_prefix \
                        -ip $ip \
                        -mod_data $mod_data \
                        -inst_name $interface_name \
                        -v_prefix $interface_name \
                        -xptn_portlist [list {*}$xptn_portlist \
                            ${interface_name}_$clock \
                            ${interface_name}_$reset] \
                        -display_name $interface_name \
                        -description $interface_name \
                        -master_slave master \
                        -t t \
                        -vlnv {amba.com:AMBA4:AXI4Stream:r0p0}]
                }
                continue
            }
        }
        return $ip
    }
}
