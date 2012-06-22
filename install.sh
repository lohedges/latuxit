#!/bin/bash
# installer script for LaTuXiT, see README for details

# Checks for root permission.
if test "`id -u`" -ne 0
	then
	echo "Please run the installer with sudo."
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
	command -v $pkg >/dev/null 2>&1 || { echo -e "\n\t\"$pkg\" not found. Aborting." >&2; exit 1; }
done
echo " Passed."

echo -n " Installing..."

# Install script.
if [ ! -d /usr/local/bin ]; then
	mkdir /usr/local/bin
fi
if [[ `uname` == "Darwin" ]]; then
	install -g 0 -o 0 -m 0755 latuxit /usr/local/bin/latuxit
else
	install -Dm755 latuxit /usr/local/bin/
fi

# Install man page.
if [ ! -d /usr/local/man/man1 ]; then
	mkdir /usr/local/man/man1
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

if [ ! -d ~/.latuxit/cache ]; then
	mkdir -p ~/.latuxit/cache
fi

if [ ! -f ~/.latuxit/latuxit.colors ]; then
	cp latuxit.colors ~/.latuxit/latuxit.colors
fi

# Change latuxit directory permissions.
user=`logname`
if [[ `uname` == "Darwin" ]]; then
	chown -R $user:staff ~/.latuxit
else
	chown -R $user:users ~/.latuxit
fi

echo " Done."
