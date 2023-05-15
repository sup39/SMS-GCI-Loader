#include "gcn.h"
#include "sms.h"

#ifndef __CARD_H__
#define __CARD_H__

#define LOAD_ERR_MOUNT -1
#define LOAD_ERR_OPEN  -2
#define LOAD_ERR_SIZE  -3
#define LOAD_ERR_FILE_NOT_EXIST -4
#define LOAD_ERR_READ  -5
#define LOAD_STAT_INIT    0
#define LOAD_STAT_LOADING 1
#define LOAD_STAT_DONE    2
int loadCard(TCardManager *cm, CARDFileInfo *fileInfo, char *fileName, u32 *dst);

#endif
