#!/bin/bash

die() {
    echo "$@" 1>&2
    exit 1
}

test_command() {
    command -v $1 >/dev/null 2>&1 || die "Command \"$1\" required but not found in PATH. Aborting."
}

install() {
    # Test for required commands
    test_command jq
    test_command iptables

    # Check for iptables owner match support
    [[ ! $( iptables -m owner --help 2>&1 >/dev/null ) ]] || die "Your iptables \
doesn't have \"owner\" match module support. For this solution to work \
you need to fix this first. "

    # Add group v2ray for gid matching in iptables
    groupadd v2ray &>/dev/null

    # Link the relevant files
    ln -s "${PWD}" /opt &>/dev/null
    ln -s /opt/v2ray-redir/routing /usr/bin/routing &>/dev/null
    ln -s /opt/v2ray-redir/systemd/v2ray.service.d /etc/systemd/system/ &>/dev/null
    cp /opt/v2ray-redir/systemd/v2ray-redir.service /etc/systemd/system/ &>/dev/null

    # Reload the daemon
    systemctl daemon-reload

    echo "Installation done."
}

uninstall() {
    # Remove the installed symlinks
    rm /usr/bin/routing &>/dev/null || die "error: not properly installed"
    rm /etc/systemd/system/v2ray-redir.service &>/dev/null || die "error: not properly installed"
    rm /etc/systemd/system/v2ray.service.d &>/dev/null || die "error: not properly installed"
    rm /opt/v2ray-redir &>/dev/null || die "error: not properly installed"

    # Reload the daemon
    systemctl daemon-reload

    echo "Uninstallation done."
    echo "The group \"v2ray\" created during installation may be removed if not"
    echo "used by other files and/or services on the system. If it's not needed"
    echo "anymore, remove it with:"
    echo ""
    echo "    groupdel v2ray"
}

[[ $( id -u ) == 0 ]] || die "fatal: must be ran as root"

if [[ "$1" == "install" ]] ; then
    install
elif [[ "$1" == "uninstall" ]] ; then
    uninstall
else
    die "usage: ${0} < install | uninstall >"
fi

