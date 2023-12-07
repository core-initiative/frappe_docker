VERSION ?= $(shell git describe --tags --always --dirty --match=v* 2> /dev/null || echo "1.0.0")
APP_DSN := mysql://root:bolo@tcp(127.0.0.1:3306)/invap
MIGRATE := docker run -v $(shell pwd)/migrations:/migrations --network host migrate/migrate:v4.10.0 -path=/migrations/ -database "$(APP_DSN)"

PID_FILE := './.pid'
FSWATCH_FILE := './fswatch.cfg'

.PHONY: default
default: help

.PHONY: clean
clean: ## remove temporary files
	rm -rf server coverage.out coverage-all.out

.PHONY: version
version: ## display the version of the API server
	@echo $(VERSION)

.PHONY: db-start
db-start: ## start the database server
	@mkdir -p testdata/mysql
	@docker run --rm --name mariadb -v $(shell pwd)/testdata:/testdata \
		-v erpnext_mariadb:/var/lib/mysql \
		-v $(shell pwd)/mariadb:/etc/mysql/conf.d \
		-e MYSQL_ROOT_PASSWORD=admin -e MYSQL_DATABASE=ihram -d -p 3306:3306 mariadb:10.6

.PHONY: db-stop
db-stop: ## stop the database server
	@docker stop mariadb

.PHONY: redis-start
redis-start: ## start the database server
	@mkdir -p redis
	@docker run --rm --name redis -v $(shell pwd)/redis:/data -d -p 6379:6379 redis

.PHONY: redis-stop
redis-stop: ## stop the database server
	@docker stop redis

.PHONY: erpnext-start
erpnext-start: ## start the php builtin server
	@docker run --rm --name erpnext \
		-v $(shell pwd)/ihram:/home/ihram \
		-d -p 8000:8000 purwaren/ihram:0.4


.PHONY: erpnext-stop
erpnext-stop: ## stop the php builtin server
	@docker stop erpnext
