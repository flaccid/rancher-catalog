version: '2'
services:
  prometheus:
    image: prom/prometheus:v2.1.0
    stdin_open: true
    tty: true
    labels:
      io.rancher.container.pull_image: always

{{- if eq .Values.SETUP_GRAFANA "true"}}
  grafana:
    image: grafana/grafana:4.6.3
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
  confd-rancher:
    image: flaccid/confd:latest
    stdin_open: true
    tty: true
    command:
    - -backend
    - rancher
    labels:
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
