NAME=goodeggs/logspout-sumo
VERSION=$(shell cat VERSION)

dev:
	rm -rf ./tmp
	mkdir -p ./tmp/src
	cp -R ./vendor/src tmp/
	mkdir -p ./tmp/src/github.com/goodeggs/logspout-sumo/http
	cp -R ./modules.go ./tmp/src/github.com/goodeggs/logspout-sumo
	cp -R ./http/* ./tmp/src/github.com/goodeggs/logspout-sumo/http
	cp ./tmp/src/github.com/goodeggs/logspout-sumo/modules.go ./tmp/src/github.com/gliderlabs/logspout
	@docker build -f Dockerfile.dev -t $(NAME):dev .
	@docker run --rm \
		-e DEBUG=true \
		-e STATS=true \
		-e CRASH= \
		-e LOGSPOUT=ignore \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-v $(PWD):/go/src/github.com/goodeggs/logspout-sumo \
		-p 8000:80 \
		-e ROUTE_URIS="$(ROUTE)" \
		$(NAME):dev

build:
	mkdir -p build
	docker build -t $(NAME):$(VERSION) .
	docker save $(NAME):$(VERSION) | gzip -9 > build/$(NAME)_$(VERSION).tgz

.PHONY: release
