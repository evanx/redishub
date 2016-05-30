
## RedisHub

Try: https://demo.redishub.com/register-ephemeral

Documentation: https://github.com/evanx/rquery

Note that (insecure) HTTP access to all RedisHub domains, and also some other HTTPS URLs e.g. home page and `/about,` are redirected to this info page.


### Status

UNSTABLE, INCOMPLETE


### FAQ

#### What is RedisHub?

It is envisaged as online hub of Redis keyspaces accessed via HTTPS. These can be private, public or shared. We support various Redis commands for lists, sets etc, although not all (yet).

RedisHub is intended as a free serverless database for some low-volume use cases e.g. with data expiring from RAM if not accessed for some time.

Currently, ephemeral keyspaces are created with a randomly generated name, which you can keep secret, or share.

Private keyspaces can be created. They are secured using self-signed client certificates e.g. generated using `openssl.`

#### What upcoming features?

HTTP POST

Role-based keyspace access control: Admins can control which certs can access their private keyspaces, and if read-only or add-only.

Export and import to JSON: Entire keyspaces can be exported as a JSON file, or imported or created from such.


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


#### How do I generate an RedisHub admin cert?

You specify the authoritative Telegram.org username for the RedisHub account.

You can use `@redishub_bot /signup` which will propose an `openssl` command.

You use that `openssl` command to generate a PEM for `curl` and P12 for your browser.

#### Why use a Redis database rather than SQL?

Redis is a popular and awesome NoSQL database. It's in-memory and so really fast. It supports data structures which are well understood and pretty fundamental, e.g. sets, sorted sets, lists, hashes and geos. Having said that, I love SQL too and may use PostgreSQL for some transactional aspects of RedisHub.

#### But isn't Redis just for caching?

Certainly Redis is the leading caching server. But actually Redis is an in-memory "data structure server." As such, it has many use cases, including fast shareable data storage, analytics, geo-spatial processing, synchronisation, queuing and messaging.

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

I wish to experiment with orchestrating Redis instances, clusters and replicas, to automate RedisHub itself. However I'm more interested in other things e.g. auto-archival and supporting serverless lamdbas, than Redis hosting per se.

#### How will RedisHub support its lambdas?

The platform should handle identity, auth, configuration, deployment, logging, messaging, monitoring and scaling. A notable simplication is that Redis will be used across the board for all these concerns.

#### Why would a developer use an indie service which might become abandonware?

That is a very good question. I guess it would have to be compelling for a specific niche, e.g. Telegram bots.

#### What is free?

I want to offer a free public utility in perpetuity to support most low-volume use cases, where the computing cost is less than 10c per user per month, e.g. peak database size of 10MB RAM with a 10Gb transfer limit per month.

#### What about higher volume usage?

Users who wish to exceed the above-mentioned free limits, should become a "funder" contributing the equivalent of 50c per month to our Bitcoin wallet: 1Djf7wqB7jqBTWWMoLht9MhLeKBZEkDjS5. Funders' limits are bumped up to 50MB RAM (Redis) storage and 50Gb transfer per month. You can double up as needed and contribute accordingly, e.g. $5 for 300MB, $50 for 3GB.

#### What value length limits?

We currently only support `GET` where the maximum URL length is 2083 characters, most of which can be the value. So value strings are limited to around 2050 characters when URL encoded, which is quite limited for JSON documents.

Later we will support `POST` for `set, hset` et al, and thereby enable larger document limits.

#### How to register an account

I haven't yet built a typical SaaS web site with signup, signin with Github, etc. Nevertheless one must be able to identify and alert users for operational reasons, e.g. send a monthly usage report.

Currently, your Telegram username is used for your private RedisHub account name. See documentation: https://github.com/evanx/rquery.

#### Why Telegram.org?

I've always liked the sound of Telegram, e.g. their security and openness.
Also I have a Ubuntu phone, which has Telegram.
Last but not least, I want to enter the Bot competion and maybe get lucky and win one of those prizes.
"Then we'll be millionaires!" as Homer says ;)


#### What technology is behind a RedisHub keyspace?

It is a deployment of my Node project: https://github.com/evanx/rquery, using Nginx and Redis 2.8.

There are two production configurations:
- demo.redishub.com - playground with short TTLs
- secure.redishub.com - client SSL auth, account admin, longer TTLs

See: https://github.com/evanx/rquery/tree/master/config

For convenience other domains are provided for the "secure" server:
- cli.redishub.com - for command-line access, so responses are `text/plain` by default
- json.redishub.com - response content always `application/javascript`

Short-term deployment plans:
- `hot.redishub.com` VM for hot standby via a Redis replica.
- `archive.redishub.com` for read-only authenticated access to warm data
- `cdn.redishub.com` for read-only queries to "hub" warm data via CloudFlare CDN

Note that clients should follow HTTP redirects to the above domains when reading data.

Medium-term deployment plans:
- a Redis Cluster on load-balanced dedicated servers with 64GB each.


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
- Use a free hosted Redis "keyspace" for low-volume ephemeral purposes (currently Redis so in-memory i.e. very fast)
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
- Register adhoc ephemeral keyspaces
- Identity verification via Telegram.org chat bot `@redishub_bot`
- Access secured via client-authenticated SSL (secure.redishub.com)
- Generate tokens for Google Authenticator
- Encrypt keys using client cert

### Documentation

See: https://github.com/evanx/rquery
