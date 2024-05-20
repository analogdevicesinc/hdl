.. _triple_buffer:

AXI DMAC in Triple Buffer configuration
================================================================================

To setup a pipeline in triple buffer configuration, two AXI DMAC needs to be
instantiated, one write and a reader.

The writer side is connected to an AXI-Stream interface and outputs to an
AXI Memory-Mapped memory.
The reader side is connected to an AXI Memory-Mapped interface and outputs to a
AXI-Stream memory.

.. caution::

   The Framelock must provide enough number of frames for the distance to function
   properly.

   Example: Consider number of frames equal to 3 (slot 0 to 3) and the distance is
   2 with wait writer set and in dynamic mode.

   At the 4th frame, the writer will skip slot 0 and write to slot 1 since is being
   accessed by the reader to fetch frame 0.
   The reader then attempts to fetch frame 1 from slot 1, but was just overwritten
   with frame 4 by the writer.

   Increasing the number of frames from 4 to 8 would resolve this limitation.

Two sample projects are available in this configuration:

* :git-hdl:`projects/dmac_flock`
* :git-hdl:`projects/dmac_flock_fsync`

Both use a video test pattern generator to
create test frames that are pipelined through the the AXI DMAC in framelock mode
to a HDMI output.
The reader output is enable after the external sync signal is asserted.

The second, ``dmac_flock_fsync``, also includes a frame combiner.
The frame combiner mixes pixel data from two streams, and
in this configuration, it mixes the incoming stream with the synchronized reader
output.

The :git-linux:`drivers/media/platform/adi/adi-axi-fb.c` Linux driver is available
to setup the AXI DMACs, with the parameters defined at the
:git-linux:`devicetree bindings <Documentation/devicetree/bindings/media/adi,adi-axi-fb.yaml>`.
