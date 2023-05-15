#include <stdarg.h>
#include "typedefs.h"
#include "gcn.h"

#ifndef __SMS_H__
#define __SMS_H__

typedef struct
{
  int slot;
} TCardManager;

int mount_(TCardManager *this, bool);
int open_(TCardManager *this, CARDFileInfo *fileInfo);

typedef struct TApplication {
  struct TApplication *self;
  void *director;
  u8 directorType;
} TApplication;
extern TApplication gpApplication;

// Render related
extern struct {} *gpSystemFont;
typedef float Mtx[3][4];
typedef struct {
  void* __vt__;
  char unk[0x1c-4];
  int xInt;
  int yInt;
  float xFloat;
  float yFloat;
  float zFloat;
  char unk1[12];
  uint32_t bgMask;
  uint32_t fgMask;
  uint32_t colorTop;
  uint32_t colorBot;
  int x4c;
  int lineHeight;
  int x54;
  int fontWidth;
  int fontHeight;
  char unk3[8];
} J2DPrint;

void new_J2DPrint(void *this, void *font, int x4c, int lineHeight, uint32_t *colorTop, uint32_t *colorBot);
// color.alpha = printer->color.alpha * alphaMask/0xff
void J2DPrint_print_alpha_va(void *printer, uint8_t alphaMask, const char *fmt, va_list args);

#endif
