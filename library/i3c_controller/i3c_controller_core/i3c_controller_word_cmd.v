`ifndef WORD_COMMAND_V
`define WORD_COMMAND_V

`define CMDW_HEADER_WIDTH 4

`define CMDW_NOP                   5'd00
`define CMDW_START                 5'd01
`define CMDW_BCAST_7E_W0           5'd02
`define CMDW_MSG_SR                5'd03
`define CMDW_TARGET_ADDR_OD        5'd04
`define CMDW_TARGET_ADDR_PP        5'd05
`define CMDW_MSG_TX                5'd06
`define CMDW_MSG_RX                5'd07
`define CMDW_CCC_OD                5'd08
`define CMDW_CCC_PP                5'd09
`define CMDW_STOP                  5'd10
`define CMDW_BCAST_7E_W1           5'd11
`define CMDW_DAA_DEV_CHAR_1        5'd12
`define CMDW_DAA_DEV_CHAR_2        5'd13
`define CMDW_DYN_ADDR              5'd14
`define CMDW_IBI_MDB               5'd15
`define CMDW_SR                    5'd16
`endif
