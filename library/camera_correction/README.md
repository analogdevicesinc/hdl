Building the Project 
(Only tried on linux machine, ubuntu 22.04)

Pre-build Requirements
1. Vitis HLS (Tested on v2022.2)
	- Install via Xilinx's website.
2. Vitis Vision Library with ADI modification to support parallel pixel and YUV 422 format (UYVY)
	- https://bitbucket.analog.com/users/coliveir/repos/vitis_libraries_adi/
	- Clone it to an accessible directory.
3. OpenCV and OpenCV Contrib (Tested with v4.x)
	- https://github.com/opencv/opencv/tree/4.x
	- https://github.com/opencv/opencv_contrib
	- **THIS IS ALREADY INSTALLED IN** /usr/local/include/opencv2 in ROMLX3 server.
    
	In case it is not available in your computer:
	
	Instalation steps:

	1. Create a "source" directory then clone opencv inside it;
	2. Create a "source_contrib" directory then clone opencv_contrib inside it;
	3. Open 'source/opencv/', then create a 'build' directory and open the build folder;
	4. Export the following environment variable:

		export LIBRARY_PATH=/usr/lib/x86_64-linux-gnu/

	5. While in the build directory, run the following command (remind to update <path to> to your own paths):

		cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_V4L=ON -D OPENCV_EXTRA_MODULES_PATH=<path to>/source_contrib/opencv_contrib/modules -DBUILD_TESTS=OFF -DBUILD_ZLIB=ON -DBUILD_JPEG=ON -DWITH_JPEG=ON -DWITH_PNG=ON -DBUILD_EXAMPLES=OFF -DINSTALL_C_EXAMPLES=OFF -DINSTALL_PYTHON_EXAMPLES=OFF -DWITH_OPENEXR=OFF -DBUILD_OPENEXR=OFF -D CMAKE_CXX_COMPILER=<path to>/Vitis_HLS/2022.2/tps/lnx64/gcc-6.2.0/bin/g++ ..
	6. Run the command: 

		make all -j8
	7. Run the command:

		sudo make install
	8. Export the following environment variables after installation:

		export OPENCV_INCLUDE=/usr/local/include/opencv2

		export OPENCV_LIB=/usr/local/lib

		export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

		export PATH=/usr/local/lib:$PATH
		
	9. /usr/local/include/opencv2 doesn't exist for opencv4.x. Copy the whole folder from /usr/local/include/opencv4/opencv2 to /usr/local/include/

Building projects with OpenCV:
1. If you skipped the pre-build steps, make sure to export the following environment variables:

	export OPENCV_INCLUDE=/usr/local/include/opencv2

    export OPENCV_LIB=/usr/local/lib
    
	export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH
    
	export PATH=/usr/local/lib:$PATH

2. Go to the main git directory and edit the run_hls_standalone.tcl file:
	- edit the path on 'set XF_PROJ_ROOT' to the location of the git folder
	- edit the path on 'set VISION_INC_FLAGS' to "-I/<path to Vitis_Libraries/vision/L1/include> -D__SDSVHLS__ -std=c++0x"
  	- edit the FPGA part depending on the requirements
	- edit some lines in the last portion of the file near "Run Vitis HLS Stages"
		- csim and cosim requires an argument in the -argv field, simply point it to an existing image.
		  **PS:** If the argv is empty error usually occurs. 
3. Open a command prompt 'vitis_hls -f run_hls_Standalone.tcl'.
	- It is possible to cancel the run during csim if it is needed to open the gui before running the HLS Stages.
4. Exit the command prompt with 'exit' and run the Vitis HLS Gui. The project is built.

CSIM:
1. Prepare a .bmp image file that is the same intended size of the module (1920x1080 for now);
2. Go to camera_correction.h and edit the file path of INPUT_IMAGE to the prepared .bmp file;
3. Run the camera correction;
4. Run CSIM and view the output image (usually it is located in <PROJ_NAME>/<SOLUTION_NAME>/csim/build).
5. **Warning:** csim DOES NOT work with parallel make, that is commented out in camera_correction_hls.tcl

CSYNTH:
1. Simply run:

csynth

COSIM:
1. Run COSIM, select dump trace to ALL (if you have disk space) or port (for lesser space). Use default simulator.
  - if error occures regarding an mpfr.h file, it means your GCC compiler is incompatible with vitis_hls'
  - visit <install path>/Xilinx/Vitis_HLS/2022.2/include/mpfr.h
  - edit '# include <gmp.h>' to '# include "gmp.h"'
  - Open camera_correction.h and add the following lines:

    #include "<path to install>/Xilinx/Vitis_HLS/2022.2/include/gmp.h"

    #define __gmp_const const
	
EXPORT RTL:
1. Download and install the y2k22 patch for Xilinx tools 2014.x to 2022.x. Follow their website for instructions. Skip for 2022.1 or version above 2022.2.
2. If error occurs regarding an libpython3.8.so.1.0 file, this may be because it cannot be found
  - make a local copy of Xilinx tools inside /usr/lib and /usr/lib64

    *sudo cp <path to Xilinx installation>/Xilinx/Vivado/2022.2/tps/lnx64/python-3.8.3/lib/libpython3.8.so.1.0 /usr/lib/

    *sudo cp <path to Xilinx installation>/Xilinx/Vivado/2022.2/tps/lnx64/python-3.8.3/lib/libpython3.8.so.1.0 /usr/lib64/

ALGORITHM EXPLANATION

Camera correction requires two functions:
1. InitUndistortRectifyMapInverse;
2. remap.

Currently, not even the OpenCV software library supports YUV 422 for the remap function. The usual approach converts
the image to BGR (OpenCV does not use RGB) and then perform the camera correction, the result is converted back to the original format.

The Vision Library is an OpenCV implementation for Xilinx FPGAs, and only supports a single pixel per cycle (https://xilinx.github.io/Vitis_Libraries/vision/2022.1/api-reference.html?highlight=remap)
and does not support YUV 422. In this implementation, it is possible to choose between two types of memory: BRAM or URAM.

BGR format requires 33% more memory resources than YUV 422. That can be negligible if the XF_WIN_ROWS (buffer size) is a small 
integer. Estimation of the buffer size (XF_WIN_ROWS) is:

	1.	Max of mapy (|val(x,y)-y|) or
	2.	Max of (fabs(mapy[i][j] - i)).

Where:

- i is the row index;
- j is the column index;
- Only positive values from mapy[i][j] must be considered. Negative values means that they are outside the borders of the image;
- mapy contains 'target pixel to be picked from the input image along y-axis (along the rows)'.

This equation shows the maximum distance between the row index of the input image and the row index of the output image. For our case,
the maximum distance is 44.03 (XF_WIN_ROWS), since it is necessary to buffer  XF_WIN_ROWS rows above and XF_WIN_ROWS below the
current input row, it is necessary to buffer at least 89 rows (rounded to the next integer value) for our camera coefficients. 
This number is constant because it relies on the camera coefficients represented by the matrices camera_matrix, dist_coeff, and ir in
the camera_correction.cpp.

Because of the memory limitation of the KR260, we needed to put the implementation into the URAM memory. For the BGR, that means
33 ultraRAMs for a single camera correction, while for YUV 422 it requires 22 ultraRAMs. Considering the board has 64 ultraRAMS, 
YUV 422 implementation is the only one that allows more than one camera correction.