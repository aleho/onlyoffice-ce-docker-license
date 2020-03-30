ARG oo_version=5.5.0.165
FROM onlyoffice/documentserver:$oo_version


RUN sed -is \
    's/isSupportEditFeature:function(){return!1}/isSupportEditFeature:function(){return true}/g' \
    /var/www/onlyoffice/documentserver/web-apps/apps/documenteditor/mobile/app.js

RUN sed -is \
    's/isSupportEditFeature:function(){return!1}/isSupportEditFeature:function(){return true}/g' \
    /var/www/onlyoffice/documentserver/web-apps/apps/presentationeditor/mobile/app.js

RUN sed -is \
    's/isSupportEditFeature:function(){return!1}/isSupportEditFeature:function(){return true}/g' \
    /var/www/onlyoffice/documentserver/web-apps/apps/spreadsheeteditor/mobile/app.js


RUN apt-get update && apt-get install -y \
    python3-pip \
  && rm -rf /var/lib/apt/lists/* \
  && pip3 install pycryptodome


COPY license.py /tmp/
RUN python3 /tmp/license.py

RUN pip3 uninstall -y pycryptodome \
    && apt-get purge -y python3-pip \
    && apt-get purge -y --autoremove \
    && rm -rf /var/lib/apt/lists/*


COPY run-oo.sh /usr/local/bin/run-oo.sh
RUN chmod a+x /usr/local/bin/run-oo.sh


ENTRYPOINT [ "/usr/local/bin/run-oo.sh" ]
