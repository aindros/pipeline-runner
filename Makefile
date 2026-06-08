VERSION  != cat VERSION
SRC_TEST != find test -name '*.rb'

install:
	@bundle install

tag-release:
	@echo git commit -m "'pipeline-runner ${VERSION}'"
	@echo git tag -a v${VERSION} -m "'Version ${VERSION}'"

clean:
	@rm -f Gemfile.lock

test: __force
	for i in "${SRC_TEST}"; do ruby $$i; done

__force:
