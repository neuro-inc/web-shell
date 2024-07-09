build:
	docker build -t neuro-web-shell:latest .

sanity-test:
	neuro -v run --pass-config image:${IMAGE_NAME}:${IMAGE_TAG} -- bash -euo pipefail -c "\
		apolo --version; \
		apolo config show; \
		apolo-flow --version; \
	"
