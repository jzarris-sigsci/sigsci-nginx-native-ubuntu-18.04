DOCKERUSER?=sigsci
DOCKERNAME?=sigsci-ubuntu-nginx
DOCKERTAG?=latest

build:
	docker build -t $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG) .

build-no-cache:
	docker build --no-cache -t $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG) .

#if the SigSci reverse proxy agent will be inspecting encrypted traffic \
you will need to set the proxy TLS environmental variables as well

run:
	docker run -i -p 9080:80/tcp --name $(DOCKERNAME) -d -P $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG)

deploy:
	docker push $(DOCKERUSER)/$(DOCKERNAME):$(DOCKERTAG)

clean:
	docker kill $(DOCKERNAME)
	docker rm $(DOCKERNAME)
	docker rmi $(DOCKERNAME)/$(DOCKERNAME):$(DOCKERTAG)
