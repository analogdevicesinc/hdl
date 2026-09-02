###############################################################################
## Copyright (C) 2015-2023, 2026 Analog Devices, Inc. All rights reserved.
## Short identifier: ADIBSD
##
## Redistribution and use in source and binary forms, with or without modification,
## are permitted provided that the following conditions are met:
##     - Redistributions of source code must retain the above copyright
##       notice, this list of conditions and the following disclaimer.
##     - Redistributions in binary form must reproduce the above copyright
##       notice, this list of conditions and the following disclaimer in
##       the documentation and/or other materials provided with the
##       distribution.
##     - Neither the name of Analog Devices, Inc. nor the names of its
##       contributors may be used to endorse or promote products derived
##       from this software without specific prior written permission.
##     - The use of this software may or may not infringe the patent rights
##       of one or more patent holders. This license does not release you
##       from the requirement that you obtain separate licenses from these
##       patent holders to use this software.
##     - Use of the software either in source or binary form, must be run
##       on or directly connected to an Analog Devices Inc. component.
##
## THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
## INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
## PARTICULAR PURPOSE ARE DISCLAIMED.
##
## IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
## EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
## RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
## BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
## STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
## THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
###############################################################################

ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK0_VOLTAGE                      {LVCMOS 3.3V}
ad_ip_parameter sys_ps7 CONFIG.PCW_PRESET_BANK1_VOLTAGE                      {LVCMOS 1.8V}

ad_ip_parameter sys_ps7 CONFIG.PCW_GPIO_MIO_GPIO_ENABLE                      {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_PERIPHERAL_ENABLE                   {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_ENET0_IO                            {MIO 16 .. 27}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_ENABLE                     {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_ENET0_GRP_MDIO_IO                         {MIO 52 .. 53}

ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_PERIPHERAL_ENABLE                    {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_ENABLE                         {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_USB0_RESET_IO                             {MIO 7}

ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_PERIPHERAL_ENABLE                     {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_CD_ENABLE                         {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_CD_IO                             {MIO 46}
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_WP_ENABLE                         {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_SD0_GRP_WP_IO                             {MIO 50}
ad_ip_parameter sys_ps7 CONFIG.PCW_SDIO_PERIPHERAL_FREQMHZ                   {50}

ad_ip_parameter sys_ps7 CONFIG.PCW_UART1_PERIPHERAL_ENABLE                   {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UART_PERIPHERAL_FREQMHZ                   {50}

ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_PERIPHERAL_ENABLE                    {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_SINGLE_SS_ENABLE                 {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_QSPI_GRP_FBCLK_ENABLE                     {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_TTC0_PERIPHERAL_ENABLE                    {1}

ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_PARTNO                        {MT41K256M16 RE-125}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_USE_INTERNAL_VREF             {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_WRITE_LEVEL             {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_READ_GATE               {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_TRAIN_DATA_EYE                {1}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_0            {-0.073}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_1            {-0.072}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_2            {0.024}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_DQS_TO_CLK_DELAY_3            {0.023}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY0                  {0.294}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY1                  {0.298}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY2                  {0.338}
ad_ip_parameter sys_ps7 CONFIG.PCW_UIPARAM_DDR_BOARD_DELAY3                  {0.334}

ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_0_PULLUP                              {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_1_PULLUP                              {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_9_PULLUP                              {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_10_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_11_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_12_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_13_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_14_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_15_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_16_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_17_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_18_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_19_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_20_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_21_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_22_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_23_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_24_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_25_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_26_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_27_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_28_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_29_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_30_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_31_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_32_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_33_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_34_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_35_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_36_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_37_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_38_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_39_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_40_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_41_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_42_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_43_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_44_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_45_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_46_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_47_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_48_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_49_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_50_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_51_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_52_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_53_PULLUP                             {disabled}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_0_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_1_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_2_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_3_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_4_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_5_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_6_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_7_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_8_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_9_SLEW                                {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_10_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_11_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_12_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_13_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_14_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_15_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_16_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_17_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_18_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_19_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_20_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_21_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_22_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_23_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_24_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_25_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_26_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_27_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_28_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_29_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_30_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_31_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_32_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_33_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_34_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_35_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_36_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_37_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_38_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_39_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_40_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_41_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_42_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_43_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_44_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_45_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_46_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_47_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_48_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_49_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_50_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_51_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_52_SLEW                               {slow}
ad_ip_parameter sys_ps7 CONFIG.PCW_MIO_53_SLEW                               {slow}

