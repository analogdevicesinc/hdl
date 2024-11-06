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
#include "xf_security/sha3.hpp"

void readIn(hls::stream<sha_uint64_t>& inData, int n, hls::stream<sha_uint64_t>& outData,
            hls::stream<uint128_t>& outMsgLen, hls::stream<bool>& outEndLen) {
    #pragma HLS INLINE OFF

    sha_uint64_t word;
    int i = 0;

    while (i < n) {
        if (inData.read_nb(word)){
            outData.write(word);
            i++;
        }
    }
    outMsgLen.write((unsigned long long)((NUM_BLOCKS * BLOCK_SIZE)*8)); //in this case, 288 bytes
    outEndLen.write(false);
    outEndLen.write(true);
}

void writeOut(hls::stream<uintSizeDigest_t>& inData, hls::stream<uintSizeDigest_t>& outData,
              hls::stream<bool>& outEndLen, int n) {
    #pragma HLS INLINE OFF
    
    uintSizeDigest_t word;
    int i = 0;
    bool x;

    while (i < n) {
        if (inData.read_nb(word)){
            outData.write(word);
            i++;
        }
    }
    x = outEndLen.read();
    x = outEndLen.read();
}

void sha3_ip_512(hls::stream<sha_uint64_t>& msgStreamIn, hls::stream<uintSizeDigest_t>& digestStreamOut){
    #pragma HLS INTERFACE mode=ap_fifo      port = msgStreamIn
    #pragma HLS INTERFACE mode=ap_fifo      port = digestStreamOut
    #pragma HLS INTERFACE mode=ap_ctrl_none port = return

    //sha3 interface
    hls::stream<sha_uint64_t, ((NUM_BLOCKS + 1) * BLOCK_SIZE)> msgStrm("msgStrm"); //leave one extra space (block size) for buffering
    hls::stream<uint128_t, BLOCK_SIZE>         msgLenStrm("msgLenStrm"); //one write for every block
    hls::stream<bool, BLOCK_SIZE>              endMsgLenStrm("endMsgLenStrm"); //two writes for every block
    hls::stream<uintSizeDigest_t, BLOCK_SIZE>  digestStrm("digestStrm"); //one write for every block
    hls::stream<bool, BLOCK_SIZE>              endDigestStrm("endDigestStrm"); //two writes for every block

    #pragma HLS DATAFLOW
    while (!msgStreamIn.empty()){
        readIn(msgStreamIn, (NUM_BLOCKS * BLOCK_SIZE), msgStrm, msgLenStrm, endMsgLenStrm);
        xf::security::sha3_512(msgStrm, msgLenStrm, endMsgLenStrm, digestStrm, endDigestStrm);
        writeOut(digestStrm, digestStreamOut, endDigestStrm, 1);
    }

    #if !defined(__SYNTHESIS__) && __XF_SECURITY_SHA3_DEBUG__ == 1
        std::cout << "finished execution:" << std::endl;
        std::cout << "msgStreamIn size:" << msgStreamIn.size() << std::endl;
        std::cout << "digestStreamOut size:" << digestStreamOut.size() << std::endl;
    #endif
}
