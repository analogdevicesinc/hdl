
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

## DDR MT41K256M16 HA-125 (32M, 16bit, 8banks)
## package delay & routing delay & total
## CLOCK:   137   374   511
## DQS0:     98   291   389
## DQS1:    120   292   412
## DQS2:    119   296   415
## DQS3:    141   291   432
## DQ0:     103   291   394
## DQ1:     119   292   411
## DQ2:     124   296   420
## DQ3:     144   291   435

set_property CONFIG.PCW_UIPARAM_DDR_PARTNO                        {Custom}                [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF             {0}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BANK_ADDR_COUNT               {3}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_ROW_ADDR_COUNT                {15}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_COL_ADDR_COUNT                {10}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_CL                            {11}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_CWL                           {8}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_T_RCD                         {11}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_T_RP                          {11}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_T_RC                          {48.75}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_T_RAS_MIN                     {35.0}                  [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_T_FAW                         {40}                    [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL             {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE                {1}                     [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0            {0.122}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1            {0.099}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2            {0.096}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3            {0.079}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0                  {0.453}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1                  {0.461}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2                  {0.466}                 [get_bd_cells sys_ps7]
set_property CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3                  {0.473}                 [get_bd_cells sys_ps7]

