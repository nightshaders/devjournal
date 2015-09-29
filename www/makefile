
current_dir :=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

default: webserver site web

site: .FORCE
	node_modules/.bin/gulp site

webserver:
	go install github.com/nightshaders/ywebserver

web: .FORCE
	ywebserver web --port 1111 --root $(current_dir)/dest/_site

test:
	echo $(current_dir)

.FORCE:


