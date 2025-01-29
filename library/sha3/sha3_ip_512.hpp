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
#include "hls_np_channel.h"
#include "hls_task.h"
// #include "hls_stream.h"
// the size of each message word in byte
#define MSG_SIZE 8
// the size of the digest in byte
#define DIG_SIZE 64
// the block size in words of 8bytes == (200 - (512/4))/8
#define BLOCK_SIZE 9
// number of blocks to be buffered
#define NUM_BLOCKS 100
// buffer size
#define BUFFER_SIZE ((BLOCK_SIZE + 1) * NUM_BLOCKS)
// number of workers
#define NUM_WORKERS 5

typedef ap_uint<8 * MSG_SIZE> sha_uint64_t;
typedef ap_uint<128> uint128_t;
typedef ap_uint<8 * DIG_SIZE> uintSizeDigest_t;

void sha3_ip_512(hls::stream<sha_uint64_t>& msgStreamIn, hls::stream<uintSizeDigest_t>& digestStreamOut);
