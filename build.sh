#!/bin/sh -e

docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"

cd "8.2/alpineedge/cli/"
docker buildx create --use --name wp --driver remote tcp://192.168.69.206:1234
docker buildx build --platform linux/riscv64 . -t danog/php:8.2-alpine
docker push danog/php:8.2-alpine
