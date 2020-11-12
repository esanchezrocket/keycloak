## Exporting keycloak configuration
To export the configuration of a keycloak instance that is already configured, execute the following
 commands from inside the pod that the instance is running.

```bash
/opt/jboss/keycloak/bin/standalone.sh \
-Djboss.socket.binding.port-offset=100 \
-Dkeycloak.migration.action=export \
-Dkeycloak.migration.provider=singleFile \
-Dkeycloak.migration.realmName=master \
-Dkeycloak.migration.usersExportStrategy=REALM_FILE \
-Dkeycloak.migration.file=/tmp/master_export.json
```
The previous command will start a new instance of keycloak on new ports. Once it is up and running, 
the instance can be stopes with `Cmmnd + C`. After it stops, exit the pod `exec` and run the 
the following command to copy the file from the pod.

```bash
kubectl cp <pod_name>:/tmp/master_export.json <target_directory>/master_export.json
```
## Create a new Keycloak image
Once you got the exported file, you can create a new image that will import the configuration file 
you exported before. To do so, replace the name of the file in the Dockerfile (line 25), so it will
 copy the file that you exported into the new image.

To build the new image
```bash
docker build -t gcr.io/ops-terraform-env-cicd/enterprise/keycloak:0.0.1 .
```

To push the new image
```bash
docker push gcr.io/ops-terraform-env-cicd/enterprise/keycloak:0.0.1
```
## Starting a pod with the new image
You can use the `keycloak-service.yaml` file included in this repo, or you can use another one, but 
make sure to pass the following parameters to container spec:
```yml
          args:
            - -b 0.0.0.0
            - -Dkeycloak.migration.action=import
            - -Dkeycloak.migration.provider=singleFile
            - -Dkeycloak.migration.file=/config-files/oauth2-demo-realm-config.json
            - -Dkeycloak.migration.strategy=IGNORE_EXISTING
```