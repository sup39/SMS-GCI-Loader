#ifndef __SMS_H__
#define __SMS_H__

/** For NTSC-J 1.0:
 *
 * mount_    80107b50
 * open_     801072f4
 * CARDOpen  800a3cac
 * CARDRead  800a4640
 * CARDClose 800a3e24
 *
 * onReadOptionBlock 801069f4
 */

// static void *gpApplication = (void *)0x803e9700;
// static void *gpCardManager = (void *)0x8040a2b4;

typedef struct
{
  int slot;
} TCardManager;

int mount_(TCardManager *this, bool);
int open_(TCardManager *this, CARDFileInfo *fileInfo);

#endif