version: '2'
services:
  grafana:
    image: flaccid/grafana:latest
    stdin_open: true
    tty: true
    labels:
      io.rancher.container.pull_image: always
      io.rancher.scheduler.affinity:host_label_soft: ${GRAFANA_SERVER_HOST_LABEL}
  lb:
    image: rancher/lb-service-haproxy:v0.7.15
    ports:
    - ${GRAFANA_PUBLIC_LB_PORT}:${GRAFANA_PUBLIC_LB_PORT}/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin,agent
      io.rancher.container.agent_service.drain_provider: 'true'
      io.rancher.container.create_agent: 'true'
      io.rancher.scheduler.affinity:host_label_soft: ${GRAFANA_LB_HOST_LABEL}
