#!/usr/bin/env bash
# uninstall script for LaTuXiT, see README for details

# Set installation prefix.
if [ ! -n "${PREFIX:-}" ]; then
    PREFIX=/usr/local
fi

# Checks for root permission.
if test "$(id -u)" -ne 0; then
    echo "Please run the uninstaller as root."
    exit
fi

echo -n " Uninstalling..."

# Uninstall latuxit script.
if [ -f $PREFIX/bin/latuxit ]; then
    rm $PREFIX/bin/latuxit
fi

# Uninstall man page.
if [ -f $PREFIX/man/man1/latuxit.1.gz ]; then
    rm $PREFIX/man/man1/latuxit.1.gz
fi

# Remove latuxit directory tree.
if [ -d ~/.latuxit ]; then
    rm -r ~/.latuxit
fi

echo -e " \e[00;32mDone.\e[00m"
