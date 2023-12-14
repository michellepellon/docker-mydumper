# mpellon/mydumper:0.15.1-3

## Introduction

Dockerfile to build a [mydumper](https://github.com/mydumper/mydumper) 
[Docker](https://www.docker.com/) image.

## Installation

Automated builds of the image are available on 
[Dockerhub](https://hub.docker.com/r/mpellon/mydumper) and is the recommended 
method of installation.

```bash
docker pull mpellon/mydumper:0.15.1-3
```

You can also pull the `latest` tag which is built from the repository *HEAD*

```bash
docker pull mpellon/mydumper:latest
```

Alternatively you can build the image locally.

```bash
docker build -t mpellon/mydumper github.com/michellepellon/mydumper
```
