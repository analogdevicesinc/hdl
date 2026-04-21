/*
 * AD4080 Helper - Arduino Data Reader
 *
 * Simple Arduino UNO program to read AD4080 data from FPGA helper via SPI
 * Outputs ASCII integers to serial for capture and analysis
 *
 * PMOD JB Connections:
 * JB1 (CS)         -> Arduino Pin 10
 * JB2 (SCK)        -> Arduino Pin 13
 * JB3 (MOSI)       -> Arduino Pin 11
 * JB4 (MISO)       -> Arduino Pin 12
 * JB7 (Data Ready) -> Arduino Pin 2
 * GND              -> Arduino GND
 * 3.3V             -> Arduino 3.3V (if level shifting needed)
 *
 * Usage:
 * 1. Upload to Arduino UNO
 * 2. Connect to serial terminal at 115200 baud
 * 3. Capture output: screen /dev/ttyACM0 115200 | tee ad4080_data.txt
 */

#include <SPI.h>

// Pin definitions for PMOD JB connections
const int DATA_READY_PIN = 2;   // JB7 - pmod_data_ready (input)
const int CS_PIN = 10;          // JB1 - pmod_spi_cs (output)
// SPI pins: MOSI=11 (JB3), MISO=12 (JB4), SCK=13 (JB2)

// SPI settings - 4 MHz, Mode 3, MSB first
SPISettings ad4080Settings(4000000, MSBFIRST, SPI_MODE3);

void setup() {
  // Initialize serial communication
  Serial.begin(115200);

  // Initialize SPI
  SPI.begin();

  // Setup pins
  pinMode(CS_PIN, OUTPUT);
  pinMode(DATA_READY_PIN, INPUT);

  // CS idle high
  digitalWrite(CS_PIN, HIGH);

  Serial.println("AD4080 Helper - Data Reader");
  Serial.println("Waiting for data...");
}

void loop() {
  // Check if data is ready (active low)
  if (digitalRead(DATA_READY_PIN) == LOW) {

    // Read 32-bit data from FIFO
    SPI.beginTransaction(ad4080Settings);
    digitalWrite(CS_PIN, LOW);

    // Read 4 bytes (32 bits) - MSB first
    uint32_t adcData = 0;
    adcData |= ((uint32_t)SPI.transfer(0x00)) << 24;
    adcData |= ((uint32_t)SPI.transfer(0x00)) << 16;
    adcData |= ((uint32_t)SPI.transfer(0x00)) << 8;
    adcData |= ((uint32_t)SPI.transfer(0x00));

    digitalWrite(CS_PIN, HIGH);
    SPI.endTransaction();

    // Send as ASCII integer to serial
    Serial.println(adcData);

    // Small delay to avoid overwhelming serial buffer
    delay(1);
  }
}