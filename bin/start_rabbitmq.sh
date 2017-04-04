#!/bin/bash
envsubst < /etc/rabbitmq/rabbitmq.config.envsubst > /etc/rabbitmq/rabbitmq.config && rabbitmq-server
