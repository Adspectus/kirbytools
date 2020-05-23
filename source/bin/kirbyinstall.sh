#!/bin/bash
#
# kirbyinstall by Uwe Gehring <uwe@imap.cc>

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
  echo "  $(basename $0) [-h] [-d] [-l] [-f] [-p <package>] [-w <vhost>]"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo "  -l: will replace kirby program directory with symbolic link to $KIRBYLIBDIR/[versionnumber]"
  echo "  -f: Force download even if package is already in $KIRBYDOWNLOADDIR"
  echo "  -p: package to be installed (default: ${txtbld}$KIRBYDEFAULTPACKAGE${txtrst})"
  echo "  -w: virtual hostname to be used (default: ${txtbld}$KIRBYDEFAULTVHOST${txtrst})"
  echo ""
  exit 1
}

## Get commandline options
while getopts ":hdlfp:w:" opt;do
  case "${opt}" in
    h)  usage;;
    d)  DEBUG=1;;
    l)  LINKKIRBY=1;;
    f)  FORCEDOWNLOAD=1;;
    p)  package=$OPTARG;;
    w)  vhost=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

## Check if package has a valid value and if yes, split into kit and version
package=${package:-$KIRBYDEFAULTPACKAGE}
EXPR='^(starterkit|plainkit)-([3-9].[0-9]+.[0-9]+)$'
if [[ $package =~ $EXPR ]];then
  kit=${BASH_REMATCH[1]}
  ver=${BASH_REMATCH[2]}
else
  errMsg "" && Usage
fi

## Check if vhost has a value and set KIRBYVHOSTDIR
vhost=${vhost:-$KIRBYDEFAULTVHOST}
KIRBYVHOSTDIR=$(getVHostDir $vhost)
KIRBYVHOSTLOGDIR=$(getLogDir $vhost)

## Print info in debug mode
[[ $DEBUG ]] && showVars

## Check first if package is already downloaded. If not, download package
if [[ $FORCEDOWNLOAD || ! -f $KIRBYDOWNLOADDIR/$package.tar.gz ]];then
  kirbydownload -f -l -k $kit -v $ver > /dev/null
  [[ $? -ne 0 ]] && errMsg "Could not download $package" && usage
fi

mkdir -p $KIRBYVHOSTDIR $KIRBYVHOSTLOGDIR
sudo tar -xzf $KIRBYDOWNLOADDIR/$package.tar.gz -C $KIRBYTEMPDIR
cp -dR --preserve=mode,timestamps $KIRBYTEMPDIR/$package/. $KIRBYVHOSTDIR

echo -e "\n${txtgreen}Kirby $package installed to $KIRBYVHOSTDIR${txtrst}\n"

if [ $LINKKIRBY ];then
  if [ ! -d $KIRBYLIBDIR/$ver ];then
    sudo mkdir -p $KIRBYLIBDIR/$ver
    sudo cp -dR --preserve=mode,timestamps $KIRBYVHOSTDIR/kirby/. $KIRBYLIBDIR/$ver
  fi
  rm -rf $KIRBYVHOSTDIR/kirby && ln -fs $KIRBYLIBDIR/$ver $KIRBYVHOSTDIR/kirby
  sed -i.bak -e "s/Kirby)/Kirby\(\[ 'roots' => \[ 'index' => __DIR__ \] \]\)\)/" $KIRBYVHOSTDIR/index.php
fi

exit 0
## code: language=bash