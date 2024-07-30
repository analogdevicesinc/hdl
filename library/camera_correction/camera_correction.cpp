#include "camera_correction.h"

void camera_correction	(input_stream_t& stream_in, output_stream_t& stream_out){
	/*	The main function, parameter consists of AXI Stream values going in/out	*/

	#pragma HLS INTERFACE axis port = stream_in
	#pragma HLS INTERFACE axis port = stream_out
	#pragma HLS INTERFACE ap_ctrl_none port = return
		/*	ap_ctrl_none means no block level I/O protocol
		Note: Using the ap_ctrl_none mode might prevent the design from being verified using C/RTL co-simulation.	*/

	//---Template Matrix Containers for each process that will happen---
	xf::cv:: Mat <PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE, 10> img_input  (IMG_MAX_HEIGHT, IMG_MAX_WIDTH);
	xf::cv:: Mat <PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE, 10> img_output (IMG_MAX_HEIGHT, IMG_MAX_WIDTH);

	int rows = IMG_MAX_HEIGHT;
	int cols = IMG_MAX_WIDTH;
	int tdest;

	xf::cv:: Mat <MAP_PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE, 10> map_x;
	xf::cv:: Mat <MAP_PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE, 10> map_y;
	map_x.rows = rows;  map_x.cols = cols;
	map_y.rows = rows;  map_y.cols = cols;

		/*	Setup output Mat objects for the mapping of x and y values of InitUndistortRectifyMapInverse	*/

	//-------------------------------------
	//		HLS Proper Dataflow
	//-------------------------------------
	#pragma HLS DATAFLOW
	
		//---InitUndistortRectifyMapInverse parameters---
	ap_fixed<32, 12> camera_matrix[9] = {2.0275377339070669e+03, 0., 9.5950000000000000e+02,
						    0., 2.0275377339070669e+03, 5.3950000000000000e+02,
						    0., 0., 1.};
		/*	The input matrix representing the camera in the old coordinate system	*/
	ap_fixed<32, 12> dist_coeff[5] = {-4.2891185432986179e-01, -4.4634579643931555e-02, 0., 0., 1.0981159168852910e+00};
		/*	Input distortion coefficients (k1,k2,p1,p2,k3)	*/

	ap_fixed<32, 12> ir[9] = {0.00055395990039000345819, 0., -0.53124660253524777503,
					 0., 0.00055418505099354853374, -0.29870566725730897924,
					 0., 0., 1.};
	/*	Input transformation matrix = Invert(newCameraMatrix*R), where newCameraMatrix = camera in the new coordinate system and R = rotation matrix	*/

	/*	Optimizes task parallelism. Without this, HLS will still try to make code run parallel like but not efficient	*/

	xf::cv:: AXIvideo2xfMat <DATA_WIDTH, WUSER, WID, WDEST, PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE> (stream_in, img_input, &tdest);
	
	//---Undistortion Process of Images---
	xf::cv:: InitUndistortRectifyMapInverse <9, 5, MAP_PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE> (camera_matrix, dist_coeff, ir, map_x, map_y, 9, 5);
		/*	The process to getting the remapping values using the known camera correction parameters	*/
	xf::cv:: remap <90, XF_INTERPOLATION_BILINEAR, PIXEL_TYPE, MAP_PIXEL_TYPE, PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE, USE_URAM>
			(img_input, img_output, map_x, map_y);
		/*	Remap function process input image via 2 inputs of map for x and y provided by InitUndistortRectifyMapInverse	*/

	//xf::cv:: uyvy2rgb <PIXEL_TYPE, RGB_888_PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE>(img_output, img_output_rgb);
		/* Conversion from YUV 422 to RGB 888*/

	xf::cv:: xfMat2AXIvideo <DATA_WIDTH, WUSER, WID, WDEST, PIXEL_TYPE, IMG_MAX_HEIGHT, IMG_MAX_WIDTH, PIXEL_PER_CYCLE> (img_output, stream_out, &tdest);
}