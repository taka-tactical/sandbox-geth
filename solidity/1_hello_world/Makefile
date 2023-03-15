.PHONY: build_hello
build_hello:
	docker-compose run --rm solc -o //app/output --bin --abi --overwrite Hello.sol

.PHONY: clean
clean:
	rm -f ./src/output/*

.PHONY: destroy
destroy:
	make clean
	docker compose down --rmi all --volumes --remove-orphans
