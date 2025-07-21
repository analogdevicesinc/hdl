# Corundum IP Core

This IP Core repackages [Corundum NIC](https://github.com/ucsdsysnet/corundum) as an IP Core.

## Building

Clone the [Corundum NIC](https://github.com/ucsdsysnet/corundum) repository alongside this repository.
Do a git checkout to the latest tested version (commit - 37f2607).
When the 10G-based implementation is used, apply the indicated patch.

```
hdl/../> git clone https://github.com/ucsdsysnet/corundum.git

corundum/> git checkout 37f2607
corundum/> git apply ../hdl/library/corundum/patch_axis_xgmii_rx_64.patch

hdl/library/corundum> make &
```

## Publications

The following papers pertain to the Corundum source code:

- A. Forencich, A. C. Snoeren, G. Porter, G. Papen, *Corundum: An Open-Source 100-Gbps NIC,* in FCCM'20. ([FCCM Paper](https://www.cse.ucsd.edu/~snoeren/papers/corundum-fccm20.pdf), [FCCM Presentation](https://www.fccm.org/past/2020/forums/topic/corundum-an-open-source-100-gbps-nic/))

- J. A. Forencich, *System-Level Considerations for Optical Switching in Data Center Networks*. ([Thesis](https://escholarship.org/uc/item/3mc9070t))
