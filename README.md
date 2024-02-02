# Nginx Cacher for pypi, npm, apt

A pypi, apt and npm caching proxy using only nginx


## Build

```
docker build -t nginx --no-cache .
```


## Run

```
docker run -p 80:8080 -p 81:8081 -ti nginx
```


## Client configuration

### PyPi

To tell pip to connect to this instead of pypi.org, use:
```
pip install --index-url=https://pypi.<yourservice>/simple mypy
```

or:
```
export PIP_INDEX_URL=https://pypi.<yourservice>/simple
pip install mypy
```

### NPM

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


### Yarn

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

### Debian apt

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

Or

```
# cat /etc/apt/sources.list
deb https://apt.<yourservice>/debian/ bookworm main contrib non-free contrib non-free-firmware
deb https://apt.<yourservice>/debian/ bookworm-updates main contrib non-free
deb https://apt.<yourservice>/debian-security bookworm-security main contrib non-free
```
