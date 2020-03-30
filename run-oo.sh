#!/usr/bin/env bash
set -e


echo "Providing license"
cp -f /var/www/onlyoffice/license.lic /var/www/onlyoffice/Data/license.lic

echo "Starting server"
/app/ds/run-document-server.sh

