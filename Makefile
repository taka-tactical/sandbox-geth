.PHONY: check
check:
	@chmod u+x ./utilities/check_requirements.sh
	@./utilities/check_requirements.sh

.PHONY: test
test:
	@@chmod u+x ./utilities/check_prepared.sh
	@./utilities/check_prepared.sh

.PHONY: init
init: check
	@chmod u+x ./utilities/init_nodes.sh
	@./utilities/init_nodes.sh

.PHONY: build
build:
	docker compose build --no-cache --force-rm

.PHONY: setup
setup: test
	docker compose up -d --build

.PHONY: start
start:
	docker compose up -d

.PHONY: stop
stop:
	docker compose down

.PHONY: status
status:
	docker compose ps

.PHONY: clean
clean:
	docker compose down --rmi all --volumes --remove-orphans
	rm -f privatenet/static-nodes.json privatenet/genesis.json
	rm -rf privatenet/nodes/node*
