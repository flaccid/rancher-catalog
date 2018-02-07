version: '2'
services:
  lb:
    image: rancher/lb-service-haproxy:v0.7.15
{{- if eq .Values.LB_ACCESS "Public"}}
    ports:
{{- end}}
{{- if eq .Values.LB_ACCESS "Internal"}}
    expose:
{{- end}}
    - 8000:8000/tcp
    - 8001:8001/tcp
    - 8002:8002/tcp
    - 8443:8443/tcp
    - 8444:8444/tcp
    - 8445:8445/tcp
    labels:
      io.rancher.container.agent.role: environmentAdmin
      io.rancher.container.create_agent: 'true'
  kong-ee:
    image: kong-docker-kong-enterprise-edition-docker.bintray.io/kong-enterprise-edition:0.30-alpine
    environment:
      KONG_ADMIN_ACCESS_LOG: /dev/stdout
      KONG_ADMIN_ERROR_LOG: /dev/stderr
      KONG_PG_HOST: db
      KONG_PROXY_ACCESS_LOG: /dev/stdout
      KONG_PROXY_ERROR_LOG: /dev/stderr
      KONG_VITALS: 'on'
      KONG_LICENSE_DATA: '${KONG_LICENSE_DATA}'
    stdin_open: true
    tty: true
    links:
    - db:db
    labels:
      io.rancher.container.pull_image: always
  migrations:
    image: kong-docker-kong-enterprise-edition-docker.bintray.io/kong-enterprise-edition:0.30-alpine
    environment:
      KONG_PG_HOST: db
      KONG_LICENSE_DATA: '${KONG_LICENSE_DATA}'
    stdin_open: true
    tty: true
    command:
    - kong
    - migrations
    - up
    links:
    - db:db
    labels:
      io.rancher.container.pull_image: always
      io.rancher.container.start_once: 'true'
  db:
    image: postgres:9.5
    environment:
      POSTGRES_DB: kong
      POSTGRES_USER: kong
    stdin_open: true
    tty: true
    labels:
      io.rancher.container.pull_image: always
