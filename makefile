OUT=build
TARGET=vm
CONFIGURATION=Release
BIN=/usr/local/bin
LIB=/usr/local/lib

.PHONY: all build clean install uninstall

all: install

build:
	@xcodebuild -target $(TARGET) -configuration $(CONFIGURATION) SYMROOT=$(OUT) build

clean:
	@rm -rf $(OUT)
	@echo "removed $(OUT)"

install: build
	@mkdir -p $(LIB)/$(TARGET)
	@cp -f $(OUT)/$(CONFIGURATION)/$(TARGET) $(LIB)/$(TARGET)/$(TARGET)
	@ln -sf $(LIB)/$(TARGET)/$(TARGET) $(BIN)
	@echo "created symlink $(LIB)/$(TARGET)/$(TARGET) <-> $(BIN)/$(TARGET)"

uninstall:
	@rm -f $(BIN)/$(TARGET)
	@rm -rf $(LIB)/$(TARGET)
	@echo "removed $(BIN)/$(TARGET) and $(LIB)/$(TARGET)/"
