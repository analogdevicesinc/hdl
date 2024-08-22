.. _axi_fan_control:

AXI Fan Control
================================================================================

.. hdl-component-diagram::

The :git-hdl:`AXI Fan Control <library/axi_fan_control>` IP core
is a software programmable fan controller.
Its purpose is to control the fan used for the cooling of an AMD Xilinx Zynq
Ultrascale+ MPSoC without the need of any external temperature sensors.
To achieve this, the IP core uses the PL SYSMONE4 primitive to obtain the PL
temperature via the DRP interface. Based on the temperature readings, it then
outputs a PWM signal to control the fan rotation accordingly. The tacho signal
coming from the fan is also measured and evaluated to ensure that the RPM is
correct and the fan is working properly.

Features
--------------------------------------------------------------------------------

*  AXI Lite control/status interface
*  Allows interpolation by 10/100/1000/10000/100000 with filtering
*  Allows arbitrary zero-hold interpolation
*  Filtering is implemented by a 6-section CIC programmable rate filter and a
   compensation FIR filter.

Files
--------------------------------------------------------------------------------

.. list-table::
   :header-rows: 1

   * - Name
     - Description
   * - :git-hdl:`library/axi_fan_control/axi_fan_control.v`
     - Verilog source for the peripheral.

Block Diagram
--------------------------------------------------------------------------------

.. image:: block_diagram.svg
   :alt: AXI Fan Control block diagram
   :align: center

Configuration Parameters
--------------------------------------------------------------------------------

.. hdl-parameters::

   * - PWM_FREQUENCY_HZ
     - Frequency of the PWM signal
   * - ID
     - ID of the core instance
   * - INTERNAL_SYSMONE
     - Determines the source of the temperature information. ``0`` means
       temperature is read from 'temp_in' port.
   * - AVG_POW
     - Specifies the number of tacho measurements (``2^AVP_POW``) before
       averaging them. 7 is the highest possible value.
   * - TACHO_TOL_PERCENT
     - Tolerance of tacho thresholds when evaluating measurements.
   * - TACHO_T25
     - Nominal tacho period at 25% PWM.
   * - TACHO_T50
     - Nominal tacho period at 50% PWM.
   * - TACHO_T75
     - Nominal tacho period at 75% PWM.
   * - TACHO_T100
     - Nominal tacho period at 100% PWM.
   * - TEMP_00_H
     - Temperature threshold in degrees Celsius below which PWM should be 0%.
   * - TEMP_25_L
     - Temperature threshold in degrees Celsius above which PWM should be 25%.
   * - TEMP_25_H
     - Temperature threshold in degrees Celsius below which PWM should be 25%.
   * - TEMP_50_L
     - Temperature threshold in degrees Celsius above which PWM should be 50%.
   * - TEMP_50_H
     - Temperature threshold in degrees Celsius below which PWM should be 50%.
   * - TEMP_75_L
     - Temperature threshold in degrees Celsius above which PWM should be 75%.
   * - TEMP_75_H
     - Temperature threshold in degrees Celsius below which PWM should be 75%.
   * - TEMP_00_L
     - Temperature threshold in degrees Celsius above which PWM should be 100%.

Interface
--------------------------------------------------------------------------------

.. hdl-interfaces::

   * - temp_in
     - Input bus for use with System Management Wizzard IP.
   * - tacho
     - Tacho generator input.
   * - pwm
     - PWM control signal.
   * - irq
     - Interrupt signal, level high.
   * - s_axi
     - AXI Slave Memory Map interface.

Clocking
--------------------------------------------------------------------------------

The IP core runs on the AXI clock and requires a frequency of 100MHz.

Detailed Description
--------------------------------------------------------------------------------

The main features of this IP core are its independent operation and the fact
that it does not require an external temperature sensor. All of the mechanisms
contained inside the core are controlled by a state machine, so that they do not
depend on the software in case the software fails. The state machine uses the
temperature it reads from the SYSMONE4 primitive or via the "temp_in" bus to
decide the correct PWM duty-cycle. The temperature thresholds and hysteresis
have defaults set in hardware and can be modified by the software. The
INTERNAL_SYSMONE parameter is used to set the temperature values source, 0 when
reading from temp_in and 1 when instantiating the internal SYSMONE primitive.

Running independently
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The hardware can operate with no input from the software; the IP core starts
working after the bitstream is loaded, without needing to be brought out of
reset. To activate the interrupts, the software must write to the
IRQ_MASK register. At this point, the hardware starts operating and a minimal
feedback is provided.

There are 9 temperature intervals defined in the hardware as below:

.. image:: pwm_vs_temp.svg
   :alt: PWM vs Temperature

Five of these intervals have only one possible duty-cycle and four of them can
have either of the neighbouring values. After reset, the PWM duty-cycle will
start as 100%. The state-machine will begin reading the temperature and will
decide on the PWM duty cycle depending on which interval the value matches. The
PWM duty-cycle will only change when the temperature enters one of the five
intervals with a single PWM duty-cycle, while in the other four, the previous
duty-cycle will be maintained. In these intervals, its value will depend on
whether the temperature is rising or falling. The temperature can be
reconfigured by the software.

The temperature is obtained from the PL SYSMONE4 primitive as a 16-bit raw value
or from the temp_in bus as 10-bit.
The latest reading is in the TEMPERATURE register.
To keep the IP as light as possible, the temperature values obtained are used
as raw; they are not converted to Celsius. To convert to Celsius, the
following formula needs to be used:

Internal SYSMONE4 primitive: Temperature [C] = (ADC × 501.3743 / 2^bits) –
273.6777
(:xilinx:`ug580 <support/documentation/user_guides/ug580-ultrascale-sysmon.pdf>`).

Reading from temp_in: Temperature [C] = (ADC \*20 - 11195) / 41

There are five configurations described in the hardware, each with a
corresponding tacho period +/- 25% tolerance.

.. note::

   The tacho parameters are for a SUNON PF92251B1-000U-S99 fan.

.. list-table::
   :header-rows: 1

   - - PWM duty-cycle
     - Nominal tacho period
     - Tacho tolerance 25%
   - - 0%
     - N/A
     - N/A
   - - 25%
     - 32 ms
     - 8ms
   - - 50%
     - 12.8 ms
     - 3.2 ms
   - - 75%
     - 7.2 ms
     - 1.8 ms
   - - 100%
     - 6.4 ms
     - 1.6 ms

The hardware will evaluate the tacho signal based on the current PWM duty-cycle
by comparing the measured value with the interval's thresholds. *i.e. at 50%
duty-cycle the tacho period must stay within 9.6 ms and 16 ms.*

A time-out is also used to check if there is any tacho signal at all.

Software control and customization
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The software can overwrite the temperature thresholds and the tacho values if
needed. The TEMP_00_H -> TEMP_100_L registers can redefine the temperature
intervals and the TACHO_25 -> TACHO_100 registers can also be used to redefine
tacho values if a different fan is installed. In this case, the TACHO\_*_TOL
registers must also be written in order to provide tolerances. They must be
calculated by the software as % of the nominal value *(i.e. 20% of 10000 =
2000)*.

The software can also set a custom PWM duty-cycle by using the provided
registers. All the values inside the PWM/TACHO registers are in clock-cycle
periods. The software can provide custom tacho parameters for that desired PWM,
if it wants to continue to evaluate the tacho signal. The PWM period can be read
from the PWM_PERIOD register and is by default 20000.

*i.e. 5KHz -> 20000 \* 10 ns = 200 us*

The new PWM value must be greater or equal to the value selected by the hardware
and less or equal to the PWM period. The software can use the PWM_WIDTH and
PWM_PERIOD registers in order to make sure the new value is valid.

After requesting a new duty-cycle, there is a 5-second delay during which the
hardware waits for the fan rotation speed to stabilize. The software will then
have to provide parameters for the tacho signal in order for the hardware to be
able to evaluate it. To do this, the software will have to write the TACHO_PERIOD
and TACHO_TOLERANCE registers in that order. The software can read the
TACHO_MEASUREMENT register to obtain the new tacho period and derive the
tolerance value from it.

A measurement is performed by averaging 2^AVP_POW consecutive tacho period
measurements. The time needed to finish a measurement depends on the frequency
of the signal.

The software can now use this register to read the new tacho period and then
write it to the TACHO_PERIOD register. Then it can write a tolerance value to
the TACHO_TOLERANCE register. The hardware will only start to monitor the tacho
signal when the tolerance is provided.

Interrupts
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The fan controller supports interrupts to both inform the software of any
possible errors and to facilitate the control of the core. There are four
interrupt sources:

* The ``PWM_CHANGED`` interrupt is generated at the end of the 5-second delay
  after a PWM duty-cycle change request. The request can come either from the
  software or from the hardware.
* The ``TEMP_INCREASE`` occurs when the hardware requests a higher PWM width
  than the curret one, indicating a rise in temperature.
* ``NEW_TACHO_MEASUREMENT`` is asserted when a tacho measurement cycle is
  completed and the value is written to the TACHO_MEASUREMENT register.
  The software can use this interrupt in the process where it requests a new PWM
  width to obtain tacho information.
* The ``TACHO_ERR`` interrupt is generated when the tacho signal either fails to
  stay within its designated frequency interval or does not toggle at all for 5
  seconds.

Register Map
--------------------------------------------------------------------------------

.. hdl-regmap::
   :name: AXI_FAN_CONTROL

References
--------------------------------------------------------------------------------

* HDL IP core at :git-hdl:`library/axi_fan_control`
* :dokuwiki:`AXI FAN CONTROL on wiki <resources/fpga/docs/axi_fan_control>`
* :xilinx:`7 Series libraries <support/documentation/sw_manuals/xilinx2016_2/ug953-vivado-7series-libraries.pdf>`
