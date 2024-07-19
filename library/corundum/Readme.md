# Corundum IP Core

This IP Core repackages [Corundum NIC](https://github.com/corundum/corundum) as an IP Core.

## Building

Clone the [Corundum NIC](https://github.com/corundum/corundum) repository alongside this repository.

```
hdl/../> git clone https://github.com/corundum/corundum.git
hdl/../corundum/> git checkout ed4a26e2cbc0a429c45d5cd5ddf1177f86838914
hdl/library/corundum> make &
```

## Publications

The following papers pertain to the Corundum source code:

- A. Forencich, A. C. Snoeren, G. Porter, G. Papen, *Corundum: An Open-Source 100-Gbps NIC,* in FCCM'20. ([FCCM Paper](https://www.cse.ucsd.edu/~snoeren/papers/corundum-fccm20.pdf), [FCCM Presentation](https://www.fccm.org/past/2020/forums/topic/corundum-an-open-source-100-gbps-nic/))

- J. A. Forencich, *System-Level Considerations for Optical Switching in Data Center Networks*. ([Thesis](https://escholarship.org/uc/item/3mc9070t))
