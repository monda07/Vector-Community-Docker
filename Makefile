# Rules to make things ....

CONTAINER?=docker
IMAGE_NAME=actian/vectortest
VERSION?=latest
BUILD_ARGS=$(BUILD)
ifeq ($(TERM),dumb)
BUILD_ARGS:=$(BUILD_ARGS) --progress=plain
endif

build:
	$(CONTAINER) build $(BUILD_ARGS) --tag $(IMAGE_NAME) .

run:
	$(CONTAINER)-compose up

# It is not clear how to publish versions here.
# TODO: The version stamp should probably be derived from the installer tarball
# "latest" should probably track the most recent patch of the most recent version
# Tagging specific versions is obvious

# Squash is experimental so it isn't in production use.  The rule is left here to document the
# operation for production for future updates.
buildsquashedimage:
#	$(CONTAINER) build $(BUILD_ARGS) --tag $(IMAGE_NAME):$(VERSION) --squash .
	$(CONTAINER) build $(BUILD_ARGS) --tag $(IMAGE_NAME):$(VERSION) .
publish: buildsquashedimage
	$(CONTAINER) push $(IMAGE_NAME):$(VERSION) && echo $(IMAGE_NAME):$(VERSION) > anchore_images
