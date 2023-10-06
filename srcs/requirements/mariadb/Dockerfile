
FROM	alpine:3.13

RUN		apk update && apk upgrade

RUN		apk add --no-cache --quiet --update mariadb mariadb-client vim

COPY	./scripts/entrypoint.sh ./

ENTRYPOINT [ "sh", "entrypoint.sh" ]