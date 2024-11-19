.. _use_adi_ips:

Use ADI IPs into your own project
===============================================================================

Clone the GitHub repository:

.. shell::

   $git clone https://github.com/analogdevicesinc/hdl.git

Vivado
-------------------------------------------------------------------------------

Navigate to hdl/library and build all the libraries

.. shell::

   ~/hdl
   $make -C library all

Launch a Vivado GUI and open the Settings window. Go to IP section and expand it.
There you will find a section called Repository.
From here you can add the path to the library folder inside the ADI repository
you just cloned.

.. code:: bash

   <hdl_path>/hdl/library

Click apply and Ok to save the changes.
Wait for the IP Catalog to refresh and now you should be able to see the IPs there,
under User Repository/Analog Devices section.

Quartus
-------------------------------------------------------------------------------

Launch a Quartus GUI and select the Tools dropdown from the top menu.
Click the Options category.
From the pop-up window, select IP Catalog Search Locations and add the path to
the library folder inside the ADI repository you just cloned.

.. code:: bash

   <hdl_path>/hdl/library/**/*

Wait for the IP Catalog to refresh and now you should be able to see the IPs
under Library/Analog Devices.

JESD204
-------------------------------------------------------------------------------

Vivado
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For the JESD204 IP, it is not as straightforward as for other modules.
Here you have an example of an instantiation for this interface:
:git-hdl:`projects/daq2/common/daq2_bd.tcl`.
First, you will have to source the jesd204.tcl script, inside your
``<project>_bd.tcl``.

.. code:: tcl

   source $ad_hdl_dir/library/jesd204/scripts/jesd204.tcl

The following code is for the TX/DAC part. The RX/ADC is similar.

Add the PL (Physical Layer).

.. code-block::

   ad_ip_instance axi_adxcvr axi_ad9144_xcvr [list \
     NUM_OF_LANES $TX_NUM_OF_LANES \
     QPLL_ENABLE 1 \
     TX_OR_RX_N 1 \
   ]

Then you have to add the Data Link Layer with the desired number of lanes.
For RX you will swap this one with ``adi_axi_jesd204_rx_create``.

.. code:: tcl

   adi_axi_jesd204_tx_create axi_ad9144_jesd $TX_NUM_OF_LANES

Let's instantiate the TPL (Transport Layer). For RX you will swap this one with
``adi_tpl_jesd204_rx_create``.

.. code-block::

   adi_tpl_jesd204_tx_create axi_ad9144_tpl $TX_NUM_OF_LANES \
                                              $TX_NUM_OF_CONVERTERS \
                                              $TX_SAMPLES_PER_FRAME \
                                              $TX_SAMPLE_WIDTH \

You can optionally add the util_upack2 module for unpacking the data.
For RX you will swap this one with util_cpack2.

.. code-block::

   ad_ip_instance util_upack2 axi_ad9144_upack [list \
     NUM_OF_CHANNELS $TX_NUM_OF_CONVERTERS \
     SAMPLES_PER_CHANNEL $TX_SAMPLES_PER_CHANNEL \
     SAMPLE_DATA_WIDTH $TX_SAMPLE_WIDTH \
   ]

After you added the modules for RX and TX logic, you will have to link them
together with the util_adxcvr IP. This IP includes the shared transceiver core,
so it will appear only once per RX-TX pair.

.. code::

   ad_ip_instance util_adxcvr util_daq2_xcvr [list \
     RX_NUM_OF_LANES $MAX_RX_NUM_OF_LANES \
     TX_NUM_OF_LANES $MAX_TX_NUM_OF_LANES \
     QPLL_REFCLK_DIV 1 \
     QPLL_FBDIV_RATIO 1 \
     QPLL_FBDIV 0x30 \
     RX_OUT_DIV 1 \
     TX_OUT_DIV 1 \
     RX_DFE_LPM_CFG 0x0104 \
     RX_CDR_CFG 0x0B000023FF10400020 \
   ]

Add the reference clocks and resets.

.. code:: tcl

   ad_xcvrpll  tx_ref_clk_0 util_daq2_xcvr/qpll_ref_clk_*
   ad_xcvrpll  axi_ad9144_xcvr/up_pll_rst util_daq2_xcvr/up_qpll_rst_*

Almost done, now it is time to use the ``ad_xcvrcon`` to connect the pieces
together.

.. code:: tcl

   ad_xcvrcon  util_daq2_xcvr axi_ad9144_xcvr axi_ad9144_jesd {0 2 3 1} {} {} $MAX_TX_NUM_OF_LANES

Now just add the interconnects and the interrupts for the added layers (PL, TPL, LL).

.. code:: tcl

   ad_cpu_interconnect 0x44A60000 axi_ad9144_xcvr
   ad_cpu_interconnect 0x44A04000 axi_ad9144_tpl
   ad_cpu_interconnect 0x44A90000 axi_ad9144_jesd

.. code:: tcl

   ad_cpu_interrupt ps-10 mb-15 axi_ad9144_jesd/irq

SPI Engine
-------------------------------------------------------------------------------

Vivado
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The SPI Engine is a special module too, since it consists of more than one IP.
In order to use it into your own project, you will have to add all of its components.
For this example, the code shown here is from the ad4630_fmc project:
:git-hdl:`projects/ad4630_fmc/common/ad463x_bd.tcl`

Let's start with sourcing the spi_engine.tcl script inside your ``<project>_db.tcl``.

.. code:: tcl

   source $ad_hdl_dir/library/spi_engine/scripts/spi_engine.tcl

The SPI engine has 4 modules: execution, interconnect, regmap and offload.

All of the modules are instantiated inside the ``spi_engine_create`` function.
This function requires 13 parameters. The default values for them are as follow,
but feel free to configure it as you want:

.. code:: tcl

   {{name "spi_engine"} {data_width 32} {async_spi_clk 1} {num_cs 1} {num_sdi 1} {num_sdo 1} {sdi_delay 0} {echo_sclk 0} {cmd_mem_addr_width 4} {data_mem_addr_width 4} {sdi_fifo_addr_width 5} {sdo_fifo_addr_width 5} {sync_fifo_addr_width 4} {cmd_fifo_addr_width 4}}

An example of instantiation, using the default values for ``cmd_mem_addr_width``, ``data_mem_addr_width``, ``sdi_fifo_addr_width``, ``sdo_fifo_addr_width``, ``sync_fifo_addr_width`` and ``cmd_fifo_addr_width``:

.. code:: tcl

   #                 name         data_width async_spi_clk num_csn num_sdi     sdi_delay  echo_sclk
   spi_engine_create "spi_ad463x" 32         1             1       $NUM_OF_SDI 0          1
   ad_ip_parameter spi_ad463x/execution CONFIG.DEFAULT_SPI_CFG 1   ;

   ad_ip_parameter spi_ad463x/axi_regmap CONFIG.CFG_INFO_0 $NUM_OF_SDI
   ad_ip_parameter spi_ad463x/axi_regmap CONFIG.CFG_INFO_1 $CAPTURE_ZONE
   ad_ip_parameter spi_ad463x/axi_regmap CONFIG.CFG_INFO_2 $CLK_MODE
   ad_ip_parameter spi_ad463x/axi_regmap CONFIG.CFG_INFO_3 $DDR_EN
