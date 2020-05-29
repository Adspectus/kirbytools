#!/bin/bash
#
# kirbyconfigure by Uwe Gehring <adspectus@fastmail.com>

## Read settings and make sure all config files exist
[[ ! -f /etc/kirbytools/kirbyrc ]] && echo "File /etc/kirbytools/kirbyrc not found!" && exit 1
. /etc/kirbytools/kirbyrc

debMsg "Starting $(basename $0)"

echo -e "\n$(basename $0) - Define default values for kirbytools in $KIRBYUSERRC\n"

# Create KIRBYUSERRC. If it exists, ask for confirmation to overwrite it
if [ -f $KIRBYUSERRC ];then
  read -n1 -p "File $KIRBYUSERRC exists! Do you want to delete it and create a new one? [${txtblue}Y${txtrst}|n] "
  [[ -z $REPLY ]] || echo ""
  SEL=${REPLY:-y}
  if [ "$SEL" != "y" -a "$SEL" != "Y" ];then
    exit 0
  fi
fi

# Create KIRBYUSERRC
echo -e "## File: $KIRBYUSERRC\n## Variables for kirbytools scripts by Uwe Gehring <adspectus@fastmail.com>\n##\n## Default values in brackets\n" > $KIRBYUSERRC

# Ask first the KIRBYSUFFIX because it will be used in other variables
REGEX='^[A-Za-z0-9._%+-]+$'
while true;do
  read -p "The suffix \$KIRBYSUFFIX to be used for directories and filenames [${txtblue}kirby${txtrst}] "
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
    read -p "${_KIRBYDEFAULTVARTXT[$var]} [${txtblue}${_KIRBYDEFAULTVAR[$var]}${txtrst}] "
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
EOB

echo ""
read -n1 -p "${txtbld}Are you satisfied with above settings? [${txtrst}${txtblue}Y${txtrst}${txtbld}|n] ${txtrst}"
[[ -z $REPLY ]] || echo ""
SEL=${REPLY:-y}
if [ "$SEL" == "y" -o "$SEL" == "Y" ];then
  echo -e "\n${txtgreen}Configuration finished! Run '$(basename $0)' again if you wish to define new default values.${txtrst}\n"
  echo "  If you would like kirbytools to create virtual host configuration file(s) for you, add"
  echo "  template files in $KIRBYAPACHECONFDIR/templates with file names corresponding to the pattern"
  echo "  '$KIRBYSUFFIX-vhost-SOMETHING.template'. The kirbysetup script will pick up any template in"
  echo "  this directory, rename it to 'KIRBYVHOST-SOMETHING.conf', replace any placeholder to its"
  echo "  actual value and save the file in $KIRBYCONFAVAILABLEDIR."
  echo "  See kirbysetup(1) and the file README.templates in $KIRBYTOOLSPACKAGEDIR/examples"
  echo "  for further details."
else
  echo -e "\n${txtred}Configuration aborted! Run '$(basename $0)' again to define default values for kirbytools.${txtrst}"
  debMsg "Removing $KIRBYUSERRC and finish script"
  rm $KIRBYUSERRC
fi

exit 0
