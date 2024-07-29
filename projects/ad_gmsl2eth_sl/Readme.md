# AD-GMSL2ETH-SL HDL Project

  * Evaluation board product page: [AD-GMSL2ETH-SL](https://www.analog.com/ad-gmsl2eth-sl)
  * System documentation: https://wiki.analog.com/resources/eval/user-guides/ad-gmsl2eth-sl-guide
  * HDL project documentation: [source code](../../docs/projects/ad_gmsl2eth_sl/index.rst)
    or [online](http://analogdevicesinc.github.io/hdl/projects/ad_gmsl2eth_sl/index.html)

## Involved parts

| Part name                                   | Description                                  |
|---------------------------------------------|----------------------------------------------|
| [MAX96724](https://www.analog.com/max96724) | Quad Tunneling GMSL2/1 to CSI-2 Deserializer |
| [MAX20087](https://www.analog.com/max20087) | Dual/Quad Camera Power Protectors |
| [AD9545](https://www.analog.com/ad9545)     | Quad Input, 10-Output, Dual DPLL/IEEE 1588, 1 pps Synchronizer and Jitter Cleaner |
| [ADM7154](https://www.analog.com/adm7154)   | 600 mA, Ultralow Noise, High PSRR, RF Linear Regulator |
| [MAX31827](https://www.analog.com/max31827) | Low-Power Temperature Switch with I2C Interface |
| [LTC3303](https://www.analog.com/ltc3303)   | 5V, 4A Synchronous Step-Down Regulator in 2mm × 2mm FCQFN |
| [MAX25206](https://www.analog.com/max25206) | Versatile Automotive 60V/70V 2.2MHz Buck Controller with 7µA IQ and Optional Bypass Mode |
| [MAX17573](https://www.analog.com/max17573) | 4.5V to 60V, 3.5A, High-Efficiency, Synchronous Step-Down DC-DC Converter with Internal Compensation |
| [LTC4355](https://www.analog.com/ltc4355)   | Positive High Voltage Ideal Diode-OR with Input Supply and Fuse Monitors |

## Building and generating the bit files

This project uses [Corundum NIC](https://github.com/corundum/corundum) and it needs to be cloned alongside this repository.
This project is supported only on FPGA AMD Xilinx K26.

```
hdl/../> git clone https://github.com/corundum/corundum.git
hdl/../corundum/> git checkout ed4a26e2cbc0a429c45d5cd5ddf1177f86838914
hdl/projects/ad_gmsl2eth_sl/> make &
```

## Publications

The following papers pertain to the Corundum source code:

- A. Forencich, A. C. Snoeren, G. Porter, G. Papen, *Corundum: An Open-Source 100-Gbps NIC,* in FCCM'20. ([FCCM Paper](https://www.cse.ucsd.edu/~snoeren/papers/corundum-fccm20.pdf), [FCCM Presentation](https://www.fccm.org/past/2020/forums/topic/corundum-an-open-source-100-gbps-nic/))

- J. A. Forencich, *System-Level Considerations for Optical Switching in Data Center Networks*. ([Thesis](https://escholarship.org/uc/item/3mc9070t))
