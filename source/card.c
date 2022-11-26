#include "gcn.h"
#include "sms.h"

bool loadCard(TCardManager *cm, CARDFileInfo *fileInfo, char *fileName, u32 *dst)
{
  // Mount the card
  if (!mount_(cm, 1))
    return -1;

  // Open the card
  if (!CARDOpen(cm->slot, fileName, fileInfo))
    return -1;

  // Too many codes
  if (fileInfo->length > (MEM1_END - (u32)dst))
    return -1;

  // Read codes into destination address
  if (CARDRead(fileInfo, dst, fileInfo->length, 0))
    return -1;

  // Done
  CARDClose(fileInfo);
  return 0;
}
