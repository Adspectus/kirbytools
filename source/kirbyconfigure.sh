#!/bin/bash
#
# kirbyconfigure by Uwe Gehring <uwe@imap.cc>
#
# This script checks and reads the configuration files.
# If $HOME/.kirbyrc file already exists, it will be left untouched.
# If not, the $HOME/.kirbyrc will be created and the user is asked
# about the values of all KIRBYDEFAULT* variables in /etc/kirbytools/kirbyrc.
# All variables will then be written into $HOME/.kirbyrc

# These are the main configuration files which must exist (in /etc/kirbytools)
KIRBYRC="/etc/kirbytools/kirbyrc"
KIRBYRC2="/etc/kirbytools/kirbyrc2"
KIRBYFUNC="/etc/kirbytools/kirbyfunctions"

[[ ! -f $KIRBYRC ]] && echo "File $KIRBYRC not found!" && exit 1
[[ ! -f $KIRBYRC2 ]] && echo "File $KIRBYRC2 not found!" && exit 1
[[ ! -f $KIRBYFUNC ]] && echo "File $KIRBYFUNC not found!" && exit 1

# This is the personal configuration file which will be created if it does not exist
KIRBYUSERRC="$HOME/.kirbyrc"

if [ ! -f $KIRBYUSERRC ];then
# Read main configuration file to get the variables to configure
. $KIRBYRC
  echo -e "\n${txtbld}First setup! Define your personal defaults which will be saved in $KIRBYUSERRC!${txtrst}\n"
# Create KIRBYUSERRC
  echo -e "## File: $KIRBYUSERRC\n## Variables for kirby* shell scripts by Uwe Gehring <uwe@imap.cc>\n##\n## Default values in brackets\n" > $KIRBYUSERRC
# Ask all _KIRBYDEFAULTVAR* variables and write settings into KIRBYUSERRC
  for var in ${!_KIRBYDEFAULTVAR[@]};do
    read -p "${txtbld}${_KIRBYDEFAULTVARTXT[$var]} [${txtrst}${txtblue}${_KIRBYDEFAULTVAR[$var]}${txtrst}${txtbld}] ${txtrst}"
    echo "# ${_KIRBYDEFAULTVARTXT[$var]} [${_KIRBYDEFAULTVAR[$var]}]" >> $KIRBYUSERRC
    echo -e "$var=\"${REPLY:-${_KIRBYDEFAULTVAR[$var]}}\"\n" >> $KIRBYUSERRC
  done

  echo -e "\n${txtgreen}First setup finished! Delete $KIRBYUSERRC if you would like to run this program again.${txtrst}\n"
fi

exit 0
## code: language=bash