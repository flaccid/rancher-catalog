version: '2'
services:
  konga:
   image: ${KONGA_DOCKER_IMAGE_TAG}
   stdin_open: true
   tty: true
   labels:
     io.rancher.container.pull_image: always
   environment:
     DB_ADAPTER:  '${DB_ADAPTER}'
     DB_HOST:     '${DB_HOST}'
     DB_PORT:     ${DB_PORT}
     DB_USER:     '${DB_USER}'
     DB_PASSWORD: '${DB_PASS}'
     DB_DATABASE: '${DB_DATABASE}'
     DB_SSL:      '${DB_SSL}'
     NODE_ENV:    '${NODE_ENV}'
{{- if .Values.DOCKER_ENTRYPOINT}}
   entrypoint: '${DOCKER_ENTRYPOINT}'
{{- end}}
  lb:
   image: rancher/lb-service-haproxy:v0.7.15
   ports:
    - 8004:8004/tcp
   labels:
     io.rancher.container.agent.role: environmentAdmin
     io.rancher.container.create_agent: 'true'
     io.rancher.scheduler.global: 'true'
