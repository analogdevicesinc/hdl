# AD-GMSL2ETH-SL HDL Project:

Here are some pointers to help you:
  * [Board Product Page](https://www.analog.com/ad-gmsl2eth-sl)
  * Parts : [MAX96724, Quad Tunneling GMSL2/1 to CSI-2 Deserializer](https://www.analog.com/max96724)
  * Parts : [MAX20087, Dual/Quad Camera Power Protectors](https://www.analog.com/max20087)
  * Parts : [AD9545, Quad Input, 10-Output, Dual DPLL/IEEE 1588, 1 pps Synchronizer and Jitter Cleaner](https://www.analog.com/ad9545)
  * Parts : [ADM7154, 600 mA, Ultralow Noise, High PSRR, RF Linear Regulator](https://www.analog.com/adm7154)
  * Parts : [MAX31827, Low-Power Temperature Switch with I2C Interface](https://www.analog.com/max31827)
  * Parts : [LTC3303, 5V, 4A Synchronous Step-Down Regulator in 2mm × 2mm FCQFN](https://www.analog.com/ltc3303)
  * Parts : [MAX25206, Versatile Automotive 60V/70V 2.2MHz Buck Controller with 7µA IQ and Optional Bypass Mode ](https://www.analog.com/max25206)
  * Parts : [MAX17573, 4.5V to 60V, 3.5A, High-Efficiency, Synchronous Step-Down DC-DC Converter with Internal Compensation](https://www.analog.com/max17573)
  * Parts : [LTC4355, Positive High Voltage Ideal Diode-OR with Input Supply and Fuse Monitors](https://www.analog.com/ltc4355)

## Building, Generating Bit Files

This project uses [Corundum NIC](https://github.com/corundum/corundum) and it needs to be cloned alongside this repository.

```
hdl/../> git clone https://github.com/corundum/corundum.git
hdl/../corundum/> git checkout ed4a26e2cbc0a429c45d5cd5ddf1177f86838914
hdl/projects/ad_gmsl2eth_sl/> make &
```

## Publications

The following papers pertain to the Corundum source code:

- A. Forencich, A. C. Snoeren, G. Porter, G. Papen, *Corundum: An Open-Source 100-Gbps NIC,* in FCCM'20. ([FCCM Paper](https://www.cse.ucsd.edu/~snoeren/papers/corundum-fccm20.pdf), [FCCM Presentation](https://www.fccm.org/past/2020/forums/topic/corundum-an-open-source-100-gbps-nic/))

- J. A. Forencich, *System-Level Considerations for Optical Switching in Data Center Networks*. ([Thesis](https://escholarship.org/uc/item/3mc9070t))
