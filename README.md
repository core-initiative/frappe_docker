## Docker Development Template for Frappe ERPNext
### How to Use
1. Build the docker image inside `ihram` folder, adjust the tag as you want
2. Start the database using `make db-start`. Dont forget to adjsut the  root password
3. Start the frappe-bench based on ubuntu 22.04 using `make erpnext-start`
4. Connect to the container using `docker exec` for VS Code Dev Container

### Setup Prerequisite
1. Install npm v14, use nvm
2. Install yarn using `npm install -g yarn`

### How to Setup Frappe & ERPNext
1. Init the frappe-bench with version-14
```bash
cd ~
bench init frappe-bench --branch version-14
```

2. Edit the `common_site_config.json` add `db_host` and point the ip address to the mariadb container
3. Run the bench
```bash
cd frappe-bench
bench start
```
4. Create site and use it
```bash
bench new-site ihram.local
bench use ihram.local
```
5. Get payment, erpnext & hrms app
```bash
bench get-app payments
bench get-app erpnext --branch version-14
bench get-app hrms --branch version-14
```
6. Install app, make sure the `bench start` command is running before install
```bash
bench --site ihram.local install-app payments
bench --site ihram.local install-app erpnext
bench --site ihram.local install-app hrms
```

## Docs Reference
1. https://github.com/D-codE-Hub/Frappe-ERPNext-Version-14--in-Ubuntu-22.04-LTS
