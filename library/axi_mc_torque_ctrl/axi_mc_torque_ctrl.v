// ***************************************************************************
// ***************************************************************************
// Copyright 2013(c) Analog Devices, Inc.
//
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//     - Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     - Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in
//       the documentation and/or other materials provided with the
//       distribution.
//     - Neither the name of Analog Devices, Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//     - The use of this software may or may not infringe the patent rights
//       of one or more patent holders.  This license does not release you
//       from the requirement that you obtain separate licenses from these
//       patent holders to use this software.
//     - Use of the software either in source or binary form, must be run
//       on or directly connected to an Analog Devices Inc. component.
//
// THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
// INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A
// PARTICULAR PURPOSE ARE DISCLAIMED.
//
// IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, INTELLECTUAL PROPERTY
// RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR 
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
// STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF 
// THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// ***************************************************************************
// ***************************************************************************

`timescale 1ns/100ps

module axi_mc_torque_ctrl
#(
    parameter C_S_AXI_MIN_SIZE = 32'hffff,
    parameter C_BASEADDR = 32'hffffffff,
    parameter C_HIGHADDR = 32'h00000000
)
(
    input           ref_clk,       // 100 MHz

// physical interface

    input           fmc_m1_fault_i,
    output          fmc_m1_en_o,
    output          pwm_ah_o,
    output          pwm_al_o,
    output          pwm_bh_o,
    output          pwm_bl_o,
    output          pwm_ch_o,
    output          pwm_cl_o,
    output  [7:0]   gpo_o,

// interconnection with other modules

    output  [1:0]   sensors_o,
    input   [2:0]   position_i,
    input           new_speed_i,
    input   [31:0]  speed_i,
    input   [15:0]  it_i,
    input           i_ready_i,

// dma interface

    output          adc_clk_o,
    output          adc_dwr_o,
    output  [31:0]  adc_ddata_o,
    input           adc_dovf_i,
    input           adc_dunf_i,

// axi interface

    input           s_axi_aclk,
    input           s_axi_aresetn,
    input           s_axi_awvalid,
    input   [31:0]  s_axi_awaddr,
    output          s_axi_awready,
    input           s_axi_wvalid,
    input   [31:0]  s_axi_wdata,
    input   [3:0]   s_axi_wstrb,
    output          s_axi_wready,
    output          s_axi_bvalid,
    output  [1:0]   s_axi_bresp,
    input           s_axi_bready,
    input           s_axi_arvalid,
    input   [31:0]  s_axi_araddr,
    output          s_axi_arready,
    output          s_axi_rvalid,
    output  [1:0]   s_axi_rresp,
    output  [31:0]  s_axi_rdata,
    input           s_axi_rready,

// debug signals

    output          adc_mon_valid,
    output  [31:0]  adc_mon_data
);

//------------------------------------------------------------------------------
//----------- Registers Declarations -------------------------------------------
//------------------------------------------------------------------------------
// internal registers

reg             adc_valid       = 'd0;
reg     [31:0]  adc_data        = 'd0;
reg     [31:0]  up_rdata        = 'd0;
reg             up_ack          = 'd0;
reg     [15:0]  tmr_dv_reg      = 'd0;
reg             datavalid_reg   = 'd0;
reg     [15:0]  tmr_ctrl_reg   = 'd0;
reg             pwm_gen_clk     = 'd0;
reg             ctrl_gen_clk    = 'd0;
reg             one_chan_reg    = 'd0;

//------------------------------------------------------------------------------
//----------- Wires Declarations -----------------------------------------------
//------------------------------------------------------------------------------
// internal clocks & resets

wire            adc_rst;
wire            up_rstn;
wire            up_clk;

// internal signals

wire            up_sel_s;
wire            up_wr_s;
wire    [13:0]  up_addr_s;
wire    [31:0]  up_wdata_s;
wire    [31:0]  up_adc_common_rdata_s;
wire    [31:0]  up_control_rdata_s;
wire    [31:0]  rdata_ref_speed_s;
wire    [31:0]  rdata_actual_speed_s;
wire            up_adc_common_ack_s;
wire            up_control_ack_s;
wire            ack_ref_speed_s;
wire            ack_actual_speed_s;
wire            run_s;
wire            star_delta_s;
wire            oloop_matlab_s;         // 0 - open loop, 1 matlab controlls pwm
wire    [10:0]  pwm_open_s;
wire    [31:0]  pwm_controller_s;
wire    [10:0]  pwm_s;
wire    [31:0]  err_s;
wire    [31:0]  pid_s;
wire    [2:0]   position_s;
wire    [31:0]  ki_s;
wire    [31:0]  kp_s;
wire    [31:0]  ki1_s;
wire    [31:0]  kp1_s;
wire    [31:0]  kd1_s;
wire    [31:0]  reference_speed_s;
wire    [31:0]  speed_rpm_s;            // speed in RPM from the controller

wire            enable_ref_speed_s;
wire            enable_actual_speed_s;

wire    [10:0]  gpo_s;
wire    [31:0]  it_max_s;

//------------------------------------------------------------------------------
//----------- Assign/Always Blocks ---------------------------------------------
//------------------------------------------------------------------------------

// signal name changes

assign up_clk               = s_axi_aclk;
assign up_rstn              = s_axi_aresetn;

assign adc_clk_o            = ref_clk;
assign adc_dwr_o            = adc_valid;
assign adc_ddata_o          = adc_data;

// monitor signals

assign adc_mon_valid    = i_ready_i;
assign adc_mon_data     =  {25'h0 ,fmc_m1_en_o, pwm_ah_o, pwm_al_o, pwm_bh_o, pwm_bl_o, pwm_ch_o, pwm_cl_o};

// multiple instances synchronization

assign pid_s = 32'd0;

assign fmc_m1_en_o  = run_s;
assign pwm_s        = oloop_matlab_s ? pwm_controller_s[10:0] : pwm_open_s ;
assign position_s   = position_i;

// assign gpo

 assign gpo_o[7:4] = gpo_s[10:7];
 assign gpo_o[3:0] = gpo_s[3:0];

// clock generation for controller

always @(posedge ref_clk)
begin
    pwm_gen_clk <= ~pwm_gen_clk; // generate 50 MHz clk

    if(tmr_ctrl_reg == 16'd4)  // generate 10 MHz clk
    begin
        tmr_ctrl_reg <= 16'd0;
        ctrl_gen_clk <= ~ctrl_gen_clk;
    end
    else
    begin
        tmr_ctrl_reg <= tmr_ctrl_reg + 16'd1;
    end
end

// CE generation for controller

always @(posedge ref_clk)
begin
    if(tmr_dv_reg == 16'd999)
    begin
        datavalid_reg   <= 1'b1;
        tmr_dv_reg      <= 16'd0;
    end
    else
    begin
        datavalid_reg   <= 1'b0;
        tmr_dv_reg      <= tmr_dv_reg + 16'd1;
    end
end

// adc channels - dma interface

always @(posedge ref_clk)
begin
    if(datavalid_reg == 1)
    begin
        case({enable_actual_speed_s , enable_ref_speed_s})
            2'b11:
            begin
                adc_data  <= {speed_rpm_s[29:14],reference_speed_s[15:0]};
                adc_valid <= 1'b1;
            end
            2'b01:
            begin
                adc_data <= { adc_data[15:0], reference_speed_s[15:0]};
                one_chan_reg <= ~one_chan_reg;
                if(one_chan_reg == 1'b1)
                begin
                    adc_valid <= 1'b1;
                end
                else
                begin
                    adc_valid <= 1'b0;
                end
            end
            2'b10:
            begin
                adc_data <= { adc_data[15:0], speed_rpm_s[29:14]};
                one_chan_reg <= ~one_chan_reg;
                if(one_chan_reg == 1'b1)
                begin
                    adc_valid <= 1'b1;
                end
                else
                begin
                    adc_valid <= 1'b0;
                end
            end
            2'b00:
            begin
                adc_data <= 32'hdeadbeef;
                adc_valid <= 1'b1;
            end
        endcase
    end
    else
    begin
        adc_data    <= adc_data;
        adc_valid   <= 1'b0;
    end
end

// processor read interface

always @(negedge up_rstn or posedge up_clk) begin
    if(up_rstn == 0) begin
        up_rdata  <= 'd0;
        up_ack    <= 'd0;
    end else begin
        up_rdata  <= up_control_rdata_s | up_adc_common_rdata_s | rdata_ref_speed_s | rdata_actual_speed_s ;
        up_ack    <= up_control_ack_s | up_adc_common_ack_s | ack_ref_speed_s | ack_actual_speed_s;
    end
end

// main (device interface)

motor_driver
#( .PWM_BITS(11))
motor_driver_inst(
    .clk_i(ref_clk),
    .pwm_clk_i(pwm_gen_clk),
    .rst_n_i(up_rstn) ,
    .run_i(run_s),
    .star_delta_i(1'b0),
    //.dir_i(1'b1),
    .position_i(position_s),
    .pwm_duty_i(pwm_s),
    .AH_o(pwm_ah_o),
    .BH_o(pwm_bh_o),
    .CH_o(pwm_ch_o),
    .AL_o(pwm_al_o),
    .BL_o(pwm_bl_o),
    .CL_o(pwm_cl_o));

control_registers control_reg_inst(
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_sel(up_sel_s),
    .up_wr(up_wr_s),
    .up_addr(up_addr_s),
    .up_wdata(up_wdata_s),
    .up_rdata(up_control_rdata_s),
    .up_ack(up_control_ack_s),

//control pins

    .run_o(run_s),
    .break_o(),
    .star_delta_o(star_delta_s),
    .sensors_o(sensors_o),
    .kp_o(kp_s),
    .ki_o(ki_s),
    .kp1_o(kp1_s),
    .ki1_o(ki1_s),
    .kd1_o(kd1_s),
    .gpo_o(gpo_s),
    .reference_speed_o(reference_speed_s),
    .oloop_matlab_o(oloop_matlab_s),
    .err_i(err_s),
    .calibrate_adcs_o(),
    .pwm_open_o( pwm_open_s));

bldc_sim_fpga_cw torque_controller(
    .ce(1'b1),
    .clk(ctrl_gen_clk),
    .clk_x0(ctrl_gen_clk),
    .it({16'h0,it_i}),
    .kd1(kd1_s),
    .ki(ki_s),
    .ki1(ki1_s),
    .kp(kp_s),
    .kp1(kp1_s),
    .motor_speed(speed_i),
    .new_current(i_ready_i),
    .new_speed(new_speed_i),
    .ref_speed(reference_speed_s),
    .reset(!up_rstn),
    .reset_acc(!run_s),
    .err(err_s),
    .it_max(it_max_s),
    .pwm(pwm_controller_s),
    .speed(speed_rpm_s));

up_adc_channel #(.PCORE_ADC_CHID(0)) adc_channel_ref_speed(
    .adc_clk(ref_clk),
    .adc_rst(adc_rst),
    .adc_enable(enable_ref_speed_s),
    .adc_pn_sel(),
    .adc_iqcor_enb(),
    .adc_dcfilt_enb(),
    .adc_dfmt_se(),
    .adc_dfmt_type(),
    .adc_dfmt_enable(),
    .adc_pn_type(),
    .adc_dcfilt_offset(),
    .adc_dcfilt_coeff(),
    .adc_iqcor_coeff_1(),
    .adc_iqcor_coeff_2(),
    .adc_pn_err(1'b0),
    .adc_pn_oos(1'b0),
    .adc_or(1'b0),
    .up_adc_pn_err(1'b0),
    .up_adc_pn_oos(1'b0),
    .up_adc_or(),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_decimation_m(),
    .up_usr_decimation_n(),
    .adc_usr_datatype_be(1'b0),
    .adc_usr_datatype_signed(1'b1),
    .adc_usr_datatype_shift(8'd0),
    .adc_usr_datatype_total_bits(8'd16),
    .adc_usr_datatype_bits(8'd16),
    .adc_usr_decimation_m(16'd1),
    .adc_usr_decimation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_sel(up_sel_s),
    .up_wr(up_wr_s),
    .up_addr(up_addr_s),
    .up_wdata(up_wdata_s),
    .up_rdata(rdata_ref_speed_s),
    .up_ack(ack_ref_speed_s));


up_adc_channel #(.PCORE_ADC_CHID(1)) adc_channel_actual_speed(
    .adc_clk(ref_clk),
    .adc_rst(adc_rst),
    .adc_enable(enable_actual_speed_s),
    .adc_pn_sel(),
    .adc_iqcor_enb(),
    .adc_dcfilt_enb(),
    .adc_dfmt_se(),
    .adc_dfmt_type(),
    .adc_dfmt_enable(),
    .adc_pn_type(),
    .adc_dcfilt_offset(),
    .adc_dcfilt_coeff(),
    .adc_iqcor_coeff_1(),
    .adc_iqcor_coeff_2(),
    .adc_pn_err(1'b0),
    .adc_pn_oos(1'b0),
    .adc_or(1'b0),
    .up_adc_pn_err(),
    .up_adc_pn_oos(),
    .up_adc_or(),
    .up_usr_datatype_be(),
    .up_usr_datatype_signed(),
    .up_usr_datatype_shift(),
    .up_usr_datatype_total_bits(),
    .up_usr_datatype_bits(),
    .up_usr_decimation_m(),
    .up_usr_decimation_n(),
    .adc_usr_datatype_be(1'b0),
    .adc_usr_datatype_signed(1'b1),
    .adc_usr_datatype_shift(8'd0),
    .adc_usr_datatype_total_bits(8'd16),
    .adc_usr_datatype_bits(8'd16),
    .adc_usr_decimation_m(16'd1),
    .adc_usr_decimation_n(16'd1),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_sel(up_sel_s),
    .up_wr(up_wr_s),
    .up_addr(up_addr_s),
    .up_wdata(up_wdata_s),
    .up_rdata(rdata_actual_speed_s),
    .up_ack(ack_actual_speed_s));


// common processor control
up_adc_common i_up_adc_common(
    .mmcm_rst(),
    .adc_clk(ref_clk),
    .adc_rst(adc_rst),
    .adc_r1_mode(),
    .adc_ddr_edgesel(),
    .adc_pin_mode(),
    .adc_status(1'b1),
    .adc_status_pn_err(),
    .adc_status_pn_oos(),
    .adc_status_or(),
    .adc_status_ovf(adc_dovf_i),
    .adc_status_unf(adc_dunf_i),
    .adc_clk_ratio(32'd1),
    .delay_clk(1'b0),
    .delay_rst(),
    .delay_sel(),
    .delay_rwn(),
    .delay_addr(),
    .delay_wdata(),
    .delay_rdata(5'd0),
    .delay_ack_t(1'b0),
    .delay_locked(1'b0),
    .drp_clk(1'd0),
    .drp_rst(),
    .drp_sel(),
    .drp_wr(),
    .drp_addr(),
    .drp_wdata(),
    .drp_rdata(16'd0),
    .drp_ready(1'b0),
    .drp_locked(1'b0),
    .up_usr_chanmax(),
    .adc_usr_chanmax(8'd0),
    .up_rstn(up_rstn),
    .up_clk(up_clk),
    .up_sel(up_sel_s),
    .up_wr(up_wr_s),
    .up_addr(up_addr_s),
    .up_wdata(up_wdata_s),
    .up_rdata(up_adc_common_rdata_s),
    .up_ack(up_adc_common_ack_s));

// up bus interface

up_axi #(
    .PCORE_BASEADDR(C_BASEADDR),
    .PCORE_HIGHADDR(C_HIGHADDR))
i_up_axi(
        .up_rstn(up_rstn),
        .up_clk(up_clk),
        .up_axi_awvalid(s_axi_awvalid),
        .up_axi_awaddr(s_axi_awaddr),
        .up_axi_awready(s_axi_awready),
        .up_axi_wvalid(s_axi_wvalid),
        .up_axi_wdata(s_axi_wdata),
        .up_axi_wstrb(s_axi_wstrb),
        .up_axi_wready(s_axi_wready),
        .up_axi_bvalid(s_axi_bvalid),
        .up_axi_bresp(s_axi_bresp),
        .up_axi_bready(s_axi_bready),
        .up_axi_arvalid(s_axi_arvalid),
        .up_axi_araddr(s_axi_araddr),
        .up_axi_arready(s_axi_arready),
        .up_axi_rvalid(s_axi_rvalid),
        .up_axi_rresp(s_axi_rresp),
        .up_axi_rdata(s_axi_rdata),
        .up_axi_rready(s_axi_rready),
        .up_sel(up_sel_s),
        .up_wr(up_wr_s),
        .up_addr(up_addr_s),
        .up_wdata(up_wdata_s),
        .up_rdata(up_rdata),
        .up_ack(up_ack));

endmodule

// ***************************************************************************
// ***************************************************************************

