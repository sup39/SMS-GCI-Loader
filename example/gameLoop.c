#include <sms.h>

typedef struct {
  uint8_t qfsync : 2;
} CodeConfig;
extern CodeConfig config;

void _gameLoop(void *gamePad) {
  // original function
  TMarioGamePad_read(gamePad);

  // check the controller input
  uint16_t btn = JUTGamePad_mPadStatus.button;
  config.qfsync =
    btn == (PRESS_B | PRESS_DL) ? 2 : // 4x
    btn == (PRESS_B | PRESS_DR) ? 3 : // 8x
      0; // 1x
}
