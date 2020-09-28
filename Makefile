# Rules to make things ....

CONTAINER?=docker

build:
	$(CONTAINER) build --tag actian/vectortest .

run:
	$(CONTAINER)-compose up
