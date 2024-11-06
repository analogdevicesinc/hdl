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

#include <hls_stream.h>
#include <ap_int.h>

#include <stdio.h>
#include <cstdio>
#include <cstring>
#include <iomanip>
#include <iostream>
using namespace std;
#include <sstream>
#include <string>
#include <vector>

// number of times to perform the test in different message and length
#define NUM_TESTS 1008
// the size of each message word in byte
#define MSG_SIZE 8
// the size of the digest in byte
#define DIG_SIZE 64

// table to save each message and its hash value
struct Test {
    string msg;
    unsigned char hash[DIG_SIZE];
    Test(const char* m, const void* h) : msg(m) { memcpy(hash, h, DIG_SIZE); }
};

// print hash value
std::string hash2str(unsigned char* h, int len) {
    ostringstream oss;
    string retstr;

    // check output
    oss.str("");
    oss << hex;
    for (int i = 0; i < len; i++) {
        oss << setw(2) << setfill('0') << (unsigned)h[i];
    }
    retstr = oss.str();
    return retstr;
}

int main() {
    std::cout << "*************************************" << std::endl;
    std::cout << "   Testing SHA3-512 on HLS project   " << std::endl;
    std::cout << "*************************************" << std::endl;

    // the original message to be digested
    const char message[] =
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz"
        "abcdefghijklmnopqrstuvwxyz";
    vector<Test> tests;

    unsigned char h[DIG_SIZE];
    memcpy(h, message, DIG_SIZE);
    hls::stream<sha_uint64_t> msg_strm("msg_strm_in");
    hls::stream<uintSizeDigest_t> digest_strm("digest_strm_out");

    // generate golden
    for (unsigned int i = 0; i < NUM_TESTS; i++) {
        unsigned int len = 8;
        char m[8];
        if (len != 0) {
            memcpy(m, message, len);
        }
        m[len-1] = 0;
        msg_strm.write(m);

        // tests.push_back(Test(m, h));
    }

    unsigned int nerror = 0;
    unsigned int ncorrect = 0;

    

    // // generate input message words
    // for (vector<Test>::const_iterator test = tests.begin(); test != tests.end(); test++) {
    //     sha_uint64_t msg;
    //     unsigned int n = 0;
    //     unsigned int cnt = 0;
    //     // write msg stream word by word
    //     for (string::size_type i = 0; i < (*test).msg.length(); i++) {
    //         if (n == 0) {
    //             msg = 0;
    //         }
    //         msg.range(7 + 8 * n, 8 * n) = (unsigned)((*test).msg[i]);
    //         n++;
    //         if (n == MSG_SIZE) {
    //             msg_strm.write(msg);
    //             ++cnt;
    //             n = 0;
    //         }
    //     }
    // }
    std::cout << "fulfill data" << std::endl;

    // call fpga module
    sha3_ip_512(msg_strm, digest_strm);

    // check result
    for (unsigned int i = 0; i < (NUM_TESTS / (BLOCK_SIZE * NUM_BLOCKS)); i++) {
        uintSizeDigest_t digest = digest_strm.read();
        if (i == 0) std::cout << "digest: " << digest << std::endl;
    }
    return nerror;
}
