# Corundum IP Core

This IP Core repackages [Corundum NIC](https://github.com/ucsdsysnet/corundum) as an IP Core.

## Building

Clone the [Corundum NIC](https://github.com/ucsdsysnet/corundum) repository
alongside this repository, check out the tested commit 37f2607 and apply the
patches in this directory with `apply_patches.sh`. The script skips patches
that are already applied, and each patch only changes the module it names.

```
hdl/../> git clone https://github.com/ucsdsysnet/corundum.git

corundum/> git checkout 37f2607
corundum/> ../hdl/library/corundum/apply_patches.sh

hdl/library/corundum> make &
```

| Patch | Needed when |
|-------|-------------|
| `patch_axis_xgmii_rx_64.patch` | a 10G-based implementation is used |
| `patch_dma_if_axi_rd.patch` | AXI DMA bursts can reach 4 KiB (512-bit, 256-beat); otherwise their data never reaches the packet RAM |
| `patch_mqnic_interface_tx_fifo_depth.patch` | TX_FIFO_DEPTH is larger than RX_FIFO_DEPTH; otherwise synthesis fails |

## Publications

The following papers pertain to the Corundum source code:

- A. Forencich, A. C. Snoeren, G. Porter, G. Papen, *Corundum: An Open-Source 100-Gbps NIC,* in FCCM'20. ([FCCM Paper](https://www.cse.ucsd.edu/~snoeren/papers/corundum-fccm20.pdf), [FCCM Presentation](https://www.fccm.org/past/2020/forums/topic/corundum-an-open-source-100-gbps-nic/))

- J. A. Forencich, *System-Level Considerations for Optical Switching in Data Center Networks*. ([Thesis](https://escholarship.org/uc/item/3mc9070t))
