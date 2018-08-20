FROM ethereum/client-go:stable

RUN mkdir /keystore
COPY ./docker/keystore.json /keystore

