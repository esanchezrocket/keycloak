#!/bin/bash

envsubst < /config-files/oauth2-demo-realm-config.json >> /config-files/temp.json
mv /config-files/temp.json /config-files/oauth2-demo-realm-config.json
