#!/bin/bash
#
# kirbysetup by Uwe Gehring <uwe@imap.cc>

## Read settings and make sure all config files exist
if ! kirbyconfigure;then exit 1;fi

## Source the configuration files
. /etc/kirbytools/kirbyrc
. $HOME/.kirbyrc
. /etc/kirbytools/kirbyrc2
. /etc/kirbytools/kirbyfunctions

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
  echo "  doing anything in the system. Run with ${txtbld}-d${txtrst} to see all settings."
  echo ""
  exit 1
}

## Get commandline options
while getopts ":dh" opt;do
  case "${opt}" in
    d)  DEBUG=1;;
    h)  usage;;
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
askConf

KIRBYSELECTEDVHOSTDIR=$(getVHostDir $KIRBYSELECTEDVHOST)
KIRBYSELECTEDVHOSTLOGDIR=$(getLogDir $KIRBYSELECTEDVHOST)

## Show all variables (in debug mode) and all settings
[[ $DEBUG ]] && showVars
showSettings

## Allow to stop here without doing anything (default: continue)
read -n1 -p "${txtbld}If you are satisfied with above settings, continue? [${txtrst}${txtblue}Y${txtrst}${txtbld}|n] ${txtrst}"
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
if [ "$KIRBYSELECTEDCREATEACCOUNT" == "Yes" -a -e $KIRBYCREATEUSERSCRIPT ];then
  echo -n "Creating default account... "
  php $KIRBYCREATEUSERSCRIPT "$KIRBYSELECTEDVHOSTDIR" "$KIRBYADMINUSERMAIL" "$KIRBYADMINUSERNAME" "$KIRBYADMINUSERLANG" "$KIRBYADMINUSERPASS"
  [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
fi

## Enable the panel if selected
if [ "$KIRBYSELECTEDENABLEPANEL" == "Yes" ];then
  echo -n "Enabling the panel... "
  if [ "$KIRBYSELECTEDKIT" == "starterkit" ];then
    sed -i.bak -e "s/\[/\[ 'panel' => \[ 'install' => true \],/" $KIRBYSELECTEDVHOSTDIR/site/config/config.php
  else
    mkdir -p $KIRBYSELECTEDVHOSTDIR/site/config
    echo -e "<?php\n\nreturn [ 'panel' => [ 'install' => true ],'debug' => true ];\n" > $KIRBYSELECTEDVHOSTDIR/site/config/config.php
  fi
  [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
fi

## Copying templates as .conf files to sites-available dir in KIRBYAPACHECONFDIR
for tpl in ${_KIRBYTEMPLATES[@]};do
  TMPL="$KIRBYTEMPLATEDIR/$tpl.template"
  CONF="$KIRBYAPACHECONFDIR/sites-available/${tpl/vhost/$KIRBYSELECTEDVHOST}.conf"
  echo -n "Creating $(basename $CONF)... "

  [[ -f $CONF ]] && mv $CONF $CONF.bak

  echo -e "# Virtual Host ${tpl/vhost-/} Configuration created by $(basename $0) $KIRBYTOOLSVERSION\n# Name: $KIRBYSELECTEDVHOSTNAME\n# Date: $(date)\n# Desc: $KIRBYSELECTEDVHOSTDESC\n" > $CONF
  cat $TMPL >> $CONF

  sed -i -e "s/<VHOST>/$KIRBYSELECTEDVHOST/g" $CONF
  [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
done

if [ "$KIRBYSELECTEDCOMBINECONF" == "Yes" ];then
  if [ -f $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST-Redirection.conf -a -f $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST-SSL.conf ];then 
    echo -n "Merging redirection and ssl vhost configuration files into 1 file... "
    cat $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST-Redirection.conf $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST-SSL.conf > $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST.conf
    if [ -f $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST.conf ];then
      rm $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST-Redirection.conf $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST-SSL.conf
    fi
    [[ $? -eq 0 ]] && echo -e "${txtgreen}successful.${txtrst}" || echo -e "${txtred}failed.${txtrst}\n"
  fi
fi

if $(which vhostEnable);then
  for conf in $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST*.conf;do
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
  echo ""
  echo "To enable the virtual host, create a symbolic link in $KIRBYAPACHECONFDIR/sites-enabled/, i.e."
  echo "  ln -s $KIRBYAPACHECONFDIR/sites-available/$KIRBYSELECTEDVHOST.conf $KIRBYAPACHECONFDIR/sites-enabled/"
  echo "and restart apache with i.e."
  echo "  sudo apache2ctl graceful"
  echo ""
fi

exit 0
## code: language=bash