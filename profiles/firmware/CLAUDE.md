# Project: TODO_PROJECT_NAME

Firmware for TODO_DEVICE. PlatformIO + Arduino/ESP-IDF.

## Hardware
- MCU: TODO (e.g. ESP32-C6, STM32F4)
- Peripherals: TODO (sensors, displays, radios)
- Interfaces: TODO (I2C, SPI, UART, MQTT)

## Architecture
- src/          — application code
- lib/          — local libraries
- include/      — public headers
- test/         — native tests (Unity)

## Commands
- Build: `pio run`
- Flash: `pio run -t upload`
- Monitor: `pio device monitor -b 115200`
- Test single: `pio test -e native -f test_<name>`
- Test all: `pio test -e native`
- Clean: `pio run -t clean`

## Testing
- Framework: Unity (via PlatformIO native test runner)
- Run `pio test -e native` after every code change
- New modules require matching test_*.cpp in test/

## Code Style
- platformio.ini is the single source of truth for deps and build flags
- All config constants in a single header (e.g. src/config.h)
- MQTT topics: `device-name/sensor/<metric>`
- ISR handlers: minimal work, defer to task via queue

## Gotchas
- TODO: e.g. GPIO12 is strapping pin on ESP32, brownout on heavy WiFi TX, watchdog timeout in blocking loops

## Rules
- NEVER edit .pio/ directory — it's auto-generated
- NEVER use String concatenation in loops — use char[] or snprintf instead (RAM fragmentation)
- NEVER hardcode WiFi credentials — use config header or NVS
- Don't add lib_deps manually — edit platformio.ini

## Workflow
After completing any implementation task (code changes, config edits, multi-file work):
1. Spawn **@critic** agent in background — reviews changes for bugs, security, quality
2. Spawn **@observer** agent in background — verifies compliance with rules above
3. Report agent findings to the user before marking task done
Skip for trivial tasks (typo fixes, single-line edits, questions).
