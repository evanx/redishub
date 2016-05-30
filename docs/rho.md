
#### What is the "RedisHub Owners" wallet

It is a virtual currency account where senders automatically become RedisHub funders who together own RedisHub.

For the purpose of any declared dividends to be paid out, each owner's shareholding will be calculated by some fair algorithm. 
It will be a computational analysis of various time series of metrics including:
- your actual usage costs
- your transfers

I will hold and originally fund the Bitcoin and Ethereum "RedisHub Owners" wallets. As the original funder, I will always own 51%, make executive decisions, and reimburse suppliers and developers.

The algorithm must be such that:
- the original funder owns 51%
- the second funder together with subsequent funders together own 49%
- surplus funding is suitably rewarded in shareholding
- early adopters are favoured over their followers 
- its computation is transparent and widely considered to be fair

Monthly deposits greater than usage costs (which may be neglible) are a means of direct investment in return for increased shareholding, as determined by the algorithm.

I'm not sure how the algorithm should be specifically implemented. 
The overriding principle is that 49% of the company is owned by its customers and/or outside investers that fund its development and growth. 
The hope is that the company will be successful, in which case, early adopters, customers and investers will be rewarded with dividends and collectively own 49% of the company.


#### Why the "RedisHub Owners" scheme

Its multiple purposes include:
- a pay-per-use pricing model
- a share incentive scheme for early and loyal adopters
- a share trading mechanism
- fund raising to improve and promote the service

If RedisHub does spectatularly well, then 49% of that value will be owned by its customers and funders that made it successful.

Funders should be able to designate a price/volume of equity (if any) they are willing to buy/sell. These should be settled automatically via the Owners wallet.

#### How do I join the "RedisHub Funders" share scheme

This will be launched later. 
- have a Telegram.org account e.g. via web.telegram.org
- signup via `@redishub_bot` 
- transfer 50c (0.001฿) to our Bitcoin wallet 

Then you are a "Funder" with virtual equity in redishub.com. 


#### How do I signup to RedisHub.com

- message `@redishub_bot /signup`
- create a self-signed client cert with a specified RedisHub OU 
- register an account with `redishub.com` using your client cert


#### What is free?

I want to offer a free public utility in perpetuity to support most low-volume use cases, where the computing cost is less than 10c per user per month, e.g. peak database size of 10MB RAM with a 10Gb transfer limit per month.


#### What about higher volume usage?

Customers who wish to exceed the above-mentioned free limits, should become a "funder" contributing the equivalent of 50c per month to our Bitcoin wallet. Funders' limits are bumped up to 50MB RAM (Redis) storage and 50Gb transfer per month. You can double up as needed and contribute accordingly, e.g. $5 for 300MB, $50 for 3GB. Later, surplus credit in your account can be offered to buy equity at a specified volume/price.


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
