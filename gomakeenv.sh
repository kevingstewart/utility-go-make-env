#!/bin/bash

## Simple utility to create a Go project
## usage: gomakeenv.sh poject_name

if [ -z "$1" ]
then
    echo "Must enter project name: 'gomakeenv.sh project_name'"
    exit 1
fi
if [ -d "./$1" ]
then
    echo "Project directory already exists: $1"
    exit 1
fi

## Create directory
mkdir $1 && cd $1

## Create Makefile
cat > "Makefile" << 'EOF'
## default target if none specified
.DEFAULT_GOAL := default

ARCH := $(shell go version | sed -e 's/go version go.* //')
FILE?=test

## PHONY indicates that following are not file targets
.PHONY: clean fmt vet build run default
.SILENT: clean fmt vet build run default

## target: clean
clean:
	go clean

## target: fmt
fmt: clean
	go fmt ./...

## target: vet (fmt runs before)
vet: fmt
	go vet ./...

## target build (vet runs before)
build: vet clean
	## go build -o $(FILE)
	if [ ! -z "$(COMPILE)" ]; then \
		if [ "$(COMPILE)" == "linux-amd64" ]; then \
			echo "Compiling for linux amd64"; \
			GOOS="linux" GOARCH="amd64" go build -o $(FILE); \
		elif [ "$(COMPILE)" == "linux-arm64" ]; then \
			echo "Compiling for linux arm64"; \
			GOOS="linux" GOARCH="arm64" go build -o $(FILE); \
		elif [ "$(COMPILE)" == "darwin-amd64" ]; then \
			echo "Compiling for darwin amd64"; \
			GOOS="darwin" GOARCH="amd64" go build -o $(FILE); \
		elif [ "$(COMPILE)" == "darwin-arm64" ]; then \
			echo "Compiling for darwin arm64"; \
			GOOS="darwin" GOARCH="arm64" go build -o $(FILE); \
		elif [ "$(COMPILE)" == "windows-amd64" ]; then \
			echo "Compiling for windows amd64"; \
			GOOS="windows" GOARCH="amd64" go build -o $(FILE); \
		else \
			echo "Compiling for default architecture"; \
			go build -o $(FILE); \
		fi \
	else \
		echo "Compiling for default architecture: $(ARCH)"; \
		go build -o $(FILE); \
	fi

## target build (vet runs before)
build-small: vet clean
	## go build -ldflags "-w -s" -o $(FILE)
	if [ ! -z "$(COMPILE)" ]; then \
		if [ "$(COMPILE)" == "linux-amd64" ]; then \
			echo "Compiling for linux amd64"; \
			GOOS="linux" GOARCH="amd64" go build -ldflags "-w -s" -o $(FILE); \
		elif [ "$(COMPILE)" == "linux-arm64" ]; then \
			echo "Compiling for linux arm64"; \
			GOOS="linux" GOARCH="arm64" go build -ldflags "-w -s" -o $(FILE); \
		elif [ "$(COMPILE)" == "darwin-amd64" ]; then \
			echo "Compiling for darwin amd64"; \
			GOOS="darwin" GOARCH="amd64" go build -ldflags "-w -s" -o $(FILE); \
		elif [ "$(COMPILE)" == "darwin-arm64" ]; then \
			echo "Compiling for darwin arm64"; \
			GOOS="darwin" GOARCH="arm64" go build -ldflags "-w -s" -o $(FILE); \
		elif [ "$(COMPILE)" == "windows-amd64" ]; then \
			echo "Compiling for windows amd64"; \
			GOOS="windows" GOARCH="amd64" go build -ldflags "-w -s" -o $(FILE); \
		else \
			echo "Compiling for default architecture: $(ARCH)"; \
			go build -ldflags "-w -s" -o $(FILE); \
		fi \
	else \
		echo "Compiling for default architecture"; \
		go build -ldflags "-w -s" -o $(FILE); \	
	fi

## target run
run:
	go run ./...

default:
	printf "$(ARCH) \nUsage:\n make run\t\t\t--> test run go code\n make build\t\t\t--> clean/fmt/vet/build go binary\n make build-small\t\t--> clean/fmt/vet/build go binary (small)\n\n Optional 'make build' parameters:\n\n   FILE=filename\t\t--> defaults to 'test'\n   COMPILE=linux-amd64\t\t--> builds for Linux AMD64\n   COMPILE=linux-arm64\t\t--> builds for Linux ARM64\n   COMPILE=darwin-amd64\t\t--> builds for Darwin AMD64\n   COMPILE=darwin-arm64\t\t--> builds for Darwin ARM64\n   COMPILE=windows-amd64\t--> builds for Windows AMD64\n\n\n"
EOF

## Create initial main.go
cat > "main.go" << 'EOF'
package main

import (
	"fmt"
)

func main() {
	fmt.Println()
}
EOF

## Init go module
go mod init $1
