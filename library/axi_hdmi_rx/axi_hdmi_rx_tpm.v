// ***************************************************************************
// ***************************************************************************
// Copyright 2011-2015(c) Analog Devices, Inc.
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

module axi_hdmi_rx_tpm (
  hdmi_clk,
  hdmi_sof,
  hdmi_de,
  hdmi_data,

  hdmi_tpm_oos);

  input           hdmi_clk;
  input           hdmi_sof;
  input           hdmi_de;
  input   [15:0]  hdmi_data;
  output          hdmi_tpm_oos;

  wire    [15:0]  hdmi_tpm_lr_data_s;
  wire            hdmi_tpm_lr_mismatch_s;
  wire    [15:0]  hdmi_tpm_fr_data_s;
  wire            hdmi_tpm_fr_mismatch_s;

  reg     [15:0]  hdmi_tpm_data = 'd0;
  reg             hdmi_tpm_lr_mismatch = 'd0;
  reg             hdmi_tpm_fr_mismatch = 'd0;
  reg             hdmi_tpm_oos = 'd0;

  // Limited range
  assign hdmi_tpm_lr_data_s[15:8] = (hdmi_tpm_data[15:8] < 8'h10) ? 8'h10 :
    ((hdmi_tpm_data[15:8] > 8'heb) ? 8'heb : hdmi_tpm_data[15:8]);
  assign hdmi_tpm_lr_data_s[ 7:0] = (hdmi_tpm_data[ 7:0] < 8'h10) ? 8'h10 :
    ((hdmi_tpm_data[ 7:0] > 8'heb) ? 8'heb : hdmi_tpm_data[ 7:0]);
  assign hdmi_tpm_lr_mismatch_s = (hdmi_tpm_lr_data_s == hdmi_data) ? 1'b0 : 1'b1;

  // Full range
  assign hdmi_tpm_fr_data_s[15:8] = (hdmi_tpm_data[15:8] < 8'h01) ? 8'h01 :
    ((hdmi_tpm_data[15:8] > 8'hfe) ? 8'hfe : hdmi_tpm_data[15:8]);
  assign hdmi_tpm_fr_data_s[ 7:0] = (hdmi_tpm_data[ 7:0] < 8'h01) ? 8'h01 :
    ((hdmi_tpm_data[ 7:0] > 8'hfe) ? 8'hfe : hdmi_tpm_data[ 7:0]);
  assign hdmi_tpm_fr_mismatch_s = (hdmi_tpm_fr_data_s == hdmi_data) ? 1'b0 : 1'b1;

  always @(posedge hdmi_clk) begin
    if (hdmi_sof == 1'b1) begin
      hdmi_tpm_data <= 16'd0;
      hdmi_tpm_lr_mismatch <= 1'd0;
      hdmi_tpm_fr_mismatch <= 1'd0;
      hdmi_tpm_oos <= hdmi_tpm_lr_mismatch & hdmi_tpm_fr_mismatch;
    end else if (hdmi_de == 1'b1) begin
      hdmi_tpm_data <= hdmi_tpm_data + 1'b1;
      hdmi_tpm_lr_mismatch <= hdmi_tpm_lr_mismatch | hdmi_tpm_lr_mismatch_s;
      hdmi_tpm_fr_mismatch <= hdmi_tpm_fr_mismatch | hdmi_tpm_fr_mismatch_s;
    end
  end

endmodule
