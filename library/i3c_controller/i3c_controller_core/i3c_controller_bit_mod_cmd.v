`ifndef BIT_MOD_CMD_V
`define BIT_MOD_CMD_V

`define MOD_BIT_CMD_WIDTH 4

// Modulation bit commands

`define MOD_BIT_CMD_NOP_     3'b000
`define MOD_BIT_CMD_START_   3'b001
`define MOD_BIT_CMD_STOP_    3'b010
`define MOD_BIT_CMD_WRITE_   3'b011
`define MOD_BIT_CMD_READ_    3'b100
`define MOD_BIT_CMD_T_READ_  3'b101
`define MOD_BIT_CMD_ACK_SDR_ 3'b110
`define MOD_BIT_CMD_ACK_IBI_ 3'b111

// Read and ACK are modulated identically
// The mod_byte shall send a CMD_READ to assert ACK
// T-bit LOW is a low write
// T-bit HIGH is either a open-drain high write or repeated start

`define MOD_BIT_CMD_NOP         {`MOD_BIT_CMD_NOP_,    2'b00}
`define MOD_BIT_CMD_START_OD    {`MOD_BIT_CMD_START_,  2'b00}
`define MOD_BIT_CMD_START_PP    {`MOD_BIT_CMD_START_,  2'b10}
`define MOD_BIT_CMD_STOP_OD     {`MOD_BIT_CMD_STOP_,   2'b00}
`define MOD_BIT_CMD_STOP_PP     {`MOD_BIT_CMD_STOP_,   2'b10}
`define MOD_BIT_CMD_WRITE_OD_0  {`MOD_BIT_CMD_WRITE_,  2'b00}
`define MOD_BIT_CMD_WRITE_OD_1  {`MOD_BIT_CMD_WRITE_,  2'b01}
`define MOD_BIT_CMD_WRITE_PP_0  {`MOD_BIT_CMD_WRITE_,  2'b10}
`define MOD_BIT_CMD_WRITE_PP_1  {`MOD_BIT_CMD_WRITE_,  2'b11}
`define MOD_BIT_CMD_READ        {`MOD_BIT_CMD_READ_,   2'b00}
`define MOD_BIT_CMD_T_READ_CONT {`MOD_BIT_CMD_T_READ_ ,2'b00}
`define MOD_BIT_CMD_T_READ_STOP {`MOD_BIT_CMD_T_READ_ ,2'b01}
`define MOD_BIT_CMD_ACK_SDR     {`MOD_BIT_CMD_ACK_SDR_,2'b00}
`define MOD_BIT_CMD_ACK_IBI     {`MOD_BIT_CMD_ACK_IBI_,2'b00}

`endif
