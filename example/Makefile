CC = powerpc-eabi-gcc
AS = powerpc-eabi-as
LD = powerpc-eabi-ld
OBJCOPY = powerpc-eabi-objcopy
CFLAGS = -Os -I. -Wa,-mregnames,-mgekko -Wall -fno-asynchronous-unwind-tables -fno-unwind-tables
ASFLAGS = -mregnames -mgekko
PYTHON = python3

OBJS = _start.o gameLoop.o qfsync.o
LDFILE = sms.ld
MAPOUT = gci.map

GCI = 01-GMSJ-gct.gci
OBJOUT = a.out
OBJBIN = a.bin
blockCount = 7

all: $(GCI)

$(GCI): $(OBJBIN)
	$(PYTHON) make-gci.py $(blockCount) $< $@

$(OBJOUT): $(OBJS) | $(LDFILE)
	$(LD) -o $@ -T $(LDFILE) -Map $(MAPOUT) $^
$(OBJBIN): $(OBJOUT)
	$(OBJCOPY) -O binary $^ $@


.PHONY: clean
clean:
	rm -f *.gci*.out *.bin *.o *.map
