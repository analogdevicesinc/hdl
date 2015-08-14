
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
set_property CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ                   {50}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UART1_PERIPHERAL_ENABLE                   {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USB0_PERIPHERAL_ENABLE                    {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USB0_RESET_ENABLE                         {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_USB0_RESET_IO                             {MIO 7}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_QSPI_PERIPHERAL_ENABLE                    {1}                     [get_bd_cells sys_ps7]

## DDR MT41K256M16 RE-125 (32M, 16bit, 8banks)
## DDR MT41K256M16 HA-125 (32M, 16bit, 8banks)
## CONFIG.PCW_UIPARAM_DDR_CLOCK_0_PACKAGE_LENGTH {137} 
## CONFIG.PCW_UIPARAM_DDR_CLOCK_1_PACKAGE_LENGTH {137} 
## CONFIG.PCW_UIPARAM_DDR_CLOCK_2_PACKAGE_LENGTH {137} 
## CONFIG.PCW_UIPARAM_DDR_CLOCK_3_PACKAGE_LENGTH {137}
## CONFIG.PCW_UIPARAM_DDR_DQS_0_PACKAGE_LENGTH   {98.4} 
## CONFIG.PCW_UIPARAM_DDR_DQS_1_PACKAGE_LENGTH   {120.5} 
## CONFIG.PCW_UIPARAM_DDR_DQS_2_PACKAGE_LENGTH   {119.6} 
## CONFIG.PCW_UIPARAM_DDR_DQS_3_PACKAGE_LENGTH   {141} 
## CONFIG.PCW_UIPARAM_DDR_DQ_0_PACKAGE_LENGTH    {104.4} 
## CONFIG.PCW_UIPARAM_DDR_DQ_1_PACKAGE_LENGTH    {120.5} 
## CONFIG.PCW_UIPARAM_DDR_DQ_2_PACKAGE_LENGTH    {126.4} 
## CONFIG.PCW_UIPARAM_DDR_DQ_3_PACKAGE_LENGTH    {144} 

set_property CONFIG.PCW_UIPARAM_DDR_PARTNO                        {MT41K256M16 RE-125}    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BUS_WIDTH                     {32 Bit}                [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF             {0}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL             {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE               {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE                {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0            {-0.053}                [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1            {-0.059}                [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2            {0.065}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3            {0.066}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0                  {0.264}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1                  {0.265}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2                  {0.330}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3                  {0.330}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_CLOCK_0_LENGTH_MM             {34}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_CLOCK_1_LENGTH_MM             {34}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_CLOCK_2_LENGTH_MM             {54}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_CLOCK_3_LENGTH_MM             {54}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_0_LENGTH_MM               {43.4}                  [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_1_LENGTH_MM               {43.8}                  [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_2_LENGTH_MM               {44.2}                  [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_3_LENGTH_MM               {43.5}                  [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQ_0_LENGTH_MM                {43.6}                  [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQ_1_LENGTH_MM                {43.75}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQ_2_LENGTH_MM                {44.2}                  [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQ_3_LENGTH_MM                {43.5}                  [get_bd_cells sys_ps7]

