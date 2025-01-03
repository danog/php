#!/bin/sh -ex

docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
docker buildx create --use --name wp --driver remote tcp://192.168.1.10:1234

build() {
	cd "$1"
	docker buildx build --pull --push --platform linux/riscv64 . -t danog/php:$2 --cache-from danog/php:$2 --cache-to type=inline
	cd "$base"
}


cd 8.4

base=$PWD

#build sid/cli/ 8.2
#build sid/fpm/ 8.2-fpm

build alpineedge/cli/ 8.4-alpine
build alpineedge/fpm/ 8.4-fpm-alpine

docker pull --platform linux/riscv64 danog/php:8.4-alpine
docker pull --platform linux/riscv64 danog/php:8.4-fpm-alpine

docker tag danog/php:8.4-alpine danog/php:latest
docker tag danog/php:8.4-alpine danog/php:8.4
docker tag danog/php:8.4-fpm-alpine danog/php:8.4-fpm

docker push danog/php:latest
docker push danog/php:8.4
docker push danog/php:8.4-fpm
