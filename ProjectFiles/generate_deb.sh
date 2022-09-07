#!/usr/bin/env bash

PROJECT_NAME=""
PROJECT_BUILD_DIR=""

until [ -z "$1" ]; do
    case "$1" in
    -n | --name)
        PROJECT_NAME=$2
        shift 2
        ;;
    -d | --dir)
        PROJECT_BUILD_DIR=$2
        shift 2
        ;;
    -*)
        echo "Invalid argument"
        exit 1
        ;;
    esac
done