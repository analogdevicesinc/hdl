#include "sha3_ip_512.hpp"

void readIn(hls::stream<sha_uint64_t>& inData, hls::stream<sha_uint64_t>& outData,
            hls::stream<uint128_t>& outMsgLen, hls::stream<bool>& outEndLen) {
    #pragma HLS INLINE OFF

    for (int i = 0; i < (NUM_BLOCKS * BLOCK_SIZE); i++) {
        #pragma HLS PIPELINE II=1
        if (i == 0){
            outMsgLen.write((unsigned long long)((NUM_BLOCKS * BLOCK_SIZE)*8)); //number of bytes to be processed
            outEndLen.write(false); //infinite processing
        }
        outData.write(inData.read());
    }
}

void execute(hls::stream<sha_uint64_t>& inData, hls::stream<uint128_t>& inMsgLen,
             hls::stream<bool>& inEndLen, hls::stream<uintSizeDigest_t>& outData, hls::stream<bool>& outEndLen) {
    #pragma HLS INLINE OFF

    xf::security::sha3_512(inData, inMsgLen, inEndLen, outData, outEndLen);
}

void writeOut(hls::stream<uintSizeDigest_t>& inData, hls::stream<uintSizeDigest_t>& outData,
              hls::stream<bool>& outEndLen) {
    #pragma HLS INLINE OFF
    
    outData.write(inData.read());
    outEndLen.read();
}

void sha3_ip_512(hls::stream<sha_uint64_t>& msgStreamIn, hls::stream<uintSizeDigest_t>& digestStreamOut){
    #pragma HLS INTERFACE mode=ap_fifo      depth = 100 port = msgStreamIn
    #pragma HLS INTERFACE mode=ap_fifo      depth = 100 port = digestStreamOut
    #pragma HLS INTERFACE mode=ap_ctrl_none             port = return

    // sha3 interface
    // Inputs
    hls_thread_local hls::stream<sha_uint64_t, BUFFER_SIZE> msgStrm("msgStrm"); //leave one extra block space for buffering
    hls_thread_local hls::stream<bool,         BLOCK_SIZE > endMsgLenStrm("endMsgLenStrm"); //one write for every block
    hls_thread_local hls::stream<uint128_t                > msgLenStrm("msgLenStrm"); //one write for every block

    // Outputs
    hls_thread_local hls::stream<uintSizeDigest_t         > digestStrm("digestStrm"); //one write for every block
    hls_thread_local hls::stream<bool,         BLOCK_SIZE > endDigestStrm("endDigestStrm"); //one write for every block

    // task solution
    // infinite running in parallel
    hls_thread_local hls::task t1(readIn, msgStreamIn, msgStrm, msgLenStrm, endMsgLenStrm);
    hls_thread_local hls::task t2(execute, msgStrm, msgLenStrm, endMsgLenStrm, digestStrm, endDigestStrm);
    hls_thread_local hls::task t3 (writeOut, digestStrm, digestStreamOut, endDigestStrm);
}
