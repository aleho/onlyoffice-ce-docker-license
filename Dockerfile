## Build stage
ARG product_version=6.2.2
ARG build_number=21
ARG oo_root='/var/www/onlyoffice/documentserver'

FROM onlyoffice/documentserver:${product_version}.${build_number} as build-stage
ARG product_version
ARG build_number
ARG oo_root

ENV PRODUCT_VERSION=${product_version}
ENV BUILD_NUMBER=${build_number}

# Mobile apps patching
ARG me_search='isSupportEditFeature:function(){return!1}'
ARG me_patch='s/isSupportEditFeature:function(){return!1}/isSupportEditFeature:function(){return true}/g'

RUN grep -q "${me_search}" ${oo_root}/web-apps/apps/documenteditor/mobile/app.js \
  && sed -si "${me_patch}" ${oo_root}/web-apps/apps/documenteditor/mobile/app.js

RUN grep -q "${me_search}" ${oo_root}/web-apps/apps/presentationeditor/mobile/app.js \
  && sed -si "${me_patch}" ${oo_root}/web-apps/apps/presentationeditor/mobile/app.js

RUN grep -q "${me_search}" ${oo_root}/web-apps/apps/spreadsheeteditor/mobile/app.js \
  && sed -si "${me_patch}" ${oo_root}/web-apps/apps/spreadsheeteditor/mobile/app.js


# Rebuild with license checks replaced
ARG build_deps="git make g++ nodejs npm"
RUN apt-get update && apt-get install -y ${build_deps}

ARG tag=v${product_version}.${build_number}
RUN  mkdir /build \
  && git clone --quiet --branch $tag --depth 1 https://github.com/ONLYOFFICE/build_tools.git /build/build_tools \
  && git clone --quiet --branch $tag --depth 1 https://github.com/ONLYOFFICE/server.git      /build/server


WORKDIR /build/server

RUN npm install -g pkg grunt grunt-cli

COPY license.patch /build/
RUN git apply /build/license.patch

RUN make \
  && pkg /build/build_tools/out/linux_64/onlyoffice/documentserver/server/FileConverter --targets=node10-linux -o /build/converter \
  && pkg /build/build_tools/out/linux_64/onlyoffice/documentserver/server/DocService --targets=node10-linux --options max_old_space_size=4096 -o /build/docservice \
  && cp /build/converter ${oo_root}/server/FileConverter/converter \
  && cp /build/docservice ${oo_root}/server/DocService/docservice


## Prod image
FROM onlyoffice/documentserver:${product_version}.${build_number}
ARG oo_root

COPY --from=build-stage ${oo_root}/web-apps/apps/documenteditor/mobile/app.js \
                        ${oo_root}/web-apps/apps/documenteditor/mobile/app.js
COPY --from=build-stage ${oo_root}/web-apps/apps/presentationeditor/mobile/app.js \
                        ${oo_root}/web-apps/apps/presentationeditor/mobile/app.js
COPY --from=build-stage ${oo_root}/web-apps/apps/spreadsheeteditor/mobile/app.js \
                        ${oo_root}/web-apps/apps/spreadsheeteditor/mobile/app.js

COPY --from=build-stage ${oo_root}/server/FileConverter/converter \
                        ${oo_root}/server/FileConverter/converter
COPY --from=build-stage ${oo_root}/server/DocService/docservice \
                        ${oo_root}/server/DocService/docservice
