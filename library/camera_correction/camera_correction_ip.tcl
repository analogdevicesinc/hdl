source ../../scripts/adi_env.tcl
set ::env(OPENCV_INCLUDE) "/usr/local/include/opencv2"
set ::env(OPENCV_LIB) "/usr/local/lib"
set ::env(LD_LIBRARY_PATH) "/usr/local/lib:$::env(LD_LIBRARY_PATH)"
set ::env(PATH) "/usr/local/lib:$::env(PATH)"
exec vitis_hls -f camera_correction_hls.tcl
exec ln -s "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/component.xml" component.xml
exec touch -r "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/component.xml" component.xml
exec ln -s "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/constraints" constraints
exec touch -r "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/constraints" constraints
exec ln -s "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/doc" doc
exec touch -r "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/doc" doc
exec ln -s "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/hdl" hdl
exec touch -r "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/hdl" hdl
exec ln -s "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/misc" misc
exec touch -r "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/misc" misc
exec ln -s "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/xgui" xgui
exec touch -r "$ad_hdl_dir/library/camera_correction/gmsl_camera_correction.hls/sol1/impl/ip/xgui" xgui