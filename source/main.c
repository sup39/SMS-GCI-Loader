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
#define ADDR_GECKO_HEAP_SIZE 0x00001000
#define ADDR_GECKO_HEAP_END (ADDR_GECKO_HEAP_START + ADDR_GECKO_HEAP_SIZE)
#define PTR_FLG_LOADED (bool *)ADDR_GECKO_HEAP_END
#define GECKO_CODE_START (ADDR_GECKO_HEAP_END + sizeof(*PTR_FLG_LOADED))

void loadCodes(TCardManager *cm, CARDFileInfo *fileInfo)
{
  *PTR_FLG_LOADED = -1;

  if (loadCard(cm, fileInfo, FILENAME, (void *)GECKO_CODE_START))
    *PTR_FLG_LOADED = 0;
}

// int onReadOptionBlock(TCardManager *this, CARDFileInfo *fileInfo)
// {
//   if (*PTR_FLG_LOADED)
//     return open_(this, fileInfo);

//   loadCodes(this, fileInfo);
//   return open_(this, fileInfo);
// }
