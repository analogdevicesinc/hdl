/******************************************************************************
* Copyright (C) 2002 - 2021 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

/*****************************************************************************/
/**
* @file xgpio_selftest.c
* @addtogroup gpio Overview
* @{
*
* The xgpio_selftest.c file contains implementation of the XGpio driver's self
* test function.
* See xgpio.h for more information about the driver.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a rmm  02/04/02 First release
* 2.00a jhl  01/13/04 Addition of dual channels and interrupts.
* 2.11a mta  03/21/07 Updated to new coding style
* 3.00a sv   11/21/09 Updated to use HAL Processor APIs.
* </pre>
*
*****************************************************************************/

/***************************** Include Files ********************************/
#include "xgpio.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/***************** Macros (Inline Functions) Definitions ********************/

/************************** Variable Definitions ****************************/

/************************** Function Prototypes *****************************/


/******************************************************************************/
/**
* Run a self-test on the driver/device. This function does a minimal test
* in which the data register is read. It only does a read without any kind
* of test because the hardware has been parameterized such that it may be only
* an input such that the state of the inputs won't be known.
*
* All other hardware features of the device are not guaranteed to be in the
* hardware since they are parameterizable.
*
*
* @param	InstancePtr is a pointer to the XGpio instance to be worked on.
*		This parameter must have been previously initialized with
*		XGpio_Initialize().
*
* @return 	XST_SUCCESS always. If the GPIO device was not present in the
*		hardware a bus error could be generated. Other indicators of a
*		bus error, such as registers in bridges or buses, may be
*		necessary to determine if this function caused a bus error.
*
* @note		None.
*
******************************************************************************/
int XGpio_SelfTest(XGpio * InstancePtr)
{
	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

	/*
	 * Read from the data register of channel 1 which is always guaranteed
	 * to be in the hardware device. Since the data may be configured as
	 * all inputs, there is not way to guarantee the value read so don't
	 * test it.
	 */
	(void) XGpio_DiscreteRead(InstancePtr, 1);

	return (XST_SUCCESS);
}
/** @} */
