
set dac_fifo_address_width 10

source $ad_hdl_dir/projects/common/a10gx/a10gx_system_qsys.tcl
source $ad_hdl_dir/projects/common/intel/dacfifo_qsys.tcl
source ../common/adrv9371x_qsys.tcl

set_interconnect_requirement {mm_interconnect_0|router_035.src/rsp_demux_025.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_030.src/rsp_demux_020.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_052.src/rsp_demux_042.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_060.src/rsp_demux_050.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_054.src/rsp_demux_044.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_036.src/rsp_demux_026.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_053.src/rsp_demux_043.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_059.src/rsp_demux_049.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_032.src/rsp_demux_022.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_057.src/rsp_demux_047.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_056.src/rsp_demux_046.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_055.src/rsp_demux_045.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_038.src/rsp_demux_028.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_034.src/rsp_demux_024.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_051.src/rsp_demux_041.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_037.src/rsp_demux_027.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_033.src/rsp_demux_023.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_031.src/rsp_demux_021.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_050.src/rsp_demux_040.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_046.src/rsp_demux_036.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_049.src/rsp_demux_039.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_045.src/rsp_demux_035.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_048.src/rsp_demux_038.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_044.src/rsp_demux_034.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_047.src/rsp_demux_037.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_043.src/rsp_demux_033.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_058.src/rsp_demux_048.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_040.src/rsp_demux_030.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_039.src/rsp_demux_029.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_042.src/rsp_demux_032.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_041.src/rsp_demux_031.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_012.src/rsp_demux_002.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_013.src/rsp_demux_003.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_018.src/rsp_demux_008.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_019.src/rsp_demux_009.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_014.src/rsp_demux_004.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_015.src/rsp_demux_005.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_020.src/rsp_demux_010.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_021.src/rsp_demux_011.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_010.src/rsp_demux.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_011.src/rsp_demux_001.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_016.src/rsp_demux_006.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_017.src/rsp_demux_007.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_028.src/rsp_demux_018.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_029.src/rsp_demux_019.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_024.src/rsp_demux_014.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_025.src/rsp_demux_015.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_026.src/rsp_demux_016.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_027.src/rsp_demux_017.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_022.src/rsp_demux_012.sink} {qsys_mm.postTransform.pipelineCount} {1}
set_interconnect_requirement {mm_interconnect_0|router_023.src/rsp_demux_013.sink} {qsys_mm.postTransform.pipelineCount} {1}

