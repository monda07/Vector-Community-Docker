# Rules to make things ....

IMAGEOWNER?=actian
CONTAINER?=docker

build:
	$(CONTAINER) build --tag $(IMAGEOWNER)/vectortest .

run:
	$(CONTAINER)-compose up
