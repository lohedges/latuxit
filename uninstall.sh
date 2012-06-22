#!/bin/bash
# uninstall script for LaTuXiT, see README for details

# Checks for root permission.
if test "`id -u`" -ne 0
	then
	echo "Please run the uninstaller with sudo."
	exit
fi

echo " Uninstalling..."

# Uninstall latuxit script.
if [ -f /usr/local/bin/latuxit ]; then
	rm /usr/local/bin/latuxit
fi

# Uninstall man page.
if [ -f /usr/local/man/man1/latuxit.1.gz ]; then
	rm /usr/local/man/man1/latuxit.1.gz
fi

# Remove latuxit directory tree.
if [ -d ~/.latuxit ]; then
	rm -r ~/.latuxit
fi

echo " Done."
