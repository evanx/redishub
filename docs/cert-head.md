
### How to get the head characters of a cert PEM

Try this command:
```shell
cat ~/.redishub/live/cert.pem | head -2 | tail -1 | tail -c-12
```

