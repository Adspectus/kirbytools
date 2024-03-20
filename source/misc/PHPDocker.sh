#!/bin/bash
#
# PHPDocker.sh by Uwe Gehring <adspectus@fastmail.com>
#
# This file replaces a local PHP executable. It must be called with the same arguments
# as the original PHP script, i.e. THISFILE -f SCRIPT ARG1 ARG2 ... ARGn
# When used with kirbytools (as a replacement for PHPBIN) the parameter -k must be given!
# Example: PHPDocker.sh -k -f /usr/share/kirbytools/getConfig.php /srv/www/vhost/kirby-test/htdocs

DEFAULTPHPVERSION="8.0"

usage() {
  echo ""
  echo "  Usage:"
  echo ""
  echo "  $(basename $0) [-h] [-d] [-k] [-v <PHP version>] [-f <PHP script to execute>] [-w <webroot>]"
  echo ""
  echo "  -h: Show this help"
  echo "  -d: Show debug information"
  echo "  -k: Use with kirbytools"
  echo "  -v: PHP version to be used (default: $DEFAULTPHPVERSION)"
  echo "  -f: The script to execute with PHP"
  echo "  -w: The documentroot directory of the virtual host"
  echo ""
  exit 1
}

## Get commandline options
while getopts ":hdkf:v:w:" opt;do
  case "${opt}" in
    h)  usage;;
    d)  DEBUG=1;;
    k)  KIRBY=1;;
    v)  PHPVERSION=$OPTARG;;
    f)  SCRIPT=$OPTARG;;
    w)  WEBROOT=$OPTARG;;
    :)  errMsg "-$OPTARG requires an argument" && usage;;
    *)  errMsg "Invalid option $OPTARG" && usage;;
  esac
done
shift $((OPTIND -1))

PHPVERSION=${PHPVERSION:-$DEFAULTPHPVERSION}

## When used with kirbytools, if the webroot is not set by -w, the first of the
## remaining arguments will be used as webroot (vhostdir).
[[ $KIRBY && ! $WEBROOT ]] && WEBROOT=$1 && shift

if [ $DEBUG ];then
  echo "KIRBY:   '$KIRBY'"
  echo "SCRIPT:  '$SCRIPT'"
  echo "PHP:     '$PHPVERSION'"
  echo "Webroot: '$WEBROOT'"
  echo "Rest:    '$@'"
fi

[[ ! -f $SCRIPT ]] && echo "No such file: $SCRIPT!" && exit 2
if [ ! -z $WEBROOT ];then
  [[ ! -d $WEBROOT ]] && echo "No such directory: $WEBROOT!" && exit 2
fi

WORKDIR=$(dirname $SCRIPT)
SCRIPT=$(basename $SCRIPT)

## When used with kirbytools, read settings and make sure all config files exist
if [ $KIRBY ];then
  [[ ! -f /etc/kirbytools/kirbyrc ]] && echo "File /etc/kirbytools/kirbyrc not found!" && exit 1
  . /etc/kirbytools/kirbyrc
  [[ ! -f $KIRBYUSERRC ]] && errMsg "File $KIRBYUSERRC not found! Run 'kirbyconfigure' to define default values for kirbytools in $KIRBYUSERRC!" && exit 1
fi

[[ $DEBUG ]] && echo -e "\ndocker run\n  --rm\n  --volume $WEBROOT:$WEBROOT\n  --volume $WORKDIR:$WORKDIR:ro\n  --workdir $WORKDIR\n  php:$PHPVERSION-cli\n  php -f $SCRIPT $WEBROOT $@\n" && exit 0

docker run \
  --rm \
  --volume $WEBROOT:$WEBROOT \
  --volume $WORKDIR:$WORKDIR:ro \
  --workdir $WORKDIR \
  php:$PHPVERSION-cli \
  php -f $SCRIPT $WEBROOT "$@"

exit 0
