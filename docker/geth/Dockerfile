FROM ethereum/client-go:release-1.10

WORKDIR /root/.ethereum
COPY ./docker/geth/entrypoint.sh .
COPY ./privatenet/static-nodes.json .

RUN chmod 555 ./entrypoint.sh

ENTRYPOINT ["/bin/sh", "./entrypoint.sh"]
