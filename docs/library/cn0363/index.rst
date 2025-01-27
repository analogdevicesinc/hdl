.. _cn0363_lib:

CN0363
================================================================================

The CN0363 library is comprised by two IPs:

- :doc:`cn0363_dma_sequencer`
- :doc:`cn0363_phase_data_sync`

:git-hdl:`CN0363 DMA Sequencer <library/cn0363/cn0363_dma_sequencer>` core acts
as a link between the CN0363 processing pipeline and the connected DMA
controller. :git-hdl:`CN0363 Phase Data Sync <library/cn0363/cn0363_phase_data_sync>`
core assembles the raw ADC sample data into a 24-bit word and converts it into
two's complement format.

.. toctree::
   :maxdepth: 2
   :hidden:
   :glob:

   *
