#ifndef MOD_BIT_CMD_VH
#define MOD_BIT_CMD_VH

#include <inttypes.h>

// Modulation bit commands
constexpr uint8_t MOD_BIT_CMD_NOP        = 0x00;
constexpr uint8_t MOD_BIT_CMD_START_OD   = 0x04;
constexpr uint8_t MOD_BIT_CMD_START_PP   = 0x06;
constexpr uint8_t MOD_BIT_CMD_STOP       = 0x08;
constexpr uint8_t MOD_BIT_CMD_WRITE_OD_0 = 0x0c;
constexpr uint8_t MOD_BIT_CMD_WRITE_OD_1 = 0x0d;
constexpr uint8_t MOD_BIT_CMD_WRITE_PP_0 = 0x0e;
constexpr uint8_t MOD_BIT_CMD_WRITE_PP_1 = 0x0f;
constexpr uint8_t MOD_BIT_CMD_READ       = 0x10;

#endif
