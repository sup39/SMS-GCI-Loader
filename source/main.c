#include "gcn.h"
#include "card.h"

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
