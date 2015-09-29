
GOPATH := $(shell echo $(GOPATH))
export GOPATH


run: install
	devjournal web --serve-embedded-assets

embed: .FORCE
	rm -rf embedded/* .files/_site
	mkdir -p embedded .files/_site
	cp ../www/dest/_site/* .files/_site
	go-bindata -nocompress -o embedded/assets.go -pkg embedded -prefix .files/_site  .files/_site

fmt: .FORCE
	gofmt -w */

install: .FORCE
	go build -o $(GOPATH)/bin/devjournal github.com/nightshaders/devjournal/server

.FORCE:
