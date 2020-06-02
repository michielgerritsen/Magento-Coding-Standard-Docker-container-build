# Magento Coding Standard in Docker

This repository is created to put the Magento Code Sniffer Coding Standard in a Docker container so you can easily use it in your builds.

## Usage

You can use it using the `docker run` command:

```
docker run --rm --volume $(pwd)/:/app/data michielgerritsen/magento-coding-standard:latest --severity=10
```

Let's go over this:

---

Mount the current folder into the Docker container. Change this to wherever your files exists:
```
--volume $(pwd)/:/app/data
``` 

The Docker container to run:
```
michielgerritsen/magento-coding-standard:latest
```

Set the severity you want to use. 10 = the lowest and 1 = the most strict. You need at least level 10 to get into the Magento Marketplace.

```
--severity=10
```

## Dockerfile

The specific Dockerfile can be found here:
https://github.com/michielgerritsen/Magento-Coding-Standard-Docker-container-build/blob/master/codesniffer/Dockerfile

