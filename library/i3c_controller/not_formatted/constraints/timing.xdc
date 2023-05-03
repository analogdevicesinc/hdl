# 100MHz
create_clock -period 10.000 -name IClk -waveform {0.000 5.000} [get_ports i_clk]

set_max_delay -from i_push_pull_en -to io_sda 1.000
set_max_delay -from i_sdi -to io_sda 1.000
set_min_delay -from i_push_pull_en -to io_sda 0.1
set_min_delay -from i_sdi -to io_sda 0.1