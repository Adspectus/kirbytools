#!/bin/bash
#
# kirbydownload by Uwe Gehring <adspectus@fastmail.com>

## Read settings and make sure all config files exist
[[ ! -f /etc/kirbytools/kirbyrc ]] && echo "File /etc/kirbytools/kirbyrc not found!" && exit 1
. /etc/kirbytools/kirbyrc

debMsg "Starting $(basename $0)"

## Initialize settings
initKirbySetup

## Usage
usage() {
  echo ""
  echo "  Usage:"
  echo ""
  echo "  $(basename $0) [-h] [-d] [-l] [-f] [-k <starterkit|plainkit>] [-v <current|versionnumber>] [-t <targetdir>]"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo "  -l: Extract the kirby program directory to $KIRBYLIBDIR/[versionnumber]"
  echo "  -f: Force download even if package is already in $KIRBYDOWNLOADDIR"
  echo "  -k: kit to be installed (default: ${txtbld}$KIRBYKIT${txtrst})"
  echo "  -v: version to be installed (default: ${txtbld}$KIRBYVERSION${txtrst})"
  echo "  -t: directory to be downloaded into (default: ${txtbld}$KIRBYDOWNLOADDIR${txtrst})"
  echo ""
  echo "  Current versionnumber for starterkit: ${txtbld}${_KIRBYTAGCURRENT[starterkit]}${txtrst}"
  echo "  Current versionnumber for plainkit: ${txtbld}${_KIRBYTAGCURRENT[plainkit]}${txtrst}"
  echo ""
  exit 1
}

## Get commandline options
debMsg "Get commandline options"
while getopts ":hdlfk:t:v:" opt;do
  case "${opt}" in
    h)  usage;;
    d)  DEBUG=1;;
    l)  LINKKIRBY=1;;
    f)  FORCEDOWNLOAD=1;;
    k)  kit=$OPTARG;;
    t)  target=$OPTARG;;
    v)  version=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

## Check if kit has valid value
debMsg "Check if kit has valid value"
kit=${kit:-$KIRBYKIT}
if [[ "$kit" != "starterkit" && "$kit" != "plainkit" ]];then
  errMsg "Invalid kit $kit" && usage
fi

## Check if version has valid value
debMsg "Check if version has valid value"
version=${version:-$KIRBYVERSION}
if ! isValidKirbyVersion $version $kit;then
  errMsg "Invalid version $version" && usage
fi
if [ "$version" == "current" ];then
  version=${_KIRBYTAGCURRENT[$kit]}
fi

## Check if target has valid value
debMsg "Check if target has valid value"
target=${target:-$KIRBYDOWNLOADDIR}
if [ ! -d $target ];then
  errMsg "Target directory $target does not exist" && usage
fi
target=$(realpath $target)

## Print info in debug mode
[[ $DEBUG ]] && showVars

## Check first if kit is already downloaded. If not, get kit and save it
## in target dir and rename from version.tar.gz to kit-version.tar.gz
if [[ $FORCEDOWNLOAD || ! -f $target/$kit-$version.tar.gz ]];then
  [[ -z $KIRBYGITURL ]] && errMsg "KIRBYGITURL is not defined!" && exit 1
  debMsg "wget -q $KIRBYGITURL/$kit/archive/$version.tar.gz -P $KIRBYTEMPDIR"
  wget -q $KIRBYGITURL/$kit/archive/$version.tar.gz -P "$KIRBYTEMPDIR"
  debMsg "save_cp $KIRBYTEMPDIR/$version.tar.gz $target/$kit-$version.tar.gz"
  save_cp "$KIRBYTEMPDIR/$version.tar.gz" "$target/$kit-$version.tar.gz"
  echo -e "\n${txtgreen}Kirby $kit $version downloaded to $target/$kit-$version.tar.gz${txtrst}\n"
else
  echo -e "\n${txtgreen}Kirby $kit $version already in $target/$kit-$version.tar.gz${txtrst}\n"
fi

## Unpack kirby program directory to KIRBYLIBDIR
if [[ $LINKKIRBY && ! -d $KIRBYLIBDIR/$version ]];then
  debMsg "tar -xzf $target/$kit-$version.tar.gz -C $KIRBYTEMPDIR"
  tar -xzf "$target/$kit-$version.tar.gz" -C "$KIRBYTEMPDIR"
  debMsg "save_mkdir $KIRBYLIBDIR/$version"
  save_mkdir "$KIRBYLIBDIR/$version"
  debMsg "save_cp $KIRBYTEMPDIR/$kit-$version/kirby/. $KIRBYLIBDIR/$version"
  save_cp "$KIRBYTEMPDIR/$kit-$version/kirby/." "$KIRBYLIBDIR/$version"
fi

debMsg "Script $(basename $0) finished successfully"

exit 0
## code: language=bash