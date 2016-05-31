
set -u -e

shellCommand1=${1-}

. ~/redishub/bin/rhlogging.sh

tmp=~/.bashbin/ttl/minutes/1
[ -d $tmp ] || mkdir -p $tmp

if [ ! -r ~/.redishub/live/account ]
then
  rherror 'Missing file: ~/.redishub/live/account'
  rherror 'This file must contain your RedisHub/Telegram account name'
  rherror 'Try @redishub_bot /signup'
  exit 3
fi

rhhelp() {
  rhhead "RedisHub $account"
  rhinfo 'Try:'
  rhinfo 'rh <keyspace> create-keyspace'
  exit 3
}

kshelp() {
  local keyspace="$1"
  rhhead "RedisHub $account $keyspace"
  rhinfo "Try the following cmds:"
  rhinfo "rh $keyspace create-keyspace"
  rhinfo "rh $keyspace <cmd> # e.g. set, get, sadd, hgetall et al"
  rhdebug "curl -s -E ~/.redishub/live/privcert.pem https://$domain/ak/$account/$keyspace"
  exit 3
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
  account=`cat ~/.redishub/live/account`
  if ! echo $OU | grep -q "%${account}@"
  then
    echo "ERROR $OU does not match Telegram user $account"
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
    return 1
  elif [ "$1" = 'routes' ]
  then
    rhinfo "curl -s -E ~/.redishub/live/privcert.pem https://$domain/routes"
    curlpriv https://$domain/routes
    return $?
  elif [ "$1" = 'create-ephemeral' ]
  then
    rhinfo "curl -s -E ~/.redishub/live/privcert.pem https://$domain/register-cert"
    curlpriv https://$domain/
    return $?
  elif [ "$1" = 'register-cert' ]
  then
    rhinfo "curl -s -E ~/.redishub/live/privcert.pem https://$domain/register-cert"
    curlpriv https://$domain/register-cert
    return $?
  elif [ "$1" = 'register-account' ]
  then
    rhinfo "curl -s -E ~/.redishub/live/privcert.pem https://$domain/register-account-telegram/$account"
    curlpriv https://$domain/register-account-telegram/$account
    return $?
  fi
  local keyspace="$1"
  shift
  if [ $# -eq 0 -o "${1-}" = 'help' ]
  then
    kshelp $keyspace
    return 1
  fi
  local cmd="$1"
  shift
  if echo "$cmd" | grep -q '^create$\|^reg$\|^register$\|^register-keyspace$' # TODO
  then
    cmd='create-keyspace'
  fi
  while [ $# -gt 0 ]
  do
    cmd="$cmd"'/'"$1"
    shift
  done
  rhdebug "CN=$CN OU=$OU https://$domain/ak/$account/$keyspace/$cmd"
  curlpriv "https://$domain/ak/$account/$keyspace/$cmd"
}

rhcurl $@
