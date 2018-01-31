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
