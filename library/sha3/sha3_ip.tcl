source ../../scripts/adi_env.tcl
exec vitis-run --tcl --mode hls sha3_hls.tcl
set PROJ_TOP "sha3"
set PROJ_NAME "sha3.hls"
set SOLUTION_NAME "sol1"
exec ln -s "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/component.xml" component.xml
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/component.xml" component.xml
exec ln -s "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/constraints" constraints
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/constraints" constraints
exec ln -s "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/doc" doc
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/doc" doc
exec ln -s "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/hdl" hdl
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/hdl" hdl
exec ln -s "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/misc" misc
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/misc" misc
exec ln -s "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/xgui" xgui
exec touch -r "$ad_hdl_dir/library/$PROJ_TOP/$PROJ_NAME/$SOLUTION_NAME/impl/ip/xgui" xgui