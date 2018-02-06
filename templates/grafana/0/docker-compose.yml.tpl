version: '2'
volumes:
  grafana-data:
{{- if eq .Values.GRAFANA_DATA_RANCHER_NFS_ENABLED "true"}}
    external: true
    driver: rancher-nfs
{{- end}}
services:
  grafana:
    image: ${GRAFANA_DOCKER_IMAGE}
    stdin_open: true
    tty: true
    labels:
      io.rancher.container.pull_image: always
{{- if eq .Values.SOFT_AFFINITY_SCHEDULING "true"}}
      io.rancher.scheduler.affinity:host_label_soft: ${GRAFANA_SERVER_HOST_LABEL}
{{- else}}
      io.rancher.scheduler.affinity:host_label: ${GRAFANA_SERVER_HOST_LABEL}
{{- end}}
    environment:
      GF_SECURITY_ADMIN_USER: ${GRAFANA_ADMIN_USER}
      GF_SECURITY_ADMIN_PASSWORD: ${GRAFANA_ADMIN_PASSWORD}
      GF_SECURITY_SECRET_KEY: ${GRAFANA_SECURITY_SECRET_KEY}
      GF_INSTALL_PLUGINS: ${GRAFANA_PLUGINS_INSTALL}
{{- if eq .Values.PROMETHEUS_DATASOURCE_ENABLED "true"}}
      ENABLE_PROMETHEUS_DATASOURCE: true
      PROMETHEUS_ACCESS_MODE: ${PROMETHEUS_ACCESS_MODE}
      PROMETHEUS_URL: ${PROMETHEUS_URL}
{{- end}}
    volumes:
    - grafana-data:/opt/grafana/data
  lb:
    image: rancher/lb-service-haproxy:v0.7.15
    ports:
    - ${GRAFANA_PUBLIC_LB_PORT}:${GRAFANA_PUBLIC_LB_PORT}/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin,agent
      io.rancher.container.agent_service.drain_provider: 'true'
      io.rancher.container.create_agent: 'true'
{{- if eq .Values.SOFT_AFFINITY_SCHEDULING "true"}}
      io.rancher.scheduler.affinity:host_label_soft: ${GRAFANA_LB_HOST_LABEL}
{{- else}}
      io.rancher.scheduler.affinity:host_label_soft: ${GRAFANA_LB_HOST_LABEL}
{{- end}}
{{- if eq .Values.GRAFANA_GLOBAL_LB "true"}}
      io.rancher.scheduler.global: 'true'
{{- end}}
