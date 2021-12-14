FROM centos:7
ENV container docker

RUN yum -y install wget;  
RUN yum -y install perl-Digest-SHA;
RUN yum -y install java-1.8.0-openjdk.x86_64; 

RUN wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.0-linux-x86_64.tar.gz /; \
wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.16.0-linux-x86_64.tar.gz.sha512 ;\
shasum -a 512 -c elasticsearch-7.16.0-linux-x86_64.tar.gz.sha512;

RUN tar -xzf elasticsearch-7.16.0-linux-x86_64.tar.gz;
RUN groupadd elasticsearch && useradd -g elasticsearch elasticsearch
RUN mkdir /var/lib/elasticsearch && cd /var/lib/elasticsearch/ ; mkdir snapsots data work logs;
RUN chown -R elasticsearch:elasticsearch /var/lib/elasticsearch/ ; chown -R elasticsearch:elasticsearch /elasticsearch-7.16.0

RUN rm /elasticsearch-7.16.0-linux-x86_64.tar.gz

ENV ES_HOME="/elasticsearch-7.16.0"
RUN mv ${ES_HOME}/config/elasticsearch.yml ${ES_HOME}/config/elasticsearch.yml.example

RUN echo "node.name: netology_test" > ${ES_HOME}/config/elasticsearch.yml;\
#echo "node.roles: master, data" >> ${ES_HOME}/config/elasticsearch.yml;\
echo "discovery.zen.minimum_master_nodes: 1" >> ${ES_HOME}/config/elasticsearch.yml;\
echo "node.master: true" >> ${ES_HOME}/config/elasticsearch.yml;\
echo "node.data: true" >> ${ES_HOME}/config/elasticsearch.yml;\
echo "path.data: /var/lib/elasticsearch/data/" >> ${ES_HOME}/config/elasticsearch.yml;\
echo "path.logs: /var/lib/elasticsearch/logs/" >> ${ES_HOME}/config/elasticsearch.yml;\
echo "path.repo: /var/lib/elasticsearch/snapsots/ " >> ${ES_HOME}/config/elasticsearch.yml;\
echo "network.host: 0.0.0.0" >> ${ES_HOME}/config/elasticsearch.yml;\
echo 'discovery.seed_hosts: ["127.0.0.1", "[::1]"]' >> ${ES_HOME}/config/elasticsearch.yml; \
echo 'network.publish_host: localhost' >> elasticsearch.yml


USER elasticsearch
EXPOSE 9200:9200
CMD [ "/elasticsearch-7.16.0/bin/elasticsearch" ]