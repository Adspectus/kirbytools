#!/bin/bash
#
# kirbysetup by Uwe Gehring <adspectus@fastmail.com>

## Read settings and make sure all config files exist
[[ ! -f /etc/kirbytools/kirbyrc ]] && echo "File /etc/kirbytools/kirbyrc not found!" && exit 1
. /etc/kirbytools/kirbyrc

[[ ! -f $KIRBYUSERRC ]] && errMsg "File $KIRBYUSERRC not found! Run 'kirbyconfigure' to define default values for kirbytools in $KIRBYUSERRC!" && exit 1

debMsg "Starting $(basename $0)"

## Initialize settings
initKirbySetup

## Usage
usage() {
  echo ""
  echo "  Usage:"
  echo ""
  echo "  $(basename $0) [-h] [-d]"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo ""
  echo "  $(basename $0) will ask for all settings and can be exited before"
  echo "  doing anything in the system."
  echo ""
  exit 1
}

## Get commandline options
debMsg "Get commandline options"
while getopts ":dh" opt;do
  case "${opt}" in
    h)  usage;;
    d)  DEBUG=1;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

## Ask all settings
askKit
askVersion
askVHost
askLink
askAccount
askPanel

KIRBYSELECTEDVHOSTDIR=$(getVHostDir $KIRBYSELECTEDVHOST)

## Show all variables (in debug mode) and all settings
[[ $DEBUG ]] && showVars
showSettings

## Allow to stop here without doing anything (default: continue)
read -n1 -p "${txtbld}Are you satisfied with above settings? [${txtrst}${txtblue}Y${txtrst}${txtbld}|n] ${txtrst}"
[[ -z $REPLY ]] || echo ""
SEL=${REPLY:-y}
[[ "$SEL" == "y" || "$SEL" == "Y" ]] || exit 0

## Download Kit if not already here (obsolete, will be done by kirbyinstall if necessary)
#echo -en "\nDownloading Kirby $KIRBYSELECTEDKIT-$KIRBYSELECTEDVERSION... "
#kirbydownload -k $KIRBYSELECTEDKIT -v $KIRBYSELECTEDVERSION -t $KIRBYDOWNLOADDIR > /dev/null 2>&1
#[[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"

## Install Kit to Virtual Host Dir
echo -n "Installing Kirby $KIRBYSELECTEDKIT-$KIRBYSELECTEDVERSION... "
if [ "$KIRBYSELECTEDKIRBYLINK" == "Yes" ];then
## and replacing the 'kirby' folder with a symbolic link
  kirbyinstall -l -p $KIRBYSELECTEDKIT-$KIRBYSELECTEDVERSION -w $KIRBYSELECTEDVHOST > /dev/null 2>&1
else
## and NOT replacing the 'kirby' folder with a symbolic link
  kirbyinstall -p $KIRBYSELECTEDKIT-$KIRBYSELECTEDVERSION -w $KIRBYSELECTEDVHOST > /dev/null 2>&1
fi
[[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"

## Create admin account if selected and if script exist
if [ "$KIRBYSELECTEDCREATEACCOUNT" == "Yes" -a -f $KIRBYCREATEUSERSCRIPT -a -n "$KIRBYADMINUSERMAIL" ];then
  echo -n "Creating default admin account... "
  if [ -x $KIRBYSELECTEDVHOSTDIR/site -a -w $KIRBYSELECTEDVHOSTDIR/site ];then
    debMsg "$PHPBIN $KIRBYCREATEUSERSCRIPT ..."
    $PHPBIN $KIRBYCREATEUSERSCRIPT "$KIRBYSELECTEDVHOSTDIR" "$KIRBYADMINUSERMAIL" "$KIRBYADMINUSERNAME" "$KIRBYADMINUSERLANG" "$KIRBYADMINUSERPASS"
  else
    debMsg "sudo $PHPBIN $KIRBYCREATEUSERSCRIPT ..."
    sudo $PHPBIN $KIRBYCREATEUSERSCRIPT "$KIRBYSELECTEDVHOSTDIR" "$KIRBYADMINUSERMAIL" "$KIRBYADMINUSERNAME" "$KIRBYADMINUSERLANG" "$KIRBYADMINUSERPASS"
  fi
  [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
fi

## Enable the panel if selected
if [ "$KIRBYSELECTEDENABLEPANEL" == "Yes" ];then
  echo -n "Enabling the panel "
  if [ "$KIRBYSELECTEDKIT" == "starterkit" ];then
    echo -n "by modifying site/config/config.php..."
    if [ -w $KIRBYSELECTEDVHOSTDIR/site/config/config.php ];then
      debMsg "sed $KIRBYSELECTEDVHOSTDIR/site/config/config.php"
      sed -i.bak -e "s/\[/\[ 'panel' => \[ 'install' => true \],/" $KIRBYSELECTEDVHOSTDIR/site/config/config.php
    else
      debMsg "sudo sed $KIRBYSELECTEDVHOSTDIR/site/config/config.php"
      sudo sed -i.bak -e "s/\[/\[ 'panel' => \[ 'install' => true \],/" $KIRBYSELECTEDVHOSTDIR/site/config/config.php
    fi
  else
    echo -n "by creating site/config/config.php..."
    if [ -x $KIRBYSELECTEDVHOSTDIR/site -a -w $KIRBYSELECTEDVHOSTDIR/site ];then
      debMsg "mkdir $KIRBYSELECTEDVHOSTDIR/site/config and create $KIRBYSELECTEDVHOSTDIR/site/config/config.php"
      save_mkdir "$KIRBYSELECTEDVHOSTDIR/site/config"
      echo -e "<?php\n\nreturn [ 'panel' => [ 'install' => true ],'debug' => true ];\n" > $KIRBYSELECTEDVHOSTDIR/site/config/config.php
    else
      debMsg "sudo mkdir $KIRBYSELECTEDVHOSTDIR/site/config and sudo create $KIRBYSELECTEDVHOSTDIR/site/config/config.php"
      save_mkdir "$KIRBYSELECTEDVHOSTDIR/site/config"
      sudo echo -e "<?php\n\nreturn [ 'panel' => [ 'install' => true ],'debug' => true ];\n" > $KIRBYSELECTEDVHOSTDIR/site/config/config.php
    fi
  fi
  [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
fi

## Copying kirby vhost templates as .conf files to sites-available dir in KIRBYAPACHECONFDIR
TEMPLATES=$(find $KIRBYTEMPLATEDIR -name $KIRBYSUFFIX-vhost-*.template | sort)
for tpl in $TEMPLATES;do
  debMsg "Working on vhost template $tpl"
  TEMPLATE=$(basename $tpl .template)
  CONFFILE="$KIRBYSITEAVAILABLEDIR/${TEMPLATE/$KIRBYSUFFIX-vhost/$KIRBYSELECTEDVHOST}.conf"
  echo -n "Creating apache config file $(basename $CONFFILE)... "

  [[ -f $CONFFILE ]] && save_mv "$CONFFILE" "$CONFFILE.bak"

  if [ -w $KIRBYSITEAVAILABLEDIR ];then
    echo -e "# Virtual Host ${TEMPLATE/$KIRBYSUFFIX-vhost/$KIRBYSELECTEDVHOST}\n# Configuration created by $(basename $0) $KIRBYTOOLSVERSION\n# Name: $KIRBYSELECTEDVHOSTNAME\n# Date: $(date)\n# Desc: $KIRBYSELECTEDVHOSTDESC\n" > $CONFFILE
    cat $tpl >> $CONFFILE
    sed -i -e "s/<VHOST>/$KIRBYSELECTEDVHOST/g" -e "s|<VHOSTROOT>|$KIRBYVHOSTROOT|g" -e "s|<HTDOCSDIR>|$KIRBYHTDOCSDIR|g" $CONFFILE
  else
    sudo echo -e "# Virtual Host ${TEMPLATE/$KIRBYSUFFIX-vhost/$KIRBYSELECTEDVHOST} Configuration created by $(basename $0) $KIRBYTOOLSVERSION\n# Name: $KIRBYSELECTEDVHOSTNAME\n# Date: $(date)\n# Desc: $KIRBYSELECTEDVHOSTDESC\n" > $CONFFILE
    sudo cat $tpl >> $CONFFILE
    sudo sed -i -e "s/<VHOST>/$KIRBYSELECTEDVHOST/g" -e "s|<VHOSTROOT>|$KIRBYVHOSTROOT|g" -e "s|<HTDOCSDIR>|$KIRBYHTDOCSDIR|g" $CONFFILE
  fi
  [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
done

if [[ -z $TEMPLATES ]];then
  debMsg "No templates found in $KIRBYTEMPLATEDIR"
  echo -e "\n${txtbld}No virtual host configuration templates found!${txtrst}\n"
  echo "You have to create a suitable apache vhost configuration file and save it as"
  echo "$KIRBYSITEAVAILABLEDIR/$KIRBYSELECTEDVHOST.conf. Then, enable the vhost with either"
  echo -e "\n  ${txtblue}vhostensite $KIRBYSELECTEDVHOST${txtrst}\n"
  echo "(requires the vhostmanger package to be installed) OR"
  echo -e "\n  ${txtblue}ln -s $KIRBYSITEAVAILABLEDIR/$KIRBYSELECTEDVHOST.conf $KIRBYSITEENABLEDDIR/${txtrst}\n"
  echo "Finally restart apache with"
  echo -e "\n  ${txtblue}sudo apache2ctl graceful${txtrst}\n"
  echo "If you would like kirbysetup to create virtual host configuration file(s) for you, add"
  echo "template files in $KIRBYAPACHECONFDIR/templates with file names corresponding to the pattern"
  echo "'$KIRBYSUFFIX-vhost-[SOMETHING].template'. The kirbysetup script will pick up any template in this"
  echo "directory, rename it to 'KIRBYVHOST-[SOMETHING].conf', substitute any placeholder within to its"
  echo "actual value, and save the file in $KIRBYSITEAVAILABLEDIR."
  echo -e "\nSee kirbysetup(1) and /usr/share/doc/kirbytools/examples/README.templates for further details.\n"
fi

CONFS=$(find $KIRBYSITEAVAILABLEDIR -name $KIRBYSELECTEDVHOST*.conf | sort)
if [[ ! -z $CONFS ]];then
  if [ ! $(which vhostensite) ];then echo -e "\nTo enable a virtual host, create a symbolic link in $KIRBYSITEENABLEDDIR/ with:\n";fi
  for conf in $CONFS;do
    debMsg "Working on conf file $conf"
    CONF=$(basename $conf .conf)
    if [ $(which vhostensite) ];then
      read -n1 -p "${txtbld}Enable Virtual Host $CONF? [y|${txtrst}${txtblue}N${txtrst}${txtbld}] ${txtrst}"
      [[ -z $REPLY ]] || echo ""
      SEL=${REPLY:-n}
      if [[ "$SEL" == "y" || "$SEL" == "Y" ]];then
        echo -n "Enabling Virtual Host $CONF ..."
        vhostensite $CONF > /dev/null
        echo -e "${txtgreen}successful.${txtrst}"
        restart_apache2
      fi
    else
      echo "  ${txtblue}ln -s $conf $KIRBYSITEENABLEDDIR/${txtrst}"
    fi
  done
  if [ ! $(which vhostensite) ];then echo -e "\nand restart apache with:\n\n  ${txtblue}sudo apache2ctl graceful${txtrst}\n";fi
fi

debMsg "Script $(basename $0) finished successfully"

exit 0
## code: language=bash