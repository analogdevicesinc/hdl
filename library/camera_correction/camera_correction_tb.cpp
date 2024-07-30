#include "camera_correction.h"
#include "common/xf_headers.hpp"
#include "common/xf_utility.hpp"
#include <iostream>
/*
	Use OpenCV to open an image and pack it to an AXI Stream
	Call the function to process it and save to an output image
*/

void rgb_to_yuv422_uyvy(const cv::Mat& bgr, cv::Mat& yuv) {
    assert(bgr.size() == yuv.size() &&
           bgr.depth() == CV_8U &&
           bgr.channels() == 3 &&
           yuv.depth() == CV_8U &&
           yuv.channels() == 2);
    for (int ih = 0; ih < bgr.rows; ih++) {
        const uint8_t* rgbRowPtr = bgr.ptr<uint8_t>(ih);
        uint8_t* yuvRowPtr = yuv.ptr<uint8_t>(ih);

        for (int iw = 0; iw < bgr.cols; iw = iw + 2) {
            const int rgbColIdxBytes = iw * bgr.elemSize();
            const int yuvColIdxBytes = iw * yuv.elemSize();

            const uint8_t B1 = rgbRowPtr[rgbColIdxBytes + 0];
            const uint8_t G1 = rgbRowPtr[rgbColIdxBytes + 1];
            const uint8_t R1 = rgbRowPtr[rgbColIdxBytes + 2];
            const uint8_t B2 = rgbRowPtr[rgbColIdxBytes + 3];
            const uint8_t G2 = rgbRowPtr[rgbColIdxBytes + 4];
            const uint8_t R2 = rgbRowPtr[rgbColIdxBytes + 5];

            const int Y  =  (0.257f * R1) + (0.504f * G1) + (0.098f * B1) + 16.0f ;
            const int U  = -(0.148f * R1) - (0.291f * G1) + (0.439f * B1) + 128.0f;
            const int V  =  (0.439f * R1) - (0.368f * G1) - (0.071f * B1) + 128.0f;
            const int Y2 =  (0.257f * R2) + (0.504f * G2) + (0.098f * B2) + 16.0f ;

            yuvRowPtr[yuvColIdxBytes + 0] = cv::saturate_cast<uint8_t>(U );
            yuvRowPtr[yuvColIdxBytes + 1] = cv::saturate_cast<uint8_t>(Y );
            yuvRowPtr[yuvColIdxBytes + 2] = cv::saturate_cast<uint8_t>(V );
            yuvRowPtr[yuvColIdxBytes + 3] = cv::saturate_cast<uint8_t>(Y2);
        }
    }
}

void yuv422_to_rgb_uyvy(const cv::Mat& yuv, cv::Mat& bgr) {
    assert(bgr.size() == yuv.size() &&
           bgr.depth() == CV_8U &&
           bgr.channels() == 3 &&
           yuv.depth() == CV_8U &&
           yuv.channels() == 2);
    for (int ih = 0; ih < yuv.rows; ih++) {
        const uint8_t* yuvRowPtr = yuv.ptr<uint8_t>(ih);
        uint8_t* rgbRowPtr = bgr.ptr<uint8_t>(ih);

        for (int iw = 0; iw < yuv.cols; iw = iw + 2) {
            const int rgbColIdxBytes = iw * bgr.elemSize();
            const int yuvColIdxBytes = iw * yuv.elemSize();

            const int U  = yuvRowPtr[yuvColIdxBytes + 0] - 128;
            const int Y  = yuvRowPtr[yuvColIdxBytes + 1] - 16;
            const int V  = yuvRowPtr[yuvColIdxBytes + 2] - 128;
            const int Y2  = yuvRowPtr[yuvColIdxBytes + 3] - 16;

            const int B1  =  1.164 * Y + 2.017 * U;
            const int G1  =  1.164 * Y - 0.392 * U - 0.813 * V;
            const int R1  =  1.164 * Y + 1.596 * V;
            const int B2  =  1.164 * Y2 + 2.017 * U;
            const int G2  =  1.164 * Y2 - 0.392 * U - 0.813 * V;
            const int R2  =  1.164 * Y2 + 1.596 * V;
            // const int B1  =  1.164 * Y + 2.115 * U;
            // const int G1  =  1.164 * Y - 0.213 * U - 0.534 * V;
            // const int R1  =  1.164 * Y + 1.793 * V;
            // const int B2  =  1.164 * Y2 + 2.115 * U;
            // const int G2  =  1.164 * Y2 - 0.213 * U - 0.534 * V;
            // const int R2  =  1.164 * Y2 + 1.793 * V;

            rgbRowPtr[rgbColIdxBytes + 0] = cv::saturate_cast<uint8_t>(B1 );
            rgbRowPtr[rgbColIdxBytes + 1] = cv::saturate_cast<uint8_t>(G1 );
            rgbRowPtr[rgbColIdxBytes + 2] = cv::saturate_cast<uint8_t>(R1 );
            rgbRowPtr[rgbColIdxBytes + 3] = cv::saturate_cast<uint8_t>(B2 );
            rgbRowPtr[rgbColIdxBytes + 4] = cv::saturate_cast<uint8_t>(G2 );
            rgbRowPtr[rgbColIdxBytes + 5] = cv::saturate_cast<uint8_t>(R2 );
        }
    }
}

void yuv_8c2_to_16c1(cv::Mat& yuv_8, cv::Mat& yuv_16) {
	for (int ih = 0; ih < yuv_8.rows; ih++) {
        uint8_t* yuvRowPtr = yuv_8.ptr<uint8_t>(ih);
        uint8_t* yuv16RowPtr = yuv_16.ptr<uint8_t>(ih);

        for (int iw = 0; iw < yuv_8.cols; iw = iw + 2) {
            const int yuvColIdxBytes = iw * yuv_8.elemSize();
			const int yuv16ColIdxBytes = iw * yuv_16.elemSize();

            yuv16RowPtr[yuv16ColIdxBytes + 0] = cv::saturate_cast<uint8_t>(yuvRowPtr[yuvColIdxBytes + 0]);
            yuv16RowPtr[yuv16ColIdxBytes + 1] = cv::saturate_cast<uint8_t>(yuvRowPtr[yuvColIdxBytes + 1]);
            yuv16RowPtr[yuv16ColIdxBytes + 2] = cv::saturate_cast<uint8_t>(yuvRowPtr[yuvColIdxBytes + 2]);
            yuv16RowPtr[yuv16ColIdxBytes + 3] = cv::saturate_cast<uint8_t>(yuvRowPtr[yuvColIdxBytes + 3]);
        }
    }
}

void yuv_16c1_to_8c2(cv::Mat& yuv_16, cv::Mat& yuv_8) {
	for (int ih = 0; ih < yuv_8.rows; ih++) {
        uint8_t* yuvRowPtr = yuv_8.ptr<uint8_t>(ih);
        uint8_t* yuv16RowPtr = yuv_16.ptr<uint8_t>(ih);

        for (int iw = 0; iw < yuv_8.cols; iw = iw + 2) {
            const int yuvColIdxBytes = iw * yuv_8.elemSize();
			const int yuv16ColIdxBytes = iw * yuv_16.elemSize();

            yuvRowPtr[yuvColIdxBytes + 0] = cv::saturate_cast<uint8_t>((yuv16RowPtr[yuv16ColIdxBytes + 0]) & 0xff);
            yuvRowPtr[yuvColIdxBytes + 1] = cv::saturate_cast<uint8_t>((yuv16RowPtr[yuv16ColIdxBytes + 1]) & 0xff);
            yuvRowPtr[yuvColIdxBytes + 2] = cv::saturate_cast<uint8_t>((yuv16RowPtr[yuv16ColIdxBytes + 2]) & 0xff);
            yuvRowPtr[yuvColIdxBytes + 3] = cv::saturate_cast<uint8_t>((yuv16RowPtr[yuv16ColIdxBytes + 3]) & 0xff);
        }
    }
}

int main(int argc, char** argv)
{
    // printf("OpenCV: %s\n", cv::getBuildInformation().c_str());
    int tdest = 1;
    uint8_t  *m = new uint8_t [IMG_MAX_HEIGHT * IMG_MAX_WIDTH * 2];
    uint8_t  *n = new uint8_t [IMG_MAX_HEIGHT * IMG_MAX_WIDTH * 2];
    cv::Mat src_bgr = cv::imread(argv[1]);
	//cv::Mat src_bgr = cv::imread(INPUT_IMAGE);
	if (src_bgr.empty()) {
	        std::cout << "read error" << std::endl;
	        return -1;
	}
	cv::Mat img_yuv = cv::Mat(IMG_MAX_HEIGHT, IMG_MAX_WIDTH, CV_8UC2, m);
    cv::Mat img_yuv2 = cv::Mat(IMG_MAX_HEIGHT, IMG_MAX_WIDTH, CV_8UC2, n);
    cv::Mat out_img_yuv_8uc2 = img_yuv;
	cv::Mat img_yuv_16uc1 = cv::Mat(IMG_MAX_HEIGHT, IMG_MAX_WIDTH, CV_16UC1);
	cv::Mat out_img_yuv_16uc1 = img_yuv_16uc1; //cv::Mat(IMG_MAX_HEIGHT, IMG_MAX_WIDTH, CV_16UC1);
	cv::Mat out_img_bgr = cv::Mat(IMG_MAX_HEIGHT, IMG_MAX_WIDTH, CV_8UC3);
	xf::cv::Mat <PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE> src_mat(IMG_MAX_HEIGHT, IMG_MAX_WIDTH);
    xf::cv::Mat <PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE> dst_mat(IMG_MAX_HEIGHT, IMG_MAX_WIDTH);


	rgb_to_yuv422_uyvy(src_bgr, img_yuv);
	// cv::cvtColor(img_yuv, out_img_bgr, cv::COLOR_YUV2BGR_UYVY);
	// cv::imwrite("rgb_to_yuv422.bmp", out_img_bgr);
	yuv_8c2_to_16c1(img_yuv, img_yuv_16uc1);
	// yuv_16c1_to_8c2 (out_img_yuv_16uc1, out_img_yuv_8uc2);
	// cv::cvtColor(out_img_yuv_8uc2, out_img_bgr, cv::COLOR_YUV2BGR_UYVY);
	// cv::imwrite("yuv422_16_8_to_rgb.bmp", out_img_bgr);
	src_mat.copyTo(img_yuv_16uc1.data);

	input_stream_t stream_in;
	output_stream_t stream_out;
	xf::cv::xfMat2AXIvideo <DATA_WIDTH, WUSER, WID, WDEST, PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE> (src_mat, stream_in, &tdest);
	camera_correction (stream_in, stream_out);
	xf::cv::AXIvideo2xfMat <DATA_WIDTH, WUSER, WID, WDEST, PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE> (stream_out, dst_mat, &tdest);

	out_img_yuv_16uc1.data = dst_mat.copyFrom();
    yuv_16c1_to_8c2 (out_img_yuv_16uc1, out_img_yuv_8uc2);

    //working with Y only
    // cv::Mat chan[2];
    // cv::split(out_img_yuv_8uc2, chan);
    // cv::cvtColor(out_img_yuv_8uc2, chan[0], cv::COLOR_YUV2GRAY_UYVY);//cv::COLOR_YUV2GRAY_YUY2);
    // cv::cvtColor(out_img_yuv_8uc2, chan[1], cv::COLOR_YUV2GRAY_UYVY);//cv::COLOR_YUV2GRAY_YUY2);
    // cv::cvtColor(out_img_yuv_8uc2, img_yuv2, cv::COLOR_YUV2GRAY_UYVY);//cv::COLOR_YUV2GRAY_YUY2);
    // cv::split(img_yuv2, chan);
    // cv::imwrite("chan[0].bmp", chan[0]);
    // cv::imwrite("chan[1].bmp", chan[1]);

	cv::cvtColor(out_img_yuv_8uc2, out_img_bgr, cv::COLOR_YUV2BGR_UYVY);
    // yuv422_to_rgb_uyvy(out_img_yuv_8uc2, out_img_bgr);
	cv::imwrite(OUTPUT_IMAGE, out_img_bgr);

	out_img_bgr.release();
    out_img_yuv_16uc1.release();
    img_yuv_16uc1.release();
    out_img_yuv_8uc2.release();
	img_yuv.release();
    img_yuv2.release();
	delete [] m;
    delete [] n;

	return 0;
}
