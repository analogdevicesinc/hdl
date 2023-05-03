/** TODO: OUTDATED, need to include new clock clk_quarter.v and update logic*/
#include <verilated.h>
#include "mod_bit_cmd.h"
#include "Vmod_bit.h"

Vmod_bit* top;

void tick (){
	top->eval();
	top->i_clk = 1;
	top->eval();
	top->i_clk = 0;
	top->eval();
}

void half_tick(){
	top->eval();
	top->i_clk = !top->i_clk;
}

void ensure(int value, int exp, char* str){
	if (value != exp){
		fprintf(stderr, "Error! Got %d instead of %d, signal %s\n", value, exp, str);
		exit(-1);
	} else {
		printf("%s:%d\n", str, value);
	}
}

void at_posedge_clk_quarter(){
	while (top->i_clk_quarter != 1)
		tick();
}

void sanity_start_state(){
	printf("Sanity start state\n");
	top->i_cmd = MOD_BIT_CMD_START_OD;
	tick(); // idle (start_a)
	top->i_cmd = MOD_BIT_CMD_NOP;
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, 1, "sdi");
	tick(); // start_b
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, 1, "sdi");
	tick(); // start_c
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, 0, "sdi");
	tick(); // start_d
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, 0, "sdi");
	tick(); // start_e
	ensure(top->o_scl, 0, "scl");
	ensure(top->o_sdi, 0, "sdi");
	tick();
}
void sanity_stop_state(){
	printf("Sanity stop state\n");
	top->i_cmd = MOD_BIT_CMD_STOP;
	tick(); // idle (stop_a)
	top->i_cmd = MOD_BIT_CMD_NOP;
	ensure(top->o_scl, 0, "scl");
	ensure(top->o_sdi, 0, "sdi");
	tick(); // stop_b
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, 0, "sdi");
	tick(); // stop_c
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, 0, "sdi");
	tick(); // stop_d
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, 1, "sdi");
	tick();
}
/**
 * Single bit transfer with start and stop.
 */
void single_bit_transfer(int state){
	printf("Single bit transfer\n");
	top->i_cmd = MOD_BIT_CMD_START_OD;
	tick(); // idle (start_a)
	tick(); // start_b
	top->i_cmd = MOD_BIT_CMD_WRITE_PP_0 | state;
	at_posedge_clk_quarter();
	// idle (wr_a)
	ensure(top->o_scl, 0, "scl");
	ensure(top->o_sdi, state, "sdi");
	top->i_cmd = MOD_BIT_CMD_STOP;
	tick(); // wr_b
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, state, "sdi");
	tick(); // wr_c
	ensure(top->o_scl, 1, "scl");
	ensure(top->o_sdi, state, "sdi");
	tick(); // wr_d
	ensure(top->o_scl, 0, "scl");
	ensure(top->o_sdi, state, "sdi");

	// Stop sequence
	tick(); // idle (stop_a)
	top->i_cmd = MOD_BIT_CMD_NOP;
	tick();
	at_posedge_clk_quarter();
}

int main(int argc, char** argv){
	Verilated::commandArgs(argc, argv);
	top = new Vmod_bit;

	// Initial reset state
	top->i_reset = 1;
	top->i_cmd = MOD_BIT_CMD_NOP;
	tick();
	// Start module
	top->i_reset = 0;
	at_posedge_clk_quarter();

	sanity_start_state();
	sanity_stop_state();

	single_bit_transfer(1);
	single_bit_transfer(0);

	delete top;

	printf("Test passed\n");
	return 0;
}
