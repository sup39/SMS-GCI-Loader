#include "card.h"

// TODO: we need to keep some space to store this loader code
// #define DST_END ArenaHi
#define DST_END 0x817FE800

int loadCard(TCardManager *cm, CARDFileInfo *fileInfo, char *fileName, u32 *dst)
{
  int rc;

  // Mount the card
  if (mount_(cm, 1))
    return LOAD_ERR_MOUNT;

  // Open the card
  if ((rc = CARDOpen(cm->slot, fileName, fileInfo))) {
    return rc == -4 ? LOAD_ERR_FILE_NOT_EXIST : LOAD_ERR_OPEN;
  }

  // Too many codes
  // TODO fileInfo->length seems to be 0?
  // int fileSize = fileInfo->length;
  int fileSize = 0x2000 * 6;
  if (fileSize > (DST_END - (u32)dst))
    return LOAD_ERR_SIZE;

  // Read codes into destination address
  if (CARDRead(fileInfo, dst, fileSize, 0))
     return LOAD_ERR_READ;

  // Done
  CARDClose(fileInfo);
  return 0;
}
