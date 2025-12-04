/******************************************************************************
* Copyright (C) 2002 - 2021 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

/*****************************************************************************/
/**
*
* @file xgpio_g.c
* @addtogroup gpio Overview
* @{
*
* The xgpio_g.c file contains a configuration table that specifies the
* configuration of GPIO devices in the system.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a rmm  02/04/02 First release
* 2.00a jhl  12/16/02 Update for dual channel and interrupt support
* 2.11a mta  03/21/07 Updated to new coding style
* 4.0   sha  07/15/15 Added XPAR_XGPIO_NUM_INSTANCES macro to control
*		      config table parameters.
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xgpio.h"
#include "xparameters.h"
//#include "src/platform.h"

#define XPAR_GPIO_0_BASEADDR XPAR_AXI_GPIO_ADI_0_BASEADDR
#define XPAR_XGPIO_NUM_INSTANCES 1
#define XPAR_GPIO_0_DEVICE_ID 0
#define	XPAR_GPIO_0_INTERRUPT_PRESENT 1
#define	XPAR_GPIO_0_IS_DUAL 0

/************************** Constant Definitions *****************************/


/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/


/************************** Variable Prototypes ******************************/

/**
 * This table contains configuration information for each GPIO device
 * in the system.
 */
XGpio_Config XGpio_ConfigTable[] = {
	{
#ifdef XPAR_XGPIO_NUM_INSTANCES
	 XPAR_GPIO_0_DEVICE_ID,
	 XPAR_GPIO_0_BASEADDR,
	 XPAR_GPIO_0_INTERRUPT_PRESENT,
	 XPAR_GPIO_0_IS_DUAL
#endif
	}
};
/** @} */
