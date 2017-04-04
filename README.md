# RabbitMQ with AMQPS and MQTTS with LetsEncrypt 

# Introduction

RabbitMQ with AMQPS and MQTTS with automatic renewal of certificates from LetsEncrypt in Docker. Edit
Add topics

# Start

Start AMQPS on port 5671, MQTTS on port 8883 and the management interface of RabbitMQ on port 443 

```
HOSTNAME=rabbitmq.mycoolserver.dyndns.com docker-compose up
```

# Test HTTPS

Open a browser to https://rabbitmq..mycoolserver.dyndns.com and check that you see the RabbitMQs management interface and that it has a valid SSL certificate.

# Test AMPQPS

```
docker-compose exec rabbitmq bash -c \
 'openssl s_client -connect ${HOSTNAME}:5671 \
  -CAfile /var/lib/https/rabbitmq.${HOSTNAME}/production/chained.pem \
  -cert   /var/lib/https/rabbitmq.${HOSTNAME}/production/signed.crt  \
  -key    /var/lib/https/rabbitmq.${HOSTNAME}/production/domain.key'
```

# Test MQTTS

```
docker-compose exec rabbitmq bash -c \
 'openssl s_client -connect ${HOSTNAME}:8883 \
  -CAfile /var/lib/https/rabbitmq.${HOSTNAME}/production/chained.pem \
  -cert   /var/lib/https/rabbitmq.${HOSTNAME}/production/signed.crt  \
  -key    /var/lib/https/rabbitmq.${HOSTNAME}/production/domain.key'
```

# rabbitmq.conf

The rabbitmq.conf loads the the following certificates from https://github.com/SteveLTN/https-portal

```
[
 {ssl, [{versions, ['tlsv1.2', 'tlsv1.1']}]},
 {rabbit, [
  {ssl_listeners, [5671]},
  {ssl_options, [
   {cacertfile,"/var/lib/https/rabbitmq.${HOSTNAME}/production/chained.pem"},
   {certfile,  "/var/lib/https/rabbitmq.${HOSTNAME}/production/signed.crt"},
   {keyfile,   "/var/lib/https/rabbitmq.${HOSTNAME}/production/domain.key"},
   {versions, ['tlsv1.2', 'tlsv1.1']}
  ]},
  {loopback_users, []}
 ]},
 {rabbitmq_mqtt, [
  {ssl_listeners,    [8883]},
  {tcp_listeners,    [1883]}
 ]}
].
```
