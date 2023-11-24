module btn_debouncer (
  input      [3:0] btn, 
  input            clk,
  output reg [3:0] deb_btn
);

reg [ 3:0]  shift_reg_0 = 4'b0; 
reg [ 3:0]  shift_reg_1 = 4'b0; 
reg [ 3:0]  shift_reg_2 = 4'b0; 
reg [27:0]  cnt         = 28'd0;
reg         clk_div     = 1'b0;

  always @(posedge clk) begin
   cnt <= cnt + 28'd1;
   if(cnt>=28'd999999)
    cnt <= 28'd0;
   clk_div <= (cnt<28'd500000) ? 1'b1 : 1'b0;
  end

  always @ (posedge clk_div) begin
  
    shift_reg_0 <= {shift_reg_0[2:0],~btn[0]}; 
    shift_reg_1 <= {shift_reg_1[2:0],~btn[1]};
    shift_reg_2 <= {shift_reg_2[2:0],~btn[2]};
  
    if(shift_reg_0 != 4'hf)
     deb_btn[0] <= 1'b0;
    else if(shift_reg_0 == 4'hf)
     deb_btn[0] <= 1'b1;
    else 
     deb_btn[0] <= deb_btn[0];
  

    if(shift_reg_1 != 4'hf)
      deb_btn[1] <= 1'b0;
    else if(shift_reg_1 == 4'hf)
      deb_btn[1] <= 1'b1;
    else 
      deb_btn[1] <= deb_btn[1];
  

    if(shift_reg_2 != 4'hf)
      deb_btn[2] <= 1'b0;
    else if(shift_reg_2 == 4'hf)
      deb_btn[2] <= 1'b1;
    else 
      deb_btn[2] <= deb_btn[2];
  end
endmodule