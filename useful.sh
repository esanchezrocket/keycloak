curl --location --request POST 'http://localhost:8080/auth/realms/master/protocol/openid-connect/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'client_id=admin-cli' --data-urlencode 'client_secret=2831f22c-6def-49da-ac3c-ffd256decff0' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password'

curl --location --request POST 'http://localhost:7999/auth/realms/master/protocol/openid-connect/token' --header 'Content-Type: application/x-www-form-urlencoded' --data-urlencode 'client_id=admin-cli' --data-urlencode 'client_secret=2831f22c-6def-49da-ac3c-ffd256decff0' --data-urlencode 'username=admin' --data-urlencode 'password=admin' --data-urlencode 'grant_type=password'

docker run -p 8080:8080 -e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin -e default_client_id=esanchez-client -e default_client_name=esanchez-client -e default_client_secret=2831f22c-6def-49da-ac3c-ffd256decff0 gcr.io/ops-terraform-env-cicd/enterprise/keycloak:0.0.21 -Dkeycloak.migration.action=import -Dkeycloak.migration.provider=singleFile -Dkeycloak.migration.file=/config-files/oauth2-demo-realm-config.json -Dkeycloak.migration.strategy=IGNORE_EXISTING

exec -it kc /opt/jboss/keycloak/bin/standalone.sh \
-Djboss.socket.binding.port-offset=100 \
-Dkeycloak.migration.action=export \
-Dkeycloak.migration.provider=singleFile \
-Dkeycloak.migration.realmName=master \
-Dkeycloak.migration.usersExportStrategy=REALM_FILE \
-Dkeycloak.migration.file=/tmp/master_export.json

docker exec -it zen_noyce /opt/jboss/keycloak/bin/standalone.sh \
-Djboss.socket.binding.port-offset=100 -Dkeycloak.migration.action=export \
-Dkeycloak.migration.provider=singleFile \
-Dkeycloak.migration.realmName=master \
-Dkeycloak.migration.usersExportStrategy=REALM_FILE \
-Dkeycloak.migration.file=/tmp/master_real_export.json

docker cp zen_noyce:/tmp/master_real_export.json ~/workspace/keycloak/master_realm_export.json