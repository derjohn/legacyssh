CONFDIR:=$(HOME)/.ssh
DOCKERBUILDOPTS:=--no-cache

help:
	@echo make docker : Build the docker container
	@echo make shellalias : create an alias line for the shell or for the .bashrc
	@echo docker run -it -v $(CONFDIR):/root/.legacyssh legacyssh some.ip -p someport -l someuser : connect to a legacy system manually without alias
	@echo legacyssh legacyssh ssh some.ip -p someport -l someuser : connect to a legacy system with the alias

docker: 
	docker build $(DOCKERBUILDOPTS) -t legacyssh .

configure:
	@if ! [ -d $(CONFDIR) ]; then mkdir -p $(CONFDIR); fi

shellalias: configure
	@echo "Add the following to your shellrc (.bashrc)"
	@echo 'alias legacyssh="docker run -e SSHPASS=\$${SSHPASS} -it -v $(CONFDIR):/root/.legacyssh legacyssh"'

dockerhub:
	docker tag legacyssh:latest derjohn/legacyssh:latest
	docker push derjohn/legacyssh:latest

