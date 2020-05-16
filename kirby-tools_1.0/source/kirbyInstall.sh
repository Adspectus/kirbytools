#!/bin/bash
#
# kirbyInstall by Uwe Gehring <uwe@imap.cc>

## Read default variables
if [ -f /etc/default/kirbyrc ];then
  . /etc/default/kirbyrc
else
  echo "File /etc/default/kirbyrc not found!" && exit 2
fi

## Read default functions
if [ -f /etc/default/kirby_functions ];then
  . /etc/default/kirby_functions
else
  echo "File /etc/default/kirby_functions not found!" && exit 2
fi

## Initialize settings
initKirbySetup

## Usage
usage() {
  echo ""
  echo "  Usage:"
  echo ""
  echo "  $(basename $0) [-h] [-d] [-l] [-p <package>] [-w <vhost>]"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo "  -l: will replace kirby dir with symbolic link to $KIRBYLIBDIR"
  echo "  -p: package to be installed (default: ${txtbld}$KIRBYDEFAULTPACKAGE${txtrst})"
  echo "  -w: virtual hostname to be used (default: ${txtbld}$KIRBYDEFAULTVHOST${txtrst})"
  echo ""
  exit 1
}

## Get commandline options
while getopts ":dhlp:w:" opt;do
  case "${opt}" in
    d)  DEBUG=1;;
    h)  usage;;
    l)  LINKKIRBY=1;;
    p)  package=$OPTARG;;
    w)  vhost=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

## Check if package has a value
package=${package:-$KIRBYDEFAULTPACKAGE}

## Check if vhost has a value and set KIRBYVHOSTDIR
vhost=${vhost:-$KIRBYDEFAULTVHOST}
KIRBYVHOSTDIR=$(getVHostDir $vhost)
KIRBYVHOSTLOGDIR=$(getLogDir $vhost)

## Print info in debug mode
[[ $DEBUG ]] && showVars

## Split package into kit and version
KIT=$(echo $package | cut -d"-" -f1)
VERSION=$(echo $package | cut -d"-" -f2)

## Check first if package is already downloaded. If not, download package
if [ ! -f $KIRBYDOWNLOADDIR/$package.tar.gz ];then
  KirbyDownload -k $KIT -v $VERSION > /dev/null
  [[ $? -ne 0 ]] && errMsg "Could not download $package" && usage
fi

mkdir -p $KIRBYVHOSTDIR $KIRBYVHOSTLOGDIR
tar -xzf $KIRBYDOWNLOADDIR/$package.tar.gz -C $KIRBYTEMPDIR
cp -au $KIRBYTEMPDIR/$package/. $KIRBYVHOSTDIR

if [ $LINKKIRBY ];then
  if [ ! -d $KIRBYLIBDIR/$VERSION ];then
    mkdir -p $KIRBYLIBDIR/$VERSION
    cp -au $KIRBYVHOSTDIR/kirby/. $KIRBYLIBDIR/$VERSION
  fi
  rm -rf $KIRBYVHOSTDIR/kirby && ln -fs $KIRBYLIBDIR/$VERSION $KIRBYVHOSTDIR/kirby
  sed -i.bak -e "s/Kirby)/Kirby\(\[ 'roots' => \[ 'index' => __DIR__ \] \]\)\)/" $KIRBYVHOSTDIR/index.php
fi

## If all went right, print message and exit with code 0
echo -e "\n${txtgreen}Kirby $package installed to $KIRBYVHOSTDIR${txtrst}\n"

exit 0
## code: language=bash