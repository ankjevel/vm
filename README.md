# VM
VM is a command line tool for VMWare Fusion, where it allows the user to run <br/>`msbuild` from osx. It does so by creating a script inside the virtual windows <br/>image, runs it and reads the output.

## Available command line arguments
### MSBuild related

**-t** *--task*
* set default msbuild task
* default: `/t:build`

**-p** *--property*
* msbuild properties for task
* default: `/property:Configuration=Debug`

**-s** *--solution*
* solution file to build (enter windows path)
* ex: `C:\Dev\Project\Project.sln`

**-u** *--user*
* user in guest vm

**-p** *--password*
* password for user

**-m** *--msbuild*
* msbuild.exe location
* default: `C:\Program Files (x86)\MSBuild\12.0\bin\MSBuild.exe`

### Global options

**-i** *--image*
* select a specific image
* will match if name CONTAINS this string

**-y**
* always enter `yes` when prompted

**-n**
* always enter `no` when prompted

**-c** *--clear*
* clear Core Data saves

**-h**
* prints a help message

### To run the build from the command-line
```bash
make
```
