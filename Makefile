VERSION != cat VERSION

tag-release:
	@echo git commit -m "'pipeline-runner ${VERSION}'"
	@echo git tag -a v${VERSION} -m "'Version ${VERSION}'"
