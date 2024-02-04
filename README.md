# Nginx Cacher for pypi, npm, apt

A package and generic url caching proxy using only nginx

supercacher is an nginx caching proxy for pypi, npm, apt and generic urls.
It can be used to cache package installs close to the home to speed up
pipelines, local machine install and deployments.

supercacher is build only using nginx config and heavily uses the nginx proxy
module.


## Ports used for caching services

The ports used are as followed:

| Port   | Service            |
| ------ | ------------------ |
| `8080` | PyPi Caching Proxy |
| `8081` | NPM Caching Proxy  |
| `8082` | APT Caching Proxy  |
| `8083` | Generic Url Cache  |


## Setup

### Build

To build the docker container, run:

```sh
docker build -t supercacher:latest --no-cache .
```

### Run with docker

To run the docker container locally, please run:

```sh
docker run \
    -p 80:8080 \
    -p 81:8081 \
    -p 82:8082 \
    -p 83:8083 \
    -ti supercacher:latest
```

### Run with helm

To install the supercacher proxy as a helm chart:

```sh
docker build -t supercacher:latest . --no-cache

if helm ls -a | grep -q ^supercacher; then
    helm delete supercacher || true
fi

helm upgrade \
    supercacher \
    charts/supercacher \
    --install \
    --values charts/supercacher/config/local/values.yaml

kubectl wait pod \
    --selector statefulset.kubernetes.io/pod-name=supercacher-0 \
    --for=condition=ready \
    --timeout=-1s

kubectl port-forward svc/supercacher 8080:8080 8081:8081 8082:8082 8083:8083
```

# Available caching services

This nginx config provides caching endpoints for several services.

## Apt

The apt proxy provides package caching for several repostories:

- ubuntu
- ubuntu-security
- debian
- debian-security
- alpine

Additional endpoints for other package repositories can be added easily.

### Client configuration

#### Debian and Ubuntu apt

```
$ cat /etc/apt/sources.list.d/debian.sources
Types: deb
URIs: http://<yourservice>/debian
Suites: bookworm bookworm-updates
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://apt.<yourservice>/debian-security
Suites: bookworm-security
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
```

Or:

For Debian:
```
# cat /etc/apt/sources.list
deb https://apt.<yourservice>/debian/ bookworm main contrib non-free contrib non-free-firmware
deb https://apt.<yourservice>/debian/ bookworm-updates main contrib non-free
deb https://apt.<yourservice>/debian-security bookworm-security main contrib non-free
```

For Ubuntu:
```
# cat /etc/apt/sources.list
deb https://apt.<yourservice>/ubuntu/ jammy main contrib non-free contrib non-free-firmware
deb https://apt.<yourservice>/ubuntu/ jammy-updates main contrib non-free
deb https://apt.<yourservice>/ubuntu-security jammy-security main contrib non-free
```

More info: https://wiki.debian.org/SourcesList

#### Alpine

For alpine you can set the caching service as the registry on the command line
and in configuration. To do this, use:

For config, edit the `/etc/apk/repositories` file and add our cache as the main
source:
```
https://yourservice/alpine/v2.6/main
```

On the command line, use:
```sh
apk \
    --no-cache \
    --repository https://yourservice/alpine/v3.13/main \
    --repository https://yourservice/v3.13/community
    add package1 package2 ... package10
```

More info: https://wiki.alpinelinux.org/wiki/Alpine_Package_Keeper


## PyPi

The pipy proxy provides a local caching proxy for python packages installed from
pypi.org and pythonhosted.org.


### Client configuration

#### Pip

To tell pip to connect to this instead of pypi.org, use:
```
pip install --index-url=https://pypi.<yourservice>/simple mypy
```

or:
```
export PIP_INDEX_URL=https://pypi.<yourservice>/simple
pip install mypy
```

#### Poetry

For poetry to work with an external registry only in pipelines, but not on local
laptops, use the following configuration in `pyproject.toml` to make pypi explicit:


```toml
[[tool.poetry.source]]
name = "PyPI"
priority = "primary"
```

Then in your CI pipeline, you can override this using:

```sh
poetry config repositories.pypi https://yourservice:8080/simple/
```


## Generic url caching proxy

On port 8083 a generic url proxy is available that can be used for large file
downloads and other generic off-site downloads that should be cached locally for
multiple downloads in a short amount of time.

This can reduce the bandwidth usage a lot.

To use it, connect to the proxy setting the 'Host:` header to the domain you
want to retrieve..

For this to work, the upstream service needs to have https enabled, as this
proxy forces connections over ssl for security reasons.

To use it, set the url and the host of the download you want to cache on the
local cacher:

```
curl --header 'Host: www.google.com' http://yourservice:8083/some/remote/url.html
```

## Npm and Yarn

The yarn and npm cache proxy service can be used for installing packages for the
javascript and nodejs ecosystem.

### Client configuration

#### NPM

- Set via CLI:
  ```
  npm config set registry https://npm.<yourservice>/
  ```

- Set via Environment Variable:
  ```
  NPM_CONFIG_REGISTRY=https://npm.<yourservice>/
  ```

- Set Project or User specific config
  ```
  echo 'registry = "https://npm.<yourservice>/"' > ~/.npmrc
  ```

#### Yarn

- Set through yarn config:
  ```
  # Yarn 1
  yarn config set registry https://npm.<yourservice>/

  # Yarn 2
  yarn config set npmRegistryServer https://npm.<yourservice>/
  ```

- Set through environment variable:
  ```
  YARN_REGISTRY=https://npm.<yourservice>/
  ```

- Project or User specific config:
  ```
  echo 'registry = "https://npm.<yourservice>/"' > ~/.yarnrc
  ```
