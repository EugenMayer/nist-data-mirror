# NIST Data Mirror

A simple Java command-line utility to mirror the NVD (CPE/CVE JSON) data from NIST.

The intended purpose of `nist-data-mirror` is to be able to replicate the NIST vulnerabiity data
inside a company firewall so that local (faster) access to NIST data can be achieved.

`nist-data-mirror` does not rely on any third-party dependencies, only the Java SE core libraries.
It can be used in combination with [OWASP Dependency-Check] in order to provide Dependency-Check
a mirrored copy of NIST data.

For best results, use `nist-data-mirror` with cron or another scheduler to keep the mirrored data fresh.

## Usage

### Building locally

```sh
make build-java
# or: mvn clean package
java -jar target/nist-data-mirror.jar <mirror-directory>
```

To use a proxy provide http.proxyHost / http.proxyPort system properties.

### Kubernetes

See [EugenMayer/helm-charts](https://github.com/EugenMayer/helm-charts)

### Docker

The image is release at [ghcr.io/eugenmayer/nist-data-mirror](https://github.com/EugenMayer/nist-data-mirror/pkgs/container/nist-data-mirror)

#### Build yourself

```sh
make build-java
# or: mvn clean package
make build-docker
# or: docker-compose up -d
make build # this builds them both
```

The image is listening on port `80/TCP`. If you want to persist the mirrored data, be sure to mount a volume to `/usr/local/apache2/htdocs`.

#### Configuration
assist in debugging other issues. While the image does create an httpd instance
that mirrors the NVD CVE data feeds - note that it also creates a backup for all
changed files and there is currently no automatic cleanup.

The httpd server will take a minute to spin up as it is mirroring the initial NVD files.

To use a proxy during build time provide the `http_proxy`, `https_proxy` and `no_proxy`
environment variables as build arguments (e.g. `--build-arg http_proxy="${http_proxy}"`.
For the runtime you can pass the `http.proxyHost` and `http.proxyPort` values in `_JAVA_OPTIONS`.

For example.

```
_JAVA_OPTIONS="-Dhttps.proxyHost=yourproxyhost.domain -Dhttps.proxyPort=3128 -Dhttp.proxyHost=yourproxyhost.domain
      -Dhttp.proxyPort=3128 -Dhttp.nonProxyHosts="localhost|*.domain"
```

The image is designed to be executed as a random non-root user and can be deployed on
container orchestration platforms such as Kubernetes and OpenShift.

## Related Projects

- Helm chart at [EugenMayer/helm-charts](https://github.com/EugenMayer/helm-charts)
- [VulnDB Data Mirror](https://github.com/stevespringett/vulndb-data-mirror)

## Copyright & License

nist-data-mirror is Copyright (c) Steve Springett. All Rights Reserved.
Dependency-Check is Copyright (c) Jeremy Long. All Rights Reserved.

Permission to modify and redistribute is granted under the terms of the Apache 2.0 license. See the [LICENSE] [Apache 2.0] file for the full license.

[owasp dependency-check](https://www.owasp.org/index.php/OWASP_Dependency_Check)
[apache 2.0](https://github.com/eugenmayer/nist-data-mirror/blob/master/LICENSE)
