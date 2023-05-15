#include "gcn.h"
#include "card.h"
#include "drawText.h"

#if VERSION == 1
#define FILENAME "GCT_GMSE01"
#elif VERSION == 2
#define FILENAME "GCT_GMSJ01"
#elif VERSION == 3
#define FILENAME "GCT_GMSP01"
#elif VERSION == 4
#define FILENAME "GCT_GMSJ0A"
#endif

// Memory space reserved for Gecko codes to store their state
// data, based on the current usage
// See: https://github.com/BitPatty/gctGenerator/blob/375ba5eb73e50894d4e765fdfddbe004e3b4949d/Readme.md#reserved-memory
// Range: 0x817F0000 - 0x817F1000
#define ADDR_GECKO_HEAP_START 0x817F0000
#define ADDR_GECKO_HEAP_SIZE  0x00001000
#define ADDR_GECKO_HEAP_END (ADDR_GECKO_HEAP_START + ADDR_GECKO_HEAP_SIZE)
// GCTDST = 0x817F1000; // in ldscripts/sms.ld

extern struct GCTBuffer {
  // =0: initialized
  // >0: Loading(1), Done(2)
  // <0: error
  int status;
  // return address to the original Gecko handler
  void *returnAddr;
  // actual Gecko code
  u32 code[0];
} GCTDST;

#define GCT_LOAD_LOADING 1
#define GCT_LOAD_DONE 2

void loadCodes(TCardManager *cm, CARDFileInfo *fileInfo)
{
  GCTDST.status = GCT_LOAD_LOADING;
  // load card
  int rc = loadCard(cm, fileInfo, FILENAME, GCTDST.code);
  GCTDST.status = rc == 0 ? GCT_LOAD_DONE : rc; // DONE or Error code
}

int onReadOptionBlock(TCardManager *this, CARDFileInfo *fileInfo)
{
  if (GCTDST.status <= 0) // Initialized(=0) or Error(<0)
    loadCodes(this, fileInfo);
  return open_(this, fileInfo);
}

// TODO better hook address?
// e.g. hook after fader.draw() (but also avoid conflict with controller display)
void JUTRect_set(void *r3, u32 r4, u32 r5, u32 r6, u32 r7);
void willDrawFader(void *r3, u32 r4, u32 r5, u32 r6, u32 r7) {
  JUTRect_set(r3, r4, r5, r6, r7);

  // do not show GCI status until boot finished
  if (gpApplication.directorType < 4) return;
  DrawTextOpt opt = {
    .x = 16,
    .y = 440,
    .fontSize = 32,
    .colorTop = 0xff3333bb,
    .colorBot = 0xff3333bb
  };
  switch (GCTDST.status) {
    case LOAD_ERR_MOUNT:
      drawText(&opt, "Fail to mount memory card");
      break;
    case LOAD_ERR_OPEN:
      drawText(&opt, "Fail to open GCI file: "FILENAME);
      break;
    case LOAD_ERR_SIZE:
      drawText(&opt, "GCI file too large: "FILENAME);
      break;
    case LOAD_ERR_FILE_NOT_EXIST:
      drawText(&opt, "GCI file not exists: "FILENAME);
      break;
    case LOAD_ERR_READ:
      drawText(&opt, "Fail to read GCI file");
      break;
    case LOAD_STAT_INIT:
      drawText(&opt, "Preparing to load GCI file...");
      break;
    case LOAD_STAT_LOADING:
      drawText(&opt, "Loading GCI file...");
      break;
    case LOAD_STAT_DONE:
      break;
    default:
      drawText(&opt, "Unknown GCI Error: %d", GCTDST.status);
      break;
  }
}
