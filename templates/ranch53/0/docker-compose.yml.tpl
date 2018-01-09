version: '2'
services:
  ranch53:
    image: flaccid/ranch53
    environment:
      AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}
      AWS_SECRET_ACCESS_KEY: ${AWS_SECRET_ACCESS_KEY}
      POLL_INTERVAL: '30'
{{- if (.Values.RANCHER_URL)}}
      RANCHER_URL: ${RANCHER_URL}
{{- end}}
{{- if (.Values.RANCHER_ACCESS_KEY)}}
      RANCHER_ACCESS_KEY: ${RANCHER_ACCESS_KEY}
{{- end}}
{{- if (.Values.RANCHER_SECRET_KEY)}}
      RANCHER_SECRET_KEY: ${RANCHER_SECRET_KEY}
{{- end}}
{{- if (.Values.FORWARD_PROXY)}}
      http_proxy: ${FORWARD_PROXY}
{{- end}}
    stdin_open: true
    tty: true
    labels:
      io.rancher.container.agent.role: environment
      io.rancher.container.create_agent: 'true'
      io.rancher.container.pull_image: always
      io.rancher.container.start_once: 'true'
