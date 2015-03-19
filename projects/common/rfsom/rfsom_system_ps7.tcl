
set_property CONFIG.PCW_PRESET_BANK0_VOLTAGE                      {LVCMOS 1.8V}           [get_bd_cells sys_ps7]
set_property CONFIG.PCW_PRESET_BANK1_VOLTAGE                      {LVCMOS 1.8V}           [get_bd_cells sys_ps7]
set_property CONFIG.PCW_PACKAGE_NAME                              {fbg676}                [get_bd_cells sys_ps7]

set_property CONFIG.PCW_GPIO_MIO_GPIO_ENABLE                      {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_ENET0_PERIPHERAL_ENABLE                   {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_ENET0_ENET0_IO                            {MIO 16 .. 27}          [get_bd_cells sys_ps7]
set_property CONFIG.PCW_ENET0_GRP_MDIO_ENABLE                     {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_ENET1_PERIPHERAL_ENABLE                   {1}                     [get_bd_cells sys_ps7] 
set_property CONFIG.PCW_ENET_RESET_SELECT                         {Separate reset pins}   [get_bd_cells sys_ps7]
set_property CONFIG.PCW_ENET0_RESET_ENABLE                        {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_ENET0_RESET_IO                            {MIO 8}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_ENET1_RESET_ENABLE                        {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_ENET1_RESET_IO                            {MIO 51}                [get_bd_cells sys_ps7]

set_property CONFIG.PCW_SD0_PERIPHERAL_ENABLE                     {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_SD0_GRP_CD_ENABLE                         {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_SD0_GRP_CD_IO                             {MIO 50}                [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UART1_PERIPHERAL_ENABLE                   {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USB0_PERIPHERAL_ENABLE                    {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USB0_RESET_ENABLE                         {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USB0_RESET_IO                             {MIO 7}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_QSPI_PERIPHERAL_ENABLE                    {1}                     [get_bd_cells sys_ps7]

set_property CONFIG.PCW_UIPARAM_DDR_PARTNO                        {MT41K256M16 RE-15E}    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF             {1}                     [get_bd_cells sys_ps7]

