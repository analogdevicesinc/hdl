###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

namespace eval ipl {
    #node: {name attributes content childs}
    set ip_desc {{lsccip:ip} {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip" xmlns:xi="http://www.w3.org/2001/XInclude" version="1.0" platform="radiant" platform_version="2023.2"}} {} {
            {lsccip:general} {{lsccip:general} {} {} {
                    {lsccip:vendor} {{lsccip:vendor} {} {latticesemi.com} {}}
                    {lsccip:library} {{lsccip:library} {} {ip} {}}
                    {lsccip:name} {{lsccip:name} {} {} {}}
                    {lsccip:display_name} {{lsccip:display_name} {} {} {}}
                    {lsccip:version} {{lsccip:version} {} {1.0} {}}
                    {lsccip:category} {{lsccip:category} {} {ADI} {}}
                    {lsccip:keywords} {{lsccip:keywords} {} {ADI IP} {}}
                    {lsccip:min_radiant_version} {{lsccip:min_radiant_version} {} {2022.1} {}}
                    {lsccip:max_radiant_version} {{} {} {} {}}
                    {lsccip:min_esi_version} {{lsccip:min_esi_version} {} {1.0} {}}
                    {lsccip:max_esi_version} {{} {} {} {}}
                    {lsccip:supported_products} {{lsccip:supported_products} {} {} {
                        {*} {{lsccip:supported_family} {{name} {name="*"}} {} {}}
                    }}
                    {lsccip:supported_platforms} {{lsccip:supported_platforms} {} {} {
                        {radiant} {{lsccip:supported_platform} {{name} {name="radiant"}} {} {}}
                        {esi} {{lsccip:supported_platform} {{name} {name="esi"}} {} {}}
                    }}
                    {href} {{} {} {https://wiki.analog.com/resources/fpga/docs/ip_cores} {}}
                }
            }
            {lsccip:settings} {{} {} {} {}}
            {lsccip:ports} {{} {} {} {}}
            {xi:include} {{} {} {} {}}
            {lsccip:componentGenerators} {{} {} {} {}}
        }
    }
    #  <lsccip:generatorExe>testbench/cache_update.py</lsccip:generatorExe>
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
                            {lsccip:abstractionRef} {{lsccip:abstractionRef} {} {} {}}
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
        {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}} {} {}}
    set addressSpace_desc {{lsccip:addressSpace} {} {} {
            {lsccip:name} {{lsccip:name} {} {} {}}
            {lsccip:range} {{lsccip:range} {} {0x100000000} {}}
            {lsccip:width} {{lsccip:width} {} {32} {}}
        }
    }
    set memoryMaps_desc {{lsccip:memoryMaps}
        {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip"}} {} {}}
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

    set ip [list {} {} {} [list fdeps {} \
        ip_desc $ip_desc addressSpaces_desc {} \
        busInterfaces_desc {} \
        memoryMaps_desc {}]]

    set cc {}

    proc setcc {ip} {
        set ipl::cc $ip
    }
    
    proc current_core {} {
        return $cc
    }

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
            set xmlstring "[string repeat "    " $index]<$name"
            if {$name == "lsccip:port" || $name == "lsccip:setting"} {
                set rep [expr [string length $name] + 1]
                foreach {id att} $attr {
                    set xmlstring "$xmlstring $att\n[string repeat "    " $index][string repeat " " $rep]"
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
                    set xmlstring "$xmlstring[xmlgen $child $id [expr $index + 1]]"
                }
                set xmlstring "$xmlstring[string repeat "    " $index]</$name>\n"
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
# test it!
    proc rmnchilds {path id desc} {
        set childs [lindex $desc 3]
        set pth [string map {/ " "} $path]
        set pth0 [lindex $pth 0]
        set pt [string map {" " /} [lrange $pth 1 end]]

        if {[llength $pth] != 0 } {
            if {[dict keys $childs $pth0] != ""} {
                dict set childs $pth0 [rmnchilds $pt $id [dict get $childs $pth0]]
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

    proc general {args} {
        array set opt [list -ip "$::ipl::ip" \
            -vendor "latticesemi.com" \
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
                if {[ipl::getnname ip_desc/lsccip:general "lsccip:$op" $ip] != ""} {
                    set ip [ipl::setncont ip_desc/lsccip:general "lsccip:$op" $val $ip]
                } else {
                    set ip [ipl::setnode ip_desc/lsccip:general "lsccip:$op" [list "lsccip:$op" {} $val {}] $ip]
                }
            }
        }
        foreach family $supported_products {
            set sfamily [list lsccip:supported_family [list name "name=\"$family\""] {} {}]
            set ip [ipl::setnode ip_desc/lsccip:general/lsccip:supported_products $family $sfamily $ip]
        }
        foreach platform $supported_platforms {
            set splatform [list lsccip:supported_platform [list name "name=\"$platform\""] {} {}]
            set ip [ipl::setnode ip_desc/lsccip:general/lsccip:supported_platforms $platform $splatform $ip]
        }
        return $ip
    }

    set settingid 0
    proc settpar {args} {
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
        # -optional for entering exact xml attribute string

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
                        set ip [ipl::setatt ip_desc/lsccip:settings $id $attid "${attid}=$c$att$c" $ip]
                    }
                }
            } else {
                set node [list lsccip:setting $atts {} {}]
                set ip [ipl::setnode ip_desc/lsccip:settings $id $node $ip]
            }
        } else {
            set node [list lsccip:setting $atts {} {}]
            set ip [ipl::setnode ip_desc/lsccip:settings $::ipl::settingid $node $ip]
            incr ipl::settingid
        }
        return $ip
    }

    set portid 0
    proc setport {args} {
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
        # -optional for entering exact xml attribute string

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
                        set ip [ipl::setatt ip_desc/lsccip:ports $id $attid "${attid}=$c$att$c" $ip]
                    }
                }
            } else {
                set node [list lsccip:port $atts {} {}]
                set ip [ipl::setnode ip_desc/lsccip:ports $id $node $ip]
            }
        } else {
            set node [list lsccip:port $atts {} {}]
            set ip [ipl::setnode ip_desc/lsccip:ports $::ipl::portid $node $ip]
            incr ipl::portid
        }
        return $ip
    }

    proc igports {args} {
        array set opt [list -ip "$::ipl::ip" \
            -portlist "" \
            -expression "" \
        {*}$args]

        set ip $opt(-ip)
        set portlist $opt(-portlist)
        set expression $opt(-expression)

        foreach port $portlist {
            set dir [ipl::getatt ip_desc/lsccip:ports $port dir $ip]
            if {$dir == "dir=\"in\""} {
                set ip [ipl::setport -ip $ip -name $port -stick_low $expression]
            } else {
                set ip [ipl::setport -ip $ip -name $port -dangling $expression]
            }
        }
        return $ip
    }

    proc getiports {args} {
        array set opt [list -mod_data "" \
            -v_name "" \
            -exept_pl "" \
        {*}$args]

        set mod_data $opt(-mod_data)
        set v_name $opt(-v_name)
        set exept_pl $opt(-exept_pl)
        set ports [dict get $mod_data portlist]

        set portlist {}
        set regx [list ${v_name}_.+]
        foreach line $ports {
            set pname [dict get $line name]
            if {[lsearch $exept_pl $pname] == -1 && [regexp $regx $pname]} {
                set portlist [list {*}$portlist $pname]
            }
        }
        return $portlist
    }

    proc igiports {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
            -v_name "" \
            -exept_pl "" \
            -expression "" \
        {*}$args]

        set ip $opt(-ip)
        set mod_data $opt(-mod_data)
        set expression $opt(-expression)

        set v_name $opt(-v_name)
        set exept_pl $opt(-exept_pl)

        set portlist [ipl::getiports -mod_data $mod_data -v_name $v_name -exept_pl $exept_pl]

        set ip [ipl::igports -ip $ip -expression $expression -portlist $portlist]
        return $ip
    }

    proc address {args} {
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

    proc mmap {args} {
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
                set adbln [ipl::setncont {} lsccip:baseAddress $baseAddress $adbln]
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

# to do: call it in genip and automatically include based on the defined xml descriptors in the IP structure
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
            # set include [format {parse="xml" href="%s"} $include]
            set node [list xi:include [list href href=$c$include$c parse {parse="xml"}] {} {}]
            if {$debug} {
                puts $node
            }
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
        set file [open "introduction.html" w]
        foreach line [ipl::docsgen $ip] {
            puts $file $line
        }
        close $file
        set busInterfaces_desc [ipl::getnode {} busInterfaces_desc $ip]
        if {$busInterfaces_desc != ""} {
            set ip [ipl::include -ip $ip -include bus_interface.xml]
            set file [open "bus_interface.xml" w]
            puts [xmlgen $busInterfaces_desc]
            puts $file [xmlgen $busInterfaces_desc]
            close $file
        } else {
            puts "WARNING, No busInterfaces_desc defined!"
        }
        set addressSpaces_desc [ipl::getnode {} addressSpaces_desc $ip]
        if {$addressSpaces_desc != ""} {
            set ip [ipl::include -ip $ip -include address_space.xml]
            set file [open "address_space.xml" w]
            puts [xmlgen $addressSpaces_desc]
            puts $file [xmlgen $addressSpaces_desc]
            close $file
        } else {
            puts "WARNING, No addressSpaces_desc defined!"
        }
        set memoryMaps_desc [ipl::getnode {} memoryMaps_desc $ip]
        if {$memoryMaps_desc != ""} {
            set ip [ipl::include -ip $ip -include memory_map.xml]
            set file [open "memory_map.xml" w]
            puts [xmlgen $memoryMaps_desc]
            puts $file [xmlgen $memoryMaps_desc]
            close $file
        } else {
            puts "WARNING, No memoryMaps_desc defined!"
        }
        set ip_desc [ipl::getnode {} ip_desc $ip]
        if {$ip_desc != ""} {
            set file [open "metadata.xml" w]
            puts [xmlgen $ip_desc]
            puts $file [xmlgen $ip_desc]
            close $file
        } else {
            puts "ERROR, No ip_desc defined!"
        }
    }

    proc getmod {path} {
        set debug 0
        set file [open $path]
        set data [read $file]
        close $file

        if {[regexp {module\s+[^#(\n]+} $data match]} {
            set mod_name [string map {" " ""} [lindex $match 1]]
        } else {
            puts {ERROR, no module found in the verilog file!}
            exit 2
        }
        
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
        set module_data [list portlist $portlist parlist $parlist mod_name $mod_name]
        return $module_data
    }

    proc addifsa {args} {
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
    proc addif {args} {
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -display_name "" \
            -description "" \
            -bus_type "" \
            -abstraction_ref "" \
            -master_slave "" \
            -mmap_ref "" \
            -aspace_ref "" \
            -portmap "" \
        {*}$args]
        
        set c {"}
        set ip $opt(-ip)
        set name $opt(-name)
        set display_name $opt(-display_name)
        set description $opt(-description)
        set bus_type $opt(-bus_type)
        set abst_ref $opt(-abstraction_ref)
        set master_slave $opt(-master_slave)
        set mmap_ref $opt(-mmap_ref)
        set aspace_ref $opt(-aspace_ref)
        set portmap $opt(-portmap)

        set bif $::ipl::busInterface_desc
        set bif [ipl::setncont {} lsccip:name $name $bif]
        set bif [ipl::setncont {} lsccip:displayName $display_name $bif]
        set bif [ipl::setncont {} lsccip:description $description $bif]
        set bif [ipl::setatts {} lsccip:busType [list {0} $bus_type] $bif]
        set bif [ipl::setatts lsccip:abstractionTypes/lsccip:abstractionType lsccip:abstractionRef [list {0} $abst_ref] $bif]
        set bif [ipl::setnname {} lsccip:master_slave lsccip:$master_slave $bif]

        if {$master_slave == "slave" && $mmap_ref != ""} {
            set mmap_ref_node [list lsccip:memoryMapRef [list memoryMapRef "memoryMapRef=\"$mmap_ref\""] {} {}]
            set bif [ipl::setnode lsccip:master_slave lsccip:memoryMapRef $mmap_ref_node $bif]
        }
        if {$master_slave == "master" && $aspace_ref != ""} {
            set aspace_ref_node [list lsccip:addressSpaceRef [list addressSpaceRef "addressSpaceRef=\"$aspace_ref\""] {} {}]
            set bif [ipl::setnode lsccip:master_slave lsccip:addressSpaceRef $aspace_ref_node $bif]
        }

        foreach line $portmap {
            set pname [lindex $line 0]
            set logic [lindex $line 1]
            set pmap [ipl::setncont lsccip:logicalPort lsccip:name $logic $::ipl::portMap_desc]
            set pmap [ipl::setncont lsccip:physicalPort lsccip:name $pname $pmap]
            set bif [ipl::setnode lsccip:abstractionTypes/lsccip:abstractionType/lsccip:portMaps $pname $pmap $bif]
            set ip [ipl::setport -ip $ip -name $pname -bus_interface $name]
        }
        set bifs [ipl::getnode {} busInterfaces_desc $ip]
        if {$bifs == ""} {
            set bifs $::ipl::busInterfaces_desc
        }
        set bifsl [lindex $bifs 3]
        dict set bifsl $name $bif
        lset bifs 3 $bifsl
        set ip [ipl::setnode {} busInterfaces_desc $bifs $ip]

        # to do: 
        # - manual portlist/portmap
        # - update ports attributes with the interface attribute
        return $ip
    }
    proc addifa {args} {
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -display_name "" \
            -description "" \
            -bus_type "" \
            -abstraction_ref "" \
            -master_slave "" \
            -mmap_ref "" \
            -aspace_ref "" \
            -mod_data "" \
            -v_name "" \
            -exept_pl "" \
        {*}$args]

        set optl {
            -ip
            -name
            -display_name
            -description
            -bus_type
            -abstraction_ref
            -master_slave
            -mmap_ref
            -aspace_ref
        }
        set argl {}
        foreach op $optl {
            set argl [list {*}$argl $op $opt($op)]
        }
 
        set mod_data $opt(-mod_data)
        set v_name $opt(-v_name)
        set exept_pl $opt(-exept_pl)

        set portmap {}
        set portlist [ipl::getiports -mod_data $mod_data -v_name $v_name -exept_pl $exept_pl]

        foreach pname $portlist {
            set logic [string toupper [string map [list ${v_name}_ ""] $pname]]
            set portmap [list {*}$portmap [list $pname $logic]]
        }
        # puts $portmap
        return [ipl::addif {*}$argl -portmap $portmap]
    }

# create an ignore ports or ignore interface option
# automaticalli set dandling or stick low based on if it is input or output
    proc addports {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
        {*}$args]
        set ip $opt(-ip)
        set mod_data $opt(-mod_data)
        # to do: check the input parameters
        set mod_name [dict get $mod_data mod_name]

        foreach data [dict get $mod_data portlist] {
            set dir [dict get $data type]
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
            if {[llength $data] > 4} {
                set from [dict get $data from]
                set to [dict get $data to]
                set ip [ipl::setport -ip $ip -name $name \
                    -dir $dir -range "$op$from,$to$cl" \
                    -conn_port $name \
                    -conn_mod $mod_name]
            } else {
                set ip [ipl::setport -ip $ip -name $name \
                    -dir $dir \
                    -conn_port $name \
                    -conn_mod $mod_name]
            }
        }
        return $ip
    }

    proc addpars {args} {
        array set opt [list -ip "$::ipl::ip" \
            -mod_data "" \
        {*}$args]
        set ip $opt(-ip)
        set mod_data $opt(-mod_data)

        # to do: check the input parameters
        set mod_name [dict get $mod_data mod_name]
        foreach data [dict get $mod_data parlist] {
            set name [dict get $data name]
            if {[llength $data] > 4} {
                set defval [dict get $data defval]
                set ip [ipl::settpar -ip $ip -id $name \
                    -type param -value_type int \
                    -conn_mod $mod_name -title $name \
                    -default $defval \
                    -output_formatter nostr \
                    -group1 PARAMS -group2 GLOB]
            } else {
                set ip [ipl::settpar -ip $ip -id $name \
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
        set display_name [ipl::getncont ip_desc/lsccip:general lsccip:display_name $ip]
        set name [ipl::getncont ip_desc/lsccip:general lsccip:name $ip]
        set version [ipl::getncont ip_desc/lsccip:general lsccip:version $ip]
        set keywords [ipl::getncont ip_desc/lsccip:general lsccip:keywords $ip]
        set href [ipl::getncont ip_desc/lsccip:general href $ip]

        set supported_products [ipl::getnchilds ip_desc/lsccip:general lsccip:supported_products $ip]
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

    proc addfiles {args} {
        array set opt [list -ip $ip \
            -spath "" \
            -sdepth 0 \
            -regex "" \
            -extl {{*.v}} \
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
        if {$regex != ""} {
            set flist [regexp -all -inline $regex $flist]
        }

        # if {[file exists $dpath] != 1} {
        #     file mkdir $dpath
        # }
        # file copy {*}$flist $dpath
  
        return [ipl::setnode fdeps $dpath $flist $ip]
    }

    proc get_file_list {path {extension_list {*}} {depth 0}} {
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

    proc tw {} {
        set mod_data [ipl::getmod axi_dmac.v]
        set ip $::ipl::ip

        set ip [ipl::addports -ip $ip -mod_data $mod_data]
        set ip [ipl::addpars -ip $ip -mod_data $mod_data]

        set ip [ipl::general -ip $ip -name [dict get $mod_data mod_name]]
        set ip [ipl::general -ip $ip -display_name "AXI_DMA ADI"]
        set ip [ipl::general -ip $ip -supported_products {*}]
        set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
        set ip [ipl::general -ip $ip -href "https://wiki.analog.com/resources/fpga/docs/axi_dmac"]
        set ip [ipl::general  -vendor "latticesemi.com" \
            -library "ip" \
            -version "1.0" \
            -category "ADI" \
            -keywords "ADI IP" \
            -min_radiant_version "2022.1" \
            -max_radiant_version "2023.2" \
            -min_esi_version "2022.1" -ip $ip]

        set ip [ipl::mmap -ip $ip \
            -name "axi_dmac_mem_map" \
            -description "axi_dmac_mem_map" \
            -baseAddress 0 \
            -range 4096 \
            -width 32]
        set ip [ipl::address -ip $ip \
            -name "m_dest_axi_aspace" \
            -range 0x100000000 \
            -width 32]
        
        set bustype {library="AMBA4" name="AXI4-Lite" vendor="amba.com" version="r0p0"}
        set abstref {library="AMBA4" name="AXI4-Lite_rtl" vendor="amba.com" version="r0p0"}
        set ip [ipl::addifa -ip $ip -mod_data $mod_data -name s_axi -v_name s_axi \
            -exept_pl [list s_axi_aclk s_axi_aresetn] \
            -display_name s_axi \
            -description s_axi \
            -bus_type $bustype \
            -abstraction_ref $abstref \
            -master_slave slave \
            -mmap_ref axi_dmac_mem_map]
        # set ip [ipl::igiports -ip $ip \
        #     -mod_data $mod_data \
        #     -v_name s_axi \
        #     -expression true]
        set bustype {library="AMBA4" name="AXI4" vendor="amba.com" version="r0p0"}
        set abstref {library="AMBA4" name="AXI4_rtl" vendor="amba.com" version="r0p0"}
        set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_dest_axi \
            -exept_pl [list m_dest_axi_aclk m_dest_axi_aresetn] \
            -name m_dest_axi \
            -display_name m_dest_axi \
            -description m_dest_axi \
            -bus_type $bustype \
            -abstraction_ref $abstref \
            -master_slave master \
            -aspace_ref m_dest_axi_aspace]
        set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_src_axi \
            -exept_pl [list m_src_axi_aclk m_src_axi_aresetn] \
            -name m_src_axi \
            -display_name m_src_axi \
            -description m_src_axi \
            -bus_type $bustype \
            -abstraction_ref $abstref \
            -master_slave master]
        set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_sg_axi \
            -exept_pl [list m_sg_axi_aclk m_sg_axi_aresetn] \
            -name m_sg_axi \
            -display_name m_sg_axi \
            -description m_sg_axi \
            -bus_type $bustype \
            -abstraction_ref $abstref \
            -master_slave master]
        ipl::genip $ip

        # return $ip
        # ipl::getaxi [ipl::getmod axi_dmac.v]
    }

    # to do check the ports to select the interface type
    # set up a structure with the ports and the interface type included
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
                set reg [list ${interface_name}_.+]
                set name [dict get $line name]
                if {[regexp $reg $name]} {
                    puts $line
                }
            }
            puts "-------------------------------------------------------------"
        }
    }

    # to do:
    # -add memory map descriptors and set procedure, this can be included at addif procedure
    # -extend address space descriptor and add set procedures, this can be included at addif procedure
    # -add source file include procedure
    # -add ip create procedure that will create the necessary folders, collect the files, and generates the ip based in the ip script.
    # -create make script.
}