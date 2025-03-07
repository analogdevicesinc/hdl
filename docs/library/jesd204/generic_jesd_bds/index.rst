.. _generic_jesd_bds:

Generic JESD204 block designs
===============================================================================

Using the generic building blocks from the
:ref:`ADI IP library <library>`, together with the
:ref:`JESD framework <jesd204>`, parametrizable block designs can be built to
interface ADI ADCs and DACs in various JESD modes.

Link parameters
-------------------------------------------------------------------------------

========= ===============================================
Parameter Description
========= ===============================================
L         Number of lanes
M         Number of converters
F         Octets per Frame per Lane
S         Samples per Converter per Frame
NP/N'     Total number of Bits per Sample
N         Converter Resolution
K         Frames per Multiframe
HD        High Density User Data Format
E         Number of multiblocks in an extended multiblock
========= ===============================================

.. important::

   In JESD links, the following equations must hold:
   
   .. math::
   
      M * S * NP = L * F * 8
      
   or

   .. math::

      \frac{M}{L} = \frac{F}{s} * \frac{8}{NP}

Changing the link parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Usually, projects are built and configured to exercise the ADC/DAC devices at
maximum capability using all available lanes --- this corresponds to a single
JESD operation mode.

To switch to other modes, the generic block designs can be reconfigured by
changing its parameters. These parameters map to the JESD link parameters.
See the example below taken from
:git-hdl:`this block design <projects/adrv9009/common/adrv9009_bd.tcl>`:

.. code-block:: tcl

   # TX parameters
   set TX_NUM_OF_LANES 4      ; # L
   set TX_NUM_OF_CONVERTERS 4 ; # M
   set TX_SAMPLES_PER_FRAME 1 ; # S
   set TX_SAMPLE_WIDTH 16     ; # N/NP
    
   set TX_SAMPLES_PER_CHANNEL 2 ; # L * 32 / (M * N)

.. caution::

   Changing the parameters "number of lanes" requires updating the top-level
   file and the constraints file as well! If the number of lanes is reduced,
   both files must be updated to remove references to the unused lanes.

