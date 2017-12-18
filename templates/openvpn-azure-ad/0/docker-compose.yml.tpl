version: '2'
services:
  openvpn-server:
    privileged: true
    image: flaccid/openvpn:azure-ad
    environment:
      AUTH_TYPE: azuread
      AZUREAD_CLIENT_ID: ${CLIENT_ID}
      AZUREAD_TENANT_ID: ${TENANT_ID}
      CA_CERTIFICATE: ${CA_CERTIFICATE}
      DEBUG: ${DEBUG}
      PUSH_ROUTES: ${PUSH_ROUTES}
      PRINT_CLIENT_PROFILE: ${PRINT_CLIENT_PROFILE}
      REMOTE_HOST: ${REMOTE_HOST}
    stdin_open: true
    tty: true
    ports:
    - 1194:1194/udp
    labels:
      io.rancher.container.pull_image: always
