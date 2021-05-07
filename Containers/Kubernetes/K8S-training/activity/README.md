# Exercise

## WP + MariaDB

Create the K8s resources you need to deploy a WP site on your cluster using MariaDB as database with the characteristics below:

* All the resources should be created under the *activity* namespace.
* The WP site should use a MariaDB database.
* Use ConfigMaps and Secrets to configure both MariaDB and WP.
  * Admin user for WP should be "kubernetes" with password "training"
  * MariaDB password should NOT be empty
* MariaDB database should be persisted on a PV
* Use a canary deployment for WP. Consider the version 4.9.7 as the sable WP
version and use 4.9.8 in the canary deployment.
* Add appropriate readiness/liveness probes to MariaDB and WP containers.
* WP should be accessible through http using a NGINX Ingress on the URL *wordpress.activity.com*.
* WP should be accessible through http/https using a NGINX Ingress on the URL *wordpress.activity.com* . Ingress should handle the TLS certificates.

## Tips

* Use a linter to avoid syntax errors on your YAML/JSON files
* You can use the command below in order to create your TLS certificates:

```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/CN=wordpress.activity.com" -keyout wordpress.key -out wordpress.crt  
```
