
### How to get tail characters of a cert PEM

Try this command:
```shell
cat ~/.redishub/live/cert.pem | tail -2 | grep '^\w' | sed 's/=*$//' | tail -c-12
```
where we exclude any '=' Base64 padding at the end of the last line of the PEM.

#### Step by step 

Get the last two lines of the PEM:
```shell
cat ~/.redishub/live/cert.pem | tail -2
```
Result:
```
JepFtfage+nEzTOH9uNXDtXTqESABt1vBLf1+LOhjyzY1EI2M7QaVBU=
-----END CERTIFICATE-----
```
We exclude the last line starting with '-'
```shell
cat ~/.redishub/live/cert.pem | tail -2 | grep '^\w' 
```
Result:
```
JepFtfage+nEzTOH9uNXDtXTqESABt1vBLf1+LOhjyzY1EI2M7QaVBU=
```
Remove any '=' Base64 padding at the end of the line:
```shell
cat ~/.redishub/live/cert.pem | tail -2 | grep '^\w' | sed 's/=*$//' 
```
Result:
```
JepFtfage+nEzTOH9uNXDtXTqESABt1vBLf1+LOhjyzY1EI2M7QaVBU
``` 
Take the last 12 characters only:
```shell
cat ~/.redishub/live/cert.pem | tail -2 | grep '^\w' | sed 's/=*$//' | tail -c-12
```
Result:
```
1EI2M7QaVBU
```

