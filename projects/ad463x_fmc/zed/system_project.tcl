
source ../../scripts/adi_env.tcl
source $ad_hdl_dir/projects/scripts/adi_project_xilinx.tcl
source $ad_hdl_dir/projects/scripts/adi_board.tcl

## In function of the required interface mode, select the number of SDI lines.
#  (e.g. "set num_of_sdi 2")
#  The valid values are:
#
#    1 - Interleaved mode
#    2 - 1 lane per channel
#    4 - 2 lanes per channel
#    8 - 4 lanes per channel
#

set num_of_sdi 2

adi_project ad463x_fmc_zed 0 [list \
  NUM_OF_SDI $num_of_sdi \
]

adi_project_files ad463x_fmc_zed [list \
  "$ad_hdl_dir/library/xilinx/common/ad_iobuf.v" \
  "$ad_hdl_dir/projects/common/zed/zed_system_constr.xdc" \
  "system_constr.xdc" \
  "system_top.v" \
]

switch $num_of_sdi {
  1 {
    adi_project_files ad463x_fmc_zed [list \
      "system_constr_1sdi.xdc"
    ]
  }
  2 {
    adi_project_files ad463x_fmc_zed [list \
      "system_constr_2sdi.xdc"
    ]
  }
  4 {
    adi_project_files ad463x_fmc_zed [list \
      "system_constr_4sdi.xdc"
    ]
  }
  8 {
    adi_project_files ad463x_fmc_zed [list \
      "system_constr_8sdi.xdc"
    ]
  }
  default {
    adi_project_files ad463x_fmc_zed [list \
      "system_constr_2sdi.xdc"
    ]
  }
}

adi_project_run ad463x_fmc_zed

