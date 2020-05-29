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
#askConf

KIRBYSELECTEDVHOSTDIR=$(getVHostDir $KIRBYSELECTEDVHOST)
#KIRBYSELECTEDVHOSTLOGDIR=$(getLogDir $KIRBYSELECTEDVHOST)

## Show all variables (in debug mode) and all settings
[[ $DEBUG ]] && showVars
showSettings

## Allow to stop here without doing anything (default: continue)
read -n1 -p "${txtbld}Are you satisfied with above settings? [${txtrst}${txtblue}Y${txtrst}${txtbld}|n] ${txtrst}"
[[ -z $REPLY ]] || echo ""
SEL=${REPLY:-y}
[[ "$SEL" == "y" || "$SEL" == "Y" ]] || exit 0

## Download Kit if not already here
echo -en "\nDownloading Kirby $KIRBYSELECTEDKIT-$KIRBYSELECTEDVERSION... "
kirbydownload -k $KIRBYSELECTEDKIT -v $KIRBYSELECTEDVERSION -t $KIRBYDOWNLOADDIR > /dev/null 2>&1
[[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"

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
    debMsg "php $KIRBYCREATEUSERSCRIPT ..."
    php $KIRBYCREATEUSERSCRIPT "$KIRBYSELECTEDVHOSTDIR" "$KIRBYADMINUSERMAIL" "$KIRBYADMINUSERNAME" "$KIRBYADMINUSERLANG" "$KIRBYADMINUSERPASS"
  else
    debMsg "sudo php $KIRBYCREATEUSERSCRIPT ..."
    sudo php $KIRBYCREATEUSERSCRIPT "$KIRBYSELECTEDVHOSTDIR" "$KIRBYADMINUSERMAIL" "$KIRBYADMINUSERNAME" "$KIRBYADMINUSERLANG" "$KIRBYADMINUSERPASS"
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
for tpl in $KIRBYTEMPLATEDIR/$KIRBYSUFFIX-vhost-*.template;do
  debMsg "Working on vhost template $tpl"
  TEMPLATE=$(basename $tpl .template)
  CONFFILE="$KIRBYCONFAVAILABLEDIR/${TEMPLATE/kirby-vhost/$KIRBYSELECTEDVHOST}.conf"
  echo -n "Creating $(basename $CONFFILE)... "

  [[ -f $CONFFILE ]] && save_mv "$CONFFILE" "$CONFFILE.bak"

  if [ -w $KIRBYCONFAVAILABLEDIR ];then
    echo -e "# Virtual Host ${TEMPLATE/kirby-vhost/$KIRBYSELECTEDVHOST}\n# Configuration created by $(basename $0) $KIRBYTOOLSVERSION\n# Name: $KIRBYSELECTEDVHOSTNAME\n# Date: $(date)\n# Desc: $KIRBYSELECTEDVHOSTDESC\n" > $CONFFILE
    cat $tpl >> $CONFFILE
    sed -i -e "s/<VHOST>/$KIRBYSELECTEDVHOST/g" -e "s|<VHOSTROOT>|$KIRBYVHOSTROOT|g" -e "s|<HTDOCSDIR>|$KIRBYHTDOCSDIR|g" $CONFFILE
  else
    sudo echo -e "# Virtual Host ${TEMPLATE/vhost/$KIRBYSELECTEDVHOST} Configuration created by $(basename $0) $KIRBYTOOLSVERSION\n# Name: $KIRBYSELECTEDVHOSTNAME\n# Date: $(date)\n# Desc: $KIRBYSELECTEDVHOSTDESC\n" > $CONFFILE
    sudo cat $tpl >> $CONFFILE
    sudo sed -i -e "s/<VHOST>/$KIRBYSELECTEDVHOST/g" -e "s|<VHOSTROOT>|$KIRBYVHOSTROOT|g" -e "s|<HTDOCSDIR>|$KIRBYHTDOCSDIR|g" $CONFFILE
  fi
  [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
done

#if [ "$KIRBYSELECTEDCOMBINECONF" == "Yes" ];then
#  if [ -f $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST-Redirection.conf -a -f $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST-SSL.conf ];then 
#    echo -n "Merging redirection and ssl vhost configuration files into 1 file... "
#    cat $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST-Redirection.conf $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST-SSL.conf > $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST.conf
#    if [ -f $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST.conf ];then
#      rm $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST-Redirection.conf $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST-SSL.conf
#    fi
#    [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
#  fi
#fi

if [ $(which vhostenable) ];then
  for conf in $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST*.conf;do
    echo ""
    CONF=$(basename $conf .conf)
    read -n1 -p "${txtbld}Enable Virtual Host $CONF? [y|${txtrst}${txtblue}N${txtrst}${txtbld}] ${txtrst}"
    [[ -z $REPLY ]] || echo ""
    SEL=${REPLY:-n}
    if [[ "$SEL" == "y" || "$SEL" == "Y" ]];then
      echo -n "Enabling Virtual Host $CONF ..."
      vhostenable $CONF > /dev/null
      CONFIGTEST=$(sudo apache2ctl configtest 2>&1 > /dev/null)
      ERR=$?
      if [ "$ERR" != "0" ];then
        echo -e "${txtred}failed.${txtrst}\n"
        errMsg $CONFIGTEST
      else
        sudo apache2ctl graceful
        echo -e "${txtgreen}successful.${txtrst}"
      fi
    fi
  done
else
  echo -e "\nTo enable the virtual host, create a symbolic link in $KIRBYCONFENABLEDDIR/ with:\n"
  echo -e "  ${txtblue}ln -s $KIRBYCONFAVAILABLEDIR/$KIRBYSELECTEDVHOST.conf $KIRBYCONFENABLEDDIR/${txtrst}\n"
  echo -e "and restart apache with:\n"
  echo -e "  ${txtblue}sudo apache2ctl graceful${txtrst}\n"
fi

debMsg "Script $(basename $0) finished successfully"

exit 0
## code: language=bash