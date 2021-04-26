# Patched ONLYOFFICE Docs (Community Edition)

## Features

This [Dockerfile](./Dockerfile) and [patch](license.patch) compile a version of
OnlyOffice Docs server with mobile editing enabled in the Nextcloud apps for an
unlimited amount of concurrent users.

It can be integrated into e.g. Nextcloud or ownCloud like the official images.

## Background

Just about two months after [Nextcloud released their partnership with Ascensio](https://nextcloud.com/blog/onlyoffice-and-nextcloud-partnering-up/)
and featured a community version of OnlyOffice, the latter decided to remove
support for mobile editing of documents. This affected the Nextcloud app,
killing a feature that was previously marketed by both companies.

The changes were executed without any prior notice and alienated quite a lot of
home users, who would now be forced to pay more than €1.000 to unlock that
previously free feature. Only after some outcries Ascensio deigned to release a
statement and a new, albeit "limited", offer of €90 for home servers. This
offer has since expired and their licensing tier suggests current licenses are
valid for one year, starting at about €140.

In my opinion these deceptive practices of advertising a feature only to take
it away are unacceptable for a company presenting itself and their products as
open source.


## Usage

Please refer the the official docs on how to integrate OnlyOffice into your
setup.

### Podman CLI

```sh
podman run \
    --name=onlyoffice \
    --detach \
    --publish=80:80 \
    docker.io/alehoho/oo-ce-docker-license
```

### Docker CLI

```sh
docker run \
    --name=onlyoffice \
    --detach \
    --publish=80:80 \
    alehoho/oo-ce-docker-license
```

### docker-compose.yml

```yml
services:
  onlyoffice:
    container_name: onlyoffice
    image: alehoho/oo-ce-docker-license
    ports:
      - "80"
```

### Verify

To verify that the container is running successfully open
`[server-url]/healthcheck` (has to return `true`) and for the version number open
`[server-url]/web-apps/apps/api/documents/api.js` and check the header comment.


## Build

### Buildah CLI

```sh
buildah build-using-dockerfile \
    --tag=onlyoffice-patched \
    https://github.com/aleho/onlyoffice-ce-docker-license.git
```

### Docker CLI

```sh
docker build \
    --tag=onlyoffice-patched \
    https://github.com/aleho/onlyoffice-ce-docker-license.git
```


### docker-compose.yml

```yml
services:
  onlyoffice:
    container_name: onlyoffice
    image: onlyoffice-patched
    build:
      context: https://github.com/aleho/onlyoffice-ce-docker-license.git
    …
```


## Thanks

This repo was heavily inspired by the works of
[Zegorax/OnlyOffice-Unlimited](https://github.com/Zegorax/OnlyOffice-Unlimited).
