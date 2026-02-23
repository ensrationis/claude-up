# Project: TODO_PROJECT_NAME

Firmware for TODO_DEVICE. PlatformIO + Arduino/ESP-IDF.

## Hardware
- MCU: TODO (e.g. ESP32-C6, STM32F4)
- Peripherals: TODO (sensors, displays, radios)
- Interfaces: TODO (I2C, SPI, UART, MQTT)

## Commands
- Build: `pio run`
- Flash: `pio run -t upload`
- Monitor: `pio device monitor -b 115200`
- Test (native): `pio test -e native`
- Clean: `pio run -t clean`

## Structure
- src/          — application code
- lib/          — local libraries
- include/      — public headers
- test/         — native tests (Unity)

## Conventions
- platformio.ini is the single source of truth for dependencies and build flags
- All config constants in a single header (e.g. src/config.h)
- MQTT topics: `device-name/sensor/<metric>`
- ISR handlers: minimal work, defer to task via queue

## Rules
- NEVER edit .pio/ directory contents
- NEVER use String concatenation in loops (RAM fragmentation)
- NEVER hardcode WiFi credentials — use config header or NVS
- Don't add lib_deps without checking platformio.ini first
