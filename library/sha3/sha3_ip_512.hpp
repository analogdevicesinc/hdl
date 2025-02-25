/*
 * Copyright 2019 Xilinx, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <ap_int.h>
#include "xf_security/sha3.hpp"
#include "hls_task.h"
// the size of each input message word in bits
#define INPUT_MSG_SIZE 64
// SHA3 only accepts 64-bit message, 
#define MSG_SIZE 64
// number of messages after input message is split
#define NUM_MSG ((INPUT_MSG_SIZE + (MSG_SIZE-1))/MSG_SIZE)
// the size of the digest in bits
#define DIG_SIZE 512
// the block size in words of 8bytes == (200 - (512/4))/8
#define BLOCK_SIZE 9
// number of blocks to be buffered
#define NUM_BLOCKS 88
// buffer size
#define BUFFER_SIZE ((BLOCK_SIZE + 1) * NUM_BLOCKS)
// number of workers
#define NUM_WORKERS 5
// number of necessary blocks
#define NUM_BLOCK_WORKERS (NUM_WORKERS/NUM_MSG)

typedef ap_uint<INPUT_MSG_SIZE> uintInputMsg_t;
typedef ap_uint<MSG_SIZE> uintMsg_t;
typedef ap_uint<128> uint128_t;
typedef ap_uint<DIG_SIZE> uintSizeDigest_t;

void sha3_ip_512(hls::stream<uintInputMsg_t>& msgStreamIn, hls::stream<uintSizeDigest_t>& digestStreamOut);
