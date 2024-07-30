source ../../scripts/adi_env.tcl
# ------------------------------------------------------------------------------
# Vitis Vision and OpenCV Library Path Information
# ------------------------------------------------------------------------------
set XF_PROJ_ROOT "$ad_hdl_dir/library/camera_correction"
set OPENCV_INCLUDE "/usr/local/include/opencv2"
set OPENCV_LIB "/usr/local/lib"
# ------------------------------------------------------------------------------
# Vitis HLS Project Information
# ------------------------------------------------------------------------------
set PROJ_DIR "$XF_PROJ_ROOT"
set SOURCE_DIR "$PROJ_DIR"
set PROJ_NAME "gmsl_camera_correction.hls"
set PROJ_TOP "camera_correction"
set SOLUTION_NAME "sol1"
set SOLUTION_PART "xck26-sfvc784-2LVI-i"
set SOLUTION_CLKP 3.333

# ------------------------------------------------------------------------------
# OpenCV C Simulation / CoSimulation Library References
#------------------------------------------------------------------------------
set VISION_INC_FLAGS "-I$ad_hdl_dir/../vitis_libraries_adi/vision/L1/include -D__SDSVHLS__ -std=c++0x"
set OPENCV_INC_FLAGS "-I$OPENCV_INCLUDE"
set OPENCV_LIB_FLAGS "-L $OPENCV_LIB"

# Windows OpenCV Include Style:
#set OPENCV_LIB_REF   "-lopencv_imgcodecs3411 -lopencv_imgproc3411 -lopencv_core3411 -lopencv_highgui3411 -lopencv_flann3411 -lopencv_features2d3411"

# Linux OpenCV Include Style:
set OPENCV_LIB_REF "-lopencv_imgcodecs -lopencv_imgproc -lopencv_core -lopencv_highgui -lopencv_flann -lopencv_features2d"

# ------------------------------------------------------------------------------
# Create Project
# ------------------------------------------------------------------------------
open_project -reset $PROJ_NAME

# ------------------------------------------------------------------------------
# Add C++ source and Testbench files with Vision and OpenCV includes
# ------------------------------------------------------------------------------
add_files "${PROJ_DIR}/camera_correction.cpp" -cflags "${VISION_INC_FLAGS} -I${PROJ_DIR}/build" -csimflags "${VISION_INC_FLAGS} -I${PROJ_DIR}/build"
add_files "${PROJ_DIR}/camera_correction.h" -cflags "${VISION_INC_FLAGS} -I${PROJ_DIR}/build" -csimflags "${VISION_INC_FLAGS} -I${PROJ_DIR}/build"
add_files -tb "${PROJ_DIR}/camera_correction_tb.cpp" -cflags "${OPENCV_INC_FLAGS} ${VISION_INC_FLAGS} -I${PROJ_DIR}/build" -csimflags "${OPENCV_INC_FLAGS} ${VISION_INC_FLAGS} -I${PROJ_DIR}/build"

# ------------------------------------------------------------------------------
# Create Project and Solution
# ------------------------------------------------------------------------------
set_top $PROJ_TOP
open_solution -reset $SOLUTION_NAME
set_part $SOLUTION_PART
config_schedule -effort high
config_compile -name_max_length 64
create_clock -period $SOLUTION_CLKP -name usr_clk_300

# ------------------------------------------------------------------------------
# Run Vitis HLS Stages
# Note: CSim and CoSim require datafiles to be included
# ------------------------------------------------------------------------------
#csim_design -ldflags "-L ${OPENCV_LIB} ${OPENCV_LIB_REF}" -argv "$XF_PROJ_ROOT/cam_sample.bmp"
csynth_design
#cosim_design -ldflags "-L ${OPENCV_LIB} ${OPENCV_LIB_REF}" -argv "$XF_PROJ_ROOT/cam_sample.bmp"
export_design -flow impl -rtl verilog
exit
