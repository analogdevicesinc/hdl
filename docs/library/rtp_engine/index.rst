.. _rtp_engine:

RTP Engine
================================================================================

.. hdl-component-diagram::

The :git-hdl:`RTP Engine <library/rtp_engine>` core is to create RTP for
uncompressed video (compliant to `[RFC4175] https://datatracker.ietf.org/doc/html/rfc4175`_
, `[RFC3550] https://datatracker.ietf.org/doc/html/rfc3550`_) packets from incoming
AXIS-based YUV422 color video lines.

Features
--------------------------------------------------------------------------------

- 64-bit AXIS master/slave interfaces for input video data and ouput RTP packets
- Create 1 video line-based RTP packets
- No external clock handling feature; The data handling and AXI4-Lite logic
  are working with same clocking

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/rtp_engine/rtp_engine.sv`
     - SystemVerilog source for the top module
   * - :git-hdl:`library/rtp_engine/rtp_engine_package.sv`
     - SystemVerilog package for Internet protocols structures
   * - :git-hdl:`library/rtp_engine/rtp_engine_regmap.sv`
     - SystemVerilog source for regmap
   * - :git-hdl:`library/rtp_session_mux/rtp_session_mux_ip.tcl`
     - Packaged IP creation script (AMD tooling)

Configuration Parameters
--------------------------------------------------------------------------------

.. note::

   The SSRC_ID field from the RTP header represents the unique identifier of the
   streaming session and it is equal to the **ID of the RTP Engine instance**.
   The data clock is the same as the AXI4-lite related clock.

.. hdl-parameters::

   * - S_TDATA_WIDTH 
     - The TDATA width of the slave interface is hardcoded to 64 bits (8 bytes) 
   * - M_TDATA_WIDTH
     - The TDATA width of the master interface is hardcoded to 64 bits (8 bytes)
   * - SSRC_ID
     - SSRC ID field of the general RTP header contain an unique identifier for
       each RTP engine instance of the setup (between 0 to 7)

.. _rtp_engine interface:

Interfaces
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - rtp_engine_slave
     - Slave AXIS interfaces for input video data
   * - rtp_engine_master
     - Master AXIS interface for output RTP packets

Detailed Description
--------------------------------------------------------------------------------

The RTP Engine IP contains the following features:

- Has the role to convert 64-bit AXIS video data (hardcoded 4 pixels per clock of
  YUV422 format from the MIPI CSI-2 Receiver) to AXIS RTP-compliant packets.
- Contains the implementation for the following network stack: Ethernet at Layer 2
  (L2), IPv4 at L3, UDP at L4 and RTP for uncompressed video at L5 [RTP header +
  RTP payload header].
- Contains multiple hardcoded and SW-configurable headers' fields for the previously
  mentioned protocols. The SW-configurable fields are listed in the register map
  table.
- Contains internal AXIS-based FIFO, which facilitates the protocols-related
  encapsulation on the payload video data.
- Creates the RTP packets based on a 1 line/packet approach in order to avoid
  fragmentation and additional compute operations for partial lines.
- Does not implement the optional UDP checksum implementation to facilitate a lower
  latency for the video to RTP packets translation.
- The data path runs using the same clocking source as the AXI4-Lite and MIPI CSI-2
  receiver to facilitate a lower latency by avoiding additional clock domain crossing
  operations.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: rtp_engine

References
--------------------------------------------------------------------------------

- HDL IP core at :git-hdl:`library/rtp_engine`
- :dokuwiki:`RTP Engine on wiki <resources/fpga/docs/rtp_engine>`
