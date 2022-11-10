#ifndef SMS_H
#define SMS_H

#include <stdint.h>

void TMarioGamePad_read(void*);

typedef struct {
  uint16_t button;
  int8_t stickX;
  int8_t stickY;
  int8_t substickX;
  int8_t substickY;
  uint8_t triggerLeft;
  uint8_t triggerRight;
  uint8_t analogA;
  uint8_t analogB;
  int8_t err;
} PADStatus;
extern PADStatus JUTGamePad_mPadStatus;
#define PRESS_START 0x1000
#define PRESS_Y     0x0800
#define PRESS_X     0x0400
#define PRESS_B     0x0200
#define PRESS_A     0x0100
#define PRESS_L     0x0040
#define PRESS_R     0x0020
#define PRESS_Z     0x0010
#define PRESS_DU    0x0008
#define PRESS_DD    0x0004
#define PRESS_DR    0x0002
#define PRESS_DL    0x0001

#endif
