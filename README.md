# VM
VM is a command line tool for VMWare Fusion, where it allows the user to run <br/>`msbuild` from osx. It does so by creating a script inside the virtual windows <br/>image, runs it and reads the output.

## Available commands
* -task (-t)
    - set default msbuild task
    - default: `/t:build`
* -property (-p)
    - msbuild properties for task
    - default: `/property:Configuration=Debug`
* -solution (-s)
    - solution file to build (enter windows path)
    - ex: `C:\Dev\Project\Project.sln`
* -user (-u)
    - user in guest vm
* -password (-p)
    - password for user
* -msbuild (-m)
    - msbuild.exe location
    - default: `C:\Program Files (x86)\MSBuild\12.0\bin\MSBuild.exe`
* -y
    - always enter `yes` when prompted
* -n
    - always enter `no` when prompted
* -clear (-c)
    - clear Core Data saves
* -m
    - prints a help message


### To run the build from the command-line
```bash
make
```
