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
  echo "  $(basename $0) [-h] [-d] [-w <vhost>]"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
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
    w)  vhost=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

[[ $DEBUG ]] && showVars

for vh in $KIRBYVHOSTROOT/${vhost[*]};do
  debMsg "Remove dir $vh?"
  [[ -d $vh ]] && read -n1 -p "Remove directory $vh and all subdirectories [y|${txtblue}N${txtrst}] "
  [[ -z $REPLY ]] || echo ""
  SEL=${REPLY:-n}
  if [[ "$SEL" == "y" || "$SEL" == "Y" ]];then
    # First disable the site if it is enabled
    for file in $KIRBYSITEENABLEDDIR/$(basename $vh)*.conf;do
      if [ $(which vhostdissite) ];then
        debMsg "Disable $file with vhostdissite $(basename $file)"
        [[ -L $file ]] && vhostdissite $(basename $file) > /dev/null
      else
        debMsg "Disable $file with save_rm $file"
        [[ -L $file ]] && save_rm "$file"
      fi
    done
    # Then remove vhost directory. Use sudo here because it might be that the webserver has written
    # some dirs/files and if the user has no write and execute permisson, the removal will fail.
    if isValidDir "$vh";then
      debMsg "sudo rm -rf $vh"
      sudo rm -rf "$vh"
    else
      errMsg "Could not remove directory $vh!"
    fi
    # Finally remove all confs from sites-available
    for file in $KIRBYSITEAVAILABLEDIR/$(basename $vh)*.conf;do
      read -n1 -p "Remove configuration file $(basename $file) [y|${txtblue}N${txtrst}] "
      [[ -z $REPLY ]] || echo ""
      SEL=${REPLY:-n}
      if [[ "$SEL" == "y" || "$SEL" == "Y" ]];then
        debMsg "save_rm $file"
        [[ -f $file ]] && save_rm "$file"
      fi
    done
  fi
done

exit 0
## code: language=bash