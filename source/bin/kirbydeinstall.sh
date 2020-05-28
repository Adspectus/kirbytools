#!/bin/bash
#
# kirbydeinstall by Uwe Gehring <adspectus@fastmail.com>

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
debMsg "Get commandline options"
while getopts ":dhlw:" opt;do
  case "${opt}" in
    h)  usage;;
    d)  DEBUG=1;;
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