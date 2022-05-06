#!/bin/bash
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.11.0
docker pull docker.elastic.co/kibana/kibana:7.11.0
docker pull docker.elastic.co/logstash/logstash:6.3.2
docker pull docker.elastic.co/beats/filebeat:7.2.0
docker pull library/python:3.9-alpine
