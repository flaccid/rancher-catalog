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
      MYSQL_DATABASE: ${mysql_database}
      MYSQL_ONETIME_PASSWORD: ${mysql_onetime_password}
{{- if (.Values.mysql_password)}}
      MYSQL_PASSWORD: ${mysql_password}
{{- end}}
      MYSQL_RANDOM_ROOT_PASSWORD: ${mysql_random_root_password}
      MYSQL_ROOT_PASSWORD: ${mysql_root_password}
      MYSQL_USER: ${mysql_user}
    tty: true
    stdin_open: true
    labels:
      io.rancher.sidekicks: mysql-data
    volumes_from:
      - mysql-data
