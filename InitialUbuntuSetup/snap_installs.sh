#!/usr/bin/env bash

#TODO: Add Additional extensions to VSCode

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

if [[ ! -f /bin/snap/cmake ]]; then
    printStatus "Installing latest CMake using snap"
    ${SUDO} snap install cmake --classic
else
    printStatus "CMake is already installed"
    printStatus "Trying update"
    ${SUDO} snap refresh cmake
fi

if [[ ! -f /bin/snap/bitwarden ]]; then
    printStatus "Installing Bitwarden"
    ${SUDO} snap install bitwarden
else
    printStatus "Bitwarden is already installed"
    printStatus "Trying update"
    ${SUDO} snap refresh bitwarden
fi

if [[ ! -f /bin/snap/clion ]]; then
    printStatus "Installing CLion"
    ${SUDO} snap install clion --classic
else
    printStatus "CLion is already installed"
    printStatus "Trying update"
    ${SUDO} snap refresh clion
fi

if [[ ! -f /bin/snap/code ]]; then
    printStatus "Installing VSCode"
    ${SUDO} snap install code --classic
    printStatus "Installing C/C++ Extension Pack"
    code --install-extension ms-vscode.cpptools-extension-pack
    printStatus "Installing Better C++ syntax"
    code --install-extension jeff-hykin.better-cpp-syntax
    printStatus "Installing Code Spell Checker"
    code --install-extension streetsidesoftware.code-spell-checker
    printStatus "Installing Doxygen Documentation Generator"
    code --install-extension cschlosser.doxdocgen
    printStatus "Installing Git Extension Pack"
    code --install-extension donjayamanne.git-extension-pack
    printStatus "Installing Git Blame"
    code --install-extension waderyan.gitblame
    printStatus "Installing Git Graph"
    code --install-extension mhutchie.git-graph
    printStatus "Installing GitLense"
    code --install-extension eamodio.gitlens
    printStatus "Installing QML support"
    code --install-extension bbenoist.QML
    printStatus "Installing Shell Format"
    code --install-extension foxundermoon.shell-format
    printStatus "Installing ShellCheck"
    code --install-extension timonwong.shellcheck
    printStatus "Installing Bash Debug"
    code --install-extension rogalmic.bash-debug
else
    printStatus "VSCode is already installed"
    printStatus "Trying update"
    ${SUDO} snap refresh code
fi

if [[ ! -f /bin/snap/zoom-client ]]; then
    printStatus "Installing Zoom"
    ${SUDO} snap install zoom-client
else
    printStatus "Zoom is already installed"
    printStatus "Trying update"
    ${SUDO} snap refresh zoom-client
fi

if [[ ! -f /bin/snap/gimp ]]; then
    printStatus "Installing GIMP"
    ${SUDO} snap install gimp
else
    printStatus "GIMP is already installed"
    printStatus "Trying update"
    ${SUDO} snap refresh gimp
fi

if [[ ! -f /bin/snap/remmina ]]; then
    printStatus "Installing Remmina"
    ${SUDO} snap install remmina
else
    printStatus "Remmina is already installed"
    printStatus "Trying update"
    ${SUDO} snap refresh remmina
fi

if [[ ! -f /bin/snap/telegram-desktop ]]; then
    printStatus "Installing Telegram"
    ${SUDO} snap install telegram-desktop
else
    printStatus "Remmina is already installed"
    printStatus "Trying update"
    ${SUDO} snap refresh telegram-desktop
fi