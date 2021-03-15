
# Data offload IP core

## Description, general use cases

Data offload module for high-speed converters:

**NOTE**: This IP will always have a storage unit (internal or external to the FPGA) and is
designed to handle high data rates. If your data paths will run in a lower data
rate, and your intention is just to transfer the data to another clock domain or
to adjust the bus width of the data path, you must to use another IP.

  * in case of DAC, the DMA initialize the storage unit, after that the controller
will push the data to the DAC interface in one-shot or cyclic way, until the next initialization

  * in case of ADC, the DMA request a transfer, the controller will save the data into
the storage unit, after that will push it to the DMA

  * BYPASS mode: simple streaming FIFO in case of clock rate or data width differences
between source and sink interfaces (data rate MUST match in order to work); the BYPASS
mode is used when an initially high rate path is downgraded to lower rates.

## Table of content

  * [Block diagrams](README.md#block-diagram)
  * [Parameters](README.md#parameters)
  * [Interfaces](README.md#interfaces)
  * [Register map](README.md#register-map)
  * [Clock tree](README.md#clock-tree)
  * [Data path](README.md#data-path)
  * [Control path](README.md#control-path-offload-fsm)

## Generic arhitecture

The main role of our data paths, is to stream data from point A to point B 
in a particular system. There are always a SOURCE and a DESTINATION
point, which can be a device (ADC or DAC), a DMA (for system memory) or any other
data processing IP.

In the context of Data Offload IP, we don't need to know who is the source and
who is the destination. Both interface is a AXI4 Stream interface, which can be 
supported in both Xilinx's an Intel's architecture, and can be connected to any device
core or DMA.

The storage unit is connected to the Data Offload controller via two FIFO interface.
This way the same controller can be used for various storage solutions. (BRAM, 
URAM, external memory etc.)

## Block diagram

![Generic Block Diagram](./docs/do_arch.svg)

## Parameters

|      NAME            |   TYPE      |  DEFAULT   |            DESCRIPTION      |
|----------------------|:-----------:|:----------:|:---------------------------:|
|ID                    |  integer    |    0       | Instance ID number | 
|MEM_TYPE              |  [ 0:0]     |    0       | Define the used storage type: FPGA RAM - 0; external DDR - 1 |
|MEM_SIZE              |  [31:0]     |   1024     | Define the size of the storage element |
|RX_ENABLE             |  [ 0:0]     |    1       | Enable/disable the ADC path |
|RX_FRONTEND_IF        |  [ 0:0]     |    0       | M_AXIS - 0; FIFO_RD - 1 (FRONTEND is the DMA side) |
|RX_BACKEND_IF         |  [ 0:0]     |    0       | S_AXIS - 0; FIFO_WR - 1 (BACKEND is the device side) |
|RX_FRONTEND_DATA_WIDTH|  integer    |    64      | The data width of the RX frontend interface, it depends of the dma configuration |
|RX_BACKEND_DATA_WIDTH |  integer    |    64      | The data width of the RX backend interface, it depends of the device core configuration |
|RX_RAW_DATA_EN        |  [ 0:0]     |    1       | Enables a gearbox module in the RX path, so only the raw samples will be stored in the memory. |
|TX_ENABLE             |  [ 0:0]     |    1       | Enable/disable the DAC path |
|TX_FRONTEND_IF        |  [ 0:0]     |    0       | S_AXIS - 0; FIFO_WR - 1 (FRONTEND is the DMA side) |
|TX_BACKEND_IF         |  [ 0:0]     |    0       | M_AXIS - 0; FIFO_RD - 1 (BACKEND is the device side) |
|TX_FRONTEND_DATA_WIDTH|  integer    |    64      | The data width of the TX frontend interface, it depends of the dma configuration |
|TX_BACKEND_DATA_WIDTH |  integer    |    64      | The data width of the TX backend interface, it depends of the device core configuration |
|TX_RAW_DATA_EN        |  [ 0:0]     |    1       | Enables a gearbox module in the TX path, so only the raw samples will be stored in the memory. |
|MEMC_UIF_TYPE         |  [ 0:0]     |    0       | AXI_MM - 0; AVL_MM - 1 |
|MEMC_UIF_DATA_WIDTH   |  [ 0:0]     |   512      | The valid data depends on the DDRx memory controller IP. |
|MEMC_UIF_ADDRESS_WIDTH|  integer    |    25      | The valid data depends on the DDRx memory controller IP. |
|MEMC_RX_BADDRESS      |  [31:0]     |32'h000000  | DDR base address for the ADC data. |
|MEMC_TX_BADDRESS      |  [31:0]     |32'h100000  | DDR base address for the DAC data. |

## Interfaces

![Interfaces](../../docs/block_diagrams/data_offload/interface.svg)

### AXI4 Lite Memory Mapped Slave (S_AXI4_LITE)

This interface is used to access the register map.

```verilog
// interface clock -- system clock -- 100 MHz
input                   s_axi_aclk
// interface resetn -- synchronous reset active low
input                   s_axi_aresetn

/* write address channel */

// validates the address on the bus
input                   s_axi_awvalid
// write address
input       [15:0]      s_axi_awaddr
// protection type -- not used in the core
input       [ 2:0]      s_axi_awprot
// write ready, indicates that the slave can accept the address
output                  s_axi_awready

/* write data channel */

// validate the data on the bus
input                   s_axi_wvalid
// write data
input       [31:0]      s_axi_wdata
// write strobe, indicates which byte lanes to update
input       [ 3:0]      s_axi_wstrb
// write ready, indicates that the slave can accept the data
output                  s_axi_wready

/* write response channel */

// validates the write response of the slave
output                  s_axi_bvalid
// write response, indicate the status of the transfer
output      [ 1:0]      s_axi_bresp
// response ready, indicates that the master can accept the data
input                   s_axi_bready

/* read address channel */

// validates the address on the bus
input                   s_axi_arvalid
// read address
input       [15:0]      s_axi_araddr
// protection type -- not used in the core
input       [ 2:0]      s_axi_arprot
// read ready, indicates that the slave can accept the address
output                  s_axi_arready

/* read data channel */

// validate the data on the bus
output                  s_axi_rvalid
// read response, indicate the status of the transfer
output      [ 1:0]      s_axi_rresp
// read data drivers by the slave
output      [31:0]      s_axi_rdata
// read ready, indicates that the master can accept the data
input                   s_axi_rready
```

### Supported data interfaces

**NOTE**: All the data interfaces for the streams should be supported by both
frontend (DMA) and backend (device) side. Although in general the FIFO_RD and
FIFO_WR interfaces can be found in the device side, and the AXIS interfaces on
the DMA side.

#### AXI4 Stream interface (S_AXIS | M_AXIS)

* The AXI Stream Slave (S_AXIS) interface is used to receive AXI stream from
the transmit DMA or ADC device.

* The AXI Stream Master (M_AXIS) interface is used to transmit AXI stream
to receive DMA or DAC device

**NOTE**: In all cases the data stream is controlled by the device. Although the
generic AXI Stream interface standard supports back-pressure, in our cases none
the DAC, nore the ADC can wait for data. The DMA always have to be ready, samples
will be lost otherwise!

```verilog
// NOTE: this reference is a master interface

// interface clock -- can be device/core clock or DMA clock
input                        m_axis_aclk
// interface resetn -- synchronous reset with the system clock
input                        m_axis_resetn
// indicates that the slave can accept a transfer in the current cycle (in case of an ADC core, this will control the stream)
input                        m_axis_ready
// indicates that the master is driving a valid transfer
output                       m_axis_valid
// primary payload
output [DATA_WIDTH-1:0]      m_axis_data
// indicates the boundary of a packet
output                       m_axis_last
// byte qualifier, we need this so we can have different DMA and device data widths
output [(DATA_WIDTH/8)-1:0]  m_axis_tkeep
```

**NOTE**: A packet will always be a full buffer. All the data beats going to be
full beats (all the bytes of the bus are valid), except the last one. **axis_last**
and **axis_tkeep** will be used to indicate a partial last beat. This information
should be transferred from the source domain to the sink domain, so we can read
back the data from memory correctly.

#### ADI FIFO interface

This is non-blocking (no back-pressure) interface for the device cores.

To understand the motivation behind the name, let's look at a simple FIFO and its
interfaces:

![Simple FIFO](../../docs/block_diagrams/data_offload/simple_fifo.svg)

A FIFO in general has a **write** and a **read** interface. In each case the
interface is controlled by an external logic. Meaning that the FIFO will always
act as slave. The only difference between the two interfaces is that in case of
the **write** interface the data is driven by the master (we are writing into
the FIFO), and in case of the **read** interface the data is driven by the slave
(we are reading from the FIFO).

To adapt this concept in our case, the device, which can be an ADC or a DAC,
will always be the master. This means, that an ADC core will have a **fifo write**
interface, and a DAC core will have a **fifo read** interface.

In the same time, this means, that a processing core, which wants to interface
a device core, need to have a **salve fifo write** or a **slave fifo read**
interface, in other words needs to act as a FIFO.

**Note:** The processing core (or DMA) can have an AXI stream interface too. To
connect an AXIS stream interface to a FIFO interface the following mapping should
be respected:

 * **fifo write to AXIS slave**:
```verilog
  // the processing unit should always be READY, otherwise will lose data
  assign s_axis_valid = fifo_wr_valid;
  assign s_axis_data = fifo_wr_data;
```

 * **fifo read to AXIS master**:
```verilog
  // the processing unit should drive the data bus with the next valid data,
  // as the READY gets asserted
  assign m_axis_ready = fifo_rd_valid;
  assign fifo_rd_data = m_axis_data;
```

User should be aware that in this case the AXI stream interface will loose the
back pressure capability. The processing unit should be designed to compensate this
scarcity.

**NOTE**: the data stream should arrive in packed format to the core. The core
does not care about number of channels or samples per beat. Result of this
constraint is that the FIFO interface of the **Data Offload** module does not
have any **enable** signals.

```verilog
// This is a Slave FIFO Read interface
// device digital interface clock, or core clock
input                     fifo_rd_clk
// enables the channel --  in our case this is redundant -- maybe we do neet to use it at all
input                     fifo_rd_enable
// validates the data on the bus, it's driven by the device indicates when the core latches the data
input                     fifo_rd_valid
// primary payload, its data width is equal with the channel's data width
output  [DATA_WIDTH-1:0]  fifo_rd_data
// indicates an underflow, the source (offload FIFO in this case) can not produce the data fast enough
output                    fifo_rd_unf
```

```verilog
// This is a Slave FIFO Write interface
// device digital interface clock, or core clock
input                     fifo_wr_clk
// enables the channel -- in our case this is redundant -- maybe we do neet to use it at all
input                     fifo_wr_enable
// validates the data on the bus, it's driven by the device, indicates when the core drives the bus with new data
input                     fifo_wr_valid
// primary payload, its data width is equal with the channel's data width
input   [DATA_WIDTH-1:0]  fifo_wr_data
// indicates an overflow, the sink (offload FIFO in this case) can not consume the data fast enough
output                    fifo_wr_ovf
```

#### AXI4 Memory Mapped master (M_AXI_MM)

An AXI4 Memory Mapped interface, which transfer data into/from the external DDRx
memory. This interface will be used explicitly with Xilinx FPGAs, to interface
the MC (Memory Controller).

```verilog
/* clocks and resets */

// clock signal of the interface, this is an independent clock from the sys_cpu, in general 200 MHz
input                                 axi_clk
// synchronous active low reset
input                                 axi_resetn

/* write address channel */

// validates the address on the bus
output                                axi_awvalid
// write address ID, this signal is the identification tag for the write address group of signals
output      [ 3:0]                    axi_awid
// burst type, this must use INCR (incrementing address burst) -- 2'b01
output      [ 1:0]                    axi_awburst
// lock type, atomic characteristics of the transfer -- must be set to 1'b0
output                                axi_awlock
// indicates the bufferable, cacheable, write-through, write-back, and allocate attributes -- 4'b0011 recommended by Xilinx, IP as slaves in general ignores
output      [ 3:0]                    axi_awcache
// protection type -- not used in the core, recommended value 3'b000
output      [ 2:0]                    axi_awprot
// not implemented in Xilinx Endpoint IP
output      [ 3:0]                    axi_awqos
// not implemented in Xilinx Endpoint IP
output      [ 3:0]                    axi_awuser
// up to 256 beats for incrementing (INCR)
output      [ 7:0]                    axi_awlen
// transfer width 8 to 1024 supported, in general the MIG core has 512 bits interface
output      [ 2:0]                    axi_awsize
// write address
output      [ 31:0]                   axi_awaddr
// write ready, indicates that the slave can accept the address
input                                 axi_awready

/* write data channel */

// validate the data on the bus
output                                axi_wvalid
// write data
output      [AXI_DATA_WIDTH-1:0]      axi_wdata
/8)-1:0]  axi_wstrb   // write strobe, indicates which byte lanes to update
output      [(AXI_DATA_WIDTH
// fully supported, this signal indicates the last transfer in a write burst
output                                axi_wlast
// not implemented in Xilinx Endpoint IP
output      [ 3:0]                    axi_wuser
// write ready, indicates that the slave can accept the data
input                                 axi_wready

/* write response channel */

// validates the write response of the slave
input                                 axi_bvalid
// the identification tag of the write response, the BID value must match the AWID
input       [ 3:0]                    axi_bid
// write response, indicate the status of the transfer
input       [ 1:0]                    axi_bresp
// not implemented in Xilinx Endpoint IP
input       [ 3:0]                    axi_buser
// response ready, indicates that the master can accept the data
output                                axi_bready

/* read address channel */

// validates the address on the bus
output                                axi_arvalid
// read address ID, this signal is the identification tag for the read address group of signals
output      [ 3:0]                    axi_arid
// burst type, this must use INCR (incrementing address burst) -- 2'b01
output      [ 1:0]                    axi_arburst
// lock type, atomic characteristics of the transfer -- must be set to 1'b0
output                                axi_arlock
// indicates the bufferable, cacheable, write-through, write-back, and allocate attributes -- 4'b0011 recommended by Xilinx, IP as slaves in general ignores
output      [ 3:0]                    axi_arcache
// protection type -- not used in the core
output      [ 2:0]                    axi_arprot
// not implemented in Xilinx Endpoint IP
output      [ 3:0]                    axi_arqos
// not implemented in Xilinx Endpoint IP
output      [ 3:0]                    axi_aruser
// up to 256 beats for incrementing (INCR)
output      [ 7:0]                    axi_arlen
// transfer width 8 to 1024 supported, in general the MIG core has 512 bits interface
output      [ 2:0]                    axi_arsize
// read address
output      [ 31:0]                   axi_araddr
// read ready, indicates that the slave can accept the address
input                                 axi_arready

/* read data channel */

// validate the data on the bus
input                                 axi_rvalid
// the RID is generated by the slave and must match by the ARID value
input       [ 3:0]                    axi_rid
// not implemented in Xilinx Endpoint IP
input       [ 3:0]                    axi_ruser
// read response, indicate the status of the transfer
input       [ 1:0]                    axi_rresp
// indicates the last transfer in a read burst
input                                 axi_rlast
// read data drivers by the slave
input       [AXI_DATA_WIDTH-1:0]      axi_rdata
// read ready, indicates that the master can accept the data
output                                axi_rready
```

### Avalon Memory Mapped master (AVL_MM)

An Avalon Memory Mapped interface which transfer data into/from an external DDR4
memory. This interface will be used explicitly with Intel FPGAs.

```verilog
// interface clock and reset
input                                 avl_clk
input                                 avl_reset
// address for read or write
output  reg [(AVL_ADDRESS_WIDTH-1):0] avl_address
// indicate the number of transfers in each burst
output  reg [  6:0]                   avl_burstcount
// enables specific byte lanes during transfers on interfaces fo width greater than 8 bits [3]
output  reg [ 63:0]                   avl_byteenable
// asserted to indicate a read transfer (request)
output                                avl_read
// read data, driven from the slave to the master
input       [(AVL_DATA_WIDTH-1):0]    avl_readdata
// used for variable-latency, pipelined read transfers, to validate the data on the bus
input                                 avl_readdata_valid
// or waitrequest_n in specs, indicates the availability of the slave
input                                 avl_ready
// asserted to indicate a write transfer
output                                avl_write
// write data, driven from the master to the slave
output      [(AVL_DATA_WIDTH-1):0]    avl_writedata
```

###  Initialization request interface

Define a simple request/acknowledge interface to initialize the memory:

  * The request will comes from the system and will put the data offload FSM
into a standby/ready state.
  * Both RX and TX path should have a separate initialization request interface.
  * Acknowledge will be asserted by the data offload IP as the FSM  is ready to
receive data. (from TX_DMA or ADC)

  * In case of ADC: after the acknowledge samples will be stored into the memory
using one of the SYNC modes.

  * In case of the DAC: after acknowledge data from the DMA will be stored into
the memory. Acknowledge will stay asserted until one of the SYNC mode is used,
after that the source interface of the IP will stay in busy state. (all the DMA
transfers will be blocked)

#### Synchronization modes

  * **AUTOMATIC**
    * ADC: As the acknowledge of the initialization interface is asserted, the
IP will start to fill up the buffer with samples.
    * DAC: As the DMA will send a valid last, the FSM will start to send the
stored data to the device.

  * **HARDWARE**
    * ADC and DAC: An external signal will trigger the write or read into or from
the memory.
    * **NOTE**: In case of DAC, if the DMA does not sent all the data into the
buffer, before a hardware sync event, the unsent data will be ignored. It's the
user/software responsibility to sync up these events accordingly.

  * **SOFTWARE**
    * The software write a RW1C register which will trigger the reads or writes
into or from the memory.

## Register Map

|  WORD  |  BYTE    |   BITS   |    NAME             | CLK_DOMAIN | TYPE  |       DESCRIPTION       |
|-------:|:--------:|:--------:|:-------------------:|:----------:|:-----:|:-----------------------:|
| 0x0000 |  0x0000  |          |     VERSION         |  SYS       |  RO   |  Version number         |
|        |          | [31:16]  | MAJOR               |            |       |                         |
|        |          | [15: 8]  | MINOR               |            |       |                         |
|        |          | [ 7: 0]  | PATCH               |            |       |                         |
| 0x0001 |  0x0004  |          | PERIPHERAL_ID       |  SYS       |  RO   |  Value of the IP configuration parameter |
| 0x0002 |  0x0008  |          | SCRATCH             |  SYS       |  RW   |  Scratch register       |
| 0x0003 |  0x000C  |          | IDENTIFICATION      |  SYS       |  RO   |  Peripheral identification. Default value: 0x44414F46 - ('D','A','O','F') |
| 0x0004 |  0x0010  |          | CONFIGURATION       |  SYS       |  RO   |  Core configuration registers |
|        |          | [ 2: 2]  | MEMORY_TYPE         |            |       |  The used storage type (embedded or external) |
|        |          | [ 1: 1]  | TX_PATH             |            |       |  TX path synthesized/implemented    |
|        |          | [ 0: 0]  | RX_PATH             |  SYS       |       |  RX path synthesized/implemented    |
| 0x0005 |  0x0014  |          | CONFIG_RX_SIZE_LSB  |  SYS       |  RO   |  32bits LSB of the receive memory size register |
| 0x0006 |  0x0018  |          | CONFIG_RX_SIZE_MSB  |  SYS       |  RO   |  2bits MSB of the receive memory size register |
|        |          | [ 1: 0]  | RX_SIZE_MSB         |  SYS       |       |    |
| 0x0007 |  0x001C  |          | CONFIG_TX_SIZE_LSB  |  SYS       |  RO   |  32bits LSB of the transmit memory size register |
| 0x0008 |  0x0020  |          | CONFIG_TX_SIZE_MSB  |  SYS       |  RO   |  2bits MSB of the transmit memory size register |
|        |          | [ 1: 0]  | TX_SIZE_MSB         |  SYS       |       |    |
| 0x0020 |  0x0080  |          | MEM_PHY_STATE       |  DDR       |  RO   |  Status bits of the memory controller IP |
|        |          | [ 0: 0]  | CALIB_COMPLETE      |            |       |  Indicates that the memory initialization and calibration have completed successfully |
| 0x0021 |  0x0084  |          | RESET_OFFLOAD       |    ALL     |  RW   |  Reset all the internal address registers and state machines |
|        |          | [ 1: 1]  | RESET_TX            |            |       |                         |
|        |          | [ 0: 0]  | RESET_RX            |            |       |                         |
| 0x0022 |  0x0088  |          | RX_CONTROL_REG      | RX/RX_DMA  |  RW   |  A global control register |
|        |          | [ 0: 0]  | OFFLOAD_BYPASS      |            |       |  Bypass the offload storage, the data path consist just of a CDC FIFO |
| 0x0023 |  0x008C  |          | TX_CONTROL_REG      | TX/TX_DMA  |  RW   |  A global control register |
|        |          | [ 1: 1]  | ONESHOT_EN          |            |       |  By default the TX path runs on CYCLIC mode, set this bit to switch it to ONE-SHOT mode |
|        |          | [ 0: 0]  | OFFLOAD_BYPASS      |            |       |  Bypass the offload storage, the data path consist just of a CDC FIFO |
| 0x0040 |  0x0100  |          | SYNC_OFFLOAD        |            |  RW1P |  Synchronization setup for RX and TX path |
|        |          | [ 1: 1]  | TX_SYNC             | TX         |       |  Synchronize the TX data transfer |
|        |          | [ 0: 0]  | RX_SYNC             | RX         |       |  Synchronize the RX data capture |
| 0x0041 |  0x0104  |          | SYNC_RX_CONFIG      |            |  RW   |  Synchronization setup for RX path |
|        |          | [ 1: 0]  | SYNC_CONFIG         | RX         |       |  Auto - '0'; hardware - '1'; software - '2' |
| 0x0042 |  0x0108  |          | SYNC_TX_CONFIG      |            |  RW   |  Synchronization setup for TX path
|        |          | [ 1: 0]  | SYNC_CONFIG         |  TX        |       |  Auto - '0'; hardware - '1'; software - '2' |
| 0x0080 |  0x0200  |          | RX_FSM_DBG          | RX_DMA     |  RW   |  Debug register for the RX offload FSM |
|        |          | [15: 8]  | CONTROL_FSM         |            |       |  Force the offload state machine into a required state |
|        |          | [ 7: 0]  | FSM_STATE           |            |       |  The current state of the offload state machine |
| 0x0081 |  0x0204  |          | TX_FSM_DBG          | TX_DMA     |  RW   |  Debug register for the TX offload FSM |
|        |          | [16:16]  | NO_TLAST            |            |       |  This bits gets asserted, if the memory is empty and the DMA trying to read out data |
|        |          | [15: 8]  | CONTROL_FSM         |            |       |  Force the offload state machine into a required state |
|        |          | [ 7: 0]  | FSM_STATE           |            |       |  The current state of the offload state machine |
| 0x0082 |  0x0204  |          | RX_SAMPLE_COUNT_LSB | RX_DMA     |  RO   |  Stored sample count for the RX path (32 LSB) |
| 0x0083 |  0x0208  |          | RX_SAMPLE_COUNT_MSB | RX_DMA     |  RO   |  Stored sample count for the RX path (32 MSB) |
| 0x0084 |  0x020C  |          | TX_SAMPLE_COUNT_LSB | TX_DMA     |  RO   |  Stored sample count for the TX path (32 LSB) |
| 0x0085 |  0x0210  |          | TX_SAMPLE_COUNT_MSB | TX_DMA     |  RO   |  Stored sample count for the TX path (32 MSB) |

## Clock tree

In general there are at least two different clock in the data offload module:

  * DMA or system clock : on this clock will run all the front end interfaces
  * Memory Controller user clock : user interface clock of the DDRx controller (**optional**)
  * Device clock : the digital interface clock of the converter

![Clocks](../../docs/block_diagrams/data_offload/clocks.svg)

A general frequency relationship of the above clocks are:

```
  CLKdma <= CLKddr <= CLKconverter
```

The clock domain crossing should be handled by the [util_axis_fifo](https://github.com/analogdevicesinc/hdl/tree/master/library/util_axis_fifo) module.
  * **TODO** : Make sure that we support both AXIS and FIFO
  * **TODO** : Add support for asymmetric aspect ratio.

All the back end paths (device side) are time critical. The module must read or
write from or into the storage at the speed of the device.

```
  DDR data rate >= Device data rate
  DDR data rate >= ADC data rate + DAC data rate
```

## Data path

![Data path](../../docs/block_diagrams/data_offload/datapath.svg)

  * The data path should be designed to support any kind of difference between
the source, memory and sink data width.

  * The data width adjustments will be made by the CDC_FIFO.

  * In both path (ADC and DAC) the data stream at the front-end side is packatized,
meaning there is a valid TLAS/TKEEP in the stream. While in the back-end side
the stream is continuous. (no TLAST/TKEEP)
    * The DAC path have to have a depacketizer to get rid of the last partial beat
from the stream.
    * Because the ADC path already arrive in a packed form, and we always will
fill up the whole storage, we don't need to treat special use-cases.

### Used storage elements

|                       |         ZC706      |       ZCU102      |       A10SOC     |
|:----------------------|:------------------:|:-----------------:|:----------------:|
|          FPGA         | XC7Z045 FFG900 – 2 | XCZU9EG-2FFVB1156 | 10AS066N3F40E2SG |
| External Memory Type  |     DDR3 SODIMM    |        DDR4       |   DDR4 HILO      |
| External Memory Size  |         1 GB       |       512 MB      |      2 GB        |
| Embedded Memory Type  |         BRAM       |        BRAM       |      M20K        |
| Embedded Memory Size  |       19.1 Mb      |       32.1 Mb     |      41 Mb       |

### Data width manipulation

* data width differences should be treated by the CDC FIFO

* the smallest granularity should be 8 bits. This constraints mainly will generate
additional logic just in the TX path, taking the fact that the data from the ADC
will come packed.

* the gearbox main role is to improve the DDR's bandwidth, strips the padding bits
of each samples, so the raw data could be stored into the memory.

### Xilinx's MIG vs. Intel's EMIF

* Incrementing burst support for 1 to 256 beats, the length of the burst should
be defined by the internal controller

* Concurrent read/write access, the external memory to be shared between an ADC
and DAC
* Dynamic burst length tuning: an FSM reads and writes dummy data until both
ADC's overflow and DAC's underflow lines are de-asserted. Pre-requisites : both
device's interface should be up and running.

* **TODO**: prefetch the next transfer if it's possible, by driving the address channels ahead (e.g. Overlapping read burst in case of AXI4)

* Optional gearbox to congest the samples in order to increase the maximum data rate.
* In general we packing all samples into 16 bits. This can add a significant
overhand to the maximum real data rate on the memory interface. The gearbox main
role is to pack and unpack the device's samples into the required data width. (in general 512 or 1024 bit)

Boards with FPGA side DDR3/4 SODIMMs/HILO: ZC706, ZCU102, A10SOC

|                              |  ZC706    |  ZCU102    |   A10SOC   |
|------------------------------|:---------:|:----------:|:----------:|
| Max data throughputs (MT/s)  |   1600    |   2666     |    2133    |
| DDRx reference clocks        |  200 MHz  |  300 MHz   |    133 MHz |
| DDRx Data bus width          |    64     |   16       |     64     |
| Memory to FPGA clock ratio   |    4:1    |   4:1      |    4:1     |
| UI type & burst length       | AXI4-256  | AXI4-256   | Avalon Memory Map |
| UI data width                |    512    |   512      |    512     |

### Internal cyclic buffer support for the TX path

![Data path with external storage](../../docs/block_diagrams/data_offload/architecture_DDR.svg)

* On the front end side if the TX path, a special buffer will handle the data
width up/down conversions and run in cyclic mode if the length of the data set
is smaller than 4/8 AXI/Avalon burst. This way we can avoid to overload the memory
interface with small bursts.

* On the back end side, because the smallest granularity can be 8 bytes, we need
a dynamic 'depackatizer' or re-aligner, which will filter out the invalid data
bytes from the data stream. (this module will use the tlast and tkeep signal of
the AXI stream interface)

## Control path - Offload FSM

### RX control FSM for internal RAM mode

![RX_control FMS for internal RAM mode](../../docs/block_diagrams/data_offload/rx_bram_fsm.svg)

### TX control FSM for internal RAM mode

![TX_control FMS for internal RAM mode](../../docs/block_diagrams/data_offload/tx_bram_fsm.svg)

**TODO** FSMs for the external DDR mode

## References

### AMBA AXI
  * [AMBA specification](http://infocenter.arm.com/help/topic/com.arm.doc.set.amba/index.html#specs)
  * [UG761 AXI Reference Guide](https://www.xilinx.com/support/documentation/ip_documentation/ug761_axi_reference_guide.pdf)

### Avalon
  * [Avalon Interface Specification](https://www.altera.com/en_US/pdfs/literature/manual/mnl_avalon_spec.pdf)

### Xilinx
  * [Device Memory Interface Solutions](https://www.xilinx.com/support/documentation/ip_documentation/mig_7series/v4_2/ds176_7Series_MIS.pdf)
  * [Device Memory Interface Solutions User Guide](https://www.xilinx.com/support/documentation/ip_documentation/mig_7series/v4_2/ug586_7Series_MIS.pdf)
  * [Ultrascale Architecutre-Based FPGAs Memory IP (v1.4)](https://www.xilinx.com/support/documentation/ip_documentation/ultrascale_memory_ip/v1_4/pg150-ultrascale-memory-ip.pdf)
  * [Xilinx FIFO Generator](https://www.xilinx.com/products/intellectual-property/fifo_generator.html#documentation)
  * [7 Series FPGAs Memory Resources](https://www.xilinx.com/support/documentation/user_guides/ug473_7Series_Memory_Resources.pdf)
  * [Ultrascale Memory Resources](https://www.xilinx.com/support/documentation/user_guides/ug573-ultrascale-memory-resources.pdf)

### Intel
  * [Intel Arria 10 Core Fabric and General Purpose I/Os Handbook](https://www.altera.com/en_US/pdfs/literature/hb/arria-10/a10_handbook.pdf)
  * [Intel Arria 10 External Memory Interface IP User Guide](https://www.altera.com/en_US/pdfs/literature/ug/ug-20115.pdf)
  * [Intel Arria 10 External Memory Interface IP Design Example](https://www.altera.com/en_US/pdfs/literature/ug/ug-20118.pdf)
  * [Intel SCFIFO and DCFIFO](https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_fifo.pdf)
  * [Intel Startix 10 High-Performance Design Handbook](https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/hb/stratix-10/s10_hp_hb.pdf)
  * [Intel Stratix 10 Embedded Memory User Guide](https://www.altera.com/en_US/pdfs/literature/hb/stratix-10/ug-s10-memory.pdf)

### Supported FPGA boards
  * [ZC706](https://www.xilinx.com/products/boards-and-kits/ek-z7-zc706-g.html)
  * [ZCU102](https://www.xilinx.com/products/boards-and-kits/ek-u1-zcu102-g.html)
  * [A10SOC](https://www.altera.com/products/boards_and_kits/dev-kits/altera/arria-10-soc-development-kit.html)
