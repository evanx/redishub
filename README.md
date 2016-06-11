
## RedisHub.com

<i>The RedisHub.com home page and `/about` are redirected to this page.</i>

RedisHub's marketing tag line might be "the fast web database service."
It's <b>fast</b> because it's a RAM database, using Redis. 
It's a <b>web database,</b> because it's accessed via HTTPS. 

It's for everyone because its easy to store data by key, with lists, sets and sorted sets to keep track of things. There is more to come e.g. geographical data courtesy of Redis 3.2.

Try demo: https://demo.redishub.com/create-ephemeral. This endpoint creates a new ephemeral keyspace with a TTL of 10 minutes, for demonstration purposes. This is assigned an "unguessable" 12 character keyspace name. 

<img src='http://evanx.github.io/images/rquery/redishub-welcome.png'/>

You can signup via our Telegram bot `@redishub_bot` via the command `/signup.` This will create an account as per your Telegram username. It will advise how to create an a client cert for https://secure.redishub.com/routes, and how to install our CLI `rhcurl` bash script. This is a wrapper of `curl` using your cert. 

<img src='http://evanx.github.io/images/rquery/rh.png'/>

Our "10MB" service is free. This service bundle includes 10MB peak RAM and 20GB monthly transfer. So for example, you can store 250k records averaging 40 characters each, on us. 

So sign up and imagine some cool use cases for storing hot data in memory in the cloud, publishable in volume via CDN, or kept private:
- "open" keyspaces have a randomly-generated name that you can keep secret, or share
- keyspaces you create on account are strictly privately accessible by default
- private access is via client certs you have authorised on your account 
- you can publish specific keyspaces for read-only access to the web via CloudFlare CDN
- "permutable" keyspaces can be shared e.g. for registries, message hubs and metrics aggregators

Note that client certs are:
- self-signed e.g. created using `openssl` with your account name as the Organisation (O name)
- the Organisational Unit (OU name) is the role of the cert e.g. `admin`
- Our bot will advise the URL of a custom bash script to create client certs using `openssl`
- client certs are authorised by account admins via our Telegram.org bot

The service is intended to be priced roughly according to Digital Ocean infrastructure costs, as a market indicator. 
Your account can be topped up via virtual currency where "50MB" bundles are roughly 50c USD per month.

Documentation: https://github.com/evanx/rquery

Technically speaking, RedisHub is an Nginx deployment of our opensource Node webserver for Redis multi-tenancy and access control. 
It is intended to be highly-available for reads via CDN, and also for writes, via Redis Cluster. 
It is available to client and server, web and mobile apps, authenticated and open. 
We define "open" as no client cert required, and "secure" as requiring a client cert. 

<img src='http://evanx.github.io/images/rquery/rh-curl.png'/>

### Status

UNSTABLE, INCOMPLETE

### Immiment API additions

For shorter URLs, we intend the support the following endpoints by the end of June:

- `redishub.com/:account/:keyspace` - openly published keyspaces 
- `secure.redishub.com/:account/:keyspace` - strictly privately secured keyspaces

We wish to support specific "perspectives" on keyspaces:
- accessing raw data - e.g. JSON
- schema - specifies required data elements for a class of keyspaces
- HTML forms - edit and validate hash fields according to a specified schema
- Tabular data - e.g. for rendering consumption reports and account statements
- charts - for rendering dashboards of pre-defined metrics
- Schema.org content - for rendering blog articles according to a specified template
- compositional perspective - template for the 

### FAQ

#### What is RedisHub?

It is envisaged as online hub of Redis keyspaces accessed via HTTPS. These can be private, public or shared. We support various Redis commands for lists, sets etc, although not all (yet).

RedisHub is intended as a serverless database, cache and messaging hub, accessed via HTTPS.

Currently, ephemeral keyspaces are created with a randomly generated name, which you can keep secret, or share.

Private keyspaces can be created. They are secured using self-signed client certificates e.g. generated using `openssl.`

#### How do I navigate the site?

Links are shown in color. Otherwise click anywhere on the iconized header to go "back" a level e.g. to your keyspace home, `/routes` and finally here.

For example, in the following screenshot, you would click anywhere on top row containing:
- the database icon
- the "hub" account name 
- the ephemeral keyspace label

<img src='http://evanx.github.io/images/rquery/redishub-welcome.png'/>

Incidently, "hub" is the specially named "open" account name, i.e. accessed without a cert. It is available for limited writes at this time, at least while not victim to DoS or some sudden overload.

#### How do I try Redis commands?

Try: https://demo.redishub.com/create-ephemeral

This will create a new ephemeral keyspace for you. The keyspace home page lists some sample commands you can try. These links are rendered in color.

Incidently, this will create a ephemeral keyspace on the "demo" database. TTLs are 10 minutes only, but this is fine for the playground.

Note that currently we don't have a command completion tool, but you can edit the URL itself in the browser location bar. Also try to change the domain to `replica.redishub.com` to check the replication.

#### Why use a Redis database rather than SQL?

Redis is a popular and awesome NoSQL database. It's in-memory and so really fast. It supports data structures which are well understood and pretty fundamental, e.g. sets, sorted sets, lists, hashes and geos.

Having said that, I love SQL too and may use PostgreSQL to drive `pg.redishub.com` e.g. where each command is saved in a PostgreSQL record like `{account, keyspace, key, command, params}` which can be replayed for point-in-time recovery.

#### But isn't Redis just for caching?

Certainly Redis is the leading caching server. But actually Redis is an in-memory "data structure server." As such, it has many use cases, including fast shareable data storage, analytics, geo-spatial processing, synchronisation, queuing and messaging.

#### How do I generate an RedisHub admin cert?

You can use `@redishub_bot /signup` which will propose a bash script to generate a `privcert.pem` (e.g. for curl CLI) and `privcert.p12` to import into your browser.

#### How do I force my browser to send my cert

Open a new incognito window, or restart your browser. This is required if you pressed Cancel in Chrome when prompted to select the cert. The browser remembers that for the current session, and so will not ask again. 

The "secure" site allows sessions without a cert e.g. for "open" routes, but performs access control for account/keyspace access.

#### What upcoming features?

- setting keys and values via HTTPS POST (pipes)
- multiple commands transactions via HTTPS POST
- sequentially tagged requests to handle retries e.g. so `lpush` commands are safe to retry if response not received
- role-based keyspace access control - admins can control which certs can access their private keyspaces, and if read-only or add-only
- export and import to JSON: Entire keyspaces can be exported as a JSON file, or imported or created from such

#### Why do keys expire after 10 minutes?

Ephemeral (unauthenticated) keyspaces expire in 10 minutes.

Authenticated accounts have a longer default expiry, currently 10 days.

The short-term plan is to enable the following features:
- account admins can modify the default TTL of account keyspaces
- authenticated clients can persist keys

Initially, we will provide a disk-based archive limited to:
- string value of keys

Later we will support archiving hashes, lists, sets, zsets and geos.

We will publish the archive via CloudFlare on the domain `cdn.redishub.com` so that the data that you make public can be served in volume by CloudFlare. This means that data accessed from some region of the globe, will be cached there for 3 minutes, and served immediately by CloudFlare.

Ideally the archive should be seamless, although read-only requests might be HTTP redirected to get unmodified data:
- `cdn.redishub.com` for data not modified for some time
- `replica.redishub.com` for data that has been replicated since it was last modified


#### Who is RedisHub?

I'm a web developer based in Cape Town, working on content sites for a news publisher, using Nginx, Node, React and Redis. In my spare time, I work on my Github projects. Previously, I've been a Java enterprise developer, PostgreSQL DBA and Linux engineer.

Find me at https://twitter.com/@evanxsummers.


#### Why are you doing this?

RedisHub is my pet R&D project, to build something cool with my favourite toys, and thereby explore security, devops, microservices, monitoring, logging, metrics and messaging.

RedisHub is already "mission accomplished" in the sense that it can be used as a "playground" for Redis commands, whilst also providing authenticated access to secure keyspaces for some professional use cases I have in mind. However I'm inspired to take it further.


#### Why does the site redirect to this Github page?

Currently all HTTP requests are redirected, and also some HTTPS ones, namely the home page and `/about.`

I wished to focus on client cert auth first, so no webpage for login/signup yet.

Having said that, you can:
- signup via Telegram.org chat to `@redishub_bot`
- login your web browser using your self-signed client cert

#### Why do my client certs have CN and OU names only?

Our scripts assist with generating RedisHub client certs with DN defaults such that:
- CN - unique identity (user/device ID) granted access to the account
- OU - role for access by this cert
- O - RedisHub account as per an individual or organisation
- Other location fields are optionally specified

Note that an authoritative Telegram.org account is linked to the RedisHub account. Therefore an organisation, like an individual, should create its own Telegram.org account, e.g. using a prepaid SIM.

#### What are RedisHub lambdas?

These are envisaged as Redis-based lambdas that can be composed into microservices and apps.
I'm choosing to misdefine "lambdas" as server-side components which access one or more keyspaces.
They must be stateless to enable auto-scaling, but can store private and shared state in Redis of course. They must be written using a specific ES2016 framework, to simplify orchestration and management, e.g. configuration, keyspace access, logging and metrics.

#### What about ACID?

Atomicity, consistency, isolation and durability guarantees are those offered by Redis. This is a trade-off sacrificing absolute durability in favour of performance, e.g. potentially loosing a second's worth of transactions in the rare event of a server crash, versus the heavy performance cost of a disk sync on every transaction.

We wish to support maximally durable transactions since this is an important use case e.g. to record financial transactions using PostgreSQL. However, I wish firstly to address web content, messaging and analytics use cases, optionally trading off performance for database size using ssdb.io, or performance for durability using PostgreSQL.

Incidently, as an former PostgreSQL DBA for a SaaS application, I'm not convinced that absolute durability is as important as performance. One is always vulnerable to minor "disasters," the most common of which are application and configuration errors. Often application load necessitates tweaking RAID settings to boost performance at the cost of durability.

#### Why use a hosted Redis service rather than one's own?

Actually RedisHub doesn't offer hosted Redis instances (yet).
It addresses some use cases where an online serverless storage/messaging service is convenient.

#### Will you ever offer a hosted Redis service?

There are other PaaS vendors that offer hosted Redis at scale, e.g. AWS ElastiCache, RedisLabs, OpenRedis and RedisGreen.

I wish to experiment with orchestrating Redis instances, clusters and replicas, to automate RedisHub itself. However I'm more interested in other things e.g. auto-archival and serverless lamdbas, than Redis hosting per se.

#### How will RedisHub support its lambdas?

The platform should handle identity, auth, configuration, deployment, logging, messaging, monitoring and scaling. A notable simplication is that Redis will be used across the board for all these concerns.

#### Why would a developer use an indie service which might become abandonware?

That is a very good question. I guess it would have to be compelling for a specific niche, e.g. Telegram bots.

#### What is free?

I want to offer a free public utility in perpetuity to support most low-volume use cases, where the computing cost is less than 10c per user per month, e.g. peak database size of 10MB RAM with a 10Gb transfer limit per month.

#### What about higher volume usage?

Users who wish to exceed the above-mentioned free limits, should become a "funder" contributing the equivalent of 50c per month to our Bitcoin wallet. Funders' limits are bumped up to 30MB RAM (Redis) storage and 30Gb transfer per month. You can double up as needed and contribute accordingly, e.g. $5 for 300MB, $50 for 3GB.

#### What value length limits?

We currently only support `GET` where the maximum URL length is 2083 characters, most of which can be the value. So value strings are limited to around 2050 characters when URL encoded, which is quite limited for JSON documents.

Later we will support `POST` for `set, hset` et al, and thereby enable larger document limits.

#### How to create an account

Chat `/signup` to `@redishub_bot` on https://web.telegram.org. That will propose an `openssl` script for `bash.`

I haven't yet built a typical SaaS web site (yet) with signup, signin with Google, etc.

Currently, your Telegram username is used for your private RedisHub account name.

#### Why Telegram.org?

I've always liked the sound of Telegram, e.g. their security and openness.
Also I have a Ubuntu phone, which has Telegram.
Last but not least, I want to enter the Bot competion and maybe get lucky and win one of those prizes.
"Then we'll be millionaires!" as Homer says ;)

#### What technology is behind a RedisHub keyspace?

It is a deployment of my Node project: https://github.com/evanx/rquery, using Nginx and Redis 2.8.

We serve data globally via the CloudFlare CDN on `cdn.redishub.com.` 
This is for URL-secured data e.g. that you specifically publish from account keyspaces. 
It will be cached by CloudFlare for 3 minutes, and so is "warm" data, i.e. regularly updated. 

Incidently, we classify `replica.redishub.com` as "hot" data, since it is updated continually via database replication,
and not cached via CloudFlare. 
Moreover it performs client cert authentication to authorise account access.

There are multiple production configurations deployed via Nginx:
- demo.redishub.com - playground with short TTLs and no client auth
- secure.redishub.com - client SSL auth, account admin, longer TTLs
- open.redishub.com - no client SSL auth e.g. used for enrollment and public/secret keyspaces
- replica.redishub.com - replica and hot standby

See: https://github.com/evanx/rquery/tree/master/config

For convenience other domains are provided for the "secure" server:
- cli.redishub.com - for command-line access, so responses are `text/plain` by default
- json.redishub.com - response content always `application/javascript`

Short-term deployment plans:
- 64GB Redis Cluster
- `cdn.redishub.com` for read-only queries to open warm data via CloudFlare CDN
- `archive.redishub.com` for read-only authenticated access to warm data

Note that clients should follow HTTP redirects to the above domains when reading data.

As soon as warranted, we look forward to deploying Redis Clusters on multiple 64GB dedicated machines in multiple regions.

Incidently, early adopters who pay for more resources e.g. 50c per 32MB RAM, will become co-owners of RedisHub via a sharepool. The shareholding of the pool will be computed by an algorithm.

#### What financial technology is planned?

For a given point in time e.g. a specific month end, the resource algo will reduce multiple time series, including the virtual currency transfers (credits) to a RedisHub wallet, reconciled with the actual resource costs (debits) of the account associated with the sender's virtual currency address. It thereby generates an account statement.

Similarly, the shareholding algo will determine the virtual shareholding of each account.

The shareholding algo must reward early adopters, since they are naturally critical to success.

Clearly it must also reward pre-payment, since our financial surplus provides financial security to operations, and can be used for development and dividend payouts.

The dividend algo might also be a mechanism for share transfers, whereby account holders provide buy/sell orders for price/volume. If their buy volume is zero, then they are paid the dividend in full. Otherwise their buy/sell orders are settled, and their dividend recalculated.

I'm still working out the details, but the reality is that customers are "funders." The plan is that funders collectively own 49% of RedisHub. I own 51%, make executive decisions and provide regular reports to shareholders i.e. a newsletter to customers :) Watch out for announcements via https://twitter.com/@evanxsummers.

#### What are the domains demo, open, secure et al?

The `demo` domain has its own database, but otherwise all subdomains access the same master database:
 - `open` - without client cert authentication
 - `secure` - with client cert authentication for account endpoints
 - `replica` - read-only replica (hot data) with optional client authentication
 - `cdn` - read-only cached replica (warm data)
 - `archive` - read-only disk-based archive to recover cold data

#### How do I trust your server cert?

Our domains are secured via Let's Encrypt:
```shell
echo -n | openssl s_client \
  -connect cli.redishub.com:443 2>/dev/null | grep '^Cert' -A2
```
```shell
Certificate chain
 0 s:/CN=secure.redishub.com
   i:/C=US/O=Let's Encrypt/CN=Let's Encrypt Authority X3
```

Some systems have an outdated "CA certs" file which does not include Let's Encrypt cert.

We can support only clients that trust Let's Encrypt, explicity if not by default:
```shell
$ curl --cacert ~/.cacerts/letsencrypt/isrgrootx1.pem.txt https://cli.redishub.com/time/seconds
1464377206
```

See: https://letsencrypt.org/2015/06/04/isrg-ca-certs.html


### Goals

Build a site "redishub.com" with a foundational HTTP service for accessing and mutating keys in a hosted Redis "keyspace."

A keyspace is an online database accessible via Redis-style commands, and can be Redis i.e. in-memory, or disk-based e.g. via ssdb.io.

User stories:
- Use a free hosted Redis "keyspace" for low-volume ephemeral purposes
- Deploy your own private "redishub" instance using the `rquery` opensource implementation, as used by RedisHub

Potential uses of keyspaces:
- serverless backend database
- storing encrypted data
- public/shared/private online message hub
- centralised logging, monitoring and alerting
- aggregated analytics

Future user stories:
- Manage the account admins and users
- Manage access to keyspaces
- Group/classify keyspaces for access control purposes
- Web admin console to inspect and manage keys
- Use disk-based keyspaces for archival
- Manage auto-archival of keys
- Enable a durable transaction log facility with playback for recovery
- Deploy RedisHub "lambdas" to `lambdas.redishub.com` to build Redis-driven serverless backends
- Page lambdas generate web pages from React templates, populated with data from RedisHub

RedisHub lambdas are special ES2016 scripts that use keyspaces for:
- pulling their configuration
- pushing logging messages e.g. info and errors
- pushing metrics e.g. for response time histograms, user geo distribution, et al
- messaging via Redis lists e.g. for microservice app architecture
- storing application state e.g. to support stateless microservices for auto-scaling
- persistent data storage via Redis keys e.g. values, lists, sets, sorted sets, hashes, geo et al

Related specification: https://github.com/evanx/component-validator


### Related

See: https://github.com/evanx/rquery

Notable features (June 2016):
- Create adhoc ephemeral keyspaces
- Identity verification via Telegram.org chat bot `@redishub_bot`
- Access secured via client-authenticated SSL (secure.redishub.com)
- Generate tokens for Google Authenticator
- Encrypt keys using client cert

### Documentation

See: https://github.com/evanx/rquery
