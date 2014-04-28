
//-----------------------------------------------------------------
//
//  Filename      : xlclockdriver.v
//
//  Date          : 6/29/2004
//
//  Description   : Verilog description of a clock enable generator block.
//                  This code is synthesizable.
//
//  Assumptions   : period >= 1
//
//  Mod. History  : Translated VHDL clockdriver to Verilog
//                : Added pipeline registers
//
//  Mod. Dates    : 6/29/2004
//                : 12/14/2004
//
//-------------------------------------------------------------------

`timescale 1 ns / 10 ps
module xlclockdriver (sysclk, sysclr, sysce, clk, clr, ce, ce_logic);

   parameter signed [31:0] log_2_period = 1;
   parameter signed [31:0] period  = 2;
   parameter signed [31:0] use_bufg  = 1'b0;
   parameter signed [31:0] pipeline_regs = 5;
   
   input sysclk; 
   input sysclr; 
   input sysce; 
   output clk; 
   output clr; 
   output ce; 
   output ce_logic; 

   //A maximum value of 8 would allow register balancing to the tune of 10^8
   //It is set to 8 since we do not have more than 10^8 nets in an FPGA 
   parameter signed [31:0] max_pipeline_regs = 8;

   //Check if requested pipeline regs are greater than the max amount
   parameter signed [31:0] num_pipeline_regs = (max_pipeline_regs > pipeline_regs)? pipeline_regs : max_pipeline_regs;
   parameter signed [31:0] factor = num_pipeline_regs/period;  
   parameter signed [31:0] rem_pipeline_regs =  num_pipeline_regs - (period * factor) + 1;

   //Old constant values
   parameter [log_2_period-1:0] trunc_period = ~period + 1;
   parameter signed [31:0] period_floor = (period>2)? period : 2;
   parameter signed [31:0] power_of_2_counter = (trunc_period == period) ? 1 : 0;
   parameter signed [31:0] cnt_width = (power_of_2_counter & (log_2_period>1)) ? (log_2_period - 1) : log_2_period;
   parameter [cnt_width-1:0] clk_for_ce_pulse_minus1 = period_floor-2; 
   parameter [cnt_width-1:0] clk_for_ce_pulse_minus2 = (period-3>0)? period-3 : 0;
   parameter [cnt_width-1:0] clk_for_ce_pulse_minus_regs = ((period-rem_pipeline_regs)>0)? (period-rem_pipeline_regs) : 0; 
   reg [cnt_width-1:0] clk_num;
   reg temp_ce_vec;
   wire [num_pipeline_regs:0] ce_vec; 
   wire [num_pipeline_regs:0] ce_vec_logic; 
   wire internal_ce; 
   wire internal_ce_logic; 
   reg cnt_clr; 
   wire cnt_clr_dly;
   genvar index;

initial
   begin
      clk_num = 'b0;
   end

   assign clk = sysclk ;
   assign clr = sysclr ;

   // Clock Number Counter
   always @(posedge sysclk)
     begin : cntr_gen
       if (sysce == 1'b1)
         begin:hc 
           if ((cnt_clr_dly == 1'b1) || (sysclr == 1'b1))
	     begin:u1
               clk_num = {cnt_width{1'b0}};
	     end
           else
	     begin:u2
               clk_num = clk_num + 1 ; 
             end
         end  
     end 

   // Clear logic for counter
   generate
      if (power_of_2_counter == 1)
	begin:clr_gen_p2
	   always @(sysclr)
	     begin:u1
	   	cnt_clr = sysclr;
	     end
       end
   endgenerate

   generate
      if (power_of_2_counter == 0)
	begin:clr_gen
	   always @(clk_num or sysclr)
	     begin:u1
           	if ( (clk_num == clk_for_ce_pulse_minus1) | (sysclr == 1'b1) )
		  begin:u2
             	     cnt_clr = 1'b1 ;
		  end 
           	else
		  begin:u3
             	     cnt_clr = 1'b0 ;
		  end
	     end
       end // block: clr_gen
   endgenerate

   synth_reg_w_init #(1, 0, 'b0000, 1) 
     clr_reg(.i(cnt_clr), 
	     .ce(sysce), 
	     .clr(sysclr), 
	     .clk(sysclk), 
	     .o(cnt_clr_dly)); 
     
//Clock Enable Generation
   generate
      if (period > 1)
	begin:pipelined_ce
	   always @(clk_num)
	     begin:np_ce_gen
		if (clk_num == clk_for_ce_pulse_minus_regs)
		  begin
		     temp_ce_vec = 1'b1 ;
		  end
		else
		  begin
		     temp_ce_vec = 1'b0 ;
		  end
	     end
   
           for(index=0; index<num_pipeline_regs; index=index+1)
	     begin:ce_pipeline
          	synth_reg_w_init #(1, ((((index+1)%period)>0)?0:1), 1'b0, 1) 
		  ce_reg(.i(ce_vec[index+1]), 
			 .ce(sysce), 
			 .clr(sysclr), 
			 .clk(sysclk), 
		   .o(ce_vec[index]));
	     end //block ce_pipeline

         for(index=0; index<num_pipeline_regs; index=index+1)
	     begin:ce_pipeline_logic
          	synth_reg_w_init #(1, ((((index+1)%period)>0)?0:1), 1'b0, 1) 
		      ce_reg_logic(.i(ce_vec_logic[index+1]), 
			 .ce(sysce), 
			 .clr(sysclr), 
			 .clk(sysclk), 
		     .o(ce_vec_logic[index]));
	      end //block ce_pipeline
          assign ce_vec_logic[num_pipeline_regs] = temp_ce_vec;
          assign ce_vec[num_pipeline_regs] = temp_ce_vec;
          assign internal_ce = ce_vec[0];
          assign internal_ce_logic = ce_vec_logic[0];
      end // block: pipelined_ce
   endgenerate

   generate
      if (period > 1)
        begin:period_greater_than_1
 	 if (use_bufg == 1'b1)
            begin:use_bufg
             BUFG ce_bufg_inst(.I(internal_ce), .O(ce));
             BUFG ce_logic_bufg_inst(.I(internal_ce_logic), .O(ce_logic));
            end
         else
           begin:no_bufg
            assign ce = internal_ce;
            assign ce_logic = internal_ce_logic;
           end
       	end
    endgenerate
      
    generate
     if (period == 1)
       begin:period_1
         assign ce = sysce;
         assign ce_logic = sysce;
       end
    endgenerate

endmodule
