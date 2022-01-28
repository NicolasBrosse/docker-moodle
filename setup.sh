#!/bin/sh

# arguments validation
if [ ! $1 ]; then
    read -p "Moodle verison (310/311/...) ? " version
else
    version=$1
fi

# cleaning up
if [ -f "$PWD/tmp" ]; then
    rm -rf $PWD/tmp
fi

ROOTDIR=$PWD

mkdir -p $PWD/app/moodle_data >/dev/null 2>&1
mkdir -p $PWD/app/src >/dev/null 2>&1
mkdir -p $PWD/tmp >/dev/null 2>&1

if [ ! -f "tmp/moodle.tar.gz" ]; then
    echo "Downloading Moodle version $version...\n"
    curl -o $PWD/tmp/moodle.tar.gz https://download.moodle.org/download.php/direct/stable$version/moodle-latest-$version.tgz
fi

if [ -f "$PWD/tmp/moodle.tar.gz" ]; then
    cd $PWD/tmp
    tar -zxvf moodle.tar.gz
    rm moodle.tar.gz
    mv $PWD/moodle/* $PWD/../app/src
    rm -rf $PWD/moodle
fi

if [ ! -f "$PWD/.env" ]; then
    cd $ROOTDIR
    cp $PWD/.env-sample $PWD/.env
fi