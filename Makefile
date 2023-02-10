MAKE := make

CC := powerpc-eabi-gcc
CFLAGS := -O3 -I. -Wa,-mregnames,-mgekko -Wall -fno-asynchronous-unwind-tables -fno-unwind-tables -fverbose-asm -gdwarf

AS := powerpc-eabi-as
ASFLAGS := -mregnames -mgekko

OD := powerpc-eabi-objdump
ODFLAGS := -EB -D -b binary -m powerpc:750 -M gekko -a -p -h -F --full-content
ODASMFLAGS := -EB -D -b binary -m powerpc:750 -M gekko --no-show-raw-insn --no-addresses

LD := powerpc-eabi-ld
LDFLAGS := --unresolved-symbols=ignore-in-object-files --enable-non-contiguous-regions -EB --nmagic

OBJCOPY := powerpc-eabi-objcopy
#OBJCOPYFLAGS = -O binary $(foreach e,$(LD_FILES),--add-gnu-debuglink=$e) --gap-fill 0x00 --pad-to 0x81800000
OBJCOPYFLAGS = -O binary $(foreach e,$(LD_FILES),--add-gnu-debuglink=$e)

PY := python3
BIN2GCT := $(PY) gecko/bin2gct.py

SRC_DIR := source
INC_DIR := include
LD_DIR := ldscript
OUT_DIR := out
OBJ_DIR := obj

GECKO_DIR := gecko
GECKO_OUT_DIR := out

OUT_MAP := main.map
OUT_MAIN := main.out
OUT_BIN := main.bin
OUT_LST := main.lst
OUT_ASM := main.asm
OUT_LOADER_TXT = loader.txt
OUT_LOADER_GCT = loader.gct

GMSE01 := 1
GMSJ01 := 2
GMSP01 := 3
GMSJ0A := 4

TARGET_VERSION = $($(GAME_VERSION))

SRC_FILES := $(wildcard source/*.c)
OBJ_FILES := $(SRC_FILES:.c=.o)
LD_FILES := $(LD_DIR)/sms.ld $(LD_DIR)/$(GAME_VERSION).ld
GECKO_FILE_LOADER := $(GECKO_DIR)/$(GECKO_OUT_DIR)/gecko-gosub.bin
GECKO_FILES := $(GECKO_FILE_LOADER) $(GECKO_DIR)/$(GECKO_OUT_DIR)/gecko-return.bin

OBJS := main.o card.o

all: $(OUT_DIR)/$(OUT_BIN) $(OUT_DIR)/$(OUT_LST) $(OUT_DIR)/$(OUT_ASM) $(OUT_DIR)/$(OUT_LOADER_TXT)

$(OUT_DIR)/$(OUT_ASM): $(OUT_DIR)/$(OUT_BIN)
	$(OD) $(ODASMFLAGS) $(OUT_DIR)/$(OUT_BIN) | grep -Pe "^\t(?!Address)" | sed 's/^\t//'  > $(OUT_DIR)/$(OUT_ASM)

$(OUT_DIR)/$(OUT_LST): $(OUT_DIR)/$(OUT_BIN)
	$(OD) $(ODFLAGS) $(OUT_DIR)/$(OUT_BIN) > $(OUT_DIR)/$(OUT_LST)

$(OUT_DIR)/$(OUT_BIN): $(OUT_DIR)/$(OUT_MAIN)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@

$(OUT_DIR)/$(OUT_MAIN): check-set-GAME_VERSION $(OBJ_FILES) $(LD_FILES) $(OUT_DIR)
	$(LD) $(LDFLAGS) -o $@ -T $(LD_FILES) -Map $(OUT_DIR)/$(OUT_MAP) $(OBJ_FILES)

$(OBJ_FILES): $(SRC_FILES) check-set-GAME_VERSION #check-set-TARGET_VERSION
	$(CC) $(CFLAGS) -D VERSION=$(TARGET_VERSION) -I $(INC_DIR) -o $@ -c $(@:.o=.c)

$(OUT_DIR)/$(OUT_LOADER_TXT): $(OUT_DIR)/$(OUT_BIN) $(OUT_DIR)/$(OUT_MAP) $(GECKO_FILE_LOADER) | $(OUT_DIR)
	$(BIN2GCT) hook:$(OUT_DIR)/$(OUT_MAP):$(OUT_DIR)/$(OUT_BIN):onReadOptionBlock C0:$(GECKO_FILE_LOADER) > $@
$(GECKO_FILES):
	$(MAKE) -C$(GECKO_DIR) OUT_DIR=$(GECKO_OUT_DIR) $(patsubst $(GECKO_DIR)/%,%,$@)

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
	$(MAKE) -C$(GECKO_DIR) $@
