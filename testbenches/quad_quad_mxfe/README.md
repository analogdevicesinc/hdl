This testbench purpose is to verify the functionality of two quad MxFE blocks built with the JESD framework.
Each quad MxFE block services four MxFE links having a combined 32 ADC and 32 DAC channels.

Having two quad MxFE blocks in parallel gives us 64 ADC and 64 DAC channels at the transport layer.

The testbench should demonstrate the requirement that all ADC channels at the transport layer from all links must be synchronized.
This means that all data generated simultaneously at the TX side will be aligned to the same clock edge at the RX side.
This is done through a loopback of the JESD lanes from Tx physical layer to Rx physical layer.

The Rx and Tx links both operate with similar link parameter so a loopback is possible.
On every DAC channel is sent an incremental pattern combined with the channel number.
The incremental pattern serves for checking the channel synchronization
while the channel number serves for channel identification.


# How to run testbench in GUI mode?

make MODE=gui
