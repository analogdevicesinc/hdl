///////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2020 Analog Devices, Inc.  All Rights Reserved.
// This software is proprietary to Analog Devices, Inc. and its licensors.
//////////////////////////////////////////////////////////////////////////////////
// Company:     Analog Devices, Inc.
// Engineer:    MKH
// Create Date: 11/02/2020
//////////////////////////////////////////////////////////////////////////////////
module sample_assembly (
   input         clk,
   input  [7:0]  frame,
   input  [7:0]  data_in,
   input  [1:0]  resolution,
   output        data_en,
   output [15:0] data_out
   );

   //==========================================================================
   // Signal declarations
   //==========================================================================
   reg  [7:0]  data_in_reg;
   reg  [7:0]  frame_in_reg;
   reg  [6:0]  carry_reg;
   reg  [15:0] data_int_reg;
   reg         data_int_rdy;
   reg  [15:0] data_out_reg;
   reg  [15:0] sample14_reg;
   reg  [15:0] sample12_reg;
   reg  [15:0] sample8_reg;

   //==========================================================================
   // Register input data
   //==========================================================================
   always @(posedge clk)
      begin
         frame_in_reg <= frame;
         data_in_reg  <= data_in;
      end

   //==========================================================================
   // Process data for each configuration
   //==========================================================================
   always @(posedge clk) begin
      if(resolution == 2'b11) begin  // 14-bits
         case(frame_in_reg)
            8'b01111111: // 0
               begin
                  data_int_reg[15] <= data_in_reg[0]; //D0
                  data_int_reg[14] <= data_in_reg[1];
                  data_int_reg[13] <= data_in_reg[2];
                  data_int_reg[12] <= data_in_reg[3];
                  data_int_reg[11] <= data_in_reg[4];
                  data_int_reg[10] <= data_in_reg[5];
                  data_int_reg[9]  <= data_in_reg[6];
                  data_int_reg[8]  <= data_in_reg[7]; //D7
                  data_int_rdy     <= 0;
               end
            8'b00111111: // 1
               begin
                  data_int_reg[15] <= carry_reg[0];   //D0 from carry
                  data_int_reg[14] <= data_in_reg[0]; //D1
                  data_int_reg[13] <= data_in_reg[1];
                  data_int_reg[12] <= data_in_reg[2];
                  data_int_reg[11] <= data_in_reg[3];
                  data_int_reg[10] <= data_in_reg[4];
                  data_int_reg[9]  <= data_in_reg[5];
                  data_int_reg[8]  <= data_in_reg[6];
                  data_int_reg[7]  <= data_in_reg[7]; //D8
                  data_int_rdy     <= 0;
               end
            8'b00011111: // 2
               begin
                  data_int_reg[15] <= carry_reg[1];   //D0 from carry
                  data_int_reg[14] <= carry_reg[0];   //D1 from carry
                  data_int_reg[13] <= data_in_reg[0]; //D2
                  data_int_reg[12] <= data_in_reg[1];
                  data_int_reg[11] <= data_in_reg[2];
                  data_int_reg[10] <= data_in_reg[3];
                  data_int_reg[9]  <= data_in_reg[4];
                  data_int_reg[8]  <= data_in_reg[5];
                  data_int_reg[7]  <= data_in_reg[6];
                  data_int_reg[6]  <= data_in_reg[7]; //D9
                  data_int_rdy     <= 0;
               end
            8'b00001111: // 3
               begin
                  data_int_reg[15] <= carry_reg[2];   //D0 from carry
                  data_int_reg[14] <= carry_reg[1];
                  data_int_reg[13] <= carry_reg[0];   //D2 from carry
                  data_int_reg[12] <= data_in_reg[0]; //D3
                  data_int_reg[11] <= data_in_reg[1];
                  data_int_reg[10] <= data_in_reg[2];
                  data_int_reg[9]  <= data_in_reg[3];
                  data_int_reg[8]  <= data_in_reg[4];
                  data_int_reg[7]  <= data_in_reg[5];
                  data_int_reg[6]  <= data_in_reg[6];
                  data_int_reg[5]  <= data_in_reg[7]; //D10
                  data_int_rdy     <= 0;
               end
            8'b00000111: // 4
               begin
                  data_int_reg[15] <= carry_reg[3];   //D0 from carry
                  data_int_reg[14] <= carry_reg[2];
                  data_int_reg[13] <= carry_reg[1];
                  data_int_reg[12] <= carry_reg[0];   //D3 from carry
                  data_int_reg[11] <= data_in_reg[0]; //D4
                  data_int_reg[10] <= data_in_reg[1];
                  data_int_reg[9]  <= data_in_reg[2];
                  data_int_reg[8]  <= data_in_reg[3];
                  data_int_reg[7]  <= data_in_reg[4];
                  data_int_reg[6]  <= data_in_reg[5];
                  data_int_reg[5]  <= data_in_reg[6];
                  data_int_reg[4]  <= data_in_reg[7]; //D11
                  data_int_rdy     <= 0;
               end
            8'b00000011: // 5
               begin
                  data_int_reg[15] <= carry_reg[4];   //D0 from carry
                  data_int_reg[14] <= carry_reg[3];
                  data_int_reg[13] <= carry_reg[2];
                  data_int_reg[12] <= carry_reg[1];
                  data_int_reg[11] <= carry_reg[0];   //D4 from carry
                  data_int_reg[10] <= data_in_reg[0]; //D5
                  data_int_reg[9]  <= data_in_reg[1];
                  data_int_reg[8]  <= data_in_reg[2];
                  data_int_reg[7]  <= data_in_reg[3];
                  data_int_reg[6]  <= data_in_reg[4];
                  data_int_reg[5]  <= data_in_reg[5];
                  data_int_reg[4]  <= data_in_reg[6];
                  data_int_reg[3]  <= data_in_reg[7]; //D12
                  data_int_rdy     <= 0;
               end
            8'b00000001: // 6
               begin
                  data_int_reg[15] <= carry_reg[5];   //D0 from carry
                  data_int_reg[14] <= carry_reg[4];
                  data_int_reg[13] <= carry_reg[3];
                  data_int_reg[12] <= carry_reg[2];
                  data_int_reg[11] <= carry_reg[1];
                  data_int_reg[10] <= carry_reg[0];   //D5 from carry
                  data_int_reg[9]  <= data_in_reg[0]; //D6
                  data_int_reg[8]  <= data_in_reg[1];
                  data_int_reg[7]  <= data_in_reg[2];
                  data_int_reg[6]  <= data_in_reg[3];
                  data_int_reg[5]  <= data_in_reg[4];
                  data_int_reg[4]  <= data_in_reg[5];
                  data_int_reg[3]  <= data_in_reg[6];
                  data_int_reg[2]  <= data_in_reg[7]; //D13
                  data_int_rdy     <= 1;
               end
            8'b10000000: // 7
               begin
                  data_int_reg[15] <= carry_reg[6];   //D0 from carry
                  data_int_reg[14] <= carry_reg[5];
                  data_int_reg[13] <= carry_reg[4];
                  data_int_reg[12] <= carry_reg[3];
                  data_int_reg[11] <= carry_reg[2];
                  data_int_reg[10] <= carry_reg[1];
                  data_int_reg[9]  <= carry_reg[0];   //D6 from carry
                  data_int_reg[8]  <= data_in_reg[0]; //D7
                  data_int_reg[7]  <= data_in_reg[1];
                  data_int_reg[6]  <= data_in_reg[2];
                  data_int_reg[5]  <= data_in_reg[3];
                  data_int_reg[4]  <= data_in_reg[4];
                  data_int_reg[3]  <= data_in_reg[5];
                  data_int_reg[2]  <= data_in_reg[6]; //D13
                  carry_reg[0]     <= data_in_reg[7]; //D0 to carry
                  data_int_rdy     <= 1;
               end
            8'b11000000: // 8
               begin
                  data_int_reg[7]  <= data_in_reg[0]; //D8
                  data_int_reg[6]  <= data_in_reg[1];
                  data_int_reg[5]  <= data_in_reg[2];
                  data_int_reg[4]  <= data_in_reg[3];
                  data_int_reg[3]  <= data_in_reg[4];
                  data_int_reg[2]  <= data_in_reg[5]; //D13
                  carry_reg[1]     <= data_in_reg[6]; //D0 to carry
                  carry_reg[0]     <= data_in_reg[7]; //D1 to carry
                  data_int_rdy     <= 1;
               end
            8'b11100000: // 9
               begin
                  data_int_reg[6]  <= data_in_reg[0]; //D9
                  data_int_reg[5]  <= data_in_reg[1];
                  data_int_reg[4]  <= data_in_reg[2];
                  data_int_reg[3]  <= data_in_reg[3];
                  data_int_reg[2]  <= data_in_reg[4]; //D13
                  carry_reg[2]     <= data_in_reg[5]; //D0 to carry
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D2 to carry
                  data_int_rdy     <= 1;
               end
            8'b11110000: // 10
               begin
                  data_int_reg[5]  <= data_in_reg[0]; //D10
                  data_int_reg[4]  <= data_in_reg[1];
                  data_int_reg[3]  <= data_in_reg[2];
                  data_int_reg[2]  <= data_in_reg[3]; //D13
                  carry_reg[3]     <= data_in_reg[4]; //D0 to carry
                  carry_reg[2]     <= data_in_reg[5];
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D3 to carry
                  data_int_rdy     <= 1;
               end
            8'b11111000: // 11
               begin
                  data_int_reg[4]  <= data_in_reg[0]; //D11
                  data_int_reg[3]  <= data_in_reg[1];
                  data_int_reg[2]  <= data_in_reg[2]; //D13
                  carry_reg[4]     <= data_in_reg[3]; //D0 to carry
                  carry_reg[3]     <= data_in_reg[4];
                  carry_reg[2]     <= data_in_reg[5];
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D4 to carry
                  data_int_rdy     <= 1;
               end
            8'b11111100: // 12
               begin
                  data_int_reg[3]  <= data_in_reg[0]; //D12
                  data_int_reg[2]  <= data_in_reg[1]; //D13
                  carry_reg[5]     <= data_in_reg[2]; //D0 to carry
                  carry_reg[4]     <= data_in_reg[3];
                  carry_reg[3]     <= data_in_reg[4];
                  carry_reg[2]     <= data_in_reg[5];
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D5 to carry
                  data_int_rdy     <= 1;
               end
            8'b11111110: // 13
               begin
                  data_int_reg[2]  <= data_in_reg[0]; //D13
                  carry_reg[6]     <= data_in_reg[1]; //D0 to carry
                  carry_reg[5]     <= data_in_reg[2];
                  carry_reg[4]     <= data_in_reg[3];
                  carry_reg[3]     <= data_in_reg[4];
                  carry_reg[2]     <= data_in_reg[5];
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D6 to carry
                  data_int_rdy     <= 1;
               end
            default:
                  data_int_rdy     <= 0;
         endcase
         data_int_reg[1] <= 0;
         data_int_reg[0] <= 0;
      end else if(resolution == 2'b10) begin  // 12-bits
         case(frame_in_reg)
            8'b00111111: // 0
               begin
                  data_int_reg[15] <=  data_in_reg[0]; //D0
                  data_int_reg[14] <=  data_in_reg[1];
                  data_int_reg[13] <=  data_in_reg[2];
                  data_int_reg[12] <=  data_in_reg[3];
                  data_int_reg[11] <=  data_in_reg[4];
                  data_int_reg[10] <=  data_in_reg[5];
                  data_int_reg[9]  <=  data_in_reg[6];
                  data_int_reg[8]  <=  data_in_reg[7]; //D7
                  data_int_rdy     <=  0;
               end
            8'b00011111: // 1
               begin
                  data_int_reg[15] <=  carry_reg[0];   //D0 from carry
                  data_int_reg[14] <=  data_in_reg[0]; //D1
                  data_int_reg[13] <=  data_in_reg[1];
                  data_int_reg[12] <=  data_in_reg[2];
                  data_int_reg[11] <=  data_in_reg[3];
                  data_int_reg[10] <=  data_in_reg[4];
                  data_int_reg[9]  <=  data_in_reg[5];
                  data_int_reg[8]  <=  data_in_reg[6];
                  data_int_reg[7]  <=  data_in_reg[7]; //D8
                  data_int_rdy     <=  0;
               end
            8'b00001111: // 2
               begin
                  data_int_reg[15] <=  carry_reg[1];   //D0 from carry
                  data_int_reg[14] <=  carry_reg[0];   //D1 from carry
                  data_int_reg[13] <=  data_in_reg[0]; //D2
                  data_int_reg[12] <=  data_in_reg[1];
                  data_int_reg[11] <=  data_in_reg[2];
                  data_int_reg[10] <=  data_in_reg[3];
                  data_int_reg[9]  <=  data_in_reg[4];
                  data_int_reg[8]  <=  data_in_reg[5];
                  data_int_reg[7]  <=  data_in_reg[6];
                  data_int_reg[6]  <=  data_in_reg[7]; //D9
                  data_int_rdy     <=  0;
               end
            8'b00000111: // 3
               begin
                  data_int_reg[15] <=  carry_reg[2];    //D0 from carry
                  data_int_reg[14] <=  carry_reg[1];
                  data_int_reg[13] <=  carry_reg[0];   //D2 from carry
                  data_int_reg[12] <=  data_in_reg[0]; //D3
                  data_int_reg[11] <=  data_in_reg[1];
                  data_int_reg[10] <=  data_in_reg[2];
                  data_int_reg[9]  <=  data_in_reg[3];
                  data_int_reg[8]  <=  data_in_reg[4];
                  data_int_reg[7]  <=  data_in_reg[5];
                  data_int_reg[6]  <=  data_in_reg[6];
                  data_int_reg[5]  <=  data_in_reg[7]; //D10
                  data_int_rdy     <=  0;
               end
            8'b00000011: // 4
               begin
                  data_int_reg[15] <=  carry_reg[3];   //D0 from carry
                  data_int_reg[14] <=  carry_reg[2];
                  data_int_reg[13] <=  carry_reg[1];
                  data_int_reg[12] <=  carry_reg[0];   //D3 from carry
                  data_int_reg[11] <=  data_in_reg[0]; //D4
                  data_int_reg[10] <=  data_in_reg[1];
                  data_int_reg[9]  <=  data_in_reg[2];
                  data_int_reg[8]  <=  data_in_reg[3];
                  data_int_reg[7]  <=  data_in_reg[4];
                  data_int_reg[6]  <=  data_in_reg[5];
                  data_int_reg[5]  <=  data_in_reg[6];
                  data_int_reg[4]  <=  data_in_reg[7]; //D11
                  data_int_rdy     <=  1;
               end
            8'b10000001: // 5
               begin
                  data_int_reg[15] <=  carry_reg[4];   //D0 from carry
                  data_int_reg[14] <=  carry_reg[3];
                  data_int_reg[13] <=  carry_reg[2];
                  data_int_reg[12] <=  carry_reg[1];
                  data_int_reg[11] <=  carry_reg[0];   //D4 from carry
                  data_int_reg[10] <=  data_in_reg[0]; //D5
                  data_int_reg[9]  <=  data_in_reg[1];
                  data_int_reg[8]  <=  data_in_reg[2];
                  data_int_reg[7]  <=  data_in_reg[3];
                  data_int_reg[6]  <=  data_in_reg[4];
                  data_int_reg[5]  <=  data_in_reg[5];
                  data_int_reg[4]  <=  data_in_reg[6]; //D11
                  carry_reg[0]     <=  data_in_reg[7]; //D0 to carry
                  data_int_rdy     <=  1;
               end
            8'b11000000: // 6
               begin
                  data_int_reg[15] <=  carry_reg[5];   //D0 from carry
                  data_int_reg[14] <=  carry_reg[4];
                  data_int_reg[13] <=  carry_reg[3];
                  data_int_reg[12] <=  carry_reg[2];
                  data_int_reg[11] <=  carry_reg[1];
                  data_int_reg[10] <=  carry_reg[0];   //D5 from carry
                  data_int_reg[9]  <=  data_in_reg[0]; //D6
                  data_int_reg[8]  <=  data_in_reg[1];
                  data_int_reg[7]  <=  data_in_reg[2];
                  data_int_reg[6]  <=  data_in_reg[3];
                  data_int_reg[5]  <=  data_in_reg[4];
                  data_int_reg[4]  <=  data_in_reg[5]; //D11
                  carry_reg[1]     <=  data_in_reg[6]; //D0 to carry
                  carry_reg[0]     <=  data_in_reg[7]; //D1 to carry
                  data_int_rdy     <=  1;
               end
            8'b11100000: // 7
               begin
                  data_int_reg[15] <=  carry_reg[6];   //D0 from carry
                  data_int_reg[14] <=  carry_reg[5];
                  data_int_reg[13] <=  carry_reg[4];
                  data_int_reg[12] <=  carry_reg[3];
                  data_int_reg[11] <=  carry_reg[2];
                  data_int_reg[10] <=  carry_reg[1];
                  data_int_reg[9]  <=  carry_reg[0];   //D6 from carry
                  data_int_reg[8]  <=  data_in_reg[0]; //D7
                  data_int_reg[7]  <=  data_in_reg[1];
                  data_int_reg[6]  <=  data_in_reg[2];
                  data_int_reg[5]  <=  data_in_reg[3];
                  data_int_reg[4]  <=  data_in_reg[4]; //D11
                  carry_reg[2]     <=  data_in_reg[5]; //D0 to carry
                  carry_reg[1]     <=  data_in_reg[6];
                  carry_reg[0]     <=  data_in_reg[7]; //D2 to carry
                  data_int_rdy     <=  1;
               end
            8'b11110000: // 8
               begin
                  data_int_reg[7]  <=  data_in_reg[0]; //D8
                  data_int_reg[6]  <=  data_in_reg[1];
                  data_int_reg[5]  <=  data_in_reg[2];
                  data_int_reg[4]  <=  data_in_reg[3]; //D11
                  carry_reg[3]     <=  data_in_reg[4]; //D0 to carry
                  carry_reg[2]     <=  data_in_reg[5];
                  carry_reg[1]     <=  data_in_reg[6];
                  carry_reg[0]     <=  data_in_reg[7]; //D3 to carry
                  data_int_rdy     <=  1;
               end
            8'b11111000: // 9
               begin
                  data_int_reg[6]  <=  data_in_reg[0]; //D9
                  data_int_reg[5]  <=  data_in_reg[1];
                  data_int_reg[4]  <=  data_in_reg[2]; //D11
                  carry_reg[4]     <=  data_in_reg[3]; //D0 to carry
                  carry_reg[3]     <=  data_in_reg[4];
                  carry_reg[2]     <=  data_in_reg[5];
                  carry_reg[1]     <=  data_in_reg[6];
                  carry_reg[0]     <=  data_in_reg[7]; //D4 to carry
                  data_int_rdy     <=  1;
               end
            8'b11111100: // 10
               begin
                  data_int_reg[5]  <=  data_in_reg[0]; //D10
                  data_int_reg[4]  <=  data_in_reg[1]; //D11
                  carry_reg[5]     <=  data_in_reg[2]; //D0 to carry
                  carry_reg[4]     <=  data_in_reg[3];
                  carry_reg[3]     <=  data_in_reg[4];
                  carry_reg[2]     <=  data_in_reg[5];
                  carry_reg[1]     <=  data_in_reg[6];
                  carry_reg[0]     <=  data_in_reg[7]; //D5 to carry
                  data_int_rdy     <=  1;
               end
            8'b01111110: // 11
               begin
                  data_int_reg[4]  <=  data_in_reg[0];//D11
                  carry_reg[6]     <=  data_in_reg[1];//D0 to carry
                  carry_reg[5]     <=  data_in_reg[2];
                  carry_reg[4]     <=  data_in_reg[3];
                  carry_reg[3]     <=  data_in_reg[4];
                  carry_reg[2]     <=  data_in_reg[5];
                  carry_reg[1]     <=  data_in_reg[6];
                  carry_reg[0]     <=  data_in_reg[7];//D6 to carry
                  data_int_rdy     <=  1;
               end
            default:
                  data_int_rdy     <= 0;
         endcase
         data_int_reg[3] <= 0;
         data_int_reg[2] <= 0;
         data_int_reg[1] <= 0;
         data_int_reg[0] <= 0;
      end else if(resolution == 2'b00) begin  // 8-bits
         case(frame_in_reg)
            8'b00001111: // 0
               begin
                  data_int_reg[15] <= data_in_reg[0]; //D0
                  data_int_reg[14] <= data_in_reg[1];
                  data_int_reg[13] <= data_in_reg[2];
                  data_int_reg[12] <= data_in_reg[3];
                  data_int_reg[11] <= data_in_reg[4];
                  data_int_reg[10] <= data_in_reg[5];
                  data_int_reg[9]  <= data_in_reg[6];
                  data_int_reg[8]  <= data_in_reg[7]; //D7
                  data_int_rdy     <= 1;
               end
            8'b10000111: // 1
               begin
                  data_int_reg[15] <= carry_reg[0];   //D0 from carry
                  data_int_reg[14] <= data_in_reg[0]; //D1
                  data_int_reg[13] <= data_in_reg[1];
                  data_int_reg[12] <= data_in_reg[2];
                  data_int_reg[11] <= data_in_reg[3];
                  data_int_reg[10] <= data_in_reg[4];
                  data_int_reg[9]  <= data_in_reg[5];
                  data_int_reg[8]  <= data_in_reg[6]; //D7
                  carry_reg[0]     <= data_in_reg[7]; //D0 to carry
                  data_int_rdy     <= 1;
               end
            8'b11000011: // 2
               begin
                  data_int_reg[15] <= carry_reg[1];   //D0 from carry
                  data_int_reg[14] <= carry_reg[0];   //D1 from carry
                  data_int_reg[13] <= data_in_reg[0]; //D2
                  data_int_reg[12] <= data_in_reg[1];
                  data_int_reg[11] <= data_in_reg[2];
                  data_int_reg[10] <= data_in_reg[3];
                  data_int_reg[9]  <= data_in_reg[4];
                  data_int_reg[8]  <= data_in_reg[5]; //D7
                  carry_reg[1]     <= data_in_reg[6]; //D0 to carry
                  carry_reg[0]     <= data_in_reg[7]; //D1 to carry
                  data_int_rdy     <= 1;
               end
            8'b11100001: // 3
               begin
                  data_int_reg[15] <= carry_reg[2];   //D0 from carry
                  data_int_reg[14] <= carry_reg[1];
                  data_int_reg[13] <= carry_reg[0];   //D2 from carry
                  data_int_reg[12] <= data_in_reg[0]; //D3
                  data_int_reg[11] <= data_in_reg[1];
                  data_int_reg[10] <= data_in_reg[2];
                  data_int_reg[9]  <= data_in_reg[3];
                  data_int_reg[8]  <= data_in_reg[4]; //D7
                  carry_reg[2]     <= data_in_reg[5]; //D0 to carry
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D2 to carry
                  data_int_rdy     <= 1;
               end
            8'b11110000: // 4
               begin
                  data_int_reg[15] <= carry_reg[3];   //D0 from carry
                  data_int_reg[14] <= carry_reg[2];
                  data_int_reg[13] <= carry_reg[1];
                  data_int_reg[12] <= carry_reg[0];   //D3 from carry
                  data_int_reg[11] <= data_in_reg[0]; //D4
                  data_int_reg[10] <= data_in_reg[1];
                  data_int_reg[9]  <= data_in_reg[2];
                  data_int_reg[8]  <= data_in_reg[3]; //D7
                  carry_reg[3]     <= data_in_reg[4]; //D0 to carry
                  carry_reg[2]     <= data_in_reg[5];
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D3 to carry
                  data_int_rdy     <= 1;
               end
            8'b01111000: // 5
               begin
                  data_int_reg[15] <= carry_reg[4];   //D0 from carry
                  data_int_reg[14] <= carry_reg[3];
                  data_int_reg[13] <= carry_reg[2];
                  data_int_reg[12] <= carry_reg[1];
                  data_int_reg[11] <= carry_reg[0];   //D4 from carry
                  data_int_reg[10] <= data_in_reg[0]; //D5
                  data_int_reg[9]  <= data_in_reg[1];
                  data_int_reg[8]  <= data_in_reg[2]; //D7
                  carry_reg[4]     <= data_in_reg[3]; //D0 to carry
                  carry_reg[3]     <= data_in_reg[4];
                  carry_reg[2]     <= data_in_reg[5];
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D4 to carry
                  data_int_rdy     <= 1;
               end
            8'b00111100: // 6
               begin
                  data_int_reg[15] <= carry_reg[5];   //D0 from carry
                  data_int_reg[14] <= carry_reg[4];
                  data_int_reg[13] <= carry_reg[3];
                  data_int_reg[12] <= carry_reg[2];
                  data_int_reg[11] <= carry_reg[1];
                  data_int_reg[10] <= carry_reg[0];   //D5 from carry
                  data_int_reg[9]  <= data_in_reg[0]; //D6
                  data_int_reg[8]  <= data_in_reg[1]; //D7
                  carry_reg[5]     <= data_in_reg[2]; //D0 to carry
                  carry_reg[4]     <= data_in_reg[3];
                  carry_reg[3]     <= data_in_reg[4];
                  carry_reg[2]     <= data_in_reg[5];
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D5 to carry
                  data_int_rdy     <= 1;
               end
            8'b00011110: // 7
               begin
                  data_int_reg[15] <= carry_reg[6];   //D0 from carry
                  data_int_reg[14] <= carry_reg[5];
                  data_int_reg[13] <= carry_reg[4];
                  data_int_reg[12] <= carry_reg[3];
                  data_int_reg[11] <= carry_reg[2];
                  data_int_reg[10] <= carry_reg[1];
                  data_int_reg[9]  <= carry_reg[0];   //D6 from carry
                  data_int_reg[8]  <= data_in_reg[0]; //D7
                  carry_reg[6]     <= data_in_reg[1]; //D0 to carry
                  carry_reg[5]     <= data_in_reg[2];
                  carry_reg[4]     <= data_in_reg[3];
                  carry_reg[3]     <= data_in_reg[4];
                  carry_reg[2]     <= data_in_reg[5];
                  carry_reg[1]     <= data_in_reg[6];
                  carry_reg[0]     <= data_in_reg[7]; //D6 to carry
                  data_int_rdy     <= 1;
               end
            default:
                  data_int_rdy     <= 0;
         endcase
         data_int_reg[7] <= 0;
         data_int_reg[6] <= 0;
         data_int_reg[5] <= 0;
         data_int_reg[4] <= 0;
         data_int_reg[3] <= 0;
         data_int_reg[2] <= 0;
         data_int_reg[1] <= 0;
         data_int_reg[0] <= 0;
      end else begin  // Resolution control invalid
         data_int_reg <= 16'b0;
         data_int_rdy <= 1'b0;
      end
   end

   //==========================================================================
   // Register output data for each configuration, MSB justified
   //==========================================================================
   always @(posedge clk) begin
      if(data_int_rdy) begin
         sample14_reg <= {data_int_reg[2],
                          data_int_reg[3],
                          data_int_reg[4],
                          data_int_reg[5],
                          data_int_reg[6],
                          data_int_reg[7],
                          data_int_reg[8],
                          data_int_reg[9],
                          data_int_reg[10],
                          data_int_reg[11],
                          data_int_reg[12],
                          data_int_reg[13],
                          data_int_reg[14],
                          data_int_reg[15], 2'b0};
         sample12_reg <= {data_int_reg[4],
                          data_int_reg[5],
                          data_int_reg[6],
                          data_int_reg[7],
                          data_int_reg[8],
                          data_int_reg[9],
                          data_int_reg[10],
                          data_int_reg[11],
                          data_int_reg[12],
                          data_int_reg[13],
                          data_int_reg[14],
                          data_int_reg[15], 4'b0};
         sample8_reg  <= {sample8_reg[7:0],
                          data_int_reg[8],
                          data_int_reg[9],
                          data_int_reg[10],
                          data_int_reg[11],
                          data_int_reg[12],
                          data_int_reg[13],
                          data_int_reg[14],
                          data_int_reg[15]};
      end
   end


   always @(posedge clk) begin
      if(resolution == 2'b11) begin          // 14-bits
         data_out_reg <= sample14_reg;
      end else if(resolution == 2'b10) begin // 12-bits
         data_out_reg <= sample12_reg;
      end else begin                         //  8-bits
         data_out_reg <= sample8_reg;
      end
   end

   assign data_en  = data_int_rdy;
   assign data_out = data_out_reg;

endmodule