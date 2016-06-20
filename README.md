
## evanx/redishub

Note that this service is currently being rebranded from <b>RedisHub.com to WebServa.com</b> 

For "About" page, please be redirected to: https://github.com/webserva/webserva

Try the demo to create a "ephemeral" keyspace: https://demo.webserva.com/create-ephemeral

![Landing screenshot](http://evanx.github.io/images/rquery/ws040-ephemeral.png)

WebServa's marketing tag line might be "the fast web database service."
It's <b>fast</b> because it's a RAM database, using Redis. 
It's a <b>web database,</b> because it's accessed via HTTPS. 

It's for everyone because its easy to store data by key, with lists, sets and sorted sets to keep track of things. There is more to come e.g. geographical data courtesy of Redis 3.2.

Try demo: https://demo.webserva.com/create-ephemeral. This endpoint creates a new ephemeral keyspace with a TTL of 10 minutes, for demonstration purposes. This is assigned an "unguessable" 12 character keyspace name. 

You can signup via our Telegram bot `@WebServaBot` via the command `/signup.` This will create an account as per your Telegram username. It will advise how to create an a client cert for https://secure.webserva.com i.e. for private keyspaces.

![Bot signup](http://evanx.github.io/images/rquery/ws040-webservabot.png)

The cert script will advise how to install our CLI `wscurl` bash script. This is a wrapper of `curl` using your cert in `~/.webserva/live`

![Curl command line wrapper](http://evanx.github.io/images/rquery/ws040-wscurl.png)

For "About" page, see: https://github.com/webserva/webserva

