# Container Images

These [container images](https://github.com/mikevader/container-images) are tailored for Kubernetes.

Images are hosted on Github Container Registry [here](https://github.com/mikevader/packages?ecosystem=container&visibility=public).

## Test locally

### DGOSS

[dgoss](https://github.com/goss-org/goss/tree/master/extras/dgoss)

setup

```bash
# Install dgoss
curl -L https://raw.githubusercontent.com/goss-org/goss/master/extras/dgoss/dgoss -o /usr/local/bin/dgoss
chmod +rx /usr/local/bin/dgoss

# Download desired goss version to your preferred location (e.g. v0.4.8)
curl -L https://github.com/goss-org/goss/releases/download/v0.4.8/goss-linux-amd64 -o ~/Downloads/goss-linux-amd64

# Set your GOSS_PATH to the above location
export GOSS_PATH=~/Downloads/goss-linux-amd64

# Set DGOSS_TEMP_DIR to the tmp directory in your home, since /tmp is private on Mac OSX
export DGOSS_TEMP_DIR=~/tmp
```

run tests with dgoss
```bash
docker buildx build --build-arg VERSION=0.22.2196  --file ./apps/jackett/Dockerfile --label org.opencontainers.image.created=2025-07-26 --tag ghcr.io/mikevader/jackett:test .
GOSS_FILES_PATH=./apps/jackett dgoss run -p 9117:9117 ghcr.io/mikevader/jackett:test
```

### GOSS

```bash
# Run service
docker run --rm -it -p 9117:9117 ghcr.io/mikevader/jackett:test
export GOSS_USE_ALPHA=1
goss --gossfile ./apps/jackett/goss.yaml v
```
