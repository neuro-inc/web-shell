sanity-test:
	apolo -v run --pass-config image:${IMAGE_NAME}:${IMAGE_TAG} -- bash -euo pipefail -c "\
		apolo --version; \
		apolo config show; \
		apolo-flow --version; \
	"

setup:
	pip install -r requirements/python.txt