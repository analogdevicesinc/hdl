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

#include "sha3_ip_512.hpp"

// #include <hls_stream.h>
// #include <ap_int.h>

#include <stdio.h>
#include <cstdio>
#include <cstring>
#include <iomanip>
#include <iostream>
using namespace std;
#include <sstream>
#include <string>
#include <vector>
#include <unistd.h>

#define ITERATIONS 10
#define NUM_TESTS (BLOCK_SIZE * NUM_BLOCKS) * ITERATIONS //10 block executions

// print hash value
std::string hash2str(uintSizeDigest_t h, int len) {
    ostringstream oss;
    string retstr;

    // check output
    oss.str("");
    oss << hex;
    for (int i = 0; i < len; i++) {
    	oss << setw(2) << setfill('0') << (h.range(i*8 + 7, (i*8))).to_uint();
    }
    retstr = oss.str();
    return retstr;
}

int main() {
    std::cout << "*************************************" << std::endl;
    std::cout << "   Testing SHA3-512 on HLS project   " << std::endl;
    std::cout << "*************************************" << std::endl;

    hls::stream<sha_uint64_t> msg_strm("msg_strm_in");
    hls::stream<uintSizeDigest_t> digest_strm("digest_strm_out");

    ap_uint<64> msg = 0;
    for (unsigned int i = 0; i < NUM_TESTS; i++) {
        msg_strm.write(msg);
        msg++;
    }
    
    sleep(10);
    // call fpga module
    sha3_ip_512(msg_strm, digest_strm);
    sleep(10);

    std::cout << "Digests: " << std::endl;
    while (!digest_strm.empty()) {
        uintSizeDigest_t digest = digest_strm.read();
        std::cout << std::setw(128) << std::setfill('0') << std::hex << digest << std::endl;
    }
    return 0;
}
