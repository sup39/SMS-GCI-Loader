#ifndef __SMS_H__
#define __SMS_H__

typedef struct
{
  int slot;
} TCardManager;

int mount_(TCardManager *this, bool);
int open_(TCardManager *this, CARDFileInfo *fileInfo);

#endif
