#!/bin/bash
#
# kirbyconfigure by Uwe Gehring <adspectus@fastmail.com>

## Read settings and make sure all config files exist
[[ ! -f /etc/kirbytools/kirbyrc ]] && echo "File /etc/kirbytools/kirbyrc not found!" && exit 1
. /etc/kirbytools/kirbyrc

debMsg "Starting $(basename $0)"

echo -e "\n${txtbld}$(basename $0) - Define default values for kirbytools in $KIRBYUSERRC${txtrst}\n"

# Create KIRBYUSERRC. If it exists, it will be overwritten
echo -e "## File: $KIRBYUSERRC\n## Variables for kirbytools scripts by Uwe Gehring <adspectus@fastmail.com>\n##\n## Default values in brackets\n" > $KIRBYUSERRC

# Ask first the KIRBYSUFFIX because it will be used in other variables
REGEX='^[A-Za-z0-9._%+-]+$'
while true;do
  read -p "${txtbld}The suffix \$KIRBYSUFFIX to be used for directories and filenames [${txtrst}${txtblue}kirby${txtrst}${txtbld}] ${txtrst}"
  SEL=${REPLY:-kirby}
  if [[ $SEL =~ $REGEX ]];then break;else errMsg "Invalid input: $SEL";fi
done
echo "# The suffix to be used for directories and filenames [kirby]" >> $KIRBYUSERRC
KIRBYSUFFIX=${REPLY:-kirby}
echo -e "KIRBYSUFFIX=\"$KIRBYSUFFIX\"\n" >> $KIRBYUSERRC

# Add additional variables which depend on this prefix/suffix to the default array
_KIRBYDEFAULTVAR["KIRBYDOWNLOADDIR"]="/usr/local/src/\$KIRBYSUFFIX"
_KIRBYDEFAULTVAR["KIRBYLIBDIR"]="/usr/local/lib/\$KIRBYSUFFIX"
_KIRBYDEFAULTVAR["KIRBYVHOSTROOT"]="$HOME/vhosts"

# Ask all _KIRBYDEFAULTVAR* variables and write settings into KIRBYUSERRC
for var in ${_KIRBYDEFAULT[@]};do
  while true;do
    read -p "${txtbld}${_KIRBYDEFAULTVARTXT[$var]} [${txtrst}${txtblue}${_KIRBYDEFAULTVAR[$var]}${txtrst}${txtbld}] ${txtrst}"
    SEL=${REPLY:-${_KIRBYDEFAULTVAR[$var]}}
    case "${_KIRBYDEFAULTVARTYPE[$var]}" in
      dir)
        if isValidDir "$SEL";then break;else errMsg "Invalid input: $SEL";fi
      ;;
      regex)
        REGEX=${_KIRBYDEFAULTVARREGEX[$var]}
        if [[ $SEL =~ $REGEX ]];then break;else errMsg "Invalid input: $SEL";fi
      ;;
      *)
        break
      ;;
    esac
  done
  echo "# ${_KIRBYDEFAULTVARTXT[$var]} [${_KIRBYDEFAULTVAR[$var]}]" >> $KIRBYUSERRC
  echo -e "$var=\"${REPLY:-${_KIRBYDEFAULTVAR[$var]}}\"\n" >> $KIRBYUSERRC
done

# Add more variables
cat << EOB >> $KIRBYUSERRC
# The directory where templates for configuration will be found [\$KIRBYAPACHECONFDIR/templates]
KIRBYTEMPLATEDIR="\$KIRBYAPACHECONFDIR/templates"

# The directory where apache vhost configuration files will be placed [\$KIRBYAPACHECONFDIR/sites-available]
KIRBYCONFAVAILABLEDIR="\$KIRBYAPACHECONFDIR/sites-available"

# The directory where apache vhost configuration files will be linked [\$KIRBYAPACHECONFDIR/sites-enabled]
KIRBYCONFENABLEDDIR="\$KIRBYAPACHECONFDIR/sites-enabled"

# Temporary directory where files will be unpacked [/tmp/\$KIRBYSUFFIX]
KIRBYTEMPDIR="/tmp/\$KIRBYSUFFIX"

# The vhost subdirectory where the document root will be [htdocs]
KIRBYHTDOCSDIR="htdocs"

# The vhost subdirectory where logfiles can be placed (if not /var/log/apache2) [logs]
#KIRBYLOGDIR="logs"
EOB

echo ""
read -n1 -p "${txtbld}Are you satisfied with above settings? [${txtrst}${txtblue}Y${txtrst}${txtbld}|n] ${txtrst}"
[[ -z $REPLY ]] || echo ""
SEL=${REPLY:-y}
if [ "$SEL" == "y" -o "$SEL" == "Y" ];then
  echo -e "\n${txtgreen}Configuration finished! Run '$(basename $0)' again if you wish to define new default values.${txtrst}\n"

  # Check if needed programs are installed
  for prg in basename cat cp curl dirname head jq ln ls mkdir mv pathchk php realpath rm sed sudo tar tr wget;do
    [[ ! $(which $prg) ]] && errMsg "Program '$prg' is not installed! Make sure to install it before using kirbytools!"
  done

  . $KIRBYUSERRC

  # Create directories if not exist
  for dir in $KIRBYDOWNLOADDIR $KIRBYLIBDIR $KIRBYTEMPDIR $KIRBYTEMPLATEDIR $KIRBYCONFAVAILABLEDIR $KIRBYCONFENABLEDDIR $KIRBYVHOSTROOT;do
    debMsg "save_mkdir $dir"
    save_mkdir "$dir"
  done

else
  echo -e "\n${txtred}Configuration aborted! Run '$(basename $0)' again to define default values for kirbytools."
  debMsg "Removing $KIRBYUSERRC and finish script"
  rm $KIRBYUSERRC
fi

exit 0
