version: '2'
services:
  graylog-data:
    labels:
      io.rancher.container.start_once: true
    volumes:
      - /graylog/data
      - /graylog/logs
      - /graylog/plugins
    image: busybox
  mongodb-data:
    labels:
      io.rancher.container.start_once: true
    volumes:
      - /data/db
    image: busybox
  mongodb:
    image: "mongo:3"
    volumes_from:
      - mongodb-data
    labels:
      io.rancher.sidekicks: mongodb-data
  graylog-elasticsearch:
    image: "elasticsearch:2"
    command: "elasticsearch -Des.cluster.name='graylog'"
  graylog:
    environment:
      GRAYLOG_ELASTICSEARCH_HOSTS: http://elasticsearch:9200
      GRAYLOG_PASSWORD_SECRET: ${graylog_secret}
      GRAYLOG_ROOT_PASSWORD_SHA2: ${graylog_password}
      GRAYLOG_WEB_ENDPOINT_URI: "http://${graylog_fqdn}:9000/api"
    image: "graylog2/server:2.3.0-1"
    labels:
      io.rancher.sidekicks: graylog-data
    volumes_from:
      - graylog-data
    links:
      - mongodb:mongo
      - graylog-elasticsearch:elasticsearch
    ports:
      - 12201:12201/udp
      - 1514:1514/udp
  graylog-lb:
    image: rancher/lb-service-haproxy:v0.7.5
    ports:
     - ${graylog_lb_port}:${graylog_lb_port}
    labels:
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.container.create_agent: 'true'
      io.rancher.scheduler.affinity:host_label_soft: ${graylog_lb_host_label}
{{- if eq .Values.enable_logspout "true"}}
  logspout:
    image: micahhausler/logspout:gelf
    stdin_open: true
    volumes:
     - /var/run/docker.sock:/var/run/docker.sock
    tty: true
    command:
     - "gelf://${graylog_fqdn}:12201"
    labels:
      io.rancher.container.pull_image: always
      io.rancher.scheduler.global: 'true'
{{- end}}
