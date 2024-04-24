###############################################################################
## Copyright (C) 2024 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

namespace eval ipl {
    #node: {name attributes content childs}
    set ip_desc {{lsccip:ip} {{0} {xmlns:lsccip="http://www.latticesemi.com/XMLSchema/Radiant/ip" xmlns:xi="http://www.w3.org/2001/XInclude" version="1.0" platform="radiant" platform_version="2023.2"}} {} {
            {lsccip:general} {{lsccip:general} {} {} {
                    {lsccip:vendor} {{lsccip:vendor} {} {analog.com} {}}
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
                    {lsccip:supported_products} {{lsccip:supported_products} {} {} {}}
                    {lsccip:supported_platforms} {{lsccip:supported_platforms} {} {} {}}
                    {href} {{} {} {https://wiki.analog.com/resources/fpga/docs/ip_cores} {}}
                }
            }
            {lsccip:settings} {{} {} {} {}}
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

    set abstractionDefinition_desc {
        {ipxact:abstractionDefinition}
        {{0} {xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xmlns:ipxact="http://www.accellera.org/XMLSchema/IPXACT/1685-2014"
            xsi:schemaLocation="http://www.accellera.org/XMLSchema/IPXACT/1685-2014 http://www.accellera.org/XMLSchema/IPXACT/1685-2014/index.xsd"}}
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
            xsi:schemaLocation="http://www.accellera.org/XMLSchema/IPXACT/1685-2014 http://www.accellera.org/XMLSchema/IPXACT/1685-2014/index.xsd"}}
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

# <ipxact:requiresDriver driverType="singleShot">true</ipxact:requiresDriver>
# <ipxact:requiresDriver driverType="clock">true</ipxact:requiresDriver>
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
                            {ipxact:presence} {{ipxact:presence} {} {optional} {}}
                            {ipxact:width} {{} {} {} {}}
                            {ipxact:direction} {{ipxact:direction} {} {out} {}}
                        }
                    }
                    {ipxact:onSlave} {{ipxact:onSlave} {} {} {
                            {ipxact:presence} {{ipxact:presence} {} {optional} {}}
                            {ipxact:width} {{} {} {} {}}
                            {ipxact:direction} {{ipxact:direction} {} {in} {}}
                        }
                    }
                    {ipxact:requiresDriver} {{} {} {} {}}
                }
            }
        }
    }

    proc createcif {args} {
        array set opt [list -if "$::ipl::if" \
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
        set library $opt(-library)
        set name $opt(-name)
        set version $opt(-version)
        set vendor $opt(-vendor)

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
        set if [ipl::setatts abstractionDefinition_desc ipxact:busType $atts $if]
        foreach op $optla {
            set val $opt(-$op)
            if {$val != ""} {
                if {[ipl::getnname abstractionDefinition_desc "ipxact:$op" $if] != ""} {
                    set if [ipl::setncont abstractionDefinition_desc "ipxact:$op" $val $if]
                } else {
                    set if [ipl::setnode abstractionDefinition_desc "ipxact:$op" [list "ipxact:$op" {} $val {}] $if]
                }
            }
        }
        foreach op $optlb {
            set val $opt(-$op)
            if {$val != ""} {
                if {[ipl::getnname busDefinition_desc "ipxact:$op" $if] != ""} {
                    set if [ipl::setncont busDefinition_desc "ipxact:$op" $val $if]
                } else {
                    set if [ipl::setnode busDefinition_desc "ipxact:$op" [list "ipxact:$op" {} $val {}] $if]
                }
            }
        }
        set if [ipl::addcifports $if $ports]
        return $if
    }
    proc addcifport {args} {
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
            set port [ipl::setncont {} ipxact:description "$logicalName port" $port]
        }
        switch $qualifier {
            clock {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isClock ipxact:isClock $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isClock true $port]
            }
            reset {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isReset ipxact:isReset $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isReset true $port]
            }
            data {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isData ipxact:isData $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isData true $port]
            }
            address {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isAddress ipxact:isAddress $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isAddress true $port]
            }
            add {
                set port [ipl::setnname ipxact:wire/ipxact:qualifier ipxact:isAddress ipxact:isAddress $port]
                set port [ipl::setncont ipxact:wire/ipxact:qualifier ipxact:isAddress true $port]
            }
        }
        if {$presence != ""} {
            set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:presence $presence $port]
            set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:presence $presence $port]
        }
        if {$width != ""} {
            set port [ipl::setnname ipxact:wire/ipxact:onMaster ipxact:width ipxact:width $port]
            set port [ipl::setnname ipxact:wire/ipxact:onSlave ipxact:width ipxact:width $port]
            set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:width $width $port]
            set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:width $width $port]
        }
        if {$direction != ""} {
            if {$direction == "in"} {
                set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:direction in $port]
                set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:direction out $port]
            }
            if {$direction == "out"} {
                set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:direction out $port]
                set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:direction in $port]
            }
        }
        if {$qualifier == "clock" || $qualifier == "reset"} {
            set port [ipl::setncont ipxact:wire/ipxact:onMaster ipxact:direction in $port]
            set port [ipl::setncont ipxact:wire/ipxact:onSlave ipxact:direction in $port]
            set port [ipl::setnname ipxact:wire ipxact:requiresDriver ipxact:requiresDriver $port]
            switch $qualifier {
                clock {
                    set port [ipl::setatt ipxact:wire ipxact:requiresDriver driverType "driverType=\"clock\"" $port]
                }
                reset {
                    set port [ipl::setatt ipxact:wire ipxact:requiresDriver driverType "driverType=\"singleShot\"" $port]
                }
            }
            set port [ipl::setncont ipxact:wire ipxact:requiresDriver true $port]
        }
        if {[ipl::getnchilds {} abstractionDefinition_desc $if] == ""} {
            set abst $::ipl::abstractionDefinition_desc
            set if [ipl::setnode {} abstractionDefinition_desc $abst $if]
        }
        set if [ipl::setnode abstractionDefinition_desc/ipxact:ports $logicalName $port $if]
        return $if
    }
    proc addcifports {if ports} {
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
            set if [ipl::addcifport -if $if {*}$opts]
        }
        return $if
    }
    proc genif {if {dpath ./}} {
        set abstractionDefinition [ipl::getnode {} abstractionDefinition_desc $if]
        set busDefinition [ipl::getnode {} busDefinition_desc $if]

        set vendor [ipl::getncont busDefinition_desc ipxact:vendor $if]
        set library [ipl::getncont busDefinition_desc ipxact:library $if]
        set name [ipl::getncont busDefinition_desc ipxact:name $if]
        set version [ipl::getncont busDefinition_desc ipxact:version $if]

        if {[file exist $dpath/$vendor/$library/$name/$version] != 1} {
            file mkdir $dpath/$vendor/$library/$name/$version
        }

        set busdef [open "$dpath/$vendor/$library/$name/$version/${name}.xml" w]
        puts $busdef {<?xml version="1.0" encoding="UTF-8"?>}
        puts $busdef [ipl::xmlgen $busDefinition]
        close $busdef
        set abstdef [open "$dpath/$vendor/$library/$name/$version/${name}_rtl.xml" w]
        puts $abstdef {<?xml version="1.0" encoding="UTF-8"?>}
        puts $abstdef [ipl::xmlgen $abstractionDefinition]
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

    proc setwrtype {args} {
        array set opt [list -ip "$::ipl::ip" \
            -file_ext "v" \
        {*}$args]

        set ip $opt(-ip)
        set file_ext $opt(-file_ext)

        if {[ipl::getnname ip_desc lsccip:outFileConfigs $ip] == ""} {
            set ip [ipl::setnname ip_desc lsccip:outFileConfigs lsccip:outFileConfigs $ip]
        }

        if {$file_ext == "v"} {
            set atts {name {name="wrapper"} file_suffix {file_suffix="v"} file_description {file_description="top_level_verilog"}}
        } elseif {$file_ext == "sv"} {
            set atts {name {name="wrapper"} file_suffix {file_suffix="sv"} file_description {file_description="top_level_system_verilog"}}
        }
        set node [list lsccip:fileConfig $atts {} {}]
        set ip [ipl::setnode ip_desc/lsccip:outFileConfigs wrapper_type $node $ip]

        return $ip
    }

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
            puts "WARNING, you must define '-id'"
        }
        return $ip
    }

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
            puts "WARNING, you must define '-name'"
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
            set ip [ipl::setport -ip $ip -name $port -dangling $expression]
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

    proc generator {args} {
        array set opt [list -ip "$::ipl::ip" \
            -name "" \
            -generator "" \
        {*}$args]

        set ip $opt(-ip)
        set name $opt(-name)
        set generator $opt(-generator)

        if {$name != ""} {
            if {[ipl::getnname ip_desc lsccip:componentGenerators $ip] == ""} {
                set ip [ipl::setnname ip_desc lsccip:componentGenerators lsccip:componentGenerators $ip]
            }
            set cpgen $::ipl::componentGenerator_desc
            set cpgen [ipl::setncont {} lsccip:name $name $cpgen]
            set cpgen [ipl::setncont {} lsccip:generatorExe $generator $cpgen]
            set ip [ipl::setnode ip_desc/lsccip:componentGenerators $name $cpgen $ip]
        }
        return $ip
    }

    proc addressp {args} {
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

    proc genip {ip {dpath {./}}} {
        set ip_name [ipl::getncont ip_desc/lsccip:general lsccip:name $ip]
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
            puts [xmlgen $busInterfaces_desc]
            puts $file [xmlgen $busInterfaces_desc]
            close $file
        } else {
            puts "WARNING, No busInterfaces_desc defined!"
        }
        set addressSpaces_desc [ipl::getnode {} addressSpaces_desc $ip]
        if {$addressSpaces_desc != ""} {
            set ip [ipl::include -ip $ip -include address_space.xml]
            set file [open "$dpath/$ip_name/address_space.xml" w]
            puts [xmlgen $addressSpaces_desc]
            puts $file [xmlgen $addressSpaces_desc]
            close $file
        } else {
            puts "WARNING, No addressSpaces_desc defined!"
        }
        set memoryMaps_desc [ipl::getnode {} memoryMaps_desc $ip]
        if {$memoryMaps_desc != ""} {
            set ip [ipl::include -ip $ip -include memory_map.xml]
            set file [open "$dpath/$ip_name/memory_map.xml" w]
            puts [xmlgen $memoryMaps_desc]
            puts $file [xmlgen $memoryMaps_desc]
            close $file
        } else {
            puts "WARNING, No memoryMaps_desc defined!"
        }
        set ip_desc [ipl::getnode {} ip_desc $ip]
        if {$ip_desc != ""} {
            set file [open "$dpath/$ip_name/metadata.xml" w]
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

        if {[regexp {\n\s*module\s+[^#(\n]+} $data match]} {
            set mod_name [string map {" " ""} [lindex $match 1]]
        } else {
            puts {ERROR, no module found in the verilog file!}
            exit 2
        }
        
        set lines [regexp -all -inline {\n\s*parameter[^,\n]+|\n\s*input[^,\n]+|\n\s*output[^,\n]+|\n\s*inout[^,\n]+} $data]
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
                    if {[llength $line] == 3} {
                        set parameter [string map {" " ""} [lindex $values 1]]
                        set portdata [list type $type name $parameter]
                        set parlist [list {*}$parlist $portdata]
                    }
                    if {[llength $line] == 4} {
                        set values [split $values "="]
                        set parameter [string map {" " ""} [lindex $values 0]]
                        set default_value [string map {" " ""} [lindex $values 1]]
                        set portdata [list type $type name $parameter defval $default_value]
                        set parlist [list {*}$parlist $portdata]
                        if {$debug} {
                            puts "$type\t$parameter = $default_value"
                        }
                    }
                    if {[llength $line] == 5} {
                        set values [split $values "="]
                        set valtype [string map {" " ""} [lindex [lindex $values 0] 0]]
                        set parameter [string map {" " ""} [lindex [lindex $values 0] 1]]
                        set default_value [string map {" " ""} [lindex $values 1]]
                        set portdata [list type $type name $parameter defval $default_value valtype $valtype]
                        set parlist [list {*}$parlist $portdata]
                        if {$debug} {
                            puts "$type\t$parameter = $default_value"
                        }
                    }
                } else {
                    if {[regexp {^.+\[.+$} $line]} {
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
                    } else {
                        set portname [string map {" " ""} [lindex $values 1]]
                        set portdata [list type $type name $portname]
                        set portlist [list {*}$portlist $portdata]
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
            -vendor "" \
            -library "" \
            -name "" \
            -version "" \
            -iname "" \
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
        set iname $opt(-iname)
        set display_name $opt(-display_name)
        set description $opt(-description)
        set vendor $opt(-vendor)
        set library $opt(-library)
        set name $opt(-name)
        set version $opt(-version)
        set master_slave $opt(-master_slave)
        set mmap_ref $opt(-mmap_ref)
        set aspace_ref $opt(-aspace_ref)
        set portmap $opt(-portmap)

        set atts [list library "library=\"$library\"" \
            name "name=\"$name\"" \
            vendor "vendor=\"$vendor\"" \
            version "version=\"$version\""]

        set bif $::ipl::busInterface_desc
        set bif [ipl::setncont {} lsccip:name $iname $bif]
        set bif [ipl::setncont {} lsccip:displayName $display_name $bif]
        set bif [ipl::setncont {} lsccip:description $description $bif]
        set bif [ipl::setatts {} lsccip:busType $atts $bif]
        dict set atts name "name=\"${name}_rtl\""
        set bif [ipl::setatts lsccip:abstractionTypes/lsccip:abstractionType lsccip:abstractionRef $atts $bif]
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
            set ip [ipl::setport -ip $ip -name $pname -bus_interface $iname]
        }
        set bifs [ipl::getnode {} busInterfaces_desc $ip]
        if {$bifs == ""} {
            set bifs $::ipl::busInterfaces_desc
        }
        set bifsl [lindex $bifs 3]
        dict set bifsl $iname $bif
        lset bifs 3 $bifsl
        set ip [ipl::setnode {} busInterfaces_desc $bifs $ip]

        # to do: 
        # - manual portlist/portmap
        # - update ports attributes with the interface attribute
        return $ip
    }
    proc addifa {args} {
        array set opt [list -ip "$::ipl::ip" \
            -iname "" \
            -display_name "" \
            -description "" \
            -vendor "" \
            -library "" \
            -name "" \
            -version "" \
            -master_slave "" \
            -mmap_ref "" \
            -aspace_ref "" \
            -mod_data "" \
            -v_name "" \
            -exept_pl "" \
        {*}$args]

        set optl {
            -ip
            -iname
            -display_name
            -description
            -vendor
            -library
            -name
            -version
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
                    -dir $dir -range "${op}int$op$from$cl,$to$cl" \
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
                # check if parameter type is set
                set defval [dict get $data defval]
                set regxf {^\s*-?[0-9]*\.[0-9]+\s*$}
                set regxi {^\s*-?[0-9]+\s*$}
                set regxstr {^\".*\"$}
                if {[regexp $regxf $defval]} {
                    set value_type float
                } elseif {[regexp $regxi $defval]} {
                    set value_type int
                } elseif {[regexp $regxstr $defval]} {
                    set value_type string
                }
                
                set ip [ipl::settpar -ip $ip -id $name \
                    -type param -value_type $value_type \
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
                set ip [ipl::setwrtype -ip $ip -file_ext sv]
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

    proc axidmac {} {
        set mod_data [ipl::getmod ../axi_dmac/axi_dmac.v]
        set ip $::ipl::ip

        set ip [ipl::addports -ip $ip -mod_data $mod_data]
        # set ip [ipl::addpars -ip $ip -mod_data $mod_data]

        set ip [ipl::general -ip $ip -name [dict get $mod_data mod_name]]
        set ip [ipl::general -ip $ip -display_name "AXI_DMA ADI"]
        set ip [ipl::general -ip $ip -supported_products {*}]
        set ip [ipl::general -ip $ip -supported_platforms {esi radiant}]
        set ip [ipl::general -ip $ip -href "https://wiki.analog.com/resources/fpga/docs/axi_dmac"]
        set ip [ipl::general  -vendor "analog.com" \
            -library "ip" \
            -version "1.0" \
            -category "ADI" \
            -keywords "ADI IP" \
            -min_radiant_version "2022.1" \
            -max_radiant_version "2023.2" \
            -min_esi_version "2022.1" -ip $ip]

        # set ip [ipl::generator -name blabla -generator eval/blabla.py -ip $ip]

        set ip [ipl::mmap -ip $ip \
            -name "axi_dmac_mem_map" \
            -description "axi_dmac_mem_map" \
            -baseAddress 0 \
            -range 65536 \
            -width 32]
        set ip [ipl::addressp -ip $ip \
            -name "m_dest_axi_aspace" \
            -range 0x100000000 \
            -width 32]
        set ip [ipl::addressp -ip $ip \
            -name "m_src_axi_aspace" \
            -range 0x100000000 \
            -width 32]
        set ip [ipl::addressp -ip $ip \
            -name "m_sg_axi_aspace" \
            -range 0x100000000 \
            -width 32]
        
        set ip [ipl::addifa -ip $ip -mod_data $mod_data -iname s_axi -v_name s_axi \
            -exept_pl [list s_axi_aclk s_axi_aresetn] \
            -display_name s_axi \
            -description s_axi \
            -master_slave slave \
            -mmap_ref axi_dmac_mem_map \
            -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]
        set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_dest_axi \
            -exept_pl [list m_dest_axi_aclk m_dest_axi_aresetn] \
            -iname m_dest_axi \
            -display_name m_dest_axi \
            -description m_dest_axi \
            -master_slave master \
            -aspace_ref m_dest_axi_aspace \
            -vendor amba.com -library AMBA4 -name AXI4 -version r0p0]
        set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_src_axi \
            -exept_pl [list m_src_axi_aclk m_src_axi_aresetn] \
            -iname m_src_axi \
            -display_name m_src_axi \
            -description m_src_axi \
            -master_slave master \
            -aspace_ref m_src_axi_aspace \
            -vendor amba.com -library AMBA4 -name AXI4 -version r0p0]
        set ip [ipl::addifa -ip $ip -mod_data $mod_data -v_name m_sg_axi \
            -exept_pl [list m_sg_axi_aclk m_sg_axi_aresetn] \
            -iname m_sg_axi \
            -display_name m_sg_axi \
            -description m_sg_axi \
            -master_slave master \
            -aspace_ref m_sg_axi_aspace \
            -vendor amba.com -library AMBA4 -name AXI4 -version r0p0]

        set if [ipl::createcif -vendor analog.com \
            -library ADI \
            -name fifo_wr \
            -version 1.0 \
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
        global env
        set ifp "${env(TOOLRTF)}/ip/interfaces"
        ipl::genif $if $ifp

        set ip [ipl::addif -ip $ip \
            -iname fifo_wr \
            -display_name fifo_wr \
            -description fifo_wr \
            -master_slave slave \
            -portmap { \
                {"fifo_wr_en" "EN"} \
                {"fifo_wr_din" "DATA"} \
                {"fifo_wr_overflow" "OVERFLOW"} \
                {"fifo_wr_sync" "SYNC"} \
                {"fifo_wr_xfer_req" "XFER_REQ"} \
            } \
            -vendor analog.com -library ADI -name fifo_wr -version 1.0]
        # set ip [ipl::addif -ip $ip \
        #     -iname fifo_wr_m \
        #     -display_name fifo_wr_m \
        #     -description fifo_wr_m \
        #     -master_slave master \
        #     -portmap { \
        #         {"fifo_wr_m_en" "EN"} \
        #         {"fifo_wr_m_dout" "DATA"} \
        #         {"fifo_wr_m_overflow" "OVERFLOW"} \
        #         {"fifo_wr_m_sync" "SYNC"} \
        #         {"fifo_wr_m_xfer_req" "XFER_REQ"} \
        #     } \
        #     -vendor analog.com -library ADI -name fifo_wr -version 1.0]

        set if [ipl::createcif -vendor analog.com \
            -library ADI \
            -name fifo_rd \
            -version 1.0 \
            -directConnection true \
            -isAddressable false \
            -description "ADI fifo rd interface" \
            -ports {
                {-n DATA -d in -p required}
                {-n EN -d out -p required -w 1}
                {-n UNDERFLOW -d in -p optional -w 1}
                {-n VALID -d in -p optional -w 1}
                {-n XFER_REQ -d in -p optional -w 1}
            }]
        global env
        set ifp "${env(TOOLRTF)}/ip/interfaces"
        ipl::genif $if $ifp

        set ip [ipl::addif -ip $ip \
            -iname fifo_rd \
            -display_name fifo_rd \
            -description fifo_rd \
            -master_slave slave \
            -portmap 	{
                {"fifo_rd_en" "EN"} \
                {"fifo_rd_dout" "DATA"} \
                {"fifo_rd_valid" "VALID"} \
                {"fifo_rd_underflow" "UNDERFLOW"} \
            } \
            -vendor analog.com -library ADI -name fifo_rd -version 1.0]

        set ip [ipl::addif -ip $ip \
            -iname s_axis \
            -display_name s_axis \
            -description s_axis \
            -master_slave slave \
            -portmap [list {"s_axis_ready" "TREADY"} \
                            {"s_axis_valid" "TVALID"} \
                            {"s_axis_data" "TDATA"} \
                            {"s_axis_strb" "TSTRB"} \
                            {"s_axis_keep" "TKEEP"} \
                            {"s_axis_user" "TUSER"} \
                            {"s_axis_id" "TID"} \
                            {"s_axis_dest" "TDEST"} \
                            {"s_axis_last" "TLAST"}] \
            -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0]
        set ip [ipl::addif -ip $ip \
            -iname m_axis \
            -display_name m_axis \
            -description m_axis \
            -master_slave master \
            -portmap [list {"m_axis_ready" "TREADY"} \
                            {"m_axis_valid" "TVALID"} \
                            {"m_axis_data" "TDATA"} \
                            {"m_axis_strb" "TSTRB"} \
                            {"m_axis_keep" "TKEEP"} \
                            {"m_axis_user" "TUSER"} \
                            {"m_axis_id" "TID"} \
                            {"m_axis_dest" "TDEST"} \
                            {"m_axis_last" "TLAST"}] \
            -vendor amba.com -library AMBA4 -name AXI4Stream -version r0p0]

        # Do not use a port name as interface name except if you use case differences.
        set ip [ipl::addif -ip $ip \
            -iname IRQ \
            -display_name IRQ \
            -description IRQ \
            -master_slave master \
            -portmap [list {"irq" "IRQ"}] \
            -vendor spiritconsortium.org -library busdef.interrupt -name interrupt -version 1.0]

        set ip [ipl::addfiles -spath ../axi_dmac -dpath rtl -extl {*.v *.vh} -ip $ip]
        set ip [ipl::addfiles -spath ../util_cdc -dpath rtl -extl {*.v} -ip $ip]
        set ip [ipl::addfiles -spath ../common -dpath rtl -ip $ip \
            -extl {ad_rst.v
                   up_axi.v
                   ad_mem.v
                   ad_mem_asym.v}]
        set ip [ipl::addfiles -spath ../util_axis_fifo -dpath rtl -ip $ip \
            -extl {util_axis_fifo.v
                   util_axis_fifo_address_generator.v}]

        # set ip [ipl::addfiles -spath ./ -dpath eval -extl {blabla.py} -ip $ip]
        # set ip [ipl::addfiles -spath ./ -dpath plugin -extl {blabla.py} -ip $ip]

        # source
        set ip [ipl::settpar -ip $ip \
            -id DMA_TYPE_SRC \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Type} \
            -options {[('Memory-Mapped AXI', 0), ('Streaming AXI', 1), ('FIFO Interface', 2)]} \
            -default 2 \
            -output_formatter nostr \
            -group1 {Source} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_AXI_PROTOCOL_SRC \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {AXI Protocol} \
            -options {[('AXI4', 0), ('AXI3', 1)]} \
            -editable {(DMA_TYPE_SRC == 0)} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Source} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_DATA_WIDTH_SRC \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Bus Width} \
            -options {[16, 32, 64, 128, 256, 512, 1024, 2048]} \
            -default 64 \
            -output_formatter nostr \
            -group1 {Source} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id AXI_SLICE_SRC \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Insert Register Slice} \
            -options {[(True, 1), (False, 0)]} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Source} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id SYNC_TRANSFER_START \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Transfer Start Synchronization Support} \
            -options {[(True, 1), (False, 0)]} \
            -editable {not(DMA_TYPE_SRC == 0)} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Source} \
            -group2 Config]
        set ip [ipl::igiports -ip $ip \
            -mod_data $mod_data \
            -v_name m_src_axi \
            -expression {not(DMA_TYPE_SRC == 0)}]
        set ip [ipl::igiports -ip $ip \
            -mod_data $mod_data \
            -v_name s_axis \
            -expression {not(DMA_TYPE_SRC == 1)}]
        set ip [ipl::igiports -ip $ip \
            -mod_data $mod_data \
            -v_name fifo_rd \
            -expression {not(DMA_TYPE_SRC == 2)}]

        # destination
        set ip [ipl::settpar -ip $ip \
            -id DMA_TYPE_DEST \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Type} \
            -default 2 \
            -options {[('Memory-Mapped AXI', 0), ('Streaming AXI', 1), ('FIFO Interface', 2)]} \
            -output_formatter nostr \
            -group1 {Destination} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_AXI_PROTOCOL_DEST \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {AXI Protocol} \
            -options {[('AXI4', 0), ('AXI3', 1)]} \
            -editable {(DMA_TYPE_DEST == 0)} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Destination} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_DATA_WIDTH_DEST \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Bus Width} \
            -options {[16, 32, 64, 128, 256, 512, 1024, 2048]} \
            -default 64 \
            -output_formatter nostr \
            -group1 {Destination} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id AXI_SLICE_DEST \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Insert Register Slice} \
            -options {[(True, 1), (False, 0)]} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Destination} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id CACHE_COHERENT_DEST \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Assume cache coherent} \
            -options {[(True, 1), (False, 0)]} \
            -editable {(DMA_TYPE_DEST == 0)} \
            -default 1 \
            -output_formatter nostr \
            -group1 {Destination} \
            -group2 Config]
        set ip [ipl::igiports -ip $ip \
            -mod_data $mod_data \
            -v_name m_dest_axi \
            -expression {not(DMA_TYPE_DEST == 0)}]
        set ip [ipl::igiports -ip $ip \
            -mod_data $mod_data \
            -v_name m_axis \
            -expression {not(DMA_TYPE_DEST == 1)}]
        set ip [ipl::igiports -ip $ip \
            -mod_data $mod_data \
            -v_name fifo_wr \
            -expression {not(DMA_TYPE_DEST == 2)}]

        # scatter gather
        set ip [ipl::settpar -ip $ip \
            -id DMA_AXI_PROTOCOL_SG \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {AXI Protocol} \
            -editable {(DMA_SG_TRANSFER == 1)} \
            -options {[('AXI4', 0), ('AXI3', 1)]} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Scatter-Gather} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_DATA_WIDTH_SG \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Bus Width} \
            -editable {(DMA_SG_TRANSFER == 1)} \
            -options {[64]} \
            -default 64 \
            -output_formatter nostr \
            -group1 {Scatter-Gather} \
            -group2 Config]
        set ip [ipl::igiports -ip $ip \
            -mod_data $mod_data \
            -v_name m_sg_axi \
            -expression {(DMA_SG_TRANSFER == 0)}]

        # general
        set ip [ipl::settpar -ip $ip \
            -id ID \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Core ID} \
            -default 0 \
            -output_formatter nostr \
            -group1 {General Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_LENGTH_WIDTH \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {DMA Transfer Length Register Width} \
            -default 24 \
            -output_formatter nostr \
            -group1 {General Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id FIFO_SIZE \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Store-and-Forward Memory Size (In Bursts)} \
            -options {[2, 4, 8, 16, 32]} \
            -default 8 \
            -output_formatter nostr \
            -group1 {General Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id MAX_BYTES_PER_BURST \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Maximum Bytes per Burst} \
            -default 128 \
            -output_formatter nostr \
            -group1 {General Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_AXI_ADDR_WIDTH \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {DMA AXI Address Width} \
            -default 32 \
            -output_formatter nostr \
            -group1 {General Configuration} \
            -group2 Config]

        # features
        set ip [ipl::settpar -ip $ip \
            -id CYCLIC \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Cyclic Transfer Support} \
            -options {[(True, 1), (False, 0)]} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Features} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_2D_TRANSFER \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {2D Transfer Support} \
            -options {[(True, 1), (False, 0)]} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Features} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id DMA_SG_TRANSFER \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {SG Transfer Support} \
            -options {[(True, 1), (False, 0)]} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Features} \
            -group2 Config]

        # clock domain configuration
        set ip [ipl::settpar -ip $ip \
            -id ASYNC_CLK_REQ_SRC \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Request and Source Clock Asynchronous} \
            -options {[(True, 1), (False, 0)]} \
            -default 1 \
            -output_formatter nostr \
            -group1 {Clock Domain Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id ASYNC_CLK_SRC_DEST \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Source and Destination Clock Asynchronous} \
            -options {[(True, 1), (False, 0)]} \
            -default 1 \
            -output_formatter nostr \
            -group1 {Clock Domain Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id ASYNC_CLK_DEST_REQ \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Destination and Request Clock Asynchronous} \
            -options {[(True, 1), (False, 0)]} \
            -default 1 \
            -output_formatter nostr \
            -group1 {Clock Domain Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id ASYNC_CLK_REQ_SG \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Request and Scatter-Gather Clock Asynchronous} \
            -options {[(True, 1), (False, 0)]} \
            -default 1 \
            -output_formatter nostr \
            -group1 {Clock Domain Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id ASYNC_CLK_SRC_SG \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Source and Scatter-Gather Clock Asynchronous} \
            -options {[(True, 1), (False, 0)]} \
            -default 1 \
            -output_formatter nostr \
            -group1 {Clock Domain Configuration} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id ASYNC_CLK_DEST_SG \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Destination and Scatter-Gather Clock Asynchronous} \
            -options {[(True, 1), (False, 0)]} \
            -default 1 \
            -output_formatter nostr \
            -group1 {Clock Domain Configuration} \
            -group2 Config]

        # debug
        set ip [ipl::settpar -ip $ip \
            -id DISABLE_DEBUG_REGISTERS \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Disable Debug Registers} \
            -options {[(True, 1), (False, 0)]} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Debug} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -id ENABLE_DIAGNOSTICS_IF \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title {Enable Diagnostics Interface} \
            -options {[(True, 1), (False, 0)]} \
            -default 0 \
            -output_formatter nostr \
            -group1 {Debug} \
            -group2 Config]
        set ip [ipl::igports -ip $ip \
            -portlist {dest_diag_level_bursts} \
            -expression {(ENABLE_DIAGNOSTICS_IF == 0)}]

        # hidden
        set ip [ipl::settpar -ip $ip \
            -hidden True \
            -id AXI_ID_WIDTH_SRC \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title AXI_ID_WIDTH_SRC \
            -default 1 \
            -output_formatter nostr \
            -group1 {Hidden} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -hidden True \
            -id AXI_ID_WIDTH_DEST \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title AXI_ID_WIDTH_DEST \
            -default 1 \
            -output_formatter nostr \
            -group1 {Hidden} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -hidden True \
            -id AXI_ID_WIDTH_SG \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title AXI_ID_WIDTH_SG \
            -default 1 \
            -output_formatter nostr \
            -group1 {Hidden} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -hidden True \
            -id DMA_AXIS_ID_W \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title DMA_AXIS_ID_W \
            -default 8 \
            -output_formatter nostr \
            -group1 {Hidden} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -hidden True \
            -id DMA_AXIS_DEST_W \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title DMA_AXIS_DEST_W \
            -default 4 \
            -output_formatter nostr \
            -group1 {Hidden} \
            -group2 Config]
        set ip [ipl::settpar -ip $ip \
            -hidden True \
            -id ALLOW_ASYM_MEM \
            -type param \
            -value_type int \
            -conn_mod axi_dmac \
            -title ALLOW_ASYM_MEM \
            -default 0 \
            -output_formatter nostr \
            -group1 {Hidden} \
            -group2 Config]

        ipl::genip $ip
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

    proc aximon {} {
        set mod_data [ipl::getmod ../axi_clock_monitor/axi_clock_monitor.v]
        set ip $::ipl::ip

        set ip [ipl::addports -ip $ip -mod_data $mod_data]
        set ip [ipl::addpars -ip $ip -mod_data $mod_data]

        set ip [ipl::general \
            -name [dict get $mod_data mod_name] \
            -display_name "ADI AXI clock monitor" \
            -supported_products {*} \
            -supported_platforms {esi radiant} \
            -href "https://wiki.analog.com/resources/fpga/docs/axi_clock_monitor" \
            -vendor "analog.com" \
            -library "ip" \
            -version "1.0" \
            -category "ADI" \
            -keywords "ADI IP" \
            -min_radiant_version "2023.1" \
            -min_esi_version "2023.1" -ip $ip]

        set ip [ipl::mmap -ip $ip \
            -name "axi_clock_monitor_mem_map" \
            -description "axi_clock_monitor_mem_map" \
            -baseAddress 0 \
            -range 4096 \
            -width 32]

        set ip [ipl::addifa -ip $ip -mod_data $mod_data -iname s_axi -v_name s_axi \
            -exept_pl [list s_axi_aclk s_axi_aresetn] \
            -display_name s_axi \
            -description s_axi \
            -master_slave slave \
            -mmap_ref axi_clock_monitor_mem_map \
            -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]

        set ip [ipl::igports -ip $ip -portlist {clock_1} -expression {not(NUM_OF_CLOCKS > 1)}]
        set ip [ipl::igports -ip $ip -portlist {clock_2} -expression {not(NUM_OF_CLOCKS > 2)}]
        set ip [ipl::igports -ip $ip -portlist {clock_3} -expression {not(NUM_OF_CLOCKS > 3)}]
        set ip [ipl::igports -ip $ip -portlist {clock_4} -expression {not(NUM_OF_CLOCKS > 4)}]
        set ip [ipl::igports -ip $ip -portlist {clock_5} -expression {not(NUM_OF_CLOCKS > 5)}]
        set ip [ipl::igports -ip $ip -portlist {clock_6} -expression {not(NUM_OF_CLOCKS > 6)}]
        set ip [ipl::igports -ip $ip -portlist {clock_7} -expression {not(NUM_OF_CLOCKS > 7)}]
        set ip [ipl::igports -ip $ip -portlist {clock_8} -expression {not(NUM_OF_CLOCKS > 8)}]
        set ip [ipl::igports -ip $ip -portlist {clock_9} -expression {not(NUM_OF_CLOCKS > 9)}]
        set ip [ipl::igports -ip $ip -portlist {clock_10} -expression {not(NUM_OF_CLOCKS > 10)}]
        set ip [ipl::igports -ip $ip -portlist {clock_11} -expression {not(NUM_OF_CLOCKS > 11)}]
        set ip [ipl::igports -ip $ip -portlist {clock_12} -expression {not(NUM_OF_CLOCKS > 12)}]
        set ip [ipl::igports -ip $ip -portlist {clock_13} -expression {not(NUM_OF_CLOCKS > 13)}]
        set ip [ipl::igports -ip $ip -portlist {clock_14} -expression {not(NUM_OF_CLOCKS > 14)}]
        set ip [ipl::igports -ip $ip -portlist {clock_15} -expression {not(NUM_OF_CLOCKS > 15)}]

        set ip [ipl::setport -ip $ip -name s_axi_aclk -port_type clock]
        set ip [ipl::setport -ip $ip -name s_axi_aresetn -port_type reset]
        set ip [ipl::setport -ip $ip -name clock_0 -port_type clock]

        set ip [ipl::addfiles -spath ../axi_clock_monitor -dpath rtl -extl {axi_clock_monitor.v} -ip $ip]
        set ip [ipl::addfiles -spath ../common -dpath rtl -extl {up_clock_mon.v} -ip $ip]
        set ip [ipl::addfiles -spath ../common -dpath rtl -extl {up_axi.v} -ip $ip]

        ipl::genip $ip
    }

    proc axipwm {} {
        set mod_data [ipl::getmod ../axi_pwm_gen/axi_pwm_gen.sv]
        set ip $::ipl::ip

        set ip [ipl::addports -ip $ip -mod_data $mod_data]
        set ip [ipl::addpars -ip $ip -mod_data $mod_data]

        set ip [ipl::general \
            -name [dict get $mod_data mod_name] \
            -display_name "ADI AXI PWM generator" \
            -supported_products {*} \
            -supported_platforms {esi radiant} \
            -href "https://wiki.analog.com/resources/fpga/docs/axi_pwm_gen" \
            -vendor "analog.com" \
            -library "ip" \
            -version "1.0" \
            -category "ADI" \
            -keywords "ADI IP" \
            -min_radiant_version "2023.1" \
            -min_esi_version "2023.1" -ip $ip]

        set ip [ipl::mmap -ip $ip \
            -name "axi_pwm_gen_mem_map" \
            -description "axi_pwm_gen_mem_map" \
            -baseAddress 0 \
            -range 65536 \
            -width 32]

        set ip [ipl::addifa -ip $ip -mod_data $mod_data -iname s_axi -v_name s_axi \
            -exept_pl [list s_axi_aclk s_axi_aresetn] \
            -display_name s_axi \
            -description s_axi \
            -master_slave slave \
            -mmap_ref axi_pwm_gen_mem_map \
            -vendor amba.com -library AMBA4 -name AXI4-Lite -version r0p0 ]


        for {set i 1} {$i < 16} {incr i} {
            set ip [ipl::igports -ip $ip -portlist [list pwm_$i] -expression "not(N_PWMS > $i)"]
            set ip [ipl::settpar -ip $ip -id PULSE_${i}_WIDTH -hidden "not(N_PWMS > $i)"]
            set ip [ipl::settpar -ip $ip -id PULSE_${i}_PERIOD -hidden "not(N_PWMS > $i)"]
            set ip [ipl::settpar -ip $ip -id PULSE_${i}_OFFSET -hidden "not(N_PWMS > $i)"]
        }

        for {set i 0} {$i < 16} {incr i} {
            set ip [ipl::settpar -ip $ip -id PULSE_${i}_WIDTH -group2 pwm_$i]
            set ip [ipl::settpar -ip $ip -id PULSE_${i}_PERIOD -group2 pwm_$i]
            set ip [ipl::settpar -ip $ip -id PULSE_${i}_OFFSET -group2 pwm_$i]
        }

        set ip [ipl::igports -ip $ip -portlist ext_clk -expression {(ASYNC_CLK_EN == 0)}]
        set ip [ipl::igports -ip $ip -portlist ext_sync -expression {(PWM_EXT_SYNC == 0)}]

        set ip [ipl::settpar -ip $ip -id ASYNC_CLK_EN -options {[(True, 1), (False, 0)]}]
        set ip [ipl::settpar -ip $ip -id PWM_EXT_SYNC -options {[(True, 1), (False, 0)]}]
        set ip [ipl::settpar -ip $ip -id EXT_ASYNC_SYNC -options {[(True, 1), (False, 0)]}]
        set ip [ipl::settpar -ip $ip -id EXT_ASYNC_SYNC -hidden {(PWM_EXT_SYNC == 0)}]

        set ip [ipl::addfiles -spath ../axi_pwm_gen -dpath rtl -ip $ip \
        -extl {axi_pwm_gen.sv
                axi_pwm_gen_1.v
                axi_pwm_gen_regmap.sv}]
        # set ip [ipl::addfiles -spath ../axi_pwm_gen -dpath rtl -extl {axi_pwm_gen_1.v} -ip $ip]
        # set ip [ipl::addfiles -spath ../axi_pwm_gen -dpath rtl -extl {axi_pwm_gen_regmap.sv} -ip $ip]
        set ip [ipl::addfiles -spath ../common -dpath rtl -extl {ad_rst.v} -ip $ip]
        set ip [ipl::addfiles -spath ../common -dpath rtl -extl {up_axi.v} -ip $ip]
        set ip [ipl::addfiles -spath ../util_cdc -dpath rtl -extl {*.v} -ip $ip]

        ipl::genip $ip
    }

    # -create make script.
}