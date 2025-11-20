# Utility: GO Make Environment

A Bash script that creates a local Go environment (folder + go init) and a utility Makefile

----

Run the script as follows:

```bash
./gomakeenv.sh <folder>
```

This creates the <folder>, runs ```go mod init``` in that folder, creates a basic main.go starter file, and a utility Makefile.

The Makefile supports the following commands:

* **make**: shows the help menu
* **make run**: runs ```go run ./...```
* **make build**: performs a clean/fmt/vet and then builds
* **make build-small**: performs a clean/fmt/vet and then builds, stripping out the additional debug information and symbol table

The ```build``` and ```build-small``` commands also take the following additional arguments:

* FILE=filename              --> outputs to the specified filename (defaults to 'test')
* COMPILE=linux-amd64        --> builds for Linux AMD64
* COMPILE=linux-arm64        --> builds for Linux ARM64
* COMPILE=darwin-amd64       --> builds for Darwin AMD64
* COMPILE=darwin-arm64       --> builds for Darwin ARM64
* COMPILE=windows-amd64      --> builds for Windows AMD64
