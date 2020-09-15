ARG oo_version=5.6.4.20
FROM onlyoffice/documentserver:$oo_version
ARG oo_version=5.6.4.20


RUN sed -is \
    's/isSupportEditFeature:function(){return!1}/isSupportEditFeature:function(){return true}/g' \
    /var/www/onlyoffice/documentserver/web-apps/apps/documenteditor/mobile/app.js

RUN sed -is \
    's/isSupportEditFeature:function(){return!1}/isSupportEditFeature:function(){return true}/g' \
    /var/www/onlyoffice/documentserver/web-apps/apps/presentationeditor/mobile/app.js

RUN sed -is \
    's/isSupportEditFeature:function(){return!1}/isSupportEditFeature:function(){return true}/g' \
    /var/www/onlyoffice/documentserver/web-apps/apps/spreadsheeteditor/mobile/app.js


# source patching and compilation
RUN apt-get update && apt-get install -y \
        git \
        curl \
    && curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs \
    && rm -rf /var/lib/apt/lists/*


RUN mkdir /build
WORKDIR /build

RUN git clone --branch v$oo_version --depth 1 https://github.com/ONLYOFFICE/server.git .

COPY license.patch /build/
RUN git apply license.patch


RUN npm install pkg grunt-cli \
    && make \
    && node_modules/.bin/pkg --targets=linux build/server/FileConverter \
    && node_modules/.bin/pkg --targets=linux build/server/DocService \
    && cp fileconverter /var/www/onlyoffice/documentserver/server/FileConverter/converter \
    && cp coauthoring /var/www/onlyoffice/documentserver/server/DocService/docservice

WORKDIR /
RUN rm -rf /build
