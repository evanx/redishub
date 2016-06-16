
#### How to create a client cert 

You can use our `bash` cert creation script using your account name, as per https://telegram.me/redishub_bot

Our bot will propose a bash script rendered with your account name, as per the authoratitive Telegram.org username.

``shell
curl -s https://redishub.com/cert-script/ACCOUNT
```
where you should substitute `ACCOUNT` for your RedisHub account name i.e. Telegram.org username.

With this invalid placeholder, you can check its `sha1sum` at least.
``shell
curl -s https://redishub.com/cert-script/ACCOUNT | sha1sum
```
which should give the following hash:
```
9ff82c5f9ae78587cdb7785ed8554cf4ab79cc95
```
If it does not, then please report this an issue, e.g. this page should be updated, most likely.

In general, we recommend reviewing any script first before executing it as follows:
``shell
curl -s https://redishub.com/cert-script/ACCOUNT | bash
```

To see the commands being executed including `openssl` you can use `bash -x` as follows:
``shell
curl -s https://redishub.com/cert-script/ACCOUNT | bash -x
```

Query paramaters include:
- `id` - the client cert id e.g. `admin`
- `role` - the client cert tole e.g. `admin`
- `archive` - archive `~/.redishub/live` to `~/redishub/archive/TIMESTAMP` 

The content of this script is as follows when run with a placeholder `ACCOUNT` account name:
```shell
# 
# Curl this script and pipe into bash as follows to create key dir ~/.redishub/live:
# 
# curl -s 'https://secure.redishub.com/cert-script/ACCOUNT' | bash
# 

(
  account='ACCOUNT'
  role='admin'
  id='admin'

  CN='ws:ACCOUNT:admin:admin' # unique cert name (certPrefix, account, role, id)
  OU='admin' # role for this cert
  O='ACCOUNT' # account name

  dir=~/.redishub/live # must not exist, or be archived
  # Note that the following files are created in this dir:
  # account privkey.pem cert.pem privcert.pem privcert.p12 x509.txt cert.extract.txt
  commandKey='cert-script'
  serviceUrl='https://secure.redishub.com'
  archive=~/.redishub/archive
  certWebhook="${serviceUrl}/create-account-telegram/${account}"

  mkdir -p ~/.redishub # ensure dir exists
  curl -s https://raw.githubusercontent.com/evanx/redishub/bin/cert-script.sh 
  echo 'Press Ctrl-C to abort, Enter to execute'
  read _continue
  curl -s https://raw.githubusercontent.com/evanx/redishub/bin/cert-script.sh | bash
)
```

That is effectively appended with a static version of the script as follows:
```
  if [ ! -d ${dir} ]
  then
    echo "Directory ${dir} already exists. Try add '?archive' query to the URL."
  else # directory does not exist
    mkdir ${dir}
    cd $_
    echo "${account}" > account
    if openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -subj "/CN=${CN}/OU=${OU}/O=${O}" \
      -keyout privkey.pem -out cert.pem
    then
      openssl x509 -text -in cert.pem > x509.txt
      grep 'CN=' x509.txt
      cat cert.pem | head -3 | tail -1 | tail -c-12 > cert.extract.pem
      cat privkey.pem cert.pem > privcert.pem
      openssl x509 -text -in privcert.pem | grep 'CN='
      curl -s -E privcert.pem "$certWebhook" ||
        echo "Registered account ${account} ERROR $?"
      if ! openssl pkcs12 -export -out privcert.p12 -inkey privkey.pem -in cert.pem
      then
        echo; pwd; ls -l
        echo "ERROR $?: openssl pkcs12 ($PWD)"
        false # error code 1
      else
        echo "Exported $PWD/privcert.p12 OK"
        pwd; ls -l
        sleep 2
        echo ""
        # ... more echo
        curl -s https://raw.githubusercontent.com/webserva/home/master/docs/install.rhcurl.txt
        certExtract=`cat cert.extract.pem`
        echo "Try https://telegram.me/redishub_bot '/grantcert $certExtract'"
      fi
    fi
  fi
```

### How to register a client cert 

```shell
curl -E ~/.redishub/privcert.pem https://secure.redishub.com/register-cert
```


#### Troubleshooting

```shell
openssl x509 -text -in ~/.redishub/live/privcert.pem | grep 'CN='
```
 
