#!/usr/bin/env bash
# installer script for LaTuXiT, see README for details

# Checks for root permission.
if test "`id -u`" -ne 0; then
    echo "Please run the installer as root."
    exit
fi

# Assign dependencies.
if [[ `uname` == "Darwin" ]]; then
    deps=(md5 pdflatex pdfcrop gs)
else
    deps=(md5sum pdflatex pdfcrop gs)
fi

# Check dependencies.
echo -n " Checking dependencies..."
for pkg in ${deps[@]}; do
    command -v $pkg >/dev/null 2>&1 || { echo -e "\n\t\e[1;34m\"$pkg\"\e[00m not found. \e[0;31mAborting.\e[00m" >&2; exit 1; }
done
echo -e " \e[00;32mPassed.\e[00m"

echo -n " Installing..."

# Install script.
if [ ! -d /usr/local/bin ]; then
    mkdir -p /usr/local/bin
fi
if [[ `uname` == "Darwin" ]]; then
    install -g 0 -o 0 -m 0755 latuxit /usr/local/bin/latuxit
else
    install -Dm755 latuxit /usr/local/bin/
fi

# Install man page.
if [ ! -d /usr/local/man ]; then
    mkdir -p /usr/local/man
fi
if [ ! -d /usr/local/man/man1 ]; then
    mkdir -p /usr/local/man/man1
fi
if [[ `uname` == "Darwin" ]]; then
    install -g 0 -o 0 -m 0644 latuxit.1 /usr/local/man/man1/latuxit.1
else
    install -Dm644 latuxit.1 /usr/local/man/man1/
fi
gzip -f /usr/local/man/man1/latuxit.1

# Set up latuxit directory tree if it doesn't exist.
if [ ! -d ~/.latuxit ]; then
    mkdir -p ~/.latuxit
fi

if [ ! -d ~/.latuxit/library ]; then
    mkdir -p ~/.latuxit/library
fi

if [ ! -f ~/.latuxit/latuxit.colors ]; then
    cp latuxit.colors ~/.latuxit/latuxit.colors
fi

user=`logname 2>&1 /dev/null`

if [ $? -ne 0 ]; then
    user=$SUDO_USER
fi

# Change latuxit directory permissions.
if [[ `uname` == "Darwin" ]]; then
    chown -R ${user}:staff ~/.latuxit
else
    chown -R ${user}:users ~/.latuxit
fi

echo -e " \e[00;32mDone.\e[00m"
