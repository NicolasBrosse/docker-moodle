#!/bin/sh

read -p "Moodle verison (310/311/...) ? " version

# cleaning up
if [ -f "$PWD/tmp" ]; then
    rm -rf $PWD/tmp
fi

mkdir -p $PWD/app/moodle_data >/dev/null 2>&1
mkdir -p $PWD/tmp >/dev/null 2>&1

if [ ! -f "tmp/moodle.tar.gz" ]; then
    echo "Downloading Moodle version $version...\n"
    curl -o $PWD/tmp/moodle.tar.gz https://download.moodle.org/download.php/direct/stable$version/moodle-latest-$version.tgz
fi

if [ -f "$PWD/tmp/moodle.tar.gz" ]; then
    mkdir $PWD/app/src
    cd $PWD/tmp
    tar -zxvf moodle.tar.gz
    rm moodle.tar.gz
    ls $PWD/../app/src
    mv $PWD/moodle/* $PWD/../app/src
    rm -rf $PWD/moodle
fi
