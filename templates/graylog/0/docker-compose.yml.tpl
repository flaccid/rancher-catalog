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
  mongo-data:
    labels:
      io.rancher.container.start_once: true
    volumes:
      - /data/db
    image: busybox
  mongo:
    image: "mongo:3"
    volumes_from:
      - mongo-data
    labels:
      io.rancher.sidekicks: mongo-data
  elasticsearch:
    image: elasticsearch:2-alpine
    stdin_open: true
    tty: true
    command:
      - elasticsearch
      - -Des.cluster.name=graylog
    labels:
        io.rancher.container.pull_image: always
        io.rancher.sidekicks: kopf
        io.rancher.sidekicks: kopf
  kopf:
    image: lmenezes/elasticsearch-kopf
    environment:
      KOPF_ES_SERVERS: elasticsearch:9200
      KOPF_SERVER_NAME: _
    stdin_open: true
    tty: true
    labels:
        io.rancher.container.pull_image: always
  graylog:
    image: "graylog2/server:2.3.0-1"
    stdin_open: true
    tty: true
    environment:
      GRAYLOG_ELASTICSEARCH_HOSTS: http://elasticsearch:9200
      GRAYLOG_PASSWORD_SECRET: ${graylog_secret}
      GRAYLOG_ROOT_PASSWORD_SHA2: ${graylog_password}
      GRAYLOG_WEB_ENDPOINT_URI: "http://${graylog_fqdn}:9000/api"
    labels:
      io.rancher.sidekicks: graylog-data, geoip-data
      io.rancher.scheduler.affinity:host_label_soft: ${graylog_server_host_label}
    volumes_from:
      - graylog-data
    ports:
      - 12201:12201/udp
      - 12201:12201/tcp
      - 1514:1514/udp
  geoip-data:
    image: tkrs/maxmind-geoipupdate
    stdin_open: true
    tty: true
    volumes:
      - /etc/graylog/server/
    environment:
      GEOIP_DB_DIR: '/etc/graylog/server/'
    labels:
      io.rancher.container.pull_image: always
  lb:
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
