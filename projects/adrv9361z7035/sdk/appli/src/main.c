/*
 * main.c
 *
 *  Created on: 12 Feb 2019
 *      Author: sarpadi
 */

#include "xparameters.h"
#include "xgpio.h"
#include "sleep.h"

#define DO_SHORT_TEST

#define CHANNEL_1  1
#define CHANNEL_2  2

#define GPIO_LB_0_CH1_SIZE  32
#define GPIO_LB_0_CH2_SIZE  32
#define GPIO_LB_1_CH1_SIZE  4
#define GPIO_LB_1_CH2_SIZE  6
#define GPIO_LB_2_CH1_SIZE  10
#define GPIO_LB_2_CH2_SIZE  22

#define XCVR_BADDR 			XPAR_AXI_PZ_XCVRLB_BASEADDR
#define XCVR_LB_SCRATCH 	XCVR_BADDR + 0x8
#define XCVR_LB_RESET	  	XCVR_BADDR + 0x10
#define XCVR_LB_STATUS  	XCVR_BADDR + 0x14
#define XCVR_LB_PLLLOCK	  	XCVR_BADDR + 0x18

#define CLKMON_BADDR 	XPAR_CLK_MONITOR_0_BASEADDR
#define CLKMON_RESET 	CLKMON_BADDR + 0x10
#define CLKMON_CLK0 	CLKMON_BADDR + 0x40
#define CLKMON_CLK1 	CLKMON_BADDR + 0x44
#define CLKMON_CLK2 	CLKMON_BADDR + 0x48
#define CLKMON_CLK3 	CLKMON_BADDR + 0x4C

/**
 * Test for electrical continuity. Signals are now connected in pairs by the
 * FMC loopback The function is walking a '0' on one signal and expexts to
 * find '0' only on it's pair.
 * @param pGpio - pointer to gpio instance
 * @param Channel - gpio channel
 * @param Size - width of channel
 * @return XST_FAILURE if loopback test fails, XST_SUCCESS otherwise.
 */

XStatus TestLoopback(XGpio *pGpio, u8 Channel, u8 Size) {
	u32 init_oe_d, oe_d, read_d, oe_d_aux, exp_d;
	u8 i, sh_size;

	oe_d = 0;
	sh_size = Size;

	//building mask according to size
	while (sh_size > 0){
		oe_d = ((oe_d << 1) | 1);
		sh_size --;
	}
	init_oe_d = oe_d;

	//all gpio are '0' but are set as inputs so they are pulled up
	XGpio_SetDataDirection(pGpio, Channel, oe_d);
	XGpio_DiscreteWrite(pGpio, Channel, 0x00000000);
	//initial mask is applied to make sure no extra bits are used
	oe_d = 0xFFFFFFFE & init_oe_d;

	for(i = 0; i < Size/2; i++)  {
		/* to drive signal to '0' it is set as output. to return to
		*  pull up state it is set as an input
		*  oe_d must be shifted left after each iteration
		*/
		XGpio_SetDataDirection(pGpio, Channel, oe_d);
		//long wait for pull-up to have time to settle
		usleep(100000);
		read_d = XGpio_DiscreteRead(pGpio, Channel);
		//building expected data
		exp_d = oe_d & ((oe_d << 1) | 0x1);

		//check if read data matches expected data
		if(read_d != exp_d)  {
			xil_printf("loopback test fails!\r\n");
			xil_printf("oe_d = %x\r\n", oe_d);
			xil_printf("read_d = %x\r\n", read_d);
			return XST_FAILURE;
		}
		//getting next set of output data ready.
		oe_d_aux = oe_d << 2;
		oe_d = (oe_d_aux | 0x3) & init_oe_d;
	}
	return XST_SUCCESS;
}

XStatus TestLoopbackPmod(XGpio *pGpio, u8 Channel, u8 Size) {
	u32 init_oe_d, oe_d, read_d, oe_d_aux, exp_d;
	u8 i, sh_size;

	oe_d = 0;
	sh_size = Size;

	//building mask according to size
	while (sh_size > 0){
		oe_d = ((oe_d << 1) | 1);
		sh_size --;
	}
	init_oe_d = oe_d;

	//make sure all pins start as 0
	XGpio_DiscreteWrite(pGpio, Channel, 0x0);
	XGpio_SetDataDirection(pGpio, Channel, 0x0);
	usleep(10);

	//all gpio are '0' but are set as inputs
	XGpio_SetDataDirection(pGpio, Channel, oe_d);
	XGpio_DiscreteWrite(pGpio, Channel, 0x00000000);
	//initial mask is applied to make sure no extra bits are used

	oe_d = 0xFFFFFFFE & init_oe_d;

	for(i = 0; i < Size/2; i++)  {
		/* to drive signal to '0' it is set as output. to return to
		*  pull up state it is set as an input
		*  oe_d must be shifted left after each iteration
		*/
		XGpio_SetDataDirection(pGpio, Channel, oe_d);
		XGpio_DiscreteWrite(pGpio, Channel, oe_d ^ init_oe_d);

		usleep(10);
		read_d = XGpio_DiscreteRead(pGpio, Channel);
		//building expected data
		exp_d = ~(oe_d & ((oe_d << 1) | 0x1)) & init_oe_d;

		//check if read data matches expected data
		if(read_d != exp_d)  {
			xil_printf("loopback test fails!\r\n");
			xil_printf("oe_d = %x\r\n", oe_d);
			xil_printf("read_d = %x\r\n", read_d);
			return XST_FAILURE;
		}
		//getting next set of output data ready.
		oe_d_aux = oe_d << 2;
		oe_d = (oe_d_aux | 0x3) & init_oe_d;

		//reset all bits
		XGpio_DiscreteWrite(pGpio, Channel, 0x0);
		XGpio_SetDataDirection(pGpio, Channel, 0x0);
		usleep(10);
	}
	return XST_SUCCESS;
}

int main (void) {
	XStatus Status;
	u32 status;
	XGpio gpio_lb_0, gpio_lb_1, gpio_lb_2;

#ifdef DO_SHORT_TEST
	Status = XGpio_Initialize(&gpio_lb_0, XPAR_GPIO_LB_0_DEVICE_ID);
	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	Status = XGpio_Initialize(&gpio_lb_1, XPAR_GPIO_LB_1_DEVICE_ID);
	if (Status != XST_SUCCESS)
		return XST_FAILURE;

	Status = XGpio_Initialize(&gpio_lb_2, XPAR_GPIO_LB_2_DEVICE_ID);
	if (Status != XST_SUCCESS)
		return XST_FAILURE;
//
//fmc
	Status = TestLoopback(&gpio_lb_0, CHANNEL_1, GPIO_LB_0_CH1_SIZE);
	if (Status != XST_SUCCESS)
		xil_printf("FMC: GPIO_LB_0_CH1 FAILED\r\n");
//fmc
	Status = TestLoopback(&gpio_lb_0, CHANNEL_2, GPIO_LB_0_CH2_SIZE);
	if (Status != XST_SUCCESS)
		xil_printf("FMC: GPIO_LB_0_CH2 FAILED\r\n");
//fmc
	Status = TestLoopback(&gpio_lb_1, CHANNEL_1, GPIO_LB_1_CH1_SIZE);
	if (Status != XST_SUCCESS)
		xil_printf("FMC: GPIO_LB_1_CH1 FAILED\r\n");
//pmod
	Status = TestLoopbackPmod(&gpio_lb_1, CHANNEL_2, GPIO_LB_1_CH2_SIZE);
	if (Status != XST_SUCCESS)
		xil_printf("PMOD: GPIO_LB_1_CH2 FAILED\r\n");
//cam
	Status = TestLoopback(&gpio_lb_2, CHANNEL_1, GPIO_LB_2_CH1_SIZE);
	if (Status != XST_SUCCESS)
		xil_printf("CAM: GPIO_LB_2_CH1 FAILED\r\n");
//cam
	Status = TestLoopback(&gpio_lb_2, CHANNEL_2, GPIO_LB_2_CH2_SIZE);
	if (Status != XST_SUCCESS)
		xil_printf("CAM: GPIO_LB_2_CH2 FAILED\r\n");

	// gpio loopback test done
#endif
//	xcvrlb test


//	xil_printf ("xcvrlb scratch: 0x%x\r\n", Xil_In32(XCVR_LB_SCRATCH));
//	Xil_Out32(XCVR_LB_SCRATCH, 0xdeadbeef);
//	xil_printf ("xcvrlb scratch: 0x%x\r\n", Xil_In32(XCVR_LB_SCRATCH));

//	xil_printf ("xcvrlb reset: 0x%x\r\n", Xil_In32(XCVR_LB_RESET));
	Xil_Out32(XCVR_LB_RESET, 0x1);

	status = Xil_In32(XCVR_LB_STATUS);
	Xil_Out32(XCVR_LB_STATUS, status);
	xil_printf ("xcvrlb status: 0x%x\r\n", status);

	if (status != 0)
		xil_printf("xcvr_lb FAILED\r\n");

// clkmonitor test
//	ret = ((value * AXI_CLK_SPEED_MHZ + 0x7FFF) >> 16);

	//all fmc clocks (whizz fmc loopback card) are 156MHz

	//fmc clk0 m2c
	xil_printf ("clkmon clk0: %d\r\n", (0x7FFF + Xil_In32(CLKMON_CLK0) * 100) >> 16);
	//fmc clk1 m2c
	xil_printf ("clkmon clk1: %d\r\n", (0x7FFF + Xil_In32(CLKMON_CLK1) * 100) >> 16);
	//fmc gbt clk
	xil_printf ("clkmon clk2: %d\r\n", (0x7FFF + Xil_In32(CLKMON_CLK2) * 100) >> 16);
	//clk3 is output of AD9517-3ABCPZ (U21)
	xil_printf ("clkmon clk3: %d\r\n", (0x7FFF + Xil_In32(CLKMON_CLK3) * 100) >> 16);

	return XST_SUCCESS;
}
