typedef struct {
  char pad[20];
} CARDFileInfo;
typedef struct {
  int slot;
} TCardManager;

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

typedef int bool;
int mount_(TCardManager *this, bool);
int open_(TCardManager *this, CARDFileInfo*);
int CARDOpen(int slot, const char *fileName, CARDFileInfo*);
int CARDRead(CARDFileInfo *fileInfo, void *buf, unsigned long size, unsigned long offset);
int CARDClose(CARDFileInfo *fileInfo);

#define fileName "gct"
#define dst ((void*)0x817F0000)
#define size 0xE000 // 7 blocks
int onReadOptionBlock(TCardManager *this, CARDFileInfo *fileInfo) {
  int rc;
  // mount
  if ((rc = mount_(this, 1))) goto orig;

  // open file
  if ((rc = CARDOpen(this->slot, fileName, fileInfo))) {
    // TODO error handling
    // if (rc == -4) // file not exists
    goto orig;
  }

  // read file to memory
  if ((rc = CARDRead(fileInfo, dst, size, 0))) {
    // should not fail if (dst, size) is properly set
  } else {
    // everything is good => apply gecko code
    // TODO entry
    ((void(*)())0x817f4000)();
  }

  // close file
  CARDClose(fileInfo);

orig:
  // original function call
  return open_(this, fileInfo);
}
