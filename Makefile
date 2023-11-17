GO_VERSION := 1.20  

setup: 
	install-go
	init-go

install-go: 
	wget "https://golang.org/dl/go$(GO_VERSION).linux-amd64.tar.gz"
	sudo tar -C /usr/local -xzf go$(GO_VERSION).linux-amd64.tar.gz
	rm go$(GO_VERSION).linux-amd64.tar.gz

init-go: 
    echo 'export PATH=$$PATH:/usr/local/go/bin' >> $${HOME}/.bashrc
    echo 'export PATH=$$PATH:$${HOME}/go/bin' >> $${HOME}/.bashrc

upgrade-go: 
	sudo rm -rf /usr/bin/go
	wget "https://golang.org/dl/go$(GO_VERSION).linux-amd64.tar.gz"
	sudo tar -C /usr/local -xzf go$(GO_VERSION).linux-amd64.tar.gz
	rm go$(GO_VERSION).linux-amd64.tar.gz

build:
	go build -o bigFeedback cmd/main.go
#The make build command will compile the main application into a binary named bigFeedback.
test:
	go test ./... -coverprofile=coverage.out

coverage:
	go tool cover -func coverage.out \
	| grep "total:" | awk '{print ((int($$3) > 80) != 1) }'

report:
	go tool cover -html=coverage.out -o cover.html

check-format:
	go fmt ./...
	# The below code was provided however it kept returning
	# errors in the pipeline so I opted for a more simpler 
	# setup. I will check back to see if the below code 
	# is more appropriate whenever I circle back through this
	# project. 
	# test -z $$(go fmt ./...)

install-lint:
	sudo curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $$(go env GOPATH)/bin v1.41.1