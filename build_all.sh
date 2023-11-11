#!/bin/bash

set -e

rootdir=$(cd "$(dirname "$0")"; cd ..; pwd)
output="$rootdir/dist"
version=$(grep -E "Version.+ string =" "$rootdir/lib/const.go" | cut -d"=" -f2 | xargs)

build_ossutil() {
    local os_type=$1
    local arch_type=$2
    local binary_name="ossutil${arch_type}"
    local zip_name="ossutil-$version-$os_type-$arch_type.zip"

    echo "Start build ossutil for $os_type on $arch_type"

    cd "$rootdir"
    env CGO_ENABLED=0 GOOS="$os_type" GOARCH="$arch_type" go build -o "$output/$binary_name"

    cd "$output"
    mkdir -p "ossutil-$version-$os_type-$arch_type"
    cp -f "$binary_name" "ossutil-$version-$os_type-$arch_type/ossutil"
    cp -f "$binary_name" "ossutil-$version-$os_type-$arch_type/ossutil64"
    rm -f "$binary_name"
    zip -r -m "$zip_name" "ossutil-$version-$os_type-$arch_type"

    echo "ossutil for $os_type on $arch_type built successfully"
}

build_ossutil "darwin" "amd64"
build_ossutil "darwin" "arm64"
build_ossutil "windows" "amd64"
build_ossutil "windows" "arm64"
build_ossutil "linux" "amd64"
build_ossutil "linux" "arm64"
build_ossutil "linux" "loong64"