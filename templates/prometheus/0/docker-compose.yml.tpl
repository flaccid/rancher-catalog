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
{{- end}}
