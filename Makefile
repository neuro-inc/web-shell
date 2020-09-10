IMAGE_NAME ?= neuro-web-shell

build:
	docker build -t $(IMAGE_NAME):latest .
