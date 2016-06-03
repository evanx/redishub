
set -u -e

serviceLabel=${RHLABEL-RedisHub}
domain=${RHCLI-cli.redishub.com}
cdn=${RHCLICDN-cli.redishub.com}

[ "$domain" != 'cli.redishub.com' ] && serviceLabel=$domain

shellName=$0
shellCommand1=${1-}
shellArgs="${*}"

. ~/redishub/bin/rhlogging.sh

tmp=~/.ttl/redishub/days/1
if [ ! -d $tmp ] 
then
  rhwarn "Creating tmp directory: mkdir -p $tmp"
  rhinfo "Press Ctrl-C to abort, or Enter to continue..."
  read _continue
  mkdir -p $tmp
else
  rhdebug tmp $tmp
fi

trap_error() {
  local code="${1}"
  local lineno="$2"
  if [ $code -lt 63 ] 
  then
    rherror "line $lineno: error code $code"
    rhinfo "Try using bash -x as follows:"
    rhinfo "bash -x ~/redishub/bin/rhcurl $shellArgs"
  fi
}

trap_sigint() {
  find ~/.bashbin/ttl/days/1 -type f -mtime +1 -delete 
}

trap_sigterm() {
  find ~/.bashbin/ttl/days/1 -type f -mtime +1 -delete 
}

trap trap_sigint SIGINT
trap trap_sigterm SIGTERM 
trap 'trap_error $? ${LINENO}' ERR

if [ ! -r ~/.redishub/live/account ]
then
  rherror 'Missing file: ~/.redishub/live/account'
  rherror 'This file must contain your RedisHub/Telegram account name'
  rherror 'Try @redishub_bot /signup'
  exit 3
fi

kshelp1() {
  local keyspace=$1
  rhinfo "rh $keyspace help # builtin help"
  rhinfo "rh $keyspace set mykey myvalue # set a key to value"
  rhinfo "rh $keyspace get mykey # get a key"
  rhinfo "rh $keyspace ttl mykey # show the key time to live"
  rhinfo "rh $keyspace lpush mylist myvalue # push to a list"
}

rhhelp() {
  rhhead "$serviceLabel $account "
  rhinfo 'Try:'
  rhinfo 'rh create-ephemeral # create a new ephemeral keyspace'
  rhinfo 'rh tmp10days create-keyspace'
  rhinfo "rh keyspaces # list your account keyspaces"
  kshelp1 tmp10days
  rhinfo "rh routes # more online help"
}

kshelp() {
  local keyspace="$1"
  rhhead "RedisHub $account $keyspace"
  rhinfo "Try the following commands:"
  rhinfo "rh keyspaces"
  rhinfo "rh $keyspace create-keyspace # if new"
  rhinfo "rh $keyspace \$command \$key ...params # e.g. set, get, sadd, hgetall et al"
  rhinfo "rh $keyspace ttl \$key"
  rhinfo "rh routes # more online help"
  rhdebug "curl -s -E ~/.redishub/live/privcert.pem https://$domain/ak/$account/$keyspace"
  exit 253
}

curlpriv() {
  [ $# -eq 1 ]
  rhdebug "curl -s -E ~/.redishub/live/privcert.pem '$1'"
  curl -s -E ~/.redishub/live/privcert.pem "$1"
}

rhcurl() {
  openssl x509 -text -in ~/.redishub/live/privcert.pem > $tmp.certInfo
  CN=`cat "$tmp.certInfo" | grep 'CN=' | sed -n 's/.*CN=\(\S*\),.*/\1/p' | head -1`
  OU=`cat "$tmp.certInfo" | grep 'OU=' | sed -n 's/.*OU=\(\S*\).*/\1/p' | head -1`
  O=`cat "$tmp.certInfo" | grep 'O=' | sed -n 's/.*O=\(\S*\).*/\1/p' | head -1`
  account=`cat ~/.redishub/live/account`
  if ! echo $O | grep -q "^${account}$"
  then
    echo "ERROR O name '$O' does not match account '$account'"
    return 3
  fi
  local url=''
  if [ $# -eq 1 ]
  then
    if [ "$1" = 'help' ]
    then
      rhhelp
      return 0
    elif echo "$1" | grep -q '^https'
    then
      url="$1"
    elif echo "$1" | grep -q '^[a-z]*\.redishub.com'
    then
      url="https://$1"
    fi
    if [ -n "$url" ]
    then
      rhdebug "CN=$CN OU=$OU https://$domain/ak/$account/$keyspace/$cmd"
      curlpriv "https://$domain/ak/$account/$keyspace/$cmd"
      return $?
    fi
  fi
  local domain=${RHCLI-cli.redishub.com}
  rhdebug domain=$domain account=$account
  local uri=''
  if [ $# -eq 0 ]
  then
    rhhelp
    return 253
  elif [ "$1" = 'routes' ]
  then
    if [ -f $tmp/routes ]
    then
      rhdebug "cached file stat" $tmp/routes $[ `date +%s` - `stat -c %Z $tmp/routes` ]
    else
      if ! curl -s https://$cdn/routes > $tmp/routes
      then
        rm -f $tmp/routes
        rherror "https://$cdn/routes (code $?)"
        return 4
      fi
    fi
    cat $tmp/routes | grep '^accountKeyspace:' -B99 
    cat $tmp/routes | grep '^accountKeyspace:' -A99 |
      sed -n 's/^\/ak\/:account\/:keyspace\/\([a-z][-a-z]*\)$/\1/p' | tr '/' ' '
    cat $tmp/routes | grep '^accountKeyspace:' -A99 |
      sed -n 's/^\/ak\/:account\/:keyspace\/\([a-z][-a-z]*\)\/\(.*\)$/\1 \2/p' | tr '/' ' ' | sed 's/://g'
    return $?
  elif [ "$1" = 'keyspaces' ]
  then
    curlpriv https://$domain/account-keyspaces/$account
    return $?
  elif [ "$1" = 'create-ephemeral' ]
  then
    curlpriv https://$domain/create-ephemeral
    return $?
  elif [ "$1" = 'register-cert' ]
  then
    curlpriv https://$domain/register-cert
    return $?
  elif [ "$1" = 'register-account' ]
  then
    curlpriv https://$domain/register-account-telegram/$account
    return $?
  elif [ $# -eq 1 ]
  then
    if echo "$1" | grep '^create$\|^create-keyspace\|^reg$\|^register$\|^register-keyspace$\|^help$' # TODO
    then
      rhhelp
      return 253
    else
      kshelp $1
      return 63
    fi
  fi
  local keyspace="$1"
  shift
  if [ $# -eq 0 -o "${1-}" = 'help' ]
  then
    kshelp $keyspace
    return 253
  fi
  local cmd="$1"
  shift
  if echo "$cmd" | grep '^create$\|^create-keyspace\|^reg$\|^register$\|^register-keyspace$\|^help$' # TODO
  then
    cmd='create-keyspace'
  fi
  while [ $# -gt 0 ]
  do
    cmd="$cmd"'/'"$1"
    shift
  done
  if echo "$keyspace" | grep -q '^hub/'
  then
    curlpriv "https://$domain/ak/$keyspace/$cmd"
  else
    rhdebug "CN=$CN OU=$OU https://$domain/ak/$account/$keyspace/$cmd"
    curlpriv "https://$domain/ak/$account/$keyspace/$cmd"
  fi
}

rhcurl $@
