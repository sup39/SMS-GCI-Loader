CC := powerpc-eabi-gcc
CFLAGS := -O3 -I. -Wa,-mregnames,-mgekko -Wall -fno-asynchronous-unwind-tables -fno-unwind-tables -fverbose-asm -gdwarf

AS := powerpc-eabi-as
ASFLAGS := -mregnames -mgekko

OD := powerpc-eabi-objdump
ODFLAGS := -EB -D -b binary -m powerpc:750 -M gekko --full-content

LD := powerpc-eabi-ld
LDFLAGS := --unresolved-symbols=ignore-in-object-files --enable-non-contiguous-regions -EB --nmagic

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
OUT_LST := main.lst

GMSE01 := 1
GMSJ01 := 2
GMSP01 := 3
GMSJ0A := 4

TARGET_VERSION = $($(GAME_VERSION))

SRC_FILES := $(wildcard source/*.c)
OBJ_FILES := $(SRC_FILES:.c=.o)

OBJS := main.o card.o
blockCount := 7

all: $(OUT_DIR)/$(OUT_BIN) $(OUT_DIR)/$(OUT_LST)

$(OUT_DIR)/$(OUT_LST): $(OUT_DIR)/$(OUT_BIN)
	$(OD) $(ODFLAGS) $(OUT_DIR)/$(OUT_BIN) > $(OUT_DIR)/$(OUT_LST)

$(OUT_DIR)/$(OUT_BIN): $(OUT_DIR)/$(OUT_MAIN)
	$(OBJCOPY) -O binary $< $@

$(OUT_DIR)/$(OUT_MAIN): $(OBJ_FILES) $(LD_FILE) $(OUT_DIR)
	$(LD) $(LDFLAGS) -o $@ -T $(LD_FILE) -Map $(OUT_DIR)/$(OUT_MAP) $(OBJ_FILES)

$(OBJ_FILES): $(SRC_FILES) check-set-TARGET_VERSION
	$(CC) $(CFLAGS) -D VERSION=$(TARGET_VERSION) -I $(INC_DIR) -o $@ -c $(@:.o=.c)

$(OUT_DIR):
	mkdir -p $@

check-set-%:
		@ if [ "${${*}}" = "" ]; then \
				echo "Variable $* not set"; \
				exit 1; \
		fi

.PHONY: clean
clean:
	$(RM) -rv $(OUT_DIR) $(OBJ_FILES)