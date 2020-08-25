CONFDIR:=$(HOME)/.ssh
DOCKERBUILDOPTS:=--no-cache
IMAGE:=derjohn/legacyssh
TAG:=latest

help:
	@echo make docker : Build the docker container
	@echo make shellalias : create an alias line for the shell or for the .bashrc
	@echo To run it calling docker directly:
	@echo "  docker run -it -v $(CONFDIR):/root/.legacyssh $(IMAGE) some.ip -p someport -l someuser"
	@echo To run it calling via shellalias:
	@echo "  legacyssh some.ip -p someport -l someuser"

docker: 
	docker build $(DOCKERBUILDOPTS) -t $(IMAGE) .

configure:
	@if ! [ -d $(CONFDIR) ]; then mkdir -p $(CONFDIR); fi

shellalias: configure
	@echo 'Add the following to your shellrc (.bashrc)'
	@echo '  alias legacyssh="docker run -e SSHPASS=\$${SSHPASS} -it -v $(CONFDIR):/root/.legacyssh $(IMAGE)"'
	@echo 'Add the following to your shellrc (.bashrc) without config (only with your private key)'
	@echo '  alias legacyssh="docker run -e SSHPASS=\$${SSHPASS} -it -v $(CONFDIR)/id_rsa:/root/.legacyssh/id_rsa $(IMAGE)"'

dockerhub:
	docker push derjohn/legacyssh:latest

