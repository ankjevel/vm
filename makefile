TARGET=vm
SCHEME=vm
CONFIGURATION=Debug
BIN=/usr/local/bin
LIB=/usr/local/lib

.PHONY: all build clean install uninstall

all: install

build:
	@xcodebuild -scheme $(SCHEME) -target $(TARGET) -configuration $(CONFIGURATION) SYMROOT=$(LIB)/$(TARGET) build

clean:
	@rm -rf $(LIB)/$(TARGET)

install: build
	@ln -sf $(LIB)/$(TARGET)/$(CONFIGURATION)/$(TARGET) $(BIN)

uninstall:
	@rm -f $(BIN)/$(TARGET)
