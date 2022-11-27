CC := powerpc-eabi-gcc
CFLAGS := -D VERSION=${VERSION} -Os -I. -Wa,-mregnames,-mgekko -Wall -fno-asynchronous-unwind-tables -fno-unwind-tables

AS := powerpc-eabi-as
ASFLAGS := -mregnames -mgekko

OD := powerpc-eabi-objdump
ODFLAGS := -EB -D -b binary -m powerpc:750 -M gekko --full-content

LD := powerpc-eabi-ld
LDFLAGS := --unresolved-symbols=ignore-in-object-files

OBJCOPY := powerpc-eabi-objcopy
PYTHON := python3

SRC_DIR := source
INC_DIR := include
OUT_DIR := out
OBJ_DIR := obj

LD_FILE := sms.ld
OUT_MAP := main.map

OUT_MAIN := main.out
OUT_BIN := main.bin
OUT_ASM := main.asm

SRC_FILES := $(wildcard source/*.c)
OBJ_FILES := $(SRC_FILES:.c=.o)

OBJS := main.o card.o
blockCount := 7

all: $(OUT_DIR)/$(OUT_BIN) $(OUT_DIR)/$(OUT_ASM)

$(OUT_DIR)/$(OUT_ASM): $(OUT_DIR)/$(OUT_BIN)
	$(OD) $(ODFLAGS) $(OUT_DIR)/$(OUT_BIN) > $(OUT_DIR)/$(OUT_ASM)

$(OUT_DIR)/$(OUT_BIN): $(OUT_DIR)/$(OUT_MAIN)
	$(OBJCOPY) -O binary $< $@

$(OUT_DIR)/$(OUT_MAIN): $(OBJ_FILES) $(LD_FILE) $(OUT_DIR)
	$(LD) $(LDFLAGS) -o $@ -T $(LD_FILE) -Map $(OUT_DIR)/$(OUT_MAP) $(OBJ_FILES)

$(OBJ_FILES): $(SRC_FILES)
	$(CC) $(CFLAGS) -I $(INC_DIR) -o $@ -c $(@:.o=.c)

$(OUT_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	$(RM) -rv $(OUT_DIR) $(OBJ_FILES)