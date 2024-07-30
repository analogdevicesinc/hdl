#include "imgproc/xf_stereo_pipeline.hpp"
#include "imgproc/xf_cvt_color.hpp"
#include "imgproc/xf_remap.hpp"
#include "common/xf_common.hpp"
#include "common/xf_infra.hpp"
#include "common/xf_utility.hpp"
#include "ap_fixed.h"

#define USE_URAM true
#define WUSER 2
#define WID 1
#define WDEST 4
#define DATA_WIDTH  32 //two pixel per clock of YUV 422
#define DATA_MAP_WIDTH  32
#define PIXEL_PER_CYCLE XF_NPPC2 	//2 pixel per word.
#define PIXEL_TYPE      XF_16UC1		//16-bit unsigned and single channel pixel
#define MAP_PIXEL_TYPE  XF_32FC1
#define IMG_MAX_HEIGHT  1080
#define IMG_MAX_WIDTH   1920
//#define INPUT_IMAGE "/home/coliveir/Documents/camera_correction_modif_k26_8cams/corundum-gmsl/fpga/mqnic/KR260/fpga/hls/yuv_camera_correction_and_map_generator/cam_sample.bmp"
#define OUTPUT_IMAGE "cam_sample_out.bmp"
	/*
	Declaring configurable parameters for data
	*/

typedef ap_axiu<DATA_WIDTH, WUSER, WID, WDEST> input_interface_t;
typedef ap_axiu<DATA_WIDTH, WUSER, WID, WDEST> output_interface_t;
	/*	Unsigned template of AXI Stream Interface. <Type (if integer just data width), WUser, WId, WDest>	*/
typedef hls::stream <input_interface_t> input_stream_t;
typedef hls::stream <input_interface_t> output_stream_t;
	/*	Defining Streaming Data Structure using the template as stream_t	*/

void camera_correction(input_stream_t& stream_in, output_stream_t& stream_out);
	/*	Declaring the function	*/
