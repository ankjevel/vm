OUT=build
TARGET=vm
SCHEME=vm
CONFIGURATION=Release

all: xcode

xcode:
	xcodebuild -scheme $(SCHEME) -target $(TARGET) -configuration $(CONFIGURATION) SYMROOT=$(OUT) build
	@echo "executable is located in ./$(OUT)/$(CONFIGURATION)/$(TARGET)"

.PHONY: clean

clean:
	rm -rf $(OUT)/
