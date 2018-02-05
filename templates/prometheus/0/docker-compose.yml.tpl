version: '2'
services:
  lb:
    image: rancher/lb-service-haproxy:v0.7.15
    ports:
    - ${PROMETHEUS_PUBLIC_LB_PORT}:${PROMETHEUS_PUBLIC_LB_PORT}/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin,agent
      io.rancher.container.agent_service.drain_provider: 'true'
      io.rancher.container.create_agent: 'true'
{{- if eq .Values.SOFT_AFFINITY_SCHEDULING "true"}}
      io.rancher.scheduler.affinity:host_label_soft: ${PROMETHEUS_LB_HOST_LABEL}
{{- else}}
      io.rancher.scheduler.affinity:host_label_soft: ${PROMETHEUS_LB_HOST_LABEL}
{{- end}}
  prometheus:
    image: ${PROMETHEUS_DOCKER_IMAGE}
    stdin_open: true
    tty: true
    volumes_from:
      - prometheus-conf
    labels:
      io.rancher.container.pull_image: always
      io.rancher.sidekicks: prometheus-conf
{{- if eq .Values.SOFT_AFFINITY_SCHEDULING "true"}}
      io.rancher.scheduler.affinity:host_label_soft: ${PROMETHEUS_SERVER_HOST_LABEL}
{{- else}}
      io.rancher.scheduler.affinity:host_label: ${PROMETHEUS_SERVER_HOST_LABEL}
{{- end}}
  prometheus-conf:
    image: flaccid/prometheus-conf:latest
    stdin_open: true
    tty: true
    # TODO: user can choose backend
    command:
    - -backend
    - rancher
    environment:
{{- if eq .Values.SETUP_NODE_EXPORTER "true"}}
      SETUP_NODE_EXPORTER: ${SETUP_NODE_EXPORTER}
{{- end}}
{{- if eq .Values.SETUP_RANCHER_EXPORTER "true"}}
      SETUP_RANCHER_EXPORTER: ${SETUP_RANCHER_EXPORTER}
{{- end}}
{{- if eq .Values.SETUP_RANCHER_CRONTAB_EXPORTER "true"}}
      SETUP_RANCHER_CRONTAB_EXPORTER: ${SETUP_RANCHER_CRONTAB_EXPORTER}
{{- end
    volumes:
      - /etc/prometheus
    labels:
      io.rancher.container.pull_image: always

{{- if eq .Values.SETUP_GRAFANA "true"}}
  grafana:
    # we need v5 (unreleased) to configure datasources by ini
    image: flaccid/grafana:latest
    stdin_open: true
    tty: true
    labels:
      io.rancher.container.pull_image: always
{{- end}}

{{- if eq .Values.SETUP_NODE_EXPORTER "true"}}
  node-exporter:
    image: prom/node-exporter:v0.15.2
    stdin_open: true
    tty: true
    labels:
      io.rancher.scheduler.global: 'true'
      io.rancher.container.pull_image: always
{{- end}}

{{- if eq .Values.SETUP_RANCHER_EXPORTER "true"}}
  rancher-exporter:
    image: infinityworks/prometheus-rancher-exporter:v0.22.93
    stdin_open: true
    tty: true
    labels:
      io.rancher.container.agent.role: environment
      io.rancher.container.create_agent: true
      io.rancher.container.pull_image: always
{{- end}}

{{- if eq .Values.SETUP_CADVISOR "true"}}
  cadvisor:
    image: google/cadvisor:v0.28.3
    stdin_open: true
    tty: true
    labels:
      io.rancher.scheduler.global: 'true'
    volumes:
      - "/:/rootfs:ro"
      - "/var/run:/var/run:rw"
      - "/sys:/sys:ro"
      - "/var/lib/docker/:/var/lib/docker:ro"
{{- end}}
