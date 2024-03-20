#!/bin/bash
#
# createUserByDocker.sh by Uwe Gehring <adspectus@fastmail.com>
#
# This file replaces a local PHP executable. It must be called with the same parameters
# as the original createUser.php script, i.e.:
# THISFILE /path/to/createUser.php DOCROOT EMAIL NAME LANG PASSWORD
# Example: createUserByDocker.sh /usr/share/kirbytools/createUser.php \
#   '/srv/www/vhost/kirby-test/htdocs' 'adspectus@fastmail.com' 'Uwe Gehring' 'en' 'secret'

## Set PHP version to your needs
PHPVERSION="8.0"

## Read settings and make sure all config files exist
[[ ! -f /etc/kirbytools/kirbyrc ]] && echo "File /etc/kirbytools/kirbyrc not found!" && exit 1
. /etc/kirbytools/kirbyrc

[[ ! -f $KIRBYUSERRC ]] && errMsg "File $KIRBYUSERRC not found! Run 'kirbyconfigure' to define default values for kirbytools in $KIRBYUSERRC!" && exit 1

## Read parameters either from commandline or from environment
CREATEUSERSCRIPT="${1:-$KIRBYCREATEUSERSCRIPT}"
SELECTEDVHOSTDIR="${2:-$KIRBYSELECTEDVHOSTDIR}"
ADMINUSEREMAIL="${3:-$KIRBYADMINUSERMAIL}"
ADMINUSERNAME="${4:-$KIRBYADMINUSERNAME}"
ADMINUSERLANG="${5:-$KIRBYADMINUSERLANG}"
ADMINUSERPASS="${6:-$KIRBYADMINUSERPASS}"

[[ ! -f $CREATEUSERSCRIPT ]] && errMsg "No such file: $CREATEUSERSCRIPT!" && exit 2
[[ ! -d $SELECTEDVHOSTDIR ]] && errMsg "No such directory: $SELECTEDVHOSTDIR!" && exit 2
[[ -z $ADMINUSEREMAIL ]] && errMsg "Accountname (email) may not be empty!" && exit 2

WORKDIR=$(dirname $CREATEUSERSCRIPT)
SCRIPT=$(basename $CREATEUSERSCRIPT)

#echo "php$PHPVERSION-cli '$CREATEUSERSCRIPT' '$SELECTEDVHOSTDIR' '$ADMINUSEREMAIL' '$ADMINUSERNAME' '$ADMINUSERLANG' '$ADMINUSERPASS'"
#exit 0

docker run \
  --rm \
  --volume $SELECTEDVHOSTDIR:$SELECTEDVHOSTDIR \
  --volume $WORKDIR:$WORKDIR:ro \
  --workdir $WORKDIR \
  php:$PHPVERSION-cli \
  php "$SCRIPT" "$SELECTEDVHOSTDIR" "$ADMINUSEREMAIL" "$ADMINUSERNAME" "$ADMINUSERLANG" "$ADMINUSERPASS"

exit 0
