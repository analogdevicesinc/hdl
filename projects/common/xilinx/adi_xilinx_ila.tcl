###############################################################################
## Copyright (C) 2022-2023 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
###############################################################################

## Instantiate Xilinx Virtual Cable debug bridge
#  This procedure will instantiate the two debug bridges that make
#  up the XVC logic, and hook them up to the main CPU interconnect
#
#  \param[clk] - Clock input
#
proc ad_ila_setup_xvc {cpu_addr} {
  # AXI to DBSCAN
  ad_ip_instance debug_bridge debug_bridge_0 [list \
    C_DEBUG_MODE {2}     \
    C_NUM_BS_MASTER {1}  \
    C_BSCAN_MUX {2}      \
    C_XVC_HW_ID {0x0002} \
    ]

  # DBSCAN to Debug Hub
  ad_ip_instance debug_bridge debug_bridge_1 [list \
    C_DEBUG_MODE {1} \
    ]

  ad_connect sys_cpu_clk     debug_bridge_0/s_axi_aclk
  ad_connect sys_cpu_clk     debug_bridge_1/clk
  ad_connect sys_cpu_resetn  debug_bridge_0/s_axi_aresetn
  ad_connect debug_bridge_0/m0_bscan debug_bridge_1/S_BSCAN

  ad_cpu_interconnect $cpu_addr debug_bridge_0
}

global _ad_ila_cnt

## Instantiate an ILA core that can be used to monitor interfaces
#
# \param[clk] - The clock domain to which the interfaces are aligned
# \param[resetn] - The clock domains inverted reset signal
# \param[depth] - The ILA depth in samples, must be in 2**k, for k in [10, 17]
# \param[input_pipe_stages] - Input pipeline stages of the ILA core
# \param[advanced_trigger] - Enable advanced trigger options in the ILA
# \param[capture_control] - Enable capture control logic in the ILA
# \param[comparator_count] - Comparator count
#
proc ad_ila_setup_intf {clk                       \
                        resetn                    \
                       {depth 1024}               \
                       {input_pipe_stages 1}      \
                       {advanced_trigger {TRUE}}  \
                       {capture_control {TRUE}}   \
                       {comparator_count {0}}     \
                       } {
  set name "ila_intf_$clk"
  _ad_ila_setup $name $clk INTERFACE $depth $input_pipe_stages $advanced_trigger $capture_control $comparator_count
  ad_connect $resetn $name/resetn
}

## Instantiate an ILA core that can be used to monitor non-interface signals
#
# \param[clk] - The clock domain to which the interfaces are aligned
# \param[depth] - The ILA depth in samples, must be in 2**k, for k in [10, 17]
# \param[input_pipe_stages] - Input pipeline stages of the ILA core
# \param[advanced_trigger] - Enable advanced trigger options in the ILA
# \param[capture_control] - Enable capture control logic in the ILA
# \param[comparator_count] - Comparator count
#
proc ad_ila_setup {clk                       \
                  {depth 1024}               \
                  {input_pipe_stages 1}      \
                  {advanced_trigger {TRUE}}  \
                  {capture_control {TRUE}}   \
                  {comparator_count {0}}     \
                  } {
  _ad_ila_setup "ila_$clk" $clk NATIVE $depth $input_pipe_stages $advanced_trigger $capture_control $comparator_count
}

## Internal use only, backend for ad_ila_setup{,_intf}
proc _ad_ila_setup {name                      \
                    clk                       \
                    ila_type                  \
                   {depth 1024}               \
                   {input_pipe_stages 1}      \
                   {advanced_trigger {TRUE}}  \
                   {capture_control {TRUE}}   \
                   {comparator_count {0}}     \
                   } {

  global _ad_ila_cnt

  if {$comparator_count == 0} {
    set comparator_count [expr {1 + !!$capture_control}]
  }

  ad_ip_instance system_ila $name [ list        \
    ALL_PROBE_SAME_MU       {TRUE}              \
    ALL_PROBE_SAME_MU_CNT   $comparator_count   \
    C_MON_TYPE              $ila_type           \
    C_ADV_TRIGGER           $advanced_trigger   \
    C_EN_STRG_QUAL          $capture_control    \
    C_INPUT_PIPE_STAGES     $input_pipe_stages  \
    C_DATA_DEPTH            $depth ]

  ad_connect $clk $name/clk

  set _ad_ila_cnt($name) 0
}

## Connect signal to signal ILA core
#
# \param[clk] - The clock domain to which the interfaces are aligned
# \param[target] - The target pin/port
#
proc ad_ila_connect {clk target} {
  global _ad_ila_cnt

  set name "ila_$clk"
  set id $_ad_ila_cnt($name)
  set new_id [expr {$id + 1}]
  set _ad_ila_cnt($name) $new_id

  puts "Connecting ila probe ${id}, new_id: ${new_id}"

  ad_ip_parameter $name CONFIG.C_NUM_OF_PROBES $new_id

  ad_connect $target [get_bd_pins "$name/probe${id}"]
}

## Connect *any* interface to previously instantiated intf ILA core
#
# \param[clk] - The clock domain to which the interfaces are aligned
# \param[target] - The target interface pin/port
#
proc ad_ila_connect_intf {clk target} {
  global _ad_ila_cnt

  set name "ila_intf_$clk"
  set id $_ad_ila_cnt($name)
  set new_id [expr {$id + 1}]
  set _ad_ila_cnt($name) $new_id

  puts "Connecting ila slot ${id}, new_id: ${new_id}"

  ad_ip_parameter $name CONFIG.C_NUM_MONITOR_SLOTS $new_id

  set intf_vlnv [get_property VLNV [get_bd_intf_pins $target]]
  ad_ip_parameter $name CONFIG.C_SLOT_${id}_INTF_TYPE $intf_vlnv

  ad_connect $target [get_bd_intf_pins $name/SLOT_${id}_*]
}

