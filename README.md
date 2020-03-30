# OnlyOffice Community server with license

## Usage

```sh
docker build \
    --tag=onlyoffice-patched \
    https://github.com/aleho/onlyoffice-ce-docker-license.git
```

```sh
docker run \
    --name=onlyoffice \
    --detach \
    --volume=$(pwd)/ooData:/var/www/onlyoffice/Data onlyoffice-patched \
    onlyoffice-patched
```

## Background
Recently, just about a month after Nextcloud announced their partnership with
Ascensio and featuring a community version of OnlyOffice, the latter decided
to remove support for mobile editing of documents via the Nextcloud app.

This happened without any prior notice and alienated quite a lot of home users,
who would now be forced to pay more than €1.000 to unlock that previously free
feature. Only after some outcries Ascensio deigned to release a statement and
a new, albeit "limited", offer of €90 for home servers.

In my opinion these deceptive practices are unacceptable for a company
advertising itself and their product as open source .


## Thanks

This repo is heavily inspired by the works of
[Zegorax/OnlyOffice-Unlimited](https://github.com/Zegorax/OnlyOffice-Unlimited).
