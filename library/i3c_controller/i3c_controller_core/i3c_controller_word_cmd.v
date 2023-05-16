`ifndef WORD_COMMAND_V
`define WORD_COMMAND_V

`define CMDW_HEADER_WIDTH 3

`define CMDW_NOP                   4'd00
`define CMDW_START                 4'd01
`define CMDW_BCAST_7E_W0           4'd02
`define CMDW_MSG_SR                4'd03
`define CMDW_TARGET_ADDR           4'd04
`define CMDW_MSG_TX                4'd05
`define CMDW_MSG_RX                4'd06
`define CMDW_CCC                   4'd07
`define CMDW_STOP                  4'd08
`define CMDW_BCAST_7E_W1           4'd09
`define CMDW_PROV_ID_BCR_DCR       4'd10
`define CMDW_DYN_ADDR              4'd11
`endif
