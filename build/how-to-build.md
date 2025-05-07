## Building custom image for ERPNext with custom app development
### Part 1 - Build the docker image
1. Adjust the `apps.json`, put your own custom app inside the `apps.json`. You need to create a release tag for your custom application first.
2. Create the `base64 encode` from `apps.json`, and export it as environment variable `APPS_JSON_BASE64`
```bash
# Mac OS
export APPS_JSON_BASE64=$(base64 -i apps.json)
# Linux
export APPS_JSON_BASE64=$(base64 -w 0 apps.json)
```
3. Build the docker image, you can adjust the build tag
```bash
docker build -t purwaren/ihram-prod:v1.0-amd64 \
--build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
--build-arg=FRAPPE_BRANCH=version-15 \
--build-arg=PYTHON_VERSION=3.11.6 \
--build-arg=NODE_VERSION=18.18.2 \
--build-arg=APPS_JSON_BASE64=$APPS_JSON_BASE64 .
```
4. On the compose.yaml replace the image reference to the tag you used when you built it. Then, if you used a tag like `purwaren/ihram-prod:v1.0-amd64` the `x-customizable-image` section will look like this:
```yaml
x-customizable-image: &customizable_image
  image: purwaren/ihram-prod:v1.0-amd64
  pull_policy: never
```
### Part 2 - Create the docker compose file using the newly generated image
1. Assume that we want to deploy the ERPNext and use a separate mariadb / redis
2. Create the environment file
```bash
cp example.env .env
```
3. Adjust the environment file if you use the mariadb & redis from outside this deployment, search the key configuration for `DB_HOST`, `DB_PORT`, `DB_PASSWORD`, `REDIS_CACHE` and `REDIS_QUEUE`. Dont forget to set the `DB_PASSWORD` for production
4. Run the docker compose command to create the completed compose file.
```bash
docker compose -f compose.yaml -f overrides/compose.noproxy.yaml -f overrides/compose.mariadb.yaml -f overrides/compose.redis.yaml config > ../compose-prod.yml
```
### Part 3 - Starting Up the Deployment
1. Run & deploy the compose file
```bash
docker compose -f compose-prod.yml up -d
```
2. After all the container is created and started, setup the site that you want to publish, please adjust the `db-password, admin-password` and `site-name`
```bash
docker-compose exec backend bench new-site --no-mariadb-socket --mariadb-root-password <db-password> --admin-password <admin-password> <site-name>
```
3. You still need to install the app, for this case `erpnext, hrms, inn`
```bash
docker compose -f compose-prod.yml exec backend bench --site <site-name> install-app erpnext
docker compose -f compose-prod.yml exec backend bench --site <site-name> install-app hrms
docker compose -f compose-prod.yml exec backend bench --site <site-name> install-app inn
```
4. Set the default site to the `site-name` you are created
```bash
docker compose -f compose-prod.yml exec backend bench use <site-name>
```
### Part 4 - Troubleshoot
1. Clear redis cache
```bash
docker compose -f compose-prod.yml exec -it redis-cache redis-cli FLUSHALL
```
