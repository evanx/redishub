
## vimy bash function

We can try the following `vimy` function in our `~/.bashrc`

```shell
vimy() {
  if [ $# -eq 1 -a -f $1 ]
  then
    sudo vi $1
  fi
}

complete -W "$(cat .vimy.completion)" vimy
```

We add the files we often edit to the `.vimy.completion`
```
/etc/nginx/nginx.conf
```

We update our current bash shell:
```shell
. ~/.bashrc
```

