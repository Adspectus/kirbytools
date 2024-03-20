#!/bin/bash
#
# kirbyconfigure by Uwe Gehring <adspectus@fastmail.com>

## TODO
## Create temp file first, then move to real file or delete it

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
echo -e "## File: $KIRBYUSERRC\n## Variables for kirbytools scripts by Uwe Gehring <adspectus@fastmail.com>\n##\n## Default values in brackets\n" > $KIRBYUSERRC.tmp

# Ask first the KIRBYSUFFIX because it will be used in other variables
REGEX='^[A-Za-z0-9._%+-]+$'
while true;do
  read -p "The suffix \$KIRBYSUFFIX to be used for directories and filenames [${txtblue}kirby${txtrst}] "
  SEL=${REPLY:-kirby}
  if [[ $SEL =~ $REGEX ]];then break;else errMsg "Invalid input: $SEL";fi
done
echo "# The suffix to be used for directories and filenames [kirby]" >> $KIRBYUSERRC.tmp
KIRBYSUFFIX=${REPLY:-kirby}
echo -e "KIRBYSUFFIX=\"$KIRBYSUFFIX\"\n" >> $KIRBYUSERRC.tmp

# Add additional variables which depend on this prefix/suffix to the default array
_KIRBYDEFAULTVAR["KIRBYDOWNLOADDIR"]="/usr/local/src/\$KIRBYSUFFIX"
_KIRBYDEFAULTVAR["KIRBYLIBDIR"]="/usr/local/lib/\$KIRBYSUFFIX"

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
  echo "# ${_KIRBYDEFAULTVARTXT[$var]} [${_KIRBYDEFAULTVAR[$var]}]" >> $KIRBYUSERRC.tmp
  echo -e "$var=\"${REPLY:-${_KIRBYDEFAULTVAR[$var]}}\"\n" >> $KIRBYUSERRC.tmp
done

# Add more variables
cat << EOB >> $KIRBYUSERRC.tmp
# The directory where templates for configuration will be found [\$KIRBYAPACHECONFDIR/templates]
KIRBYTEMPLATEDIR="\$KIRBYAPACHECONFDIR/templates"

# The directory where apache configuration files will be placed [\$KIRBYAPACHECONFDIR/conf-available]
KIRBYCONFAVAILABLEDIR="\$KIRBYAPACHECONFDIR/conf-available"

# The directory where apache configuration files will be linked [\$KIRBYAPACHECONFDIR/conf-enabled]
KIRBYCONFENABLEDDIR="\$KIRBYAPACHECONFDIR/conf-enabled"

# The directory where apache vhost configuration files will be placed [\$KIRBYAPACHECONFDIR/sites-available]
KIRBYSITEAVAILABLEDIR="\$KIRBYAPACHECONFDIR/sites-available"

# The directory where apache vhost configuration files will be linked [\$KIRBYAPACHECONFDIR/sites-enabled]
KIRBYSITEENABLEDDIR="\$KIRBYAPACHECONFDIR/sites-enabled"

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
  mv $KIRBYUSERRC.tmp $KIRBYUSERRC
  chmod 600 $KIRBYUSERRC
  . $KIRBYUSERRC
  echo -e "\n${txtgreen}Configuration finished! Run '$(basename $0)' again if you would like to define new default values.${txtrst}\n"
#  echo "  Restart your webserver if you changed the values for the root directory of your virtual hosts"
#  echo "  or the root directory of your apache2 configuration files."
#  echo ""
  echo "If you would like kirbytools to create virtual host configuration file(s) for you, add"
  echo "template files in $KIRBYAPACHECONFDIR/templates with file names corresponding to the pattern"
  echo "'$KIRBYSUFFIX-vhost[SOMETHING].template'. The kirbysetup script will pick up any template in this"
  echo "directory, rename it to 'KIRBYVHOST[SOMETHING].conf', substitute any placeholder within to its"
  echo "actual value, and save the file in $KIRBYSITEAVAILABLEDIR."
  echo -e "\nSee kirbysetup(1) and $KIRBYTOOLSPACKAGEDIR/examples/README.templates for further details.\n"
  if [ -z $PHPBIN ];then
    echo -e "\nNOTE: Your PHP executable could not be found locally. To be able to create an admin user automatically,\n"
    echo "you must set PHPBIN in $KIRBYUSERRC either to a local PHP executable or a script,"
    echo "which will run PHP via i.e. 'docker'."
    echo -e "See $KIRBYTOOLSPACKAGEDIR/examples/createUserByDocker.sh for an example script.\n"
  fi
else
  echo -e "\n${txtred}Configuration aborted! Run '$(basename $0)' again to define default values for kirbytools.${txtrst}\n"
  debMsg "Removing $KIRBYUSERRC.tmp and finish script"
  rm $KIRBYUSERRC.tmp
fi

exit 0
