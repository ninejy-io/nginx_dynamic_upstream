#!/bin/bash


docker run -d --net host --name dev-consul -e CONSUL_BIND_INTERFACE=eth0 consul:1.2.3
