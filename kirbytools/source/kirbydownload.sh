#!/bin/bash
#
# kirbydownload by Uwe Gehring <uwe@imap.cc>

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
  echo "  $(basename $0) [-h] [-d] [-l] [-k <starterkit|plainkit>] [-v <current|versionnumber>] [-t <targetdir>]"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo "  -l: Download and extract kirby dir to $KIRBYLIBDIR"
  echo "  -k: kit to be installed (default: ${txtbld}$KIRBYDEFAULTKIT${txtrst})"
  echo "  -v: version to be installed (default: ${txtbld}$KIRBYDEFAULTVERSION${txtrst})"
  echo "  -t: directory to be downloaded into (default: ${txtbld}$KIRBYDOWNLOADDIR${txtrst})"
  echo ""
  echo "  Current versionnumber for starterkit: ${txtbld}${_KIRBYTAGCURRENT[starterkit]}${txtrst}"
  echo "  Current versionnumber for plainkit: ${txtbld}${_KIRBYTAGCURRENT[plainkit]}${txtrst}"
  echo ""
  exit 1
}

## Get commandline options
while getopts ":dhlk:t:v:" opt;do
  case "${opt}" in
    d)  DEBUG=1;;
    h)  usage;;
    l)  LINKKIRBY=1;;
    k)  kit=$OPTARG;;
    t)  target=$OPTARG;;
    v)  version=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

## Check if kit has valid value
kit=${kit:-$KIRBYDEFAULTKIT}
if [[ "$kit" != "starterkit" && "$kit" != "plainkit" ]];then
  errMsg "Invalid kit $kit" && usage
fi

## Check if version has valid value
version=${version:-$KIRBYDEFAULTVERSION}
if ! checkValidKirbyVersion $version $kit;then
  errMsg "Invalid version $version" && usage
fi
if [ "$version" == "current" ];then
  version=${_KIRBYTAGCURRENT[$kit]}
fi

## Check if target has valid value
target=${target:-$KIRBYDOWNLOADDIR}

## Print info in debug mode
[[ $DEBUG ]] && showVars

## Check first if kit is already downloaded. If not, get kit and save it
## in target dir and rename from version.tar.gz to kit-version.tar.gz
if [ ! -f $target/$kit-$version.tar.gz ];then
  [[ -z $KIRBYGITURL ]] && errMsg "KIRBYGITURL is not defined!" && exit 3
  sudo wget -q $KIRBYGITURL/$kit/archive/$version.tar.gz -P $target
  sudo mv $target/$version.tar.gz $target/$kit-$version.tar.gz
fi

## Unpack kirby directory to KIRBYLIBDIR
if [[ $LINKKIRBY && ! -d $KIRBYLIBDIR/$version ]];then
  tar -xzf $target/$kit-$version.tar.gz -C $KIRBYTEMPDIR
  mkdir -p $KIRBYLIBDIR/$version
  cp -au $KIRBYTEMPDIR/$kit-$version/kirby/. $KIRBYLIBDIR/$version
fi

## If all went right, print message and exit with code 0
echo -e "\n${txtgreen}Kirby $kit $version downloaded to $target/$kit-$version.tar.gz${txtrst}\n"

exit 0
## code: language=bash