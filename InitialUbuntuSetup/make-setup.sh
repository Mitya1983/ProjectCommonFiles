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

WORKLAPTOP=0

until [ -z "$1" ]; do
    case "$1" in
    -w | --work-laptop)
        WORKLAPTOP=1
        shift 1
        ;;
    esac
done

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

printStatus "Checking for updates"
${SUDO} apt update
${SUDO} apt upgrade
${SUDO} apt full-upgrade
${SUDO} apt autoremove


VERSION=$(gnome-extensions version)
if [[ "${VERSION}" == "" ]]; then
    printStatus "Installing gnome-extensions"
    "${SUDO}" apt install gnome-shell-extensions
else
    printStatus "gnome-extensions already installed"
fi
printStatus "Enabling desktop-icons"
"${SUDO}" gnome-extensions enable desktop-icons@csoriano
printStatus "Enabling user-theme"
"${SUDO}" gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com
printStatus "Enabling ubuntu-appindicators"
"${SUDO}" gnome-extensions enable ubuntu-appindicators@ubuntu.com
printStatus "Enabling ubuntu-dock"
"${SUDO}" gnome-extensions enable ubuntu-dock@ubuntu.com

CURRENT_VALUE=$(gsettings get org.gnome.desktop.peripherals.touchpad send-events)

if [[ "${CURRENT_VALUE}" != "disabled-on-external-mouse" ]]; then
    printStatus "Enabling touch pad disabling on external mouse"
    "${SUDO}" gsettings set org.gnome.desktop.peripherals.touchpad send-events disabled-on-external-mouse
else
    printStatus "Touch pad disabling on external mouse already enabled"
fi

CURRENT_VALUE=$(gsettings get org.gnome.desktop.peripherals.keyboard numlock-state)

if [[ "${CURRENT_VALUE}" != "true" ]]; then
    printStatus "Setting numlock-state to true"
    "${SUDO}" gsettings set org.gnome.desktop.peripherals.keyboard numlock-state numlock-state true
else
    printStatus "Numlock-state already equals true"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock dock-fixed)

if [[ "${CURRENT_VALUE}" == "false" ]]; then
    printStatus "Setting doc-fixed to true"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed true
else
    printStatus "Dock-fixed already equals true"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock isolate-monitors)

if [[ "${CURRENT_VALUE}" == "false" ]]; then
    printStatus "Setting isolate-monitors to true"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock isolate-monitors true
else
    printStatus "Isolate-monitors already equals true"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock isolate-workspaces)

if [[ "${CURRENT_VALUE}" == "false" ]]; then
    printStatus "Setting isolate-workspaces to true"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock isolate-workspaces true
else
    printStatus "Isolate-workspaces already equals true"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock show-show-apps-button)

if [[ "${CURRENT_VALUE}" == "true" ]]; then
    printStatus "Setting show-show-apps-button to false"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock show-show-apps-button false
else
    printStatus "Show-show-apps-button already equals false"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock show-trash)

if [[ "${CURRENT_VALUE}" == "true" ]]; then
    printStatus "Setting show-trash to false"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock show-trash false
else
    printStatus "Show-trash already equals false"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen)

if [[ "${CURRENT_VALUE}" == "false" ]]; then
    printStatus "Setting autohide-in-fullscreen to true"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock autohide-in-fullscreen true
else
    printStatus "Autohide-in-fullscreen already equals true"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock dash-max-icon-size)

if [[ "${CURRENT_VALUE}" == "34" ]]; then
    printStatus "Setting dash-max-icon-size to 34"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 34
else
    printStatus "Dash-max-icon-size already equals 34"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock dock-position)

if [[ "${CURRENT_VALUE}" == "BOTTOM" ]]; then
    printStatus "Setting dock-position to BOTTOM"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
else
    printStatus "Dock-position already equals BOTTOM"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock force-straight-corner)

if [[ "${CURRENT_VALUE}" == "false" ]]; then
    printStatus "Setting force-straight-corner to true"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock force-straight-corner true
else
    printStatus "Force-straight-corner already equals true"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.dash-to-dock show-mounts)

if [[ "${CURRENT_VALUE}" == "true" ]]; then
    printStatus "Setting show-mounts to false"
    "${SUDO}" gsettings set org.gnome.shell.extensions.dash-to-dock show-mounts false
else
    printStatus "Show-mounts already equals false"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.desktop-icons show-home)

if [[ "${CURRENT_VALUE}" == "true" ]]; then
    printStatus "Setting show-home to false"
    "${SUDO}" gsettings set org.gnome.shell.extensions.desktop-icons show-home false
else
    printStatus "Show-home already equals false"
fi

CURRENT_VALUE=$(gsettings get org.gnome.shell.extensions.desktop-icons show-trash)

if [[ "${CURRENT_VALUE}" == "true" ]]; then
    printStatus "Setting show-trash to false"
    "${SUDO}" gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
else
    printStatus "Show-trash already equals false"
fi

CURRENT_VALUE=$(gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-down)

if [[ "${CURRENT_VALUE}" != "['<Super>Page_Down']" ]]; then
    printStatus "Setting switch-to-workspace-down to ['<Super>Page_Down']"
    "${SUDO}" gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Page_Down']"
else
    printStatus "Switch-to-workspace-down already equals <Super>Page_Down"
fi

CURRENT_VALUE=$(gsettings get org.gnome.desktop.wm.keybindings switch-to-workspace-up)

if [[ "${CURRENT_VALUE}" != "['<Super>Page_Up']" ]]; then
    printStatus "Setting switch-to-workspace-up to ['<Super>Page_Up']"
    "${SUDO}" gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-down "['<Super>Page_Up']"
else
    printStatus "Switch-to-workspace-up already equals <Super>Page_Up"
fi

CURRENT_VALUE=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type)

if [[ "${CURRENT_VALUE}" != "nothing" ]]; then
    printStatus "Setting sleep-inactive-ac-type to nothing"
    "${SUDO}" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type nothing
else
    printStatus "Sleep-inactive-ac-type already equals nothing"
fi

CURRENT_VALUE=$(gsettings get org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type)

if [[ "${CURRENT_VALUE}" != "nothing" ]]; then
    printStatus "Setting sleep-inactive-battery-type to nothing"
    "${SUDO}" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type nothing
else
    printStatus "Sleep-inactive-battery-type already equals nothing"
fi

CURRENT_VALUE=$(gsettings get org.gnome.desktop.interface show-battery-percentage)

if [[ "${CURRENT_VALUE}" != "true" ]]; then
    printStatus "Setting show-battery-percentage to true"
    "${SUDO}" gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type nothing
else
    printStatus "Show-battery-percentage already equals true"
fi

printStatus "Copying background image to /usr/share/backgrounds"
${SUDO} cp ./background_logo.jpg /usr/share/backgrounds/background_logo.jpg

printStatus "Setting background image"
${SUDO} gsettings set org.gnome.desktop.background picture-uri file:////usr/share/backgrounds/background_logo.jpg

${SUDO} apt update

printStatus "Setting up the terminal profile"
dconf load /org/gnome/terminal/legacy/profiles:/ <gnome-terminal-profiles.dconf
printStatus "Changing bashrc file"
cp -fv bashrc ~/.bashrc






if ! command microsoft-edge --version &>/dev/null; then
    printStatus "Installing Microsoft Edge"
    ${SUDO} add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main"
    ${SUDO} apt update
    ${SUDO} apt install microsoft-edge-stable
else
    printStatus "Microsoft Edge is already installed"
fi

if [[ ${WORKLAPTOP} == 1 ]]; then
    printStatus "Creating personal folders"
    if [[ ! -d ~/Personal ]]; then
        mkdir -v ~/Personal
    fi
    if [[ ! -d ~/Personal/Documents ]]; then
        mkdir -v ~/Personal/Documents
    fi
    if [[ ! -d ~/Personal/Downloads/ ]]; then
        mkdir -v ~/Personal/Downloads
    fi
    if [[ ! -d ~/Personal/Pictures ]]; then
        mkdir -v ~/Personal/Pictures
    fi
    if [[ ! -d ~/Personal/Projects ]]; then
        mkdir -v ~/Personal/Projects
    fi
    printStatus "Setting up transmission"
    cp -fv transmission_settings.json ~/.config/transmission/settings.json
fi

#CURRENT_VALUE=$(gsettings get org.gnome.settings-daemon.plugins.media-keys custom-keybindings)
##TODO: Get list values here and to check that needed key binding is not used or is not present
#CURRENT_VALUE="${CURRENT_VALUE#*[}"
#CURRENT_VALUE="${CURRENT_VALUE%]*}"
#
#printStatus "Current list of custom-keybindings is ${CURRENT_VALUE}"
#
#NEED_TO_CREATE_BINDING=1
#
#if [[ "${CURRENT_VALUE}" == "" ]]; then
#    KEY_BINDING_INDEX=0
#else
#    KEY_BINDING_INDEX=${CURRENT_VALUE//[^[:digit:]]/}
#    echo "${KEY_BINDING_INDEX}"
#    for ((i = 0; i < KEY_BINDING_INDEX; i++)); do
#        COMMAND=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybinding/custom"${i}" command)
#        echo "${COMMAND}"
#        BINDING=$(gsettings get org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybinding/custom"${i}" binding)
#        echo "${BINDING}"
#        if [[ "${COMMAND}" == "microsoft-edge --inprivate" ]]; then
#            printStatus "New private window is already set"
#            NEED_TO_CREATE_BINDING=0
#            break
#        fi
#
#        if [[ "${BINDING}" == "<Primary>Shift<m>" ]] || [[ "${BINDING}" == "<Primary><m>Shift" ]] || [[ "${BINDING}" == "Shift<Primary><m>" ]]; then
#            printStatus "Keybinding <Primary>Shift<m> is already used for another binding"
#            NEED_TO_CREATE_BINDING=0
#            break
#        fi
#    done
#fi
#
#if [[ ${NEED_TO_CREATE_BINDING} == 1 ]]; then
#    printStatus "Creating key-binding with index of ${KEY_BINDING_INDEX}"
#    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${KEY_BINDING_INDEX}/']"
#    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${KEY_BINDING_INDEX}/ name 'New Browser Private Window'
#    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${KEY_BINDING_INDEX}/ command 'microsoft-edge --inprivate'
#    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom${KEY_BINDING_INDEX}/ binding '<Shift><Primary><m>'
#fi
exit 0
