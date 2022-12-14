.PHONY: check
check:
	@bash ./utilities/check_requirements.sh

.PHONY: test
test:
	@bash ./utilities/check_prepared.sh

.PHONY: genesis
genesis: check
	@echo ""
	@echo "*** puppeth は CTRL+D しないと抜けられないので必ず makeエラー になるが気にしないでOK ***"
	@echo ""
	puppeth --network genesis

.PHONY: init
init: check
	bash ./utilities/init_nodes.sh

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
