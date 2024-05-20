.. _triple_buffer:

AXI DMAC in Triple Buffer configuration
================================================================================

To setup a pipeline in triple buffer configuration, two AXI DMAC needs to be
instantiated, one write and a reader.

The writer side is connected to an AXI-Stream interface and outputs to an
AXI Memory-Mapped memory.
The reader side is connected to an AXI Memory-Mapped interface and outputs to a
AXI-Stream memory.

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
