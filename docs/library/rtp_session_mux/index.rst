.. _rtp_session_mux:

RTP Session MUX
================================================================================

.. hdl-component-diagram::

The :git-hdl:`RTP Session MUX <library/rtp_session_mux>` core is used to multiplex
1 to 8 AXIS input interfaces from RTP engines to a single AXIS output interface.

Features
--------------------------------------------------------------------------------

- 1 to 8 AXIS input interfaces
- Fixed AXIS TDATA width to 8 bytes (64 bits)
- No external clock handling feature; The data handling and AXI4-Lite logic
  are working with same clocking

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/rtp_session_mux/rtp_session_mux.sv`
     - SystemVerilog source for the top module
   * - :git-hdl:`library/rtp_session_mux/rtp_session_mux_regmap.sv`
     - SystemVerilog source for regmap
   * - :git-hdl:`library/rtp_session_mux/rtp_session_mux_ip.tcl`
     - Packaged IP creation script (AMD tooling)

Configuration Parameters
--------------------------------------------------------------------------------

.. note::

   The session number represents the number of RTP engines connected to the MUX
   logic, equal to **number of AXIS input interfaces**.
   The data clock is the same as the AXI4-lite related clock.

.. hdl-parameters::

   * - S_TDATA_WIDTH 
     - The TDATA width of the slave interface is hardcoded to 64 bits (8 bytes) 
   * - M_TDATA_WIDTH
     - The TDATA width of the master interface is hardcoded to 64 bits (8 bytes)
   * - SESSION_NUMBER
     - There can be 1 to 8 RTP engines (sesssions) connected to the MUX design

.. _rtp_session_mux interface:

Interfaces
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - rtp_session_x
     - Slave AXIS interfaces for RTP sessions (1 to 8)
   * - rtp_master 
     - Master AXIS interface

Detailed Description
--------------------------------------------------------------------------------

The RTP Session MUX IP contains the following features:

- Has the role to multiplex up to 8 64-bit AXIS slave interfaces into a single 
  64-bit AXIS master interface.
- Contains a configurable number of up to 8 64-bit AXIS slave interfaces.
- Contains an internal 64-bit AXIS FIFO instance with depth=262144.
- Contains a SW-configurable (using AXI4-Lite logic) start of video transfer
  signal.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: rtp_session_mux

References
--------------------------------------------------------------------------------

- HDL IP core at :git-hdl:`library/rtp_session_mux`
- :dokuwiki:`RTP Session MUX on wiki <resources/fpga/docs/rtp_session_mux>`
