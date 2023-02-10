AS := powerpc-eabi-as
ASFLAGS := -mregnames -mgekko

LD := powerpc-eabi-ld
LDFLAGS := --unresolved-symbols=ignore-in-object-files --enable-non-contiguous-regions -EB --nmagic

OBJCOPY := powerpc-eabi-objcopy
OBJCOPYFLAGS = -O binary

PY := python3
BIN2GCT := $(PY) bin2gct.py

LD_DIR := ../ldscript
LD_FILES := $(LD_DIR)/sms.ld

SRC_DIR := code
OUT_DIR := out

SRC_FILES := $(wildcard $(SRC_DIR)/*.s)
OBJ_FILES := $(SRC_FILES:.s=.o)
LDO_FILES := $(OBJ_FILES:.o=.ld.o)
OUT_TXT := $(patsubst $(SRC_DIR)/%.s,$(OUT_DIR)/%.txt,$(SRC_FILES))

all: $(OUT_TXT)

%.o: %.s
	$(AS) $(ASFLAGS) -o $@ -c $^
%.ld.o: %.o
	$(LD) $(LDFLAGS) -o $@ -T $(LD_FILES) $^
$(OUT_DIR)/%.bin: $(SRC_DIR)/%.ld.o | $(OUT_DIR)
	$(OBJCOPY) $(OBJCOPYFLAGS) $< $@
$(OUT_DIR)/%.txt: $(OUT_DIR)/%.bin | $(OUT_DIR)
	$(BIN2GCT) C0:$^ > $@

$(OUT_DIR):
	mkdir -p $@

.PHONY: clean
clean:
	$(RM) -rv $(OUT_DIR) $(OBJ_FILES) $(LDO_FILES)
