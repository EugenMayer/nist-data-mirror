build-java:
	mvn clean package

build-docker:
	docker build . -t ghcr.io/eugenmayer/nist-data-mirror


build: build-java build-docker
	echo "Build finished"