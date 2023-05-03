`ifndef MOD_BIT_CMD_VH
`define MOD_BIT_CMD_VH

`define MOD_BIT_CMD_WIDTH 4

// Modulation bit commands
`define MOD_BIT_CMD_NOP_	3'b000
`define MOD_BIT_CMD_START_	3'b001
`define MOD_BIT_CMD_STOP_	3'b010
`define MOD_BIT_CMD_WRITE_	3'b011
`define MOD_BIT_CMD_READ_	3'b100


`define MOD_BIT_CMD_NOP			{`MOD_BIT_CMD_NOP_,   2'b00}
`define MOD_BIT_CMD_START_OD	{`MOD_BIT_CMD_START_, 2'b00}
`define MOD_BIT_CMD_START_PP	{`MOD_BIT_CMD_START_, 2'b10}
`define MOD_BIT_CMD_STOP 		{`MOD_BIT_CMD_STOP_,  2'b00}
`define MOD_BIT_CMD_WRITE_OD_0	{`MOD_BIT_CMD_WRITE_, 2'b00}
`define MOD_BIT_CMD_WRITE_OD_1	{`MOD_BIT_CMD_WRITE_, 2'b01}
`define MOD_BIT_CMD_WRITE_PP_0	{`MOD_BIT_CMD_WRITE_, 2'b10}
`define MOD_BIT_CMD_WRITE_PP_1	{`MOD_BIT_CMD_WRITE_, 2'b11}
`define MOD_BIT_CMD_READ		{`MOD_BIT_CMD_READ_,  2'b00}
// Read and ACK are modulated identically
// The mod_byte shall send a CMD_READ to assert ACK
// Reserved: 10100 11000 11100
// T-bit LOW is a low write
// T-bit HIGH is either a open-drain high write or repeated start

`endif
