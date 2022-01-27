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
  echo "  $(basename $0) [-h] [-d] [-t] [-v <versionnumber> | -r] -w <vhost>"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo "  -t: Test only"
  echo "  -v: version to be installed (default: highest patch version for installed minor version)"
  echo "  -r: revert to previous version"
  echo "  -w: virtual hostname(s) for which the version should be changed (wildcards ok)"
  echo ""
  exit 1
}

## Get commandline options
debMsg "Get commandline options"
while getopts ":hdtrv:w:" opt;do
  case "${opt}" in
    h)  usage;;
    d)  DEBUG=1;;
    t)  TEST=1;;
    v)  version=$OPTARG;;
    r)  REVERT=1;;
    w)  opt_w=1;vhost=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

[[ $opt_w ]] || { errMsg "-w is required" && usage; }

## Print info in debug mode
[[ $DEBUG ]] && showVars

## Check if version is set and has valid value
if [[ -n "$version" ]];then
  debMsg "Check if version has valid value"
  if ! isValidKirbyVersion $version $KIRBYKIT;then
    errMsg "Invalid version $version" && usage
  fi
fi

[[ $TEST ]] && echo -e "\n${txtblue}Testing only!${txtrst}\n"

## Loop through all vhosts and check if it is a Kirby vhost at all
## If it is Kirby, determine the version by means of composer.json
for vh in $(find $KIRBYVHOSTROOT -maxdepth 1 -type d -name ${vhost[*]});do
  thisvhost=$(basename $vh)
  debMsg "Found virtual host $thisvhost in $(dirname $vh)"
  kirbyvhost=$(find $vh -type f -name .kirbydocroot)
  if [ -n "$kirbyvhost" ];then
    docroot=$(dirname $kirbyvhost)
    $PHPBIN -f /usr/share/kirbytools/getConfig.php $docroot | jq '.' > $KIRBYTEMPDIR/$(basename $vh).json
    thisversion=$(jq -r '.version' $KIRBYTEMPDIR/$(basename $vh).json)
    if [ -z $thisversion ];then
      errMsg "Could not determine this Kirby version!" && continue
    fi
    echo "Virtual host $thisvhost is Kirby version $thisversion"

# If the target version has not been set on command line, we will only upgrade
# to the latest patch version of the current version, so we will determine it
    if [[ -z "$version" ]];then
      if [[ $REVERT ]];then
        debMsg "Reverting to previous Kirby version"
        if [ -f $docroot/.kirbypreviousversion ];then
          targetversion=$(cat $docroot/.kirbypreviousversion)
          debMsg "Previous Kirby version: $targetversion"
        else
          errMsg "-r is only valid if there was a previous kirby version from which this program has made an up/downgrade" && continue
        fi
      else
        thisversionmajor=$(echo $thisversion | cut -d"." -f 1)
        thisversionminor=$(echo $thisversion | cut -d"." -f 2)
  #      currentversion=$(getHighestPatchVersion $KIRBYKIT $(getHighestMinorVersion $KIRBYKIT $thisversionmajor))
        targetversion=$(getHighestPatchVersion $KIRBYKIT $thisversionmajor.$thisversionminor)
        debMsg "Last patch for this version: $targetversion"
  #      debMsg "Current available version: $currentversion"
      fi
    else
      targetversion="$version"
    fi

    if [ "$thisversion" == "$targetversion" ];then
      echo "${txtbold}This Kirby version is already the required version ($targetversion)!${txtrst}"
      continue
    fi

    if [ ! $TEST ];then
      kirbydownload -l -v $targetversion > /dev/null
      [[ $? -ne 0 ]] && errMsg "Could not download $targetversion" && usage
    fi

    [[ "$thisversion" < "$targetversion" ]] && action="Upgrade"
    [[ "$thisversion" > "$targetversion" ]] && action="Downgrade"
    echo "This Kirby version will be ${action,,}d to version $targetversion"

    kirbydir=$(jq -r '.roots.kirby' $KIRBYTEMPDIR/$(basename $vh).json)
    if [ "$kirbydir" == "$docroot/kirby" ];then # Case 1: kirby is a directory in docroot (standard)
      debMsg "kirby is real directory $kirbydir"
      debMsg "Deleting old directory $kirbydir"
      [[ $TEST ]] && echo "${txtblue}Testing: kirby directory would be deleted${txtrst}"
      [[ $TEST ]] || save_rm "$docroot/kirby"
      if [ $? ];then
        debMsg "Creating kirby directory and copying $KIRBYLIBDIR/$targetversion"
        [[ $TEST ]] && echo "${txtblue}Testing: kirby directory would be created and $KIRBYLIBDIR/$targetversion/. would be copied into it${txtrst}"
        [[ $TEST ]] || { save_mkdir "$docroot/kirby" && save_cp "$KIRBYLIBDIR/$targetversion/." "$docroot/kirby"; }
        [[ $? ]] && SUCCESS=1
      else
        errMsg "Link/Directory $kirbydir could not be deleted, nothing is changed"
      fi
    elif [ "$kirbydir" == "$(readlink -f $docroot/kirby)" ];then # Case 2: kirby is a symlink to another dir
      debMsg "kirby is a symlink to $kirbydir"
      debMsg "Deleting old link $kirbydir"
      [[ $TEST ]] && echo "${txtblue}Testing: kirby link would be deleted${txtrst}"
      [[ $TEST ]] || save_rm "$docroot/kirby"
      if [ $? ];then
        debMsg "Creating kirby link and pointing to $KIRBYLIBDIR/$targetversion"
        [[ $TEST ]] && echo "${txtblue}Testing: kirby link with target $KIRBYLIBDIR/$targetversion would be created${txtrst}"
        [[ $TEST ]] || save_ln "$KIRBYLIBDIR/$targetversion" "$docroot/kirby"
        [[ $? ]] && SUCCESS=1
      else
        errMsg "Link/Directory $kirbydir could not be deleted, nothing is changed"
      fi
    else # Case 3: kirby is anything else, but this will not be considered
      debMsg "kirby is neither a real directory nor a symlink, skipping" && continue
    fi
    if [ ! $SUCCESS ];then
      errMsg "$action not successful, restoring previous version"
    else
      [[ $TEST ]] || echo "${txtgreen}Kirby virtual host $thisvhost ${action,,}d from version $thisversion to version $targetversion${txtrst}"
      [[ $TEST ]] || echo "$thisversion" > $docroot/.kirbypreviousversion
      mediadir=$(jq -r '.roots.media' $KIRBYTEMPDIR/$(basename $vh).json)
      cachedir=$(jq -r '.roots.cache' $KIRBYTEMPDIR/$(basename $vh).json)
      sessiondir=$(jq -r '.roots.sessions' $KIRBYTEMPDIR/$(basename $vh).json)
      if [ -d "$mediadir" ];then
        debMsg "Found 'media' directory $mediadir"
        for mdir in $(find "$mediadir" -mindepth 1 -maxdepth 1 -type d);do
          debMsg "Deleting directory $mdir"
          [[ $TEST ]] && echo "${txtblue}Testing: Directory $mdir would be deleted${txtrst}"
          [[ $TEST ]] || save_rm "$mdir"
          if [ $? ];then
            [[ $TEST ]] || echo "${txtgreen}Directory $mdir deleted${txtrst}"
          else
            [[ $TEST ]] || errMsg "Could not delete directory $mdir"
          fi
        done
      fi
      if [ -d "$cachedir" ];then
        debMsg "Found 'cache' directory $cachedir"
        for cdir in $(find "$cachedir" -mindepth 1 -maxdepth 1 -type d);do
          debMsg "Deleting directory $cdir"
          [[ $TEST ]] && echo "${txtblue}Testing: Directory $cdir would be deleted${txtrst}"
          [[ $TEST ]] || save_rm "$cdir"
          if [ $? ];then
            [[ $TEST ]] || echo "${txtgreen}Directory $cdir deleted${txtrst}"
          else
            [[ $TEST ]] || errMsg "Could not delete directory $cdir"
          fi
        done
      fi
      if [ -d "$sessiondir" ];then
        debMsg "Found 'session' directory $sessiondir"
        for sfile in $(find "$sessiondir" -mindepth 1 -maxdepth 1 -type f -name '*.sess');do
          debMsg "Deleting file $sfile"
          [[ $TEST ]] && echo "${txtblue}Testing: File $sfile would be deleted${txtrst}"
          [[ $TEST ]] || save_rm "$sfile"
          if [ $? ];then
            [[ $TEST ]] || echo "${txtgreen}File $sfile deleted${txtrst}"
          else
            [[ $TEST ]] || errMsg "Could not delete file $sfile"
          fi
        done
      fi
    fi
  else
    errMsg "$vh is not a Kirby vhost"
  fi
done

debMsg "Script $(basename $0) finished successfully"

exit 0
## code: language=bash