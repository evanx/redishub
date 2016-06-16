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
        curl -s https://redishub.com/cert-script-help/${account}
        curl -s https://raw.githubusercontent.com/evanx/redishub/master/docs/install.rhcurl.txt
        certExtract=`cat cert.extract.pem`
        echo "Try https://telegram.me/redishub_bot '/grantcert $certExtract'"
      fi
    fi
  fi
