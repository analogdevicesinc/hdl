###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

namespace eval ipl {
    #node: {name attributes content childs}
    set ip_desc {{lsccip:ip} {{0} {version="1.0"\
        xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"\
        xmlns:xi="http://www.w3.org/2001/XInclude"}} {} {
            {lsccip:general} {{lsccip:general} {} {} {
                    {lsccip:vendor} {{lsccip:vendor} {} {analog.com} {}}
                    {lsccip:library} {{lsccip:library} {} {ip} {}}
                    {lsccip:name} {{lsccip:name} {} {} {}}
                    {lsccip:display_name} {{lsccip:display_name} {} {} {}}
                    {lsccip:version} {{lsccip:version} {} {1.0} {}}
                    {lsccip:category} {{lsccip:category} {} {ADI} {}}
                    {lsccip:keywords} {{lsccip:keywords} {} {ADI IP} {}}
                    {lsccip:min_radiant_version} {{lsccip:min_radiant_version} {} {2022.1} {}}
                    {lsccip:min_esi_version} {{lsccip:min_esi_version} {} {2022.1} {}}
                    {lsccip:supported_products} {{lsccip:supported_products} {} {} {
                        {0} {{lsccip:supported_family} {{0} {name="*"}} {} {}}
                    }}
                    {lsccip:supported_platforms} {{lsccip:supported_platforms} {} {} {
                        {0} {{lsccip:supported_platform} {{0} {name="radiant"}} {} {}}
                        {1} {{lsccip:supported_platform} {{0} {name="esi"}} {} {}}
                    }}
                }
            }
            {lsccip:settings} {{} {} {} {}}
            {lsccip:ports} {{} {} {} {}}
            {xi:include} {{} {} {} {}}
            {lsccip:componentGenerators} {{} {} {} {}}
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
                    {lsccip:abstractionRef} {{lsccip:abstractionRef} {} {} {}}
                    {lsccip:portMaps} {{lsccip:portMaps} {} {} {}}
                }
            }
            {lsccip:master_slave} {{lsccip:master_slave} {} {} {}}
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
        {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}} {} {}}
    set addressSpace_desc {{lsccip:addressSpace} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:range} {{lsccip:range} {} {} {}}
            {lsccip:width} {{lsccip:width} {} {} {}}
        }
    }
    ## to do #############
    set memoryMaps_desc {}

    set ip [list {} {} {} [list ip_desc $ip_desc addressSpaces_desc\
        {} businterfaces_desc\
        {} memoryMaps_desc {}]]

    proc xmlgen {node {nid "0"} {index 0}} {
        set name [lindex $node 0]
        set attr [lindex $node 1]
        set content [lindex $node 2]
        set childs [lindex $node 3]

        if {$name == ""} {
            set xmlstring ""
            foreach {id child} $childs {
                set xmlstring "$xmlstring[xmlgen $child $id $index]"
            }
        } else {
            set xmlstring "[string repeat "\t" $index]<$name"
            foreach {id att} $attr {
                set xmlstring "$xmlstring $att"
            }
            if {$content == "" && $childs == ""} {
                set xmlstring "$xmlstring/>\n"
            } elseif {$content != "" && $childs == ""} {
                set xmlstring "$xmlstring>$content</$name>\n"
            } else {
                set xmlstring "$xmlstring>$content\n"
                foreach {id child} $childs {
                    set xmlstring "$xmlstring[xmlgen $child $id [expr $index + 1]]"
                }
                set xmlstring "$xmlstring[string repeat "\t" $index]</$name>\n"
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
                dict set childs $pth0 [setnode $pt $id $node [dict get $childs $pth0]]
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
            } else {
                puts "getnode:"
                puts "WARNING, no element with id:$id found!"
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

    proc general {args} {
        array set opt [list -ip "$::ipl::ip" \
            -vendor "" \
            -library "" \
            -name "" \
            -display_name "" \
            -version "1.0" \
            -category "" \
            -keywords "" \
            -min_radiant_version "" \
            -min_esi_version "" \
            -supported_products "" \
            -supported_platforms "" \
        {*}$args]

        set ip $opt(-ip)
        set vendor $opt(-vendor)
        set library $opt(-library)
        set display_name $opt(-display_name)
        set name $opt(-name)
        set version $opt(-version)
        set category $opt(-category)
        set keywords $opt(-keywords)
        set min_radiant_version $opt(-min_radiant_version)
        set min_esi_version $opt(-min_esi_version)
        set supported_products $opt(-supported_products)
        set supported_platforms $opt(-supported_platforms)

        set ip [ipl::setnode ip_desc/lsccip:general lsccip:name\
            [list lsccip:name {} $name {}] $::ipl::ip]
        # to do the rest of parameters
        return $ip
    }

    set settingid 0
    proc settings {args} {
        array set opt [list -ip "$::ipl::ip" \
            -id "" \
            -setting "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-id)
        set setting $opt(-setting)

        if {$setting != ""} {
            set stnode [ipl::getnode ip_desc lsccip:settings $ip]
            puts $stnode
            if {[lindex $stnode 0] == ""} {
                lset stnode 0 {lsccip:settings}
                puts $stnode
                set ip [ipl::setnode ip_desc lsccip:settings $stnode $ip]
            }
            set node [list lsccip:setting [list {0} $setting] {} {}]
            if {$id == ""} {
                set ip [ipl::setnode ip_desc/lsccip:settings $::ipl::settingid $node $ip]
                incr ipl::settingid
            } else {
                set ip [ipl::setnode ip_desc/lsccip:settings $id $node $ip]
            }
        }
        return $ip
    }

    set portid 0
    proc ports {args} {
        array set opt [list -ip "$::ipl::ip" \
            -id "" \
            -port "" \
            -ports "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-id)
        set port $opt(-port)
        set ports $opt(-port)

        if {$port != ""} {
            set ptnode [ipl::getnode ip_desc lsccip:ports $ip]
            puts $ptnode
            if {[lindex $ptnode 0] == ""} {
                lset ptnode 0 {lsccip:ports}
                puts $ptnode
                set ip [ipl::setnode ip_desc lsccip:ports $ptnode $ip]
            }
            set node [list lsccip:port [list {0} $port] {} {}]
            if {$id == ""} {
                set ip [ipl::setnode ip_desc/lsccip:ports $::ipl::portid $node $ip]
                incr ipl::portid
            } else {
                set ip [ipl::setnode ip_desc/lsccip:ports $id $node $ip]
            }
        }
        # to do for multiple ports
        # to do autodetect ports
        return $ip
    }

    proc interface {args} {
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -display_name "" \
            -description "" \
            -bus_type "" \
            -abstraction_ref "" \
            -portmap "" \
        {*}$args]

        set ip $opt(-ip)
        set port $opt(-port)
        # do some tasks
        return $ip
    }

    set addrid 0
    proc address {args} {
        array set opt [list -ip "$::ipl::ip" \
            -id "" \
            -name "" \
            -range "" \
            -width "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-id)
        set name $opt(-name)
        set range $opt(-range)
        set width $opt(-width)

        if {$name != "" && $range != "" && $width != ""} {
            set adnode [ipl::getnode "" addressSpaces_desc $ip]
            puts $adnode
            if {[lindex $adnode 0] == ""} {
                set adnode $::ipl::addressSpaces_desc
                puts $adnode
                set ip [ipl::setnode "" addressSpaces_desc $adnode $ip]
            }
            set addrsp $::ipl::addressSpace_desc
            set addrsp [ipl::setnode {} lsccip:name [list lsccip:name {} $name {}] $addrsp]
            set addrsp [ipl::setnode {} lsccip:range [list lsccip:range {} $range {}] $addrsp]
            set addrsp [ipl::setnode {} lsccip:width [list lsccip:width {} $width {}] $addrsp]
   
            if {$id == ""} {
                set ip [ipl::setnode addressSpaces_desc $::ipl::addrid $addrsp $ip]
                incr ipl::addrid
            } else {
                set ip [ipl::setnode addressSpaces_desc $id $addrsp $ip]
            }
        }

        return $ip
    }

    set inclid 0
    proc include {args} {
        array set opt [list -ip "$::ipl::ip" \
            -id "" \
            -include "" \
        {*}$args]

        set ip $opt(-ip)
        set id $opt(-id)
        set include $opt(-include)
        
        if {$include != ""} {
            set include [format {"parse="xml" href="%s"} $include]
            set node [list xi:include [list {0} $include] {} {}]
            puts $node
            if {$id == ""} {
                set ip [ipl::setnode ip_desc/xi:include $::ipl::inclid $node $ip]
                incr ipl::inclid
            } else {
                set ip [ipl::setnode ip_desc/xi:include $id $node $ip]
            }
        }

        return $ip
    }

    proc genip {ip} {
        set ip [lindex $ip 3]
        array set opt [list ip_desc "" \
            addressSpaces_desc "" \
            businterfaces_desc "" \
            memoryMaps_desc "" \
            {*}$ip]

        set ip_desc $opt(ip_desc)
        set addressSpaces_desc $opt(addressSpaces_desc)
        set businterfaces_desc $opt(businterfaces_desc)
        set memoryMaps_desc $opt(memoryMaps_desc)

        # to do: add the include section for xml files automatically

        if {$ip_desc != ""} {
            set file [open "metadata.xml" w]
            puts [xmlgen $ip_desc]
            puts $file {<?xml version="1.0"?>}
            puts $file [xmlgen $ip_desc]
            close $file
        } else {
            puts "ERROR, No ip_desc defined!"
        }

        if {$addressSpaces_desc != ""} {
            set file [open "address_space.xml" w]
            puts [xmlgen $addressSpaces_desc]
            puts $file [xmlgen $addressSpaces_desc]
            close $file
        } else {
            puts "WARNING, No addressSpaces_desc defined!"
        }

        if {$businterfaces_desc != ""} {
            set file [open "bus_interface.xml" w]
            puts [xmlgen $businterfaces_desc]
            puts $file [xmlgen $businterfaces_desc]
            close $file
        } else {
            puts "WARNING, No businterfaces_desc defined!"
        }

        if {$memoryMaps_desc != ""} {
            set file [open "memory_map.xml" w]
            puts [xmlgen $memoryMaps_desc]
            puts $file [xmlgen $memoryMaps_desc]
            close $file
        } else {
            puts "WARNING, No memoryMaps_desc defined!"
        }
    }

    proc getmod {path} {
        set debug 0
        set file [open $path]
        set data [read $file]
        close $file

        set lines [regexp -all -inline {parameter[^,\n]+|input[^,\n]+|output[^,\n]+|inout[^,\n]+} $data]
        set portlist {}
        set parlist {}
        foreach line $lines {
            set type [lindex $line 0]
            set values [lrange $line 1 end]
            if {[llength $line] == 2} {
                if {$type == "parameter"} {
                    set parameter [string map {" " ""} [lindex $values 0]]
                    set portdata [list type $type name $parameter]
                    set parlist [list {*}$parlist $portdata]
                    if {$debug} {
                        puts "$type\t$parameter"
                    }
                } else {
                    set portname [string map {" " ""} [lindex $values 0]]
                    set portdata [list type $type name $portname]
                    set portlist [list {*}$portlist $portdata]
                    if {$debug} {
                        puts "$type\t$portname"
                    }
                }
            } elseif {[llength $line] > 2} {
                if {$type == "parameter"} {
                    set values [split $values "="]
                    set parameter [string map {" " ""} [lindex $values 0]]
                    set default_value [string map {" " ""} [lindex $values 1]]
                    set portdata [list type $type name $parameter defval $default_value]
                    set parlist [list {*}$parlist $portdata]
                    if {$debug} {
                        puts "$type\t$parameter = $default_value"
                    }
                } else {
                    set sep {[}
                    set values [split $line $sep]
                    set sep {]}
                    set values [split [lindex $values 1] $sep]

                    set range [string map {" " ""} [lindex $values 0]]
                    set from_to [split $range ":"]
                    set from [string map {" " ""} [lindex $from_to 0]]
                    set to [string map {" " ""} [lindex $from_to 1]]
                    set portname [string map {" " ""} [lindex $values 1]]

                    set portdata [list type $type name $portname from $from to $to]
                    set portlist [list {*}$portlist $portdata]
                    if {$debug} {
                        puts "$type\t$from\t:\t$to\t$portname"
                    }
                }
            }
        }
        set module_data [list portlist $portlist parlist $parlist]
        return $module_data
    }

    proc getaxi {module_data} {
        set ports [dict get $module_data portlist]
        set aclk_list {}
        puts "--------------------------clocks------------------------------"
        foreach line $ports {
            set name [dict get $line name]
            if {[regexp {.+_aclk.*} $name]} {
                set aclk_list [list {*}$aclk_list $name]
                puts $name
            }
        }
        puts "-------------------------------------------------------------"

        foreach pname $aclk_list {
            set interface_name [string map {"_aclk" ""} $pname]
            foreach line $ports {
                set reg [list .*$interface_name.*]
                set name [dict get $line name]
                if {[regexp $reg $name]} {
                    puts $line
                }
            }
            puts "-------------------------------------------------------------"
        }
    }
}