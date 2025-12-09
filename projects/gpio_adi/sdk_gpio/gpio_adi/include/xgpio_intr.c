/******************************************************************************
* Copyright (C) 2002 - 2021 Xilinx, Inc.  All rights reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

/*****************************************************************************/
/**
* @file xgpio_intr.c
* @addtogroup gpio Overview
* @{
*
* The xgpio_intr.c file contains the implementation of GPIO interrupt
* processing functions for the XGpio driver.
* See xgpio.h for more information about the driver.
*
* The functions in this file require the hardware device to be built with
* interrupt capabilities. The functions will assert if called using hardware
* that does not have interrupt capabilities.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 2.00a jhl  11/26/03 Initial release
* 2.11a mta  03/21/07 Updated to new coding style
* 2.12a sv   06/05/08 Updated driver to fix the XGpio_InterruptDisable function
*		      to properly update the Interrupt Enable register
* 3.00a sv   11/21/09 Updated to use HAL Processor APIs. Renamed the macros
*		      XGpio_mWriteReg to XGpio_WriteReg, and XGpio_mReadReg
*		      to XGpio_ReadReg.

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


/****************************************************************************/
/**
* Enable the interrupt output signal. Interrupts enabled through
* XGpio_InterruptEnable() will not be passed through until the global enable
* bit is set by this function. This function is designed to allow all
* interrupts (both channels) to be enabled easily for exiting a critical
* section. This function will assert if the hardware device has not been
* built with interrupt capabilities.
*
* @param	InstancePtr is the GPIO instance to operate on.
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void XGpio_InterruptGlobalEnable(XGpio *InstancePtr)
{
	Xil_AssertVoid(InstancePtr != NULL);
	Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertVoid(InstancePtr->InterruptPresent == TRUE);

	XGpio_WriteReg(InstancePtr->BaseAddress, XGPIO_SOURCE_OFFSET,
			XGPIO_GIE_GINTR_ENABLE_MASK);
}


/****************************************************************************/
/**
* Disable the interrupt output signal. Interrupts enabled through
* XGpio_InterruptEnable() will no longer be passed through until the global
* enable bit is set by XGpio_InterruptGlobalEnable(). This function is
* designed to allow all interrupts (both channels) to be disabled easily for
* entering a critical section. This function will assert if the hardware
* device has not been built with interrupt capabilities.
*
* @param	InstancePtr is the GPIO instance to operate on.
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void XGpio_InterruptGlobalDisable(XGpio *InstancePtr)
{
	Xil_AssertVoid(InstancePtr != NULL);
	Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertVoid(InstancePtr->InterruptPresent == TRUE);


	XGpio_WriteReg(InstancePtr->BaseAddress,  XGPIO_SOURCE_OFFSET, 0x0);

}


/****************************************************************************/
/**
* Enable interrupts. The global interrupt must also be enabled by calling
* XGpio_InterruptGlobalEnable() for interrupts to occur. This function will
* assert if the hardware device has not been built with interrupt capabilities.
*
* @param	InstancePtr is the GPIO instance to operate on.
* @param	Mask is the mask to enable. Bit positions of 1 are enabled.
*		This mask is formed by OR'ing bits from XGPIO_IR* bits which
*		are contained in xgpio_l.h.
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void XGpio_InterruptEnable(XGpio *InstancePtr, u32 Mask)
{
	u32 Register;

	Xil_AssertVoid(InstancePtr != NULL);
	Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertVoid(InstancePtr->InterruptPresent == TRUE);

	/*
	 * Read the interrupt mask register and clear the specified bits
	 * to enable those interrupts.
	 * IP logic: up_irq_pending = (~up_irq_mask) & up_irq_source
	 * So mask=0 means interrupt is ENABLED, mask=1 means DISABLED.
	 */

	Register = XGpio_ReadReg(InstancePtr->BaseAddress, XGPIO_MASK_OFFSET);
	XGpio_WriteReg(InstancePtr->BaseAddress, XGPIO_MASK_OFFSET,
			Register & (~Mask));

}


/****************************************************************************/
/**
* Disable interrupts. This function allows specific interrupts for each
* channel to be disabled. This function will assert if the hardware device
* has not been built with interrupt capabilities.
*
* @param	InstancePtr is the GPIO instance to operate on.
* @param 	Mask is the mask to disable. Bits set to 1 are disabled. This
*		mask is formed by OR'ing bits from XGPIO_IR* bits which are
*		contained in xgpio_l.h.
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void XGpio_InterruptDisable(XGpio *InstancePtr, u32 Mask)
{
	u32 Register;

	Xil_AssertVoid(InstancePtr != NULL);
	Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertVoid(InstancePtr->InterruptPresent == TRUE);

	/*
	 * Read the interrupt mask register and set the specified bits
	 * to disable those interrupts.
	 * IP logic: up_irq_pending = (~up_irq_mask) & up_irq_source
	 * So mask=0 means interrupt is ENABLED, mask=1 means DISABLED.
	 */
	Register = XGpio_ReadReg(InstancePtr->BaseAddress, XGPIO_MASK_OFFSET);
	XGpio_WriteReg(InstancePtr->BaseAddress, XGPIO_MASK_OFFSET,
			Register | Mask);

}

/****************************************************************************/
/**
* Clear pending interrupts with the provided mask. This function should be
* called after the software has serviced the interrupts that are pending.
* This function will assert if the hardware device has not been built with
* interrupt capabilities.
*
* @param 	InstancePtr is the GPIO instance to operate on.
* @param 	Mask is the mask to clear pending interrupts for. Bit positions
*		of 1 are cleared. This mask is formed by OR'ing bits from
*		XGPIO_IR* bits which are contained in xgpio_l.h.
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
void XGpio_InterruptClear(XGpio * InstancePtr, u32 Mask)
{
	u32 Register;

	Xil_AssertVoid(InstancePtr != NULL);
	Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertVoid(InstancePtr->InterruptPresent == TRUE);

	/*
	 * Read the interrupt pending status register (0x40) for debugging.
	 * Write Mask to the source register (0x44) to clear the interrupt.
	 * IP logic: up_irq_source <= up_irq_source & ~up_irq_source_clear
	 */
	Register = XGpio_ReadReg(InstancePtr->BaseAddress, XGPIO_PENDING_OFFSET);
	XGpio_WriteReg(InstancePtr->BaseAddress, XGPIO_SOURCE_OFFSET, Mask);
}


/****************************************************************************/
/**
* Returns the interrupt enable mask. This function will assert if the
* hardware device has not been built with interrupt capabilities.
*
* @param	InstancePtr is the GPIO instance to operate on.
*
* @return	A mask of bits made from XGPIO_IR* bits which are contained in
*		xgpio_l.h.
*
* @return	None.
*
* @note		None.
*
*****************************************************************************/
u32 XGpio_InterruptGetEnabled(XGpio * InstancePtr)
{
	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertNonvoid(InstancePtr->InterruptPresent == TRUE);

	return XGpio_ReadReg(InstancePtr->BaseAddress, XGPIO_MASK_OFFSET);
}


/****************************************************************************/
/**
* Returns the status of interrupt signals. Any bit in the mask set to 1
* indicates that the channel associated with the bit has asserted an interrupt
* condition. This function will assert if the hardware device has not been
* built with interrupt capabilities.
*
* @param	InstancePtr is the GPIO instance to operate on.
*
* @return	A pointer to a mask of bits made from XGPIO_IR* bits which are
*		 contained in xgpio_l.h.
*
* @note
*
* The interrupt status indicates the status of the device regardless if
* the interrupts from the devices have been enabled or not through
* XGpio_InterruptEnable().
*
*****************************************************************************/
u32 XGpio_InterruptGetStatus(XGpio * InstancePtr)
{
	Xil_AssertNonvoid(InstancePtr != NULL);
	Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);
	Xil_AssertNonvoid(InstancePtr->InterruptPresent == TRUE);


	return XGpio_ReadReg(InstancePtr->BaseAddress, XGPIO_PENDING_OFFSET);
}
/** @} */
