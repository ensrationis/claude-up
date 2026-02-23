---
name: flash
description: Build and flash firmware to device
argument-hint: "[environment]"
disable-model-invocation: true
allowed-tools: Bash, Read
---
Build and flash firmware: $ARGUMENTS

1. Run `pio run` to build
2. If build succeeds, run `pio run -t upload`
3. Open monitor: `pio device monitor -b 115200`
4. Report build size (flash/RAM usage from build output)
