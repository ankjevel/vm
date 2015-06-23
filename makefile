OUT=build
TARGET=vm
SCHEME=vm
CONFIGURATION=Release
BIN=/usr/local/bin
LIB=/usr/local/lib

.PHONY: clean build all install uninstall

all: install

build:
	@xcodebuild -scheme $(SCHEME) -target $(TARGET) -configuration $(CONFIGURATION) SYMROOT=$(OUT) build

install: build
	@cp -r ./$(OUT)/$(CONFIGURATION)/ $(LIB)/$(TARGET)
	@ln -s $(LIB)/$(TARGET)/$(TARGET) $(BIN)/$(TARGET)

clean:
	@rm -rf $(OUT)/

uninstall:
	@rm -f $(BIN)/$(TARGET)
	@rm -rf $(LIB)/$(TARGET)
