FROM alpine:3.15

RUN apk add --no-cache ca-certificates

COPY ./bin/srvnamed /usr/local/bin

ENTRYPOINT ["srvnamed"]
