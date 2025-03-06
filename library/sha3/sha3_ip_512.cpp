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
#include <hls_print.h>

void readIn(hls::stream<uintInputMsg_t>& inData, hls::stream<uintMsg_t> outData[NUM_WORKERS],
            hls::stream<uint128_t> outMsgLen[NUM_WORKERS], hls::stream<bool> outEndLen[NUM_WORKERS]) {
    #pragma HLS INLINE OFF

    int w = 0, blockIndex = 0;
    for (int i = 0; i < (NUM_BLOCKS * BLOCK_SIZE)*NUM_BLOCK_WORKERS; i++) {
        #pragma HLS PIPELINE II = 1 REWIND
        #pragma HLS LOOP_TRIPCOUNT MIN = ((NUM_BLOCKS * BLOCK_SIZE)*NUM_BLOCK_WORKERS) max = ((NUM_BLOCKS * BLOCK_SIZE)*NUM_BLOCK_WORKERS)

        uintInputMsg_t input = inData.read();
        uintMsg_t word[NUM_MSG];

        blockIndex++;
        if (blockIndex == (NUM_BLOCKS * BLOCK_SIZE)){
            w = w + NUM_MSG;
            blockIndex = 0;
        } else {
            w = w;
        }

        for (ap_uint<10> j = 0; j < NUM_MSG; j++){
            #pragma HLS UNROLL

            word[j] = input.range(MSG_SIZE-1, 0);
            input = input >> MSG_SIZE;
            
            outData[w + j].write(word[j]);
            if (blockIndex == 1){
                outEndLen[w + j].write(false);
            } else if (blockIndex == 2){
                outEndLen[w + j].write(true);    
            }
        }
    }
}

void execute(hls::stream<uintMsg_t>& inData, hls::stream<uint128_t>& inMsgLen,
             hls::stream<bool>& inEndLen, hls::stream<uintSizeDigest_t>& outData, hls::stream<bool>& outEndLen) {
    #pragma HLS INLINE OFF

     xf::security::sha3_512(inData, inMsgLen, inEndLen, outData, outEndLen);
}

void writeOut(hls::stream<uintSizeDigest_t> inData[NUM_WORKERS], hls::stream<uintSizeDigest_t>& outData,
              hls::stream<bool> outEndLen[NUM_WORKERS]) {
    #pragma HLS INLINE OFF

    for (int i = 0; i < NUM_WORKERS; i++){
        #pragma HLS PIPELINE II = 1
        #pragma HLS LOOP_TRIPCOUNT MIN = NUM_WORKERS max = NUM_WORKERS
        outData.write(inData[i].read());
        // outEndLen[i].read();
        // outEndLen[i].read();
    }
}

void sha3_ip_512(hls::stream<uintInputMsg_t>& msgStreamIn, hls::stream<uintSizeDigest_t>& digestStreamOut){
    #pragma HLS INTERFACE mode=ap_fifo      depth = 100 port = msgStreamIn
    #pragma HLS INTERFACE mode=ap_fifo      depth = 100 port = digestStreamOut
    #pragma HLS INTERFACE mode=ap_ctrl_none port = return

    hls_thread_local hls::stream<uintMsg_t, (NUM_BLOCKS * BLOCK_SIZE)> msgStrm[NUM_WORKERS]; //leave one extra block space for buffering
    hls_thread_local hls::stream<bool,         BLOCK_SIZE > endMsgLenStrm[NUM_WORKERS]; //one write for every block
    hls_thread_local hls::stream<uint128_t, BLOCK_SIZE    > msgLenStrm[NUM_WORKERS]; //one write for every block
    // Outputs
    hls_thread_local hls::stream<uintSizeDigest_t         > digestStrm[NUM_WORKERS]; //one write for every block
    hls_thread_local hls::stream<bool,         BLOCK_SIZE > endDigestStrm[NUM_WORKERS]; //one write for every block
    
    #pragma HLS DATAFLOW

    //split solution
    readIn (msgStreamIn, msgStrm, msgLenStrm, endMsgLenStrm);

    // Task-Channels
    hls_thread_local hls::task t[NUM_WORKERS];
    for (int j = 0; j < NUM_WORKERS; j++){
        #pragma HLS UNROLL

        t[j](execute, msgStrm[j], msgLenStrm[j], endMsgLenStrm[j], digestStrm[j], endDigestStrm[j]);
    }
    writeOut (digestStrm, digestStreamOut, endDigestStrm);
}
