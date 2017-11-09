
package require qsys
source ../scripts/adi_env.tcl
source ../scripts/adi_ip_alt.tcl

ad_ip_create util_clkdiv_alt {Clock divider by 2}
ad_ip_files util_clkdiv_alt [list\
    util_clkdiv_constr.sdc \
    util_clkdiv_alt.v]

# defaults

ad_alt_intf clock   clk             input   1
ad_alt_intf reset   reset           input   1 if_clk
ad_alt_intf clock   clk_out         output  1
ad_alt_intf reset   reset_out       output  1 if_clk_out

