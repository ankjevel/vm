# VM

To run the build from the command-line:

```bash
xcodebuild -scheme vm -configuration Release build
```

If you don't want it to be built into `build/`, specify the
destination, as such (where `~/temp/` is the destination):

```bash
xcodebuild -scheme vm -target vm -configuration Release SYMROOT=~/temp/ build
```