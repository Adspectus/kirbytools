#!/bin/bash
#
# kirbychangeversion by Uwe Gehring <adspectus@fastmail.com>

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
  echo "  $(basename $0) [-h] [-d] [-l] [-f] [-v <current|versionnumber>] -w <vhost>"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo "  -l: Replace the kirby program directory with a symbolic link to $KIRBYLIBDIR/[versionnumber]"
  echo "  -f: Force download even if package is already in $KIRBYDOWNLOADDIR"
  echo "  -v: version to be installed (default: ${txtbld}$KIRBYVERSION${txtrst})"
  echo "  -w: virtual hostname(s) for which the version should be changed (wildcards ok)"
  echo ""
  exit 1
}

## Get commandline options
debMsg "Get commandline options"
while getopts ":hdlfp:v:w:" opt;do
  case "${opt}" in
    h)  usage;;
    d)  DEBUG=1;;
    l)  LINKKIRBY=1;;
    f)  FORCEDOWNLOAD=1;;
    p)  package=$OPTARG;;
    v)  version=$OPTARG;;
    w)  opt_w=1;vhost=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

[[ $opt_w ]] || { errMsg "-w is required" && usage; }

## Print info in debug mode
[[ $DEBUG ]] && showVars

for vh in $(find $KIRBYVHOSTROOT -maxdepth 1 -type d -name ${vhost[*]});do
  debMsg "Found virtual host in $vh"
# Check if Kirby vhost and whether the kirby dir is a real dir or symlink
  if [[ -n $(find $vh -type d -name kirby) ]];then
    kirbydir=$(find $vh -type d -name kirby)
    debMsg "Found kirby directory $kirbydir"
  elif [[ -n $(find $vh -type l -name kirby) ]];then
    kirbylnk=$(find $vh -type l -name kirby)
    debMsg "Found kirby symlink $kirbylnk"
  else
    errMsg "$vh is not a Kirby vhost"
  fi
done

# version=$(jq -r '.version' composer.json)
exit

## Check first if package is already downloaded. If not, download package
if [[ $FORCEDOWNLOAD || ! -f $KIRBYDOWNLOADDIR/$package.tar.gz ]];then
  [[ $LINKKIRBY ]] && kirbydownload -f -l -k $kit -v $ver > /dev/null
  [[ $LINKKIRBY ]] || kirbydownload -f -k $kit -v $ver > /dev/null
  [[ $? -ne 0 ]] && errMsg "Could not download $package" && usage
fi

save_mkdir "$KIRBYVHOSTDIR"
tar -xzf $KIRBYDOWNLOADDIR/$package.tar.gz -C "$KIRBYTEMPDIR"
save_cp "$KIRBYTEMPDIR/$package/." "$KIRBYVHOSTDIR"

echo -e "\n${txtgreen}Kirby $package installed to $KIRBYVHOSTDIR${txtrst}\n"

if [ $LINKKIRBY ];then
  if [ ! -d $KIRBYLIBDIR/$ver ];then
    save_mkdir "$KIRBYLIBDIR/$ver"
    save_cp "$KIRBYVHOSTDIR/kirby/." "$KIRBYLIBDIR/$ver"
  fi
  save_rm "$KIRBYVHOSTDIR/kirby"
  save_ln "$KIRBYLIBDIR/$ver" "$KIRBYVHOSTDIR/kirby"
  if [ -w "$KIRBYVHOSTDIR/index.php" ];then
    sed -i.bak -e "s/Kirby)/Kirby\(\[ 'roots' => \[ 'index' => __DIR__ \] \]\)\)/" $KIRBYVHOSTDIR/index.php
  else
    sudo sed -i.bak -e "s/Kirby)/Kirby\(\[ 'roots' => \[ 'index' => __DIR__ \] \]\)\)/" $KIRBYVHOSTDIR/index.php
  fi
fi

debMsg "Script $(basename $0) finished successfully"

exit 0
## code: language=bash