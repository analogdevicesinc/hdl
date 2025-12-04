/******************************************************************************
* Copyright (C) 2002 - 2021 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

/*****************************************************************************/
/**
* @file xgpio.h
* @addtogroup gpio Overview
* @{
* @details
*
* This section explains the implementation of the XGpio driver's basic
* functionality.
* This header file contains the software API definition of the Xilinx General
* Purpose I/O (XGpio) device driver.
*
* The Xilinx GPIO controller is a soft IP core designed for Xilinx FPGAs and
* contains the following general features:
*   - Support for up to 32 I/O discretes for each channel (64 bits total).
*   - Each of the discretes can be configured for input or output.
*   - Configurable support for dual channels and interrupt generation.
*
* The driver provides interrupt management functions. Implementation of
* interrupt handlers is left to the user. Refer to the provided interrupt
* example in the examples directory for details.
*
* This driver is intended to be RTOS and processor independent. Any needs for
* dynamic memory management, threads or thread mutual exclusion, virtual
* memory, or cache control must be satisfied by the layer above this driver.
*
* <b>Initialization & Configuration</b>
*
* The XGpio_Config structure is used by the driver to configure itself. This
* configuration structure is typically created by the tool-chain based on HW
* build properties.
*
* To support multiple runtime loading and initialization strategies employed
* by various operating systems, the driver instance can be initialized in one
* of the following ways:
*
*   - XGpio_Initialize(InstancePtr, DeviceId) - The driver looks up its own
*     configuration structure created by the tool-chain based on an ID provided
*     by the tool-chain.
*
*   - XGpio_CfgInitialize(InstancePtr, CfgPtr, EffectiveAddr) - Uses a
*     configuration structure provided by the caller. If running in a system
*     with address translation, the provided virtual memory base address
*     replaces the physical address present in the configuration structure.
*
* @note
*
* This API utilizes 32 bit I/O to the GPIO registers. With less than 32 bits,
* the unused bits from registers are read as zero and written as don't cares.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a rmm  03/13/02 First release
* 2.00a jhl  11/26/03 Added support for dual channels and interrupts
* 2.01a jvb  12/14/05 I separated dependency on the static config table and
*                     xparameters.h from the driver initialization by moving
*                     _Initialize and _LookupConfig to _sinit.c. I also added
*                     the new _CfgInitialize routine.
* 2.11a mta  03/21/07 Updated to new coding style, added GetDataDirection
* 2.12a sv   11/21/07 Updated driver to support access through DCR bus
* 2.12a sv   06/05/08 Updated driver to fix the XGpio_InterruptDisable function
*		      to properly update the Interrupt Enable register
* 2.13a sdm  08/22/08 Removed support for static interrupt handlers from the MDD
*		      file
* 3.00a sv   11/21/09 Updated to use HAL Processor APIs.
*		      Renamed the macros XGpio_mWriteReg to XGpio_WriteReg and
*		      XGpio_mReadReg to XGpio_ReadReg. Removed the macros
*		      XGpio_mSetDataDirection, XGpio_mGetDataReg and
*		      XGpio_mSetDataReg. Users should use XGpio_WriteReg and
*		      XGpio_ReadReg to achieve the same functionality.
* 3.01a bss  04/18/13 Updated driver tcl to generate Canonical params in
*		      xparameters.h. CR#698589
* 4.0   adk  19/12/13 Updated as per the New Tcl API's
* 4.1   lks  11/18/15 Updated to use canonical xparameters in examples and
*		      clean up of the comments, removed support for DCR bridge
*		      and removed xgpio_intr_example for CR 900381
* 4.2   sk   08/16/16 Used UINTPTR instead of u32 for Baseaddress as part of
*                     adding 64 bit support. CR# 867425.
*                     Changed the prototype of XGpio_CfgInitialize API.
* 4.3   sk   09/29/16 Modified the example to make it work when LED_bits are
*                     configured as an output. CR# 958644
*       ms   01/23/17 Added xil_printf statement in main function for all
*                     examples to ensure that "Successfully ran" and "Failed"
*                     strings are available in all examples. This is a fix
*                     for CR-965028.
*       ms   03/17/17 Added readme.txt file in examples folder for doxygen
*                     generation.
* 4.4   sne  04/25/19 Updated Makefile for IAR compier (CR-1029421).
* 4.5   sne  06/14/19 Fixed IAR compiler warnings on example files.
* 4.6	sne  08/11/19 Fixed compilation error of armcc compiler.
* 4.7   sne  08/28/20 Modify Makefile to support parallel make execution.
* 4.8	sne  02/10/21 Fixed doxygen warnings.
*
* </pre>
*****************************************************************************/

#ifndef XGPIO_H			/* prevent circular inclusions */
#define XGPIO_H			/**< by using protection macros */

#ifdef __cplusplus
extern "C" {
#endif

/***************************** Include Files ********************************/

#include "xil_types.h"
#include "xil_assert.h"
#include "xstatus.h"
#include "xgpio_l.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/

/**
 * This typedef contains configuration information for the device.
 */
typedef struct {
	u16 DeviceId;		/**< Unique ID  of device */
	UINTPTR BaseAddress;	/**< Device base address */
	int InterruptPresent;	/**< Are interrupts supported in h/w */
	int IsDual;		/**< Are 2 channels supported in h/w */
} XGpio_Config;

/**
 * The XGpio driver instance data. The user is required to allocate a
 * variable of this type for every GPIO device in the system. A pointer
 * to a variable of this type is then passed to the driver API functions.
 */
typedef struct {
	UINTPTR BaseAddress;	/**< Device base address */
	u32 IsReady;		/**< Device is initialized and ready */
	int InterruptPresent;	/**< Are interrupts supported in h/w */
	int IsDual;		/**< Are 2 channels supported in h/w */
} XGpio;

/***************** Macros (Inline Functions) Definitions ********************/


/************************** Function Prototypes *****************************/

/*
 * Initialization functions in xgpio_sinit.c
 */
int XGpio_Initialize(XGpio *InstancePtr, u16 DeviceId);
XGpio_Config *XGpio_LookupConfig(u16 DeviceId);

/*
 * API Basic functions implemented in xgpio.c
 */
int XGpio_CfgInitialize(XGpio *InstancePtr, XGpio_Config * Config,
			UINTPTR EffectiveAddr);
void XGpio_SetDataDirection(XGpio *InstancePtr, unsigned Channel,
			    u32 DirectionMask);
u32 XGpio_GetDataDirection(XGpio *InstancePtr, unsigned Channel);
u32 XGpio_DiscreteRead(XGpio *InstancePtr, unsigned Channel);
void XGpio_DiscreteWrite(XGpio *InstancePtr, unsigned Channel, u32 Mask);


/*
 * API Functions implemented in xgpio_extra.c
 */
void XGpio_DiscreteSet(XGpio *InstancePtr, unsigned Channel, u32 Mask);
void XGpio_DiscreteClear(XGpio *InstancePtr, unsigned Channel, u32 Mask);

/*
 * API Functions implemented in xgpio_selftest.c
 */
int XGpio_SelfTest(XGpio *InstancePtr);

/*
 * API Functions implemented in xgpio_intr.c
 */
void XGpio_InterruptGlobalEnable(XGpio *InstancePtr);
void XGpio_InterruptGlobalDisable(XGpio *InstancePtr);
void XGpio_InterruptEnable(XGpio *InstancePtr, u32 Mask);
void XGpio_InterruptDisable(XGpio *InstancePtr, u32 Mask);
void XGpio_InterruptClear(XGpio *InstancePtr, u32 Mask);
u32 XGpio_InterruptGetEnabled(XGpio *InstancePtr);
u32 XGpio_InterruptGetStatus(XGpio *InstancePtr);

#ifdef __cplusplus
}
#endif

#endif /* end of protection macro */
/** @} */
