build:
	docker build -t neuro-web-shell:latest .

sanity-test:
	neuro run ubuntu echo hi
	neuro -v run --pass-config image:${IMAGE_NAME}:${IMAGE_TAG} bash -euo pipefail -c "\
		neuro --version; \
		neuro config show; \
		neuro-flow --version; \
	"
