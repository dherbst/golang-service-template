.PHONY: all clean pull get build build-in-container lint lint-in-container sec sec-in-container test test-in-container build-container run-container

GOLANG := golang:1.17

VERSION := 1.0.0
GIT_HASH = $(shell git rev-parse --short HEAD)
LDFLAGS := "-X github.com/dherbst/golang-service-template/srvname.GitHash=${GIT_HASH} -X github.com/dherbst/golang-service-template/srvname.Version=${VERSION}"

all: clean pull lint sec test build build-container

clean:
	mkdir -p bin
	rm -f bin/srvnamed || true

pull:
	docker pull ${GOLANG}

lint:
	docker run -i --rm -v ${PWD}:/go/src/github.com/dherbst/golang-service-template -w /go/src/github.com/dherbst/golang-service-template ${GOLANG} make lint-in-container

lint-in-container:
	go install golang.org/x/lint/golint
	golint github.com/dherbst/golang-service-template
	golint github.com/dherbst/golang-service-template/cmd/srvnamed/...

sec:
	docker run -it --rm -v ${PWD}:/go/src/github.com/dherbst/golang-service-template -w /go/src/github.com/dherbst/golang-service-template ${GOLANG} make sec-in-container

sec-in-container:
	go install github.com/securego/gosec/cmd/gosec
	gosec .

test:
	docker run -it --rm -v ${PWD}:/go/src/github.com/dherbst/golang-service-template -w /go/src/github.com/dherbst/golang-service-template ${GOLANG} make test-in-container

test-in-container:
	go test -ldflags ${LDFLAGS} -coverprofile=coverage.out github.com/dherbst/golang-service-template
	go tool cover -html=coverage.out -o coverage.html

build:
	docker run -i --rm -v "$(PWD)":/go/src/github.com/dherbst/golang-service-template -w /go/src/github.com/dherbst/golang-service-template ${GOLANG} make build-in-container

build-in-container:
	CGO_ENABLED=0 go build -o bin/srvnamed -ldflags ${LDFLAGS} cmd/srvnamed/*.go

build-container:
	docker build -t srvname:${VERSION} .

run:
	docker run -it --rm -v "$(PWD)":/srvname -w /srvname alpine:3.15 ./bin/srvnamed

run-container:
	docker run -it --rm srvname:${VERSION}
