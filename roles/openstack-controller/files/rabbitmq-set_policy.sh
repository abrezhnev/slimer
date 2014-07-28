#!/bin/sh
(rabbitmqctl list_policies | grep -q HA) && exit 0
rabbitmqctl set_policy HA '^(?!amq\.).*' '{"ha-mode": "all"}'
