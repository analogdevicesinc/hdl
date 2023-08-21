//Filename: sgpio_slave.v
//Anthor: Anna Gu
//Description: synchronized serial interface with four signals, act as slave
//revision: 1.0
//revision history: 21-3-1

module sgpio_slave (
  input         i_rstn,
  output[7:0]   o_user_sw,        //the value of user_sw that slave gets from master
  input[7:0]    i_user_led,       //the value of user_led that slave intends to drive
  output        o_user_sw_valid,  //=1: o_user_sw is the active value driven by master.
  output        o_miso,           //master input slave output of the synchronized serial interface
  input         i_clk,            //clock of the synchronized serial interface
  input         i_sync,           //frame start of the synchronized serial interface, =1: the start of a frame
  input         i_mosi            //master output slave input of the synchronized serial interface
);

 reg [7:0] S_o_data_shift;
 reg [7:0] S_i_data_shift;
 reg [7:0] S_o_user_sw;
 reg [1:0] S_o_user_sw_valid;


 assign o_miso          = S_o_data_shift[0];
 assign o_user_sw       = S_o_user_sw;
 assign o_user_sw_valid = S_o_user_sw_valid[1];

 always @(posedge i_clk or negedge i_rstn)
  begin
    if(!i_rstn)
	   S_o_user_sw <= 8'd0;
    else if (i_sync)
	  S_o_user_sw  <= S_i_data_shift;
	else
	  S_o_user_sw <= S_o_user_sw;
 end

 always @(posedge i_clk or negedge i_rstn)
  begin
    if(!i_rstn)
	   S_i_data_shift <= 8'd0;
    else
	  S_i_data_shift  <= {i_mosi, S_i_data_shift[7:1]};
  end

 always @(posedge i_clk or negedge i_rstn)
  begin
    if(!i_rstn)
	   S_o_user_sw_valid <= 2'b00;
    else if (i_sync && (!S_o_user_sw_valid[1]))
	  S_o_user_sw_valid <= S_o_user_sw_valid + 1'b1;
	else
	  S_o_user_sw_valid <= S_o_user_sw_valid;
 end

 always @(posedge i_clk or negedge i_rstn)
  begin
    if(!i_rstn)
	  S_o_data_shift <= 8'b11111111;
    else if (i_sync)
	  S_o_data_shift <= i_user_led;
    else
	  S_o_data_shift <= {1'b1, S_o_data_shift[7:1]};
  end


endmodule
