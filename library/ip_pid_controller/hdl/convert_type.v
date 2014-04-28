// HIERARCHY
// ENDHIERARCHY

`ifndef xlConvertType
 `define xlConvertType
 `timescale 1 ns / 10 ps

`ifndef xlConvPkgIncluded
`include "conv_pkg.v"
`endif
// Cast type by zero pading or Sign extending MSB and
// zero pading or truncating LSB
module cast (inp, res);
    parameter signed [31:0] old_width = 4;
    parameter signed [31:0] old_bin_pt = 1;
    parameter signed [31:0] new_width = 4;
    parameter signed [31:0] new_bin_pt = 1;
    parameter signed [31:0] new_arith = `xlSigned;
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;
   
   // Number of digits to add/subract to the right of the decimal point
   parameter signed [31:0] right_of_dp = new_bin_pt - old_bin_pt; // Not required since new_bin_pt is always equal to old_bin_pt
    wire [new_width-1:0] result;
   genvar i;

   assign res = result;

   generate
      for (i = 0; i<new_width;  i = i+1) 
	begin:cast_loop
	   if ((i-right_of_dp) > old_width - 1) //  Bits to the left of the decimal point
	     begin:u0	
                if (new_arith == `xlUnsigned)
		  begin:u1
		     assign result[i] = 1'b0; // If unsigned, zero pad MSB
		  end
		if (new_arith == `xlSigned)
		  begin:u2
		     assign result[i] = inp[old_width-1]; // If signed, sign extend MSB
		  end
	     end 
	   else if ((i-right_of_dp) >= 0)
	     begin:u3
		assign result[i] = inp[i-right_of_dp]; // Copy bits from input
	     end
	   else
	     begin:u4
		assign result[i] = 1'b0; // zero pad LSB
	     end
	end // for (i =0; i < new_width; i = i+1)
      endgenerate
      
endmodule // cast

module shift_division_result (quotient, fraction, res);
    parameter signed [31:0] q_width = 16;
    parameter signed [31:0] f_width = 16;
    parameter signed [31:0] fraction_width = 8;
    parameter signed [31:0] shift_value = 8;
    parameter signed [31:0] shift_dir = 0;
    parameter signed [31:0] vec_MSB = q_width + f_width - 1;
    parameter signed [31:0] result_MSB = q_width + fraction_width - 1;
    parameter signed [31:0] result_LSB = vec_MSB - result_MSB;
    input [q_width - 1 : 0] quotient;
    input [f_width - 1 : 0] fraction;
    output [result_MSB : 0] res;
   
    wire [vec_MSB:0] vec;
    wire [vec_MSB:0] temp;
   genvar i;

   assign res = vec[vec_MSB:result_LSB];
   assign temp = { quotient, fraction };

   generate
      if (shift_dir == 1)
      begin:left_shift_loop
         for (i = vec_MSB; i>=0;  i = i-1) 
	 begin:u0
            if (i < shift_value)
            begin:u1	
               assign vec[i] = 1'b0;
            end 
	    else
            begin:u2
               assign vec[i] = temp[i-shift_value];
	     end
         end
      end
      else
      begin:right_shift_loop
         for (i = 0; i <= vec_MSB; i = i+1)
         begin:u3
            if (i > vec_MSB - shift_value)
            begin:u4
               assign vec[i] = temp[vec_MSB];
            end
            else
            begin:u5
               assign vec[i] = temp[i+shift_value];
            end
         end
      end
   endgenerate
      
endmodule // shift_division_result

module shift_op (inp, res);
    parameter signed [31:0] inp_width = 16;
    parameter signed [31:0] result_width = 16;
    parameter signed [31:0] shift_value = 8;
    parameter signed [31:0] shift_dir = 0;
    parameter signed [31:0] vec_MSB = inp_width - 1;
    parameter signed [31:0] result_MSB = result_width - 1;
    parameter signed [31:0] result_LSB = vec_MSB - result_MSB;
    input [vec_MSB : 0] inp;
    output [result_MSB : 0] res;
   
    wire [vec_MSB:0] vec;
   genvar i;

   assign res = vec[vec_MSB:result_LSB];

   generate
      if (shift_dir == 1)
      begin:left_shift_loop
         for (i = vec_MSB; i>=0;  i = i-1) 
	 begin:u0
            if (i < shift_value)
            begin:u1	
               assign vec[i] = 1'b0;
            end 
	    else
            begin:u2
               assign vec[i] = inp[i-shift_value];
	     end
         end
      end
      else
      begin:right_shift_loop
         for (i = 0; i <= vec_MSB; i = i+1)
         begin:u3
            if (i > vec_MSB - shift_value)
            begin:u4
               assign vec[i] = inp[vec_MSB];
            end
            else
            begin:u5
               assign vec[i] = inp[i+shift_value];
            end
         end
      end
   endgenerate
      
endmodule // shift_op

module pad_lsb (inp, res);
   parameter signed [31:0] orig_width = 4;
   parameter signed [31:0] new_width = 2;
   input [orig_width - 1 : 0] inp;
   output [new_width - 1 : 0] res;

   parameter signed [31:0] pad_pos = new_width - orig_width -1;
   wire [new_width-1:0] result;
   genvar i;

   assign  res = result;
   generate
      if (new_width >= orig_width)
       	begin:u0
	   assign result[new_width-1:new_width-orig_width] = inp[orig_width-1:0];
       	end
   endgenerate
   
   generate
      if (pad_pos >= 0)
	begin:u1
	   assign result[pad_pos:0] = {(pad_pos+1){1'b0}};
	end
   endgenerate

endmodule // pad_lsb

// zero extend the MSB
module zero_ext (inp, res);
   parameter signed [31:0]  old_width = 4;
   parameter signed [31:0]  new_width = 2;
   input [old_width - 1 : 0] inp;
   output [new_width - 1 : 0] res;

   wire [new_width-1:0] result;
   genvar i;

   assign res = result;
   generate
     if (new_width > old_width)
       begin:u0
	  assign result = { {(new_width-old_width){1'b0}}, inp}; //zero extend
       end // if (new_width >= old_width)
     else
       begin:u1
	  assign result[new_width-1:0] = inp[new_width-1:0];
       end // else: !if(new_width >= old_width)
    endgenerate

endmodule // zero_ext


// sign extend the MSB
module sign_ext (inp, res);
   parameter signed [31:0]  old_width = 4;
   parameter signed [31:0]  new_width = 2;
   input [old_width - 1 : 0] inp;
   output [new_width - 1 : 0] res;

   wire [new_width-1:0] result;

   assign res = result;

   generate
     if (new_width > old_width)
       begin:u0
	  assign result = { {(new_width-old_width){inp[old_width-1]}}, inp};//sign extend
       end // if (new_width >= old_width)
     else
       begin:u1
	  assign result[new_width-1:0] = inp[new_width-1:0];
       end // else: !if(new_width >= old_width)
   endgenerate
   
endmodule // sign_ext

// zero or sign extend the MSB
module extend_msb (inp, res);
    parameter signed [31:0]  old_width = 4;
    parameter signed [31:0]  new_width = 4;
    parameter signed [31:0]  new_arith = `xlSigned;
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;

    wire [new_width-1:0] result;

   assign res = result;
   generate
      if (new_arith ==`xlUnsigned)
	begin:u0
	   zero_ext # (old_width, new_width)
             em_zero_ext (.inp(inp), .res(result));
	end
      else
	begin:u1
	   sign_ext # (old_width, new_width)
             em_sign_ext (.inp(inp), .res(result));
	end
    endgenerate
endmodule //extend_msb

// Align input by padding LSB with zeros and sign or zero extending
module align_input (inp, res);
    parameter signed [31:0]  old_width = 4;
    parameter signed [31:0]  delta = 1;
    parameter signed [31:0]  new_arith = `xlSigned;
    parameter signed [31:0]  new_width = 4;
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;

    parameter signed [31:0]  abs_delta = (delta >= 0) ? (delta) : (-delta);
    wire [new_width-1:0] result;
    wire [(old_width+abs_delta)-1:0] padded_inp;

   assign res = result;
   generate
      if (delta > 0)
	begin:u0
	   pad_lsb # (old_width, old_width+delta)
	     ai_pad_lsb (.inp(inp), .res(padded_inp));
	   extend_msb # (old_width+delta, new_width, new_arith)
	     ai_extend_msb (.inp(padded_inp), .res(result));
	end
      else
	begin:u1
	   extend_msb # (old_width, new_width, new_arith)
	     ai_extend_msb (.inp(inp), .res(result));
	end
   endgenerate
endmodule //align_input


/////////////////////////////////////////////////////////////////////////////
// Overflow Functions
////////////////////////////////////////////////////////////////////////////

// Round Towards Infinity
module round_towards_inf (inp, res);
    parameter signed [31:0]  old_width = 4;
    parameter signed [31:0]  old_bin_pt = 2;
    parameter signed [31:0]  old_arith = `xlSigned;
    parameter signed [31:0]  new_width = 4;
    parameter signed [31:0]  new_bin_pt = 1;
    parameter signed [31:0]  new_arith = `xlSigned;
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;
    
   // Number of binary digits to add/subract to the right of the decimal point
   parameter signed [31:0]  right_of_dp = old_bin_pt - new_bin_pt;

   // Absolute value of right of DP
   parameter signed [31:0]  abs_right_of_dp = (new_bin_pt > old_bin_pt) ? (new_bin_pt-old_bin_pt) : (old_bin_pt - new_bin_pt);
   parameter signed [31:0]  right_of_dp_2 = (right_of_dp >=2) ? right_of_dp-2 : 0;
   parameter signed [31:0]  right_of_dp_1 = (right_of_dp >=1) ? right_of_dp-1 : 0;
   //parameter signed [31:0]  expected_new_width = old_width - right_of_dp + 1;
   reg [new_width-1:0] one_or_zero;
   wire [new_width-1:0] truncated_val;
   wire signed [new_width-1:0] result_signed;
   wire [abs_right_of_dp+old_width-1 : 0] padded_val;

   initial
     begin
	one_or_zero = {new_width{1'b0}};
     end

   generate
      if (right_of_dp >= 0)
     	begin:u0	 // Sign extend or zero extend to size of output
           if (new_arith ==`xlUnsigned)
	     begin:u1
	     	zero_ext # (old_width-right_of_dp, new_width)
		  rti_zero_ext (.inp(inp[old_width-1:right_of_dp]), .res(truncated_val));
	     end
	   else
	     begin:u2
	     	sign_ext # (old_width-right_of_dp, new_width)
		  rti_sign_ext (.inp(inp[old_width-1:right_of_dp]), .res(truncated_val));
	     end
     	end // if (right_of_dp >= 0)
      else
	begin:u3 // Pad LSB with zeros and sign extend by one bit
	   pad_lsb # (old_width, abs_right_of_dp+old_width)
             rti_pad_lsb (.inp(inp), .res(padded_val));
           if (new_arith ==`xlUnsigned)
	     begin:u4
		zero_ext # (abs_right_of_dp+old_width, new_width)
                  rti_zero_ext1 (.inp(padded_val), .res(truncated_val));
	     end
	   else
	     begin:u5
		sign_ext # (abs_right_of_dp+old_width, new_width)
                  rti_sign_ext1 (.inp(padded_val), .res(truncated_val));
	     end
	end // else: !if(right_of_dp >= 0)
   endgenerate

   generate
      if (new_arith == `xlSigned)
	begin:u6
	   always @(inp)
	     begin
		// Figure out if '1' should be added to the truncated number
		one_or_zero = {new_width{1'b0}};
		// Rounding logic for signed numbers
		//   Example:
		//                 Fix(5,-2) = 101.11 (bin) -2.25 (dec)
		//   Converted to: Fix(4,-1) = 101.1  (bin) -2.5  (dec)
		//   Note: same algorithm used for unsigned numbers can't be used.

		// 1st check the sign bit of the input to see if it is a positive number
	       if (inp[old_width-1] == 1'b0)
		 begin
		    one_or_zero[0] = 1'b1;
		 end

	       // 2nd check if digits being truncated are all zeros
	       // (in example if is bit zero)
	       if ((right_of_dp >=2) && (right_of_dp <= old_width))
		 begin
		    if(|inp[right_of_dp_2:0] == 1'b1)
		       begin
			  one_or_zero[0] = 1'b1;
		       end
		 end
	       // 3rd check if the bit right before the truncation point is '1'
	       // or '0' (in example it is bit one)
	       if ((right_of_dp >=1) && (right_of_dp <= old_width))
		 begin
		    if(inp[right_of_dp_1] == 1'b0)
		      begin
			 one_or_zero[0] = 1'b0;
		      end
		 end // if((right_of_dp >=1) && (right_of_dp <= old_width))
	       else
		 // No rounding to be performed
		 begin
		    one_or_zero[0] = 1'b0; 
		 end // else: !if((right_of_dp >=1) && (right_of_dp <= old_width))
	     end // always @ (inp)
             assign result_signed = truncated_val + one_or_zero;
             assign res = result_signed;
	end // if (new_arith = `xlSigned)
      
      else
	// For an unsigned number just check if the bit right before the
        // truncation point is '1' or '0'
	begin:u7
	   always @(inp)
	     begin
	       // Figure out if '1' should be added to the truncated number
		one_or_zero = {new_width{1'b0}};
	       if ((right_of_dp >=1) && (right_of_dp <= old_width))
		 begin
		    one_or_zero[0] = inp[right_of_dp_1];
		 end // if((right_of_dp >=1) && (right_of_dp <= old_width))
	     end // always @ (inp)
             assign res = truncated_val + one_or_zero;
	end // else: !if(new_arith = `xlSigned)     
   endgenerate
      
endmodule // round_towards_inf

// Round towards even values
module round_towards_even (inp, res);
    parameter signed [31:0]  old_width = 4;
    parameter signed [31:0]  old_bin_pt = 2;
    parameter signed [31:0]  old_arith = `xlSigned;
    parameter signed [31:0]  new_width = 4;
    parameter signed [31:0]  new_bin_pt = 1;
    parameter signed [31:0]  new_arith = `xlSigned;
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;

   //Number of binary digits to add/subract to the right of the decimal point
   parameter signed [31:0]  right_of_dp = old_bin_pt - new_bin_pt;
   // Absolute value of right of DP
   parameter signed [31:0]  abs_right_of_dp = (new_bin_pt > old_bin_pt) ? (new_bin_pt-old_bin_pt) : (old_bin_pt - new_bin_pt);
   parameter signed [31:0]  expected_new_width = old_width - right_of_dp + 1;

   reg [new_width-1:0] one_or_zero;
   wire signed [new_width-1:0] result_signed;
   wire [new_width-1:0] truncated_val;
   wire [abs_right_of_dp+old_width-1 : 0] padded_val;

   initial
     begin
      one_or_zero = { new_width{1'b0}};
     end
	
   generate
      if (right_of_dp >= 0)
	// Sign extend or zero extend to size of output
	begin:u0	
           if (new_arith == `xlUnsigned)
	     begin:u1
		zero_ext # (old_width-right_of_dp, new_width)
                            rte_zero_ext (.inp(inp[old_width-1:right_of_dp]), .res(truncated_val));
	     end
	   else
	     begin:u2
		sign_ext # (old_width-right_of_dp, new_width)
                            rte_sign_ext (.inp(inp[old_width-1:right_of_dp]), .res(truncated_val));
	     end
	end // if (right_of_dp >= 0)
      
      else
	// Pad LSB with zeros and sign extend by one bit
	begin:u3
	   pad_lsb # (old_width, abs_right_of_dp+old_width)
                            rte_pad_lsb (.inp(inp), .res(padded_val));
           if (new_arith == `xlUnsigned)
	     begin:u4
		zero_ext # (abs_right_of_dp+old_width, new_width)
                            rte_zero_ext1 (.inp(padded_val), .res(truncated_val));
	     end
	   else
	     begin:u5
		sign_ext # (abs_right_of_dp+old_width, new_width)
                            rte_sign_ext1 (.inp(padded_val), .res(truncated_val));
	     end
	end // else: !if(right_of_dp >= 0)
   endgenerate
   
   generate
      //  Figure out if '1' should be added to the truncated number
      //  For the truncated bits just check if the bits after the
      //  truncation point are 0.5
      if ((right_of_dp ==1) && (right_of_dp <= old_width))
	begin:u6a
	   always @(inp)
	     begin
		one_or_zero = { new_width{1'b0}};
	   	if(inp[right_of_dp-1] == 1'b1)
		  begin
		     one_or_zero[0] = inp[right_of_dp];
		  end
	   	else
		  begin
		     one_or_zero[0] = inp[right_of_dp-1];
		  end
	     end // always @ (inp)
       end // block: u6
      else if ((right_of_dp >=2) && (right_of_dp <= old_width))
	begin:u6b
	   always @(inp)
	     begin
		one_or_zero = { new_width{1'b0}};
	   	if( (inp[right_of_dp-1] == 'b1) && !(|inp[right_of_dp-2:0]) )
		  begin
		     one_or_zero[0] = inp[right_of_dp];
		  end
	   	else
		  begin
		     one_or_zero[0] = inp[right_of_dp-1];
		  end
	     end // always @ (inp)
       end // block: u6
      else
	begin:u7
	    always @(inp)
	     begin
		one_or_zero = { new_width{1'b0}};
	     end
        end
   endgenerate
   
   generate
      if (new_arith == `xlSigned)
	begin:u8
	   assign result_signed = truncated_val + one_or_zero;
	   assign res = result_signed;
	end
      else
	begin:u9
	   assign res = truncated_val + one_or_zero;
	end
   endgenerate
      
endmodule // round_towards_even

// Truncate LSB bits
module trunc (inp, res);
    parameter signed [31:0]  old_width = 4;
    parameter signed [31:0]  old_bin_pt = 2;
    parameter signed [31:0]  old_arith = `xlSigned;
    parameter signed [31:0]  new_width = 4;
    parameter signed [31:0]  new_bin_pt = 1;
    parameter signed [31:0]  new_arith = `xlSigned;
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;
   
   //Number of binary digits to add/subract to the right of the decimal point
   parameter signed [31:0]  right_of_dp = old_bin_pt - new_bin_pt;
   // Absolute value of right of DP
   parameter signed [31:0]  abs_right_of_dp = (new_bin_pt > old_bin_pt) ? (new_bin_pt-old_bin_pt) : (old_bin_pt - new_bin_pt);
   wire [new_width-1:0] result;
   wire [abs_right_of_dp+old_width-1 : 0] padded_val;

   assign res = result;

   generate
      if (new_bin_pt > old_bin_pt)
	begin:tr_u2
	   pad_lsb # (old_width, abs_right_of_dp+old_width)
	     tr_pad_lsb (.inp(inp), .res(padded_val));
	   extend_msb # (old_width+abs_right_of_dp, new_width, new_arith)
             tr_extend_msb (.inp(padded_val), .res(result));
	end
      else
	begin:tr_u1
	   extend_msb # (old_width-right_of_dp, new_width, new_arith)
	     tr_extend_msb (.inp(inp[old_width-1:right_of_dp]), .res(result));
	end
   endgenerate
 
endmodule // trunc

/////////////////////////////////////////////////////////////////////////////
// Overflow Functions
////////////////////////////////////////////////////////////////////////////

//    -- Apply Saturation arithmetic.  The new_bin_pt and old bin_pt should be
//    -- equal. The function chops bits off MSB bits.

module saturation_arith (inp, res);
    parameter signed [31:0]  old_width = 4;
    parameter signed [31:0]  old_bin_pt = 2;
    parameter signed [31:0]  old_arith = `xlSigned;
    parameter signed [31:0]  new_width = 4;
    parameter signed [31:0]  new_bin_pt = 1;
    parameter signed [31:0]  new_arith = `xlSigned;
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;

   // -- Number of digits to add/subract to the left of the decimal point
   parameter signed [31:0]  abs_right_of_dp = (new_bin_pt > old_bin_pt) ? (new_bin_pt-old_bin_pt) : (old_bin_pt - new_bin_pt);
   parameter signed [31:0]  abs_width = (new_width > old_width) ? (new_width-old_width) : 1;
   parameter signed [31:0]  abs_new_width = (old_width > new_width) ? new_width : 1;
   reg overflow;
   reg [old_width-1:0] vec;
   reg [new_width-1:0] result;
   assign res = result;

   ////////////////////////////////////////////////////
   //  For input width less than output width overflow 
   ///////////////////////////////////////////////////
   generate
      if (old_width > new_width)
	begin:sa_u0
	   always @ (inp)
	     begin
        	vec = inp;
        	overflow = 1;
                ////////////////////////////////////////////////////
      	        //  Check for cases when overflow does not occur
      	        ///////////////////////////////////////////////////

                // Case #1:
      	        // Both the input and output are signed and the bits that will
      	        // be truncated plus the sign bit are all the same
      	        // (i.e., number has been sign extended)
                if ( (old_arith == `xlSigned) && (new_arith == `xlSigned) )
                  begin
                    if (~|inp[old_width-1:abs_new_width-1] || &inp[old_width-1:abs_new_width-1])
                     begin
                       overflow = 0;
                     end
                 end
                
                //  Case #2:
      	        //  If the input is converted to a unsigned from signed then only
      	        //  check the bits that will be truncated are all zero
                if ( (old_arith == `xlSigned) && (new_arith == `xlUnsigned))
                   begin
                    if (~|inp[old_width-1 : abs_new_width])
                    begin
                       overflow = 0;
                    end
                end
                
                // Case #3:
      	        // Input is unsigned and the bits that will be truncated are all zero
                if ((old_arith == `xlUnsigned) &&  (new_arith == `xlUnsigned))
                  begin
                    if (~|inp[old_width-1 : abs_new_width])
                     begin
                       overflow = 0;
                     end
                  end
               
                // Case #4:
      	       // Input is unsigned but output signed and the bits that will be
      	       // truncated are all the same
               if ( (old_arith == `xlUnsigned) && (new_arith == `xlSigned))
                 begin
                  if (~|inp[old_width-1:abs_new_width-1] || &inp[old_width-1:abs_new_width-1])
                    begin
                      overflow = 0;
                    end
                 end

               if (overflow == 1) //overflow occured
	         begin
	           if (new_arith == `xlSigned)
	             begin
		       if (inp[old_width-1] == 'b0)
		         begin
		           result = (new_width ==1) ? 1'b0 : {1'b0, {(new_width-1){1'b1}} };//max_signed with fix for CR#434004
		         end
		      else
		        begin
		          result = (new_width ==1) ? 1'b1 : {1'b1, {(new_width-1){1'b0}} };//min_signed with fix for CR#434004
		       end
	             end // if (new_arith = `xlsigned)
	           else
	             begin
	     	       if ((old_arith == `xlSigned) && (inp[old_width-1] == 'b1))
		         begin
		           result = {new_width{1'b0}};
		         end
	     	       else
		         begin
		           result = {new_width{1'b1}};
		         end
	             end // else: !if(new_arith = `xlsigned)
	         end // if (overflow = 1)
      	       else //overflow did not occur
	         begin
	           // Check for case when input type is signed and output type
                   // unsigned
	           //If negative number set to zero
	            if ( (old_arith == `xlSigned) && (new_arith == `xlUnsigned) && (inp[old_width-1] == 'b1) )
	            begin
		      vec = {old_width{1'b0}};
	            end
		    result = vec[new_width-1:0];
	         end
	     end // else: !if(overflow = 1)
	end
   endgenerate

   ////////////////////////////////////////////////////
   //  For input width greater than output width overflow 
   ///////////////////////////////////////////////////
   generate
      if (new_width > old_width)
	begin:sa_u1
         always @ (inp)
           begin
            vec = inp;
            // Check for case when input type is signed and output type
            // unsigned
	     //If negative number set to zero
            if ( (old_arith == `xlSigned) && (new_arith == `xlUnsigned) && (inp[old_width-1] == 1'b1) )
              begin                 
                vec = {old_width{1'b0}};
              end
              // Sign or zero extend number depending on arith of new number
              if (new_arith == `xlUnsigned)
                begin
                  result = { {abs_width{1'b0}}, vec};
                end
              else
                begin
                  result = { {abs_width{inp[old_width-1]}}, vec};
                end
	   end
       end
   endgenerate
   

   ////////////////////////////////////////////////////
   //  For input width equal to output width overflow 
   ///////////////////////////////////////////////////
   generate
      if (new_width == old_width)
	begin:sa_u2
         always @ (inp)
           begin
             // Check for case when input type is signed and output type
             // unsigned
	     //If negative number set to zero
             if ( (old_arith == `xlSigned) && (new_arith == `xlUnsigned) && (inp[old_width-1] == 'b1) )
               begin                 
                 result = {old_width{1'b0}};
               end
             else
               begin
                 result = inp;
               end
           end
	end
   endgenerate
   
endmodule

module wrap_arith (inp, res);
    parameter signed [31:0]  old_width = 4;
    parameter signed [31:0]  old_bin_pt = 2;
    parameter signed [31:0]  old_arith = `xlSigned;
    parameter signed [31:0]  new_width = 4;
    parameter signed [31:0]  new_bin_pt = 1;
    parameter signed [31:0]  new_arith = `xlSigned;
    parameter signed [31:0]  result_arith = ((old_arith==`xlSigned)&&(new_arith==`xlUnsigned))? `xlSigned : new_arith; 
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;

   wire [new_width-1:0] result;

   cast # (old_width, old_bin_pt, new_width, new_bin_pt, result_arith)
     wrap_cast (.inp(inp), .res(result));    
   assign res = result;
   
endmodule // wrap_arith

// Convert one Fix point type to another fixed point type with a
// different bin_pt, width, and arithmetic type
module convert_type (inp, res);
    parameter signed [31:0]  old_width = 4;
    parameter signed [31:0]  old_bin_pt = 2;
    parameter signed [31:0]  old_arith = `xlSigned;
    parameter signed [31:0]  new_width = 4;
    parameter signed [31:0]  new_bin_pt = 1;
    parameter signed [31:0]  new_arith = `xlSigned;
    parameter signed [31:0]  quantization = `xlTruncate;
    parameter signed [31:0]  overflow = `xlWrap;
    input [old_width - 1 : 0] inp;
    output [new_width - 1 : 0] res;
   
   parameter signed [31:0]  fp_width = old_width + 2;
   parameter signed [31:0]  fp_bin_pt = old_bin_pt;
   parameter signed [31:0]  fp_arith = old_arith;
   parameter signed [31:0]  q_width = fp_width + new_bin_pt - old_bin_pt;
   parameter signed [31:0]  q_bin_pt = new_bin_pt;
   parameter signed [31:0]  q_arith = old_arith;

   wire [fp_width-1:0] full_precision_result;
   wire [new_width-1:0] result;
   wire [q_width-1:0] quantized_result;

   assign res = result;

   // old_bin_pt = fp_bin_pt
   cast # (old_width, old_bin_pt, fp_width, fp_bin_pt, fp_arith)
     fp_cast (.inp(inp), .res(full_precision_result));

   generate
      // Apply quantization functions. This will remove LSB bits.
      if (quantization == `xlRound)
     	begin:ct_u0
	   round_towards_inf # (fp_width, fp_bin_pt, fp_arith, q_width, q_bin_pt, q_arith)
	     quant_rtf (.inp(full_precision_result), .res(quantized_result));
	end
   endgenerate
   
   generate
      if (quantization == `xlRoundBanker)
     	begin:ct_u1
	   round_towards_even # (fp_width, fp_bin_pt, fp_arith, q_width, q_bin_pt, q_arith)
	     quant_rte (.inp(full_precision_result), .res(quantized_result));
	end
   endgenerate
   
   generate
      if (quantization == `xlTruncate)
     	begin:ct_u2
	   trunc # (fp_width, fp_bin_pt, fp_arith, q_width, q_bin_pt, q_arith)
	     quant_tr (.inp(full_precision_result), .res(quantized_result));
	end
   endgenerate
   
   generate
      // Apply overflow function.  This will remove MSB bits.
      if (overflow == `xlSaturate)
	begin:ct_u3
	      // q_bin_pt = new_bin_pt
	   saturation_arith # (q_width, q_bin_pt, q_arith, new_width, new_bin_pt, new_arith)
	    ovflo_sat (.inp(quantized_result), .res(result));
	end
   endgenerate
   
   // Apply Wrap behavior if saturate is not selected
   // The legal values that could be passed are 1 and 2
   // Some blocks pass illegal value of 3 (Flag as error)
   // in which case we should use xlWrap also.
   generate
      if ((overflow == `xlWrap) || (overflow == 3))
	begin:ct_u4
	   wrap_arith # (q_width, q_bin_pt, q_arith, new_width, new_bin_pt, new_arith)
	     ovflo_wrap (.inp(quantized_result), .res(result));
	end
   endgenerate
   
endmodule // convert_type

`endif

