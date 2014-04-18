


// Declare the module black box
module bldc_sim_fpga_cw (
    ce , 
    clk , 
    clk_x0 , 
    it , 
    kd1 , 
    ki , 
    ki1 , 
    kp , 
    kp1 , 
    motor_speed , 
    new_current , 
    new_speed , 
    ref_speed , 
    reset , 
    reset_acc , 
    err , 
    it_max , 
    pwm , 
    speed 
    ); // synthesis black_box 


	// Inputs
	input ce;
	input clk;
	input clk_x0;
	input [31:0] it;
	input [31:0] kd1;
	input [31:0] ki;
	input [31:0] ki1;
	input [31:0] kp;
	input [31:0] kp1;
	input [31:0] motor_speed;
	input new_current;
	input new_speed;
	input [31:0] ref_speed;
	input reset;
	input reset_acc;

	// Outputs
	output [31:0] err;
	output [31:0] it_max;
	output [31:0] pwm;
	output [31:0] speed;


//synthesis attribute box_type bldc_sim_fpga_cw "black_box"
endmodule
