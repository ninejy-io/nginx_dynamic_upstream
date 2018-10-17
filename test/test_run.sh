#!/bin/bash

apt-get install python3-pip
pip3 install Flask
python3 test_app.py > /dev/null &

curl -X PUT 127.0.0.1:8500/v1/kv/upstreams/test/127.0.0.1:8000

curl 127.0.0.1/test
curl 127.0.0.1/test/1