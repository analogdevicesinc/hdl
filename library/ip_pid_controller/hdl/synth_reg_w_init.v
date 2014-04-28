
`timescale 1 ns / 10 ps
module synth_reg_w_init (i, ce, clr, clk, o);

   parameter width  = 8;
   parameter init_index  = 0;
   parameter [width-1 : 0] init_value  = 'b0000;
   parameter latency  = 1;
 
   input[width - 1:0] i; 
   input ce, clr, clk; 
   output[width - 1:0] o;
   wire[(latency + 1) * width - 1:0] dly_i;
   wire #0.2 dly_clr;
   genvar index;
   
   generate
     if (latency == 0)
        begin:has_0_latency
         assign o = i;
        end
     else
        begin:has_latency
         assign dly_i[(latency + 1) * width - 1:latency * width] = i ;
         assign dly_clr = clr ;
         for (index=1; index<=latency; index=index+1) 
    	   begin:fd_array
// synopsys translate_off
    	     defparam reg_comp_1.width = width;
             defparam reg_comp_1.init_index = init_index;
             defparam reg_comp_1.init_value = init_value;
// synopsys translate_on
             single_reg_w_init #(width, init_index, init_value)
               reg_comp_1(.clk(clk), 
                          .i(dly_i[(index + 1)*width-1:index*width]),
                          .o(dly_i[index * width - 1:(index - 1) * width]),
                          .ce(ce), 
                          .clr(dly_clr));
             end 
        assign o = dly_i[width-1:0];
       end
   endgenerate
endmodule

module single_reg_w_init (i, ce, clr, clk, o);
   parameter width  = 8;
   parameter init_index  = 0;
   parameter [width-1 : 0] init_value  = 8'b00000000;
   input[width - 1:0] i; 
   input ce; 
   input clr; 
   input clk; 
   output[width - 1:0] o;
   parameter [0:0] init_index_val = (init_index ==  1) ? 1'b1 : 1'b0;
   parameter [width-1:0] result = (width > 1) ? { {(width-1){1'b0}}, init_index_val } : init_index_val;
   parameter [width-1:0] init_const = (init_index > 1) ? init_value : result;
   wire[width - 1:0] o;
   genvar index;
   
   generate
     for (index=0;index < width; index=index+1) begin:fd_prim_array
          if (init_const[index] == 0)
            begin:rst_comp
              FDRE fdre_comp(.C(clk), 
			     .D(i[index]),
			     .Q(o[index]),
			     .CE(ce), 
			     .R(clr));
            end
          else
            begin:set_comp
             FDSE fdse_comp(.C(clk), 
			    .D(i[index]), 
			    .Q(o[index]), 
			    .CE(ce), 
			    .S(clr));
            end
    end
   endgenerate
endmodule









