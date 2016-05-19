#!/bin/bash

sed -i "s/SOCKET_SERVER/${SOCKET_SERVER}/g" /etc/nginx/nginx.conf
nginx
