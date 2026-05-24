[fix] WiFi AP IP showing 0.0.0.0 on OLED screen (editmode.cpp)
- Added deviceIP string to store correct IP per WiFi mode
- AP mode: switched to WiFi.softAPIP() + delay(500) before reading IP
- Client mode: keeps WiFi.localIP() as before
- All Logger::Info calls for HTTP/FTP now use deviceIP

[fix] Build error: SD_MMC hardcoded in wifiserver.cpp
- Line 915: replaced SD_MMC with PANDA_SD macro so it
  respects the PANDA_SD_MODE setting (SPI or MMC)

[feat] LED color and effect control from Settings menu (menu.lua)
- New modes: MODE_LED_COLOR (8), MODE_LED_EFFECT (9)
- Settings > "Led Color": adjust hue in real time with left/right,
  saves to NVS on confirm
- Settings > "Led Effect": choose from Fixed color, Pride, Rotate,
  Random, Fade cycle, Noise, Blink — saves to NVS on confirm
- Color and effect persist across reboots via dictSet/dictSave

[feat] LED config in hardware.json (hardware.json + init.lua)
- New "leds" section: count_1, count_2, default_hue, default_sat,
  default_val — edit here to change strip size or default color
- Default color: #e75b12 orange (HSV h=15, s=235, v=231)
- init.lua reads hardware.json at boot, applies saved effect/color
  from NVS or falls back to hardware.json defaults on first run