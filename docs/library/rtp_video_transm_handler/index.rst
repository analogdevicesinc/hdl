.. _rtp_video_transm_handler:

RTP Video Transmission Handler
================================================================================

.. hdl-component-diagram::

The :git-hdl:`RTP Video Transmission Handler <library/rtp_video_transm_handler` core
is used to arbitrate and multiplex the data from NIC and video paths, this being then
transferred to Corundum's application core logic.

Features
--------------------------------------------------------------------------------

- 2 AXIS input interfaces (s0 - for NIC-related data; s1 - for video data)
- Fixed AXIS TDATA width to 8 bytes (64 bits)
- Single 64-bit AXIS master interface

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/rtp_video_transm_handler/rtp_video_transm_handler.sv`
     - SystemVerilog source for the top module
   * - :git-hdl:`library/rtp_video_transm_handler/rtp_video_transm_handler_ip.tcl`
     - Packaged IP creation script (AMD tooling)

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - S_TDATA_WIDTH 
     - The TDATA width of the slave interface is hardcoded to 64 bits (8 bytes) 
   * - M_TDATA_WIDTH
     - The TDATA width of the master interface is hardcoded to 64 bits (8 bytes)

.. _rtp_video_transm_handler interface:

Interfaces
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - transm_s0
     - Slave AXIS interfaces for NIC-related data
   * - transm_s1
     - Slave AXIS interface for video data
   * - transm_master
     - Master AXIS interface

Detailed Description
--------------------------------------------------------------------------------

The RTP Video Transmission Hanlder IP contains the following features:

- Has the role to arbitrate and multiplex the 64-bit NIC and video-related AXIS
  input interfaces into a single 64-bit AXIS output interface.
- Contains an AXIS-based rate limiter for the NIC-related AXIS input interface.

References
--------------------------------------------------------------------------------

- HDL IP core at :git-hdl:`library/rtp_video_transm_handler`
- :dokuwiki:`RTP Video Transmission Handler on wiki 
  <resources/fpga/docs/rtp_video_transm_handler>`
