# CORUNDUM HDL Project

Corundum NIC on AMD Versal devices, with the integrated 100G multirate MAC
(MRMAC) in place of the UltraScale+ CMAC used by the VCU118 Corundum designs.

## Supported parts

| Part name | Description |
|-----------|-------------|
| AMD Versal MRMAC | Integrated 100G multirate Ethernet MAC/PCS, used here as 1x100GE CAUI-4 with RS-FEC |
| QSFP28 module | 100GBASE-SR4/CR4 module or cable on the carrier's QSFP28 cage |

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.

## Publications

The following papers pertain to the Corundum source code:

- A. Forencich, A. C. Snoeren, G. Porter, G. Papen, *Corundum: An Open-Source 100-Gbps NIC,* in FCCM'20. ([FCCM Paper](https://www.cse.ucsd.edu/~snoeren/papers/corundum-fccm20.pdf), [FCCM Presentation](https://www.fccm.org/past/2020/forums/topic/corundum-an-open-source-100-gbps-nic/))

- J. A. Forencich, *System-Level Considerations for Optical Switching in Data Center Networks*. ([Thesis](https://escholarship.org/uc/item/3mc9070t))
