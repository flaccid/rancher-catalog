version: '2'
services:
  mysql-lb:
    image: rancher/load-balancer-service
    links:
      - mysql
    ports:
      - ${lb_port}:3306
  mysql-data:
    image: busybox
    labels:
      io.rancher.container.start_once: true
    volumes:
      - /var/lib/mysql
  mysql:
    image: mysql:latest
    environment:
      MYSQL_ALLOW_EMPTY_PASSWORD: ${mysql_allow_empty_password}
{{- if (.Values.mysql_database)}}
      MYSQL_DATABASE: ${mysql_database}
{{- end}}
{{- if (.Values.mysql_onetime_password)}}
      MYSQL_ONETIME_PASSWORD: ${mysql_onetime_password}
{{- end}}
{{- if (.Values.mysql_password)}}
      MYSQL_PASSWORD: ${mysql_password}
{{- end}}
      MYSQL_RANDOM_ROOT_PASSWORD: ${mysql_random_root_password}
      MYSQL_ROOT_PASSWORD: ${mysql_root_password}
{{- if (.Values.mysql_user)}}
      MYSQL_USER: ${mysql_user}
{{- end}}
    tty: true
    stdin_open: true
    labels:
      io.rancher.sidekicks: mysql-data
    volumes_from:
      - mysql-data
