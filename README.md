# Nginx Cacher for pypi, npm, apt

A pypi, apt and npm caching proxy using only nginx


## Build

```
docker build -t nginx .
```


## Run

```
docker run -p 8080:80 -ti nginx
```


## Client configuration

### PyPi

To tell pip to connect to this instead of pypi.org, use:
```
pip install --index-url=https://<yourservice>/pypi/simple mypy
```

or:
```
export PIP_INDEX_URL=https://<yourservice>/pypi/simple
pip install mypy
```

### NPM

- Set via CLI:
  ```
  npm config set registry https://<yourservice>/npm/
  ```

- Set via Environment Variable:
  ```
  NPM_CONFIG_REGISTRY=https://<yourservice>/cache/try/npm/
  ```

- Set Project or User specific config
  ```
  echo 'registry = "https://<yourservice>/npm/"' > ~/.npmrc
  ```


### Yarn

- Set through yarn config:
  ```
  # Yarn 1
  yarn config set registry https://<yourservice>/npm/

  # Yarn 2
  yarn config set npmRegistryServer https://<yourservice>/npm/
  ```

- Set through environment variable:
  ```
  YARN_REGISTRY=https://<yourservice>/npm/
  ```

- Project or User specific config:
  ```
  echo 'registry = "https://<yourservice>/npm/"' > ~/.yarnrc
  ```

### Debian apt

```
$ cat /etc/apt/sources.list.d/debian.sources
Types: deb
URIs: http://<yourservice>/debian
Suites: bookworm bookworm-updates
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

Types: deb
URIs: https://<yourservice>/debian-security
Suites: bookworm-security
Components: main
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg
```

Or

```
# cat /etc/apt/sources.list
deb https://<yourservice>/debian/ bookworm main contrib non-free contrib non-free-firmware
deb-src https://<yourservice>/debian/ bookworm main contrib non-free contrib non-free-firmware

deb https://<yourservice>/debian-security bookworm-security main contrib non-free
deb-src https://<yourservice>/debian-security bookworm-security main contrib non-free

deb https://<yourservice>/debian/ bookworm-updates main contrib non-free
deb-src https://<yourservice>/debian/ bookworm-updates main contrib non-free
```
