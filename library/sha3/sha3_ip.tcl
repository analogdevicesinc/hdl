source ../../scripts/adi_env.tcl
exec rm -rf logs
exec vitis-run --tcl --mode hls sha3_hls.tcl
set PROJ_TOP "sha3"
set PROJ_NAME "sha3.hls"
set SOLUTION_NAME "sol1"
exec find $ad_hdl_dir/library/$PROJ_TOP/ -type l -delete
exec ln -sf "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/component.xml" "$ad_hdl_dir/library/$PROJ_TOP/component.xml"
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/component.xml" "$ad_hdl_dir/library/$PROJ_TOP/component.xml"
exec ln -sf "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/constraints" "$ad_hdl_dir/library/$PROJ_TOP/constraints"
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/constraints" "$ad_hdl_dir/library/$PROJ_TOP/constraints"
exec ln -sf "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/doc" "$ad_hdl_dir/library/$PROJ_TOP/doc"
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/doc" "$ad_hdl_dir/library/$PROJ_TOP/doc"
exec ln -sf "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/hdl" "$ad_hdl_dir/library/$PROJ_TOP/hdl"
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/hdl" "$ad_hdl_dir/library/$PROJ_TOP/hdl"
exec ln -sf "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/misc" "$ad_hdl_dir/library/$PROJ_TOP/misc"
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/misc" "$ad_hdl_dir/library/$PROJ_TOP/misc"
exec ln -sf "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/xgui" "$ad_hdl_dir/library/$PROJ_TOP/xgui"
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/xgui" "$ad_hdl_dir/library/$PROJ_TOP/xgui"