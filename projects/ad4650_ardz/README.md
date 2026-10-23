# AD4650-ARDZ HDL Project

- Evaluation board product pages:
  - [EVAL-AD4650-ARDZ](https://www.analog.com/eval-ad4650-ardz)
  - [EVAL-AD4652-ARDZ](https://www.analog.com/eval-ad4652-ardz)
- System documentation:TO BE ADDED
- HDL project documentation:TO BE ADDED
- Evaluation board VIO: 3.3V

## Supported parts

| Part name                                  | Description                                                                         |
|--------------------------------------------|-------------------------------------------------------------------------------------|
| [AD4650](https://www.analog.com/ad4650)    | 8-Channel, 12-Bit, 1 MSPS Easy Drive Multiplexed SAR ADC with FIFO and Daisy-Chain SPI |
| [AD4652](https://www.analog.com/ad4652)    | 8-Channel, 16-Bit, 1 MSPS Easy Drive Multiplexed SAR ADC with FIFO and Daisy-Chain SPI |

Both parts are pin compatible and use the same evaluation board
(EVAL-AD465x-ARDZ, 02-100249-01 for AD4652, 02-100249-03 for AD4650), so a
single bitstream supports both. The SPI Engine uses 32-bit frames, which is
the native SPI frame of both devices; the 12-bit/16-bit result decoding is done
in software (see PROD_ID_L, register 0x0004: 0xA0 = AD4650, 0xA2 = AD4652).

## Building the project

Please enter the folder for the FPGA carrier you want to use and read the README.md.
