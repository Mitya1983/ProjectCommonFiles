#!/usr/bin/env bash

PACKAGE_NAME=""
PACKAGE_VERSION=""
ARCHITECTURE=""
SECTION=""
PRIORITY=""
ESSENTIAL=""
MAINTAINER=""
DESCRIPTION=""
HOMEPAGE=""
BUILT_USING=""
INSTALL_DIR=""
LIB_INSTALL_DIR=""
INCLUDE_INSTALL_DIR=""
DEVELOPER_FOLDER_NAME=""
WORKING_DIR=""
PROJECT_SOURCE_DIR=""
INCLUDE_DIR=""
LIB_DIR=""
until [ -z "$1" ]; do
    case "$1" in
    -n | --name)
        PACKAGE_NAME=$2
        shift 2
        ;;
    -v | --version)
        PACKAGE_VERSION=$2
        shift 2
        ;;
    -a | --arch)
        ARCHITECTURE=$2
        shift 2
        ;;
    -s | --section)
        SECTION=$2
        shift 2
        ;;
    -p | --priority)
        PRIORITY=$2
        shift 2
        ;;
    -e | --essential)
        ESSENTIAL=$2
        shift 2
        ;;
    -m | --maintainer)
        MAINTAINER=$2
        shift 2
        ;;
    -d | --description)
        DESCRIPTION=$2
        shift 2
        ;;
    -h | --homepage)
        HOMEPAGE=$2
        shift 2
        ;;
    -b | --build-using)
        BUILT_USING=$2
        shift 2
        ;;
    -i | --install-dir)
        INSTALL_DIR=$2
        shift 2
        ;;
    -D | --developer-folder-dir)
        DEVELOPER_FOLDER_NAME=$2
        shift 2
        ;;
    -w | --working-dir)
        WORKING_DIR=$2
        shift 2
        ;;
    -I | --include-dir)
        INCLUDE_DIR=$2
        shift 2
        ;;
    -l | --library-dir)
        LIB_DIR=$2
        shift 2
        ;;
    -S | --source-dir)
        PROJECT_SOURCE_DIR=$2
        shift 2
        ;;
    -*)
        echo "Invalid argument"
        exit 1
        ;;
    esac
done

if [[ "${PACKAGE_NAME}" == "" ]]; then
    echo "Package name was not specified but is mandatory"
    exit 2
fi

if [[ "${PACKAGE_VERSION}" == "" ]]; then
    echo "Package version was not specified but is mandatory"
    exit 2
fi

if [[ "${ARCHITECTURE}" == "" ]]; then
    echo "Architecture was not specified but is mandatory"
    ARCHITECTURE=$(dpkg-architecture -qDEB_BUILD_ARCH)
    echo "Setting architecture to ${ARCHITECTURE}"
fi

if [[ "${PACKAGE_VERSION}" == "" ]]; then
    echo "Package version was not specified but is mandatory"
    exit 2
fi

if [[ "${MAINTAINER}" == "" ]]; then
    echo "Maintainer was not specified but is mandatory"
    exit 2
fi

if [[ "${DESCRIPTION}" == "" ]]; then
    echo "Description was not specified but is mandatory"
    exit 2
fi

if [[ "${PROJECT_SOURCE_DIR}" == "" ]]; then
    PROJECT_SOURCE_DIR=$(pwd)
    echo "Project source dir was set to ${PROJECT_SOURCE_DIR}"
fi

if [[ "${DEVELOPER_FOLDER_NAME}" == "" ]]; then
    echo "Developer folder name was not specified and global directory will be used"
fi

if [[ "${INSTALL_DIR}" == "" ]]; then
    echo "Install dir was not specified and the default /usr/lib and /usr/include will be used"
    LIB_INSTALL_DIR=usr/lib/"${DEVELOPER_FOLDER_NAME}"
    INCLUDE_INSTALL_DIR=usr/include/"${DEVELOPER_FOLDER_NAME}"
else
    if [[ ! -d "${INSTALL_DIR}" ]]; then
        echo "Install dir does not exists"
        exit 3
    fi
    INSTALL_DIR=$(readlink -f "${INSTALL_DIR}")
    LIB_INSTALL_DIR="${INSTALL_DIR}"/lib/"${DEVELOPER_FOLDER_NAME}"
    INCLUDE_INSTALL_DIR="${INSTALL_DIR}"/include/"${DEVELOPER_FOLDER_NAME}"
fi

echo "${LIB_INSTALL_DIR}"
echo "${INCLUDE_INSTALL_DIR}"


if [[ "${PROJECT_SOURCE_DIR}" == "" ]]; then
    PROJECT_SOURCE_DIR=$(pwd)
fi

if [[ "${INCLUDE_DIR}" == "" ]]; then
    INCLUDE_DIR="${PROJECT_SOURCE_DIR}/inc"
fi

if [[ "${LIB_DIR}" == "" ]]; then
    LIB_DIR="${PROJECT_SOURCE_DIR}/build"
fi

if [[ ! -d "${INCLUDE_DIR}" ]]; then
    echo "Source include dir does not exists"
    exit 4
fi

if [[ "${WORKING_DIR}" != "" ]]; then
    cd "${WORKING_DIR}" || exit 5
fi

PACKAGE_DEB_FOLDER="${PACKAGE_NAME}-deb"

if [[ ! -d "${PACKAGE_DEB_FOLDER}" ]]; then
    mkdir -v "${PACKAGE_DEB_FOLDER}" || exit 6
fi

if [[ ! -d "${PACKAGE_DEB_FOLDER}/DEBIAN" ]]; then
    mkdir -v "${PACKAGE_DEB_FOLDER}/DEBIAN" || exit 7
fi

cd "${PACKAGE_DEB_FOLDER}" || exit 8

if [[ ! -d "${LIB_INSTALL_DIR}" ]]; then
    mkdir -p -v "${LIB_INSTALL_DIR}" || exit 7
fi

if [[ ! -d "${INCLUDE_INSTALL_DIR}" ]]; then
    mkdir -p -v "${INCLUDE_INSTALL_DIR}" || exit 7
fi

#TODO: Copy lib files to lib folder
#TODO: Copy .hpp files to include folder
#TODO: Create symlink to libLog.so in /usr/lib if folder is different
#TODO: Generate findLog.cmake
#TODO: Copy generated findLog.cmake to common folder of CMake prefix path

exit 0
