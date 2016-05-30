
set -u -e

command=${1-}

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
  rhinfo 'rh <keyspace> reg'
}

kshelp() {
  local keyspace="$1"
  rhhead "RedisHub $account $keyspace"
  rhinfo "Try the following cmds:"
  rhinfo "rh $keyspace register-keyspace"
  rhinfo "rh $keyspace <cmd> # e.g. set, get, sadd, hgetall et al"
  rhdebug "curl -s -E ~/.redishub/live/privcert.pem https://$domain/ak/$account/$keyspace"
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
      curl -s -E ~/.redishub/live/privcert.pem "https://$domain/ak/$account/$keyspace/$cmd"
      return $?
    fi
  fi
  local domain=${RHCLI-cli.redishub.com}
  rhdebug domain=$domain account=$account
  if [ $# -eq 0 ]
  then
    rhhelp 
    return 1
  elif [ $# -eq 1 ]
  then
    if [ "$1" = 'routes' ]
    then
      rhinfo "curl -s -E ~/.redishub/live/privcert.pem https://$domain/routes"
      curl -s -E ~/.redishub/live/privcert.pem https://$domain/routes
      return $?
    elif [ "$1" = 'register-cert' ]
    then
      rhinfo "curl -s -E ~/.redishub/live/privcert.pem https://$domain/register-cert"
      curl -s -E ~/.redishub/live/privcert.pem https://$domain/register-cert
      return $?
    elif [ "$1" = 'register-account' ]
    then
      rhinfo "curl -s -E ~/.redishub/live/privcert.pem https://$domain/register-account-telegram/$account"
      curl -s -E ~/.redishub/live/privcert.pem https://$domain/register-account-telegram/$account
      return $?
    else
      kshelp $1
      return 1
    fi
  fi
  local keyspace="$1"
  shift
  if [ $# -eq 0 ]
  then
    rhhelp
    return 1
  fi
  local cmd="$1"
  shift
  if echo "$cmd" | grep -q '^reg$\|^register$\|^register-keyspace$'
  then
    cmd='register-keyspace'
  fi
  while [ $# -gt 0 ]
  do
    cmd="$cmd/$1"
    shift
  done
  rhdebug "CN=$CN OU=$OU https://$domain/ak/$account/$keyspace/$cmd"
  curl -s -E ~/.redishub/live/privcert.pem "https://$domain/ak/$account/$keyspace/$cmd"
}

rhcurl $@

