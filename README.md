# Magento Coding Standard in Docker

This repository is created to put the Magento Code Sniffer Coding Standard in a Docker container so you can easily use it in your builds.

The image contains PHP_CodeSniffer with these standards installed:

- `Magento2` and `Magento2Framework` from [magento/magento-coding-standard](https://github.com/magento/magento-coding-standard)
- `Ecg` and `EcgM2` from [magento-ecg/coding-standard](https://github.com/magento-ecg/coding-standard)
- `PHPCompatibility`, plus the default PHP_CodeSniffer standards (PSR12 and friends)

The image is rebuilt every Monday with the latest releases and is available for `linux/amd64` and `linux/arm64`. The build fails when the newest Magento Coding Standard can't be installed, so you never silently get an old version.

## Usage

You can use it using the `docker run` command:

```
docker run --rm --volume $(pwd)/:/app/data michielgerritsen/magento-coding-standard:latest --standard=Magento2 --severity=10
```

Let's go over this:

---

Mount the current folder into the Docker container. Change this to wherever your files exist. Mounting on `/app/workdir` works too:
```
--volume $(pwd)/:/app/data
```

The Docker container to run:
```
michielgerritsen/magento-coding-standard:latest
```

Set the severity you want to use. phpcs reports everything at or above this level, so 1 shows the most and 10 the least. The Magento Marketplace only fails on severity 10 issues, so use 10 to check whether you will pass:

```
--severity=10
```

When you don't pass any arguments, the image runs `--standard=Magento2 --severity=6`. Passing your own arguments replaces both, so include them when you need them.

## Scanning a subfolder

Every argument that doesn't start with a `-` is used as a path to scan, relative to the mounted folder. Without one, the whole folder is scanned:

```
docker run --rm --volume $(pwd)/:/app/data michielgerritsen/magento-coding-standard:latest --standard=Magento2 --severity=10 src/
```

## Using your own ruleset

Put a `phpcs.xml` in your project and point to it:

```
docker run --rm --volume $(pwd)/:/app/data michielgerritsen/magento-coding-standard:latest --standard=phpcs.xml
```

## Annotations

The image ignores `phpcs:ignore` and `phpcs:disable` annotations by default, the same way the Magento Marketplace does. Set `IGNORE_ANNOTATIONS=0` to respect them:

```
docker run --rm --env IGNORE_ANNOTATIONS=0 --volume $(pwd)/:/app/data michielgerritsen/magento-coding-standard:latest --standard=Magento2
```

## Reports and CI

Reported paths are relative to the mounted folder, so reports like checkstyle line up with the files in your repository:

```
docker run --rm --volume $(pwd)/:/app/data michielgerritsen/magento-coding-standard:latest --standard=Magento2 --report=checkstyle
```

The progress output is on by default. Add `-q` to turn it off.

The container runs as root, so files it writes (like `--report-file`) end up owned by root on Linux. Run it as your own user to avoid that:

```
docker run --rm --user "$(id -u):$(id -g)" --volume $(pwd)/:/app/data michielgerritsen/magento-coding-standard:latest --standard=Magento2 --report=checkstyle --report-file=phpcs-report.xml
```

## Large codebases

The PHP memory limit is disabled and the `pcntl` extension is installed, so you can scan big codebases in parallel:

```
docker run --rm --volume $(pwd)/:/app/data michielgerritsen/magento-coding-standard:latest --standard=Magento2 --parallel=8
```

## Tags

- `latest`: the most recent weekly build.
- `YYYYMMDD`: the build from that date. Use this when you need a stable result across runs.

## Dockerfile

The specific Dockerfile can be found here:
https://github.com/michielgerritsen/Magento-Coding-Standard-Docker-container-build/blob/master/codesniffer/Dockerfile
