#!/bin/sh -e

docker login --username "$DOCKER_USERNAME" --password "$DOCKER_PASSWORD"
docker buildx create --use --name wp --driver remote tcp://192.168.69.206:1234

build() {
	cd "$1"
	docker buildx build --pull --push --platform linux/riscv64 . -t danog/php:$2 --cache-from danog/php:$2 --cache-to type=inline
	cd "$base"
}


cd 8.2

base=$PWD

build sid/cli/ 8.2
build sid/fpm/ 8.2-fpm

build alpineedge/cli/ 8.2-alpine
build alpineedge/fpm/ 8.2-fpm-alpine

docker tag danog/php:8.2 danog/php:8.2-debian
docker tag danog/php:8.2-fpm danog/php:8.2-fpm-debian

docker push danog/php:8.2-debian
docker push danog/php:8.2-fpm-debian
