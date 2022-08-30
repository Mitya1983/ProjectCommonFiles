#!/usr/bin/env bash

printStatus() {
    #if [[ $VERBOSE == true ]]; then
    printf "[STATUS] %s\n" "${1}"
    #fi
}

printError() {
    printf "[ERROR] %s\n" "${1}"
}

printWarning() {
    printf "[WARNING] %s\n" "${1}"
}

SUDO=""

if [[ $EUID != 0 ]]; then
    SUDO="sudo"
fi

if ! command curl --version &>/dev/null; then
    printStatus "Curl is not installed but needed for this script"
    printStatus "Installing Curl"
    ${SUDO} apt install curl
fi

INTERNET_STATUS=$(curl http://www.msftncsi.com/ncsi.txt)
if [[ "${INTERNET_STATUS}" != "Microsoft NCSI" ]]; then
    printError "Internet is not present\nExiting"
    exit 0
fi

if [[ -f llvm.sh ]]; then
    printStatus "Removing llvm.sh"
    rm llvm.sh
fi

printStatus "Downloading clang installer"
wget https://apt.llvm.org/llvm.sh

LATEST_CLANG_VERSION=$(awk -F'=' '/^CURRENT_LLVM_STABLE/ {print $2}' llvm.sh)
printStatus "Latest clang version is ${LATEST_CLANG_VERSION}"

if ! command clang-"${LATEST_CLANG_VERSION}" -v &>/dev/null; then
    printStatus "Latest clang version is not present"
    printStatus "Installing llvm-${LATEST_CLANG_VERSION}"
    chmod +x "$(pwd)"/llvm.sh
    ${SUDO} "$(pwd)"/llvm.sh
else
    printStatus "Latest clang version is already installed"
fi
