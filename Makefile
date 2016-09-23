DOCKER_CREDENTIAL_CUSTODIA=godeps/src/github.com/tiran/docker-credential-custodia
DCC_BIN=$(DOCKER_CREDENTIAL_CUSTODIA)/docker-credential-custodia
DOCKER_CMD=sudo docker
DOCKER_IMAGE=dcc_demo
CONTAINER_NAME=dcc_demo_container

all:
	@echo "docker-credential-custodia demo container"
	@echo ""
	@echo "  dockerbuild	build Docker image"
	@echo "  dockerrun	run Docker container"
	@echo "  dockershell	execute a bash shell in the container"
	@echo "  dockerkill	kill demo container"

.PHONY=submodules
submodules:
	git submodule init
	git submodule update

$(DCC_BIN): submodules
	GOPATH=$(CURDIR)/godeps make -C $(DOCKER_CREDENTIAL_CUSTODIA)

.PHONY=dockerbuild
dockerbuild: $(DCC_BIN)
	$(DOCKER_CMD) build -t $(DOCKER_IMAGE) .

.PHONY=dockerrun
dockerrun: dockerbuild
	$(DOCKER_CMD) rm $(CONTAINER_NAME) || true
	$(DOCKER_CMD) run \
	    --privileged \
	    --name $(CONTAINER_NAME) \
	    $(DOCKER_IMAGE):latest

#	    -v /var/run/docker.sock:/var/run/docker.sock \
#	    -v $(shell which docker):/bin/docker \

.PHONY=dockershell
dockershell:
	$(DOCKER_CMD) exec -ti $(CONTAINER_NAME) /bin/bash

dockerkill:
	$(DOCKER_CMD) kill $(CONTAINER_NAME)

clean:
	rm -f $(DCC_BIN)
