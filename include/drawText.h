#include <stdint.h>

#ifndef __DRAW_H__
#define __DRAW_H__

typedef struct {
  int16_t x;
  int16_t y;
  uint32_t fontSize;
  uint32_t colorTop;
  uint32_t colorBot;
} DrawTextOpt;
void drawText(DrawTextOpt *opt, const char *fmt, ...);

#endif
