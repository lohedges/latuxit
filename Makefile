# LaTuXiT Makefile

# Copyright (c) 2012-2016  Lester Hedges <lester.hedges+latuxit@gmail.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This Makefile can be used to setup and install LaTuXiT. For detailed
# information on using the Makefile run make without a target, i.e.
# simply run make at your command prompt.
#
# Makefile style adapted from http://clarkgrubb.com/make-file-style-guide
# Conventions:
#   - Environment and Makefile variables are in upper case, user
#     defined variables are in lower case.
#   - Variables are declared using the immediate assignment operator :=

############################### MACROS ########################################

define colorecho
	if [[ -t 1 ]]; then	\
		tput setaf $1;	\
		echo $2;        \
		tput sgr0;      \
	else				\
		echo $2;        \
	fi
endef

define boldcolorecho
	if [[ -t 1 ]]; then	\
		tput bold;      \
		tput setaf $1;	\
		echo $2;        \
		tput sgr0;      \
	else				\
		echo $2;        \
	fi
endef

############################## VARIABLES ######################################

# Set shell to bash.
SHELL := bash

# Suppress display of executed commands.
.SILENT:

# Default goal will print the help message.
.DEFAULT_GOAL := help

# Installation path.
PREFIX := /usr/local

############################### TARGETS #######################################

# Print help message.
.PHONY: help
help:
	$(call boldcolorecho, 4, "About")
	@echo " This Makefile can be used to setup and install LaTuXiT."
	@echo
	$(call boldcolorecho, 4, "Targets")
	@echo " help       -->  print this help message"
	@echo " setup      -->  setup the LaTuXiT configuration files and user directories"
	@echo " clean      -->  remove user configuration files and equation library"
	@echo " install    -->  install LaTuXiT"
	@echo " uninstall  -->  uninstall LaTuXiT"
	@echo
	$(call boldcolorecho, 4, "Dependencies")
	@echo " LaTuXiT requires md5 (or md5sum), pdflatex, pdfcrop, and gs (optional)."
	@echo
	$(call boldcolorecho, 4, "Installing")
	@echo " First setup the configuration files and user directory"
	@echo "     make setup"
	@echo
	@echo " Then install the executable and man page"
	@echo "     make install"
	@echo
	@echo " By default LaTuXiT is installed to /usr/local so you may need root"
	@echo " privileges for the install step above."
	@echo
	$(call boldcolorecho, 4, "Tips")
	@echo " To set a different installation path run"
	@echo "     make PREFIX=path install"

# Create the user workspace directories and copy across configuration files.
.PHONY: setup
setup:
	$(call colorecho, 6, "--> Creating user directory and configuration files")
	if [ ! -d ~/.latuxit ]; then                       \
		mkdir -p ~/.latuxit/library;                   \
	fi
	if [ ! -f ~/.latuxit/latuxit.colors ]; then        \
		cp latuxit.colors ~/.latuxit;                  \
	fi

# Clean user workspace directory.
.PHONY: clean
clean:
	$(call colorecho, 6, "--> Cleaning user directory and configuration files")
	echo -n " Are you sure you want to remove the user directory [Y/n]? "
	read -e clean;                                                              \
	while [[ "$$clean" != "Y" && "$$clean" != "n" && "$$clean" != "N" ]]; do    \
		echo -n " Are you sure you want to remove the user directory [Y/n]? ";	\
		read -e clean;                                                          \
	done;                                                                       \
	if [[ "$$clean" == "Y" ]]; then                                             \
		rm -rf ~/.latuxit;                                                      \
	fi

# Install executable and man page.
.PHONY: install
install:
	$(call colorecho, 3, "--> Installing LaTuXiT executable to $(PREFIX)/bin")
	if [ -d $(PREFIX)/bin ]; then                       \
		install -Dm755 latuxit $(PREFIX)/bin;           \
	else                                                \
		echo " $(PREFIX)/bin doesn't exist!";           \
	fi
	$(call colorecho, 3, "--> Installing LaTuXiT man page to $(PREFIX)/man/man1")
	if [ -d $(PREFIX)/man/man1 ]; then                  \
		install -Dm644 latuxit.1 $(PREFIX)/man/man1;	\
		gzip -9f $(PREFIX)/man/man1/latuxit.1;          \
	else                                                \
		echo " $(PREFIX)/man/man1 doesn't exist!";      \
	fi

# Uninstall the executable and man page.
.PHONY: uninstall
uninstall:
	$(call colorecho, 3, "--> Uninstalling LaTuXiT executable from $(PREFIX)/bin")
	$(call colorecho, 3, "--> Uninstalling LaTuXiT man page from $(PREFIX)/man/man1")
	rm -f $(PREFIX)/bin/latuxit
	rm -f $(PREFIX)/man/man1/latuxit.1.gz

.PHONY: sandwich
sandwich:
	if [ "$$(id -u)" != "0" ]; then                        \
		echo " What? Make it yourself."                   ;\
	else                                                   \
		echo "                      ____"                 ;\
		echo "          .----------'    '-."              ;\
		echo "         /  .      '     .   \\"            ;\
		echo "        /        '    .      /|"            ;\
		echo "       /      .             \ /"            ;\
		echo "      /  ' .       .     .  || |"           ;\
		echo "     /.___________    '    / //"            ;\
		echo "     |._          '------'| /|"             ;\
		echo "     '.............______.-' /"             ;\
		echo "     |-.                  | /"              ;\
		echo "     \`\"\"\"\"\"\"\"\"\"\"\"\"\"-.....-'"  ;\
	fi;                                                    \
