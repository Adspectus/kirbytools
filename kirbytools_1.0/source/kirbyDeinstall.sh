#!/bin/bash
#
# kirbyDeinstall by Uwe Gehring <uwe@imap.cc>

## Read default variables
if [ -f /etc/kirbytools/kirbyrc ];then
  . /etc/kirbytools/kirbyrc
else
  echo "File /etc/kirbytools/kirbyrc not found!" && exit 2
fi

## Read default functions
if [ -f /etc/kirbytools/kirbyfunctions ];then
  . /etc/kirbytools/kirbyfunctions
else
  echo "File /etc/kirbytools/kirbyfunctions not found!" && exit 2
fi

## Initialize settings
initKirbySetup

## Usage
usage() {
  echo ""
  echo "  Usage:"
  echo ""
  echo "  $(basename $0) [-h] [-d] [-l] [-w <vhost>]"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo "  -l: will remove linked kirby dir from $KIRBYLIBDIR as well (not implemented)"
  echo "  -w: virtual hostname(s) to be removed (wildcards ok)"
  echo ""
  exit 1
}

## Get commandline options
while getopts ":dhlw:" opt;do
  case "${opt}" in
    d)  DEBUG=1;;
    h)  usage;;
    l)  LINKKIRBY=1;;
    w)  vhost=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

[[ $DEBUG ]] && showVars

for vh in ${vhost[*]};do
  [[ -d $KIRBYVHOSTROOT/$vh ]] && read -n1 -p "Remove directory $KIRBYVHOSTROOT/$vh and all subdirectories [y|N] "
  [[ -z $REPLY ]] || echo ""
  SEL=${REPLY:-n}
  if [[ "$SEL" == "y" || "$SEL" == "Y" ]];then
    # First disable the site if it is enabled
    if $(which vhostDisable);then
      [[ -f $KIRBYAPACHECONFDIR/sites-enabled/$vh.conf ]] && vhostDisable $vh* > /dev/null
    else
      rm $KIRBYAPACHECONFDIR/sites-enabled/$vh*.conf
    fi
    # Then remove vhost directory
    rm -rf $KIRBYVHOSTROOT/$vh
    # Finally remove all confs from sites-available
    [[ -f $KIRBYAPACHECONFDIR/sites-available/$vh.conf ]] && rm $KIRBYAPACHECONFDIR/sites-available/$vh*.conf
  fi
done

exit 0
## code: language=bash