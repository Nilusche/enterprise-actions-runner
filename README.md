# enterprise-actions-runner
Dockerfiles and bash to setup an organizational runner to execute Python scripts

This Dockerfile enables users to setup self-hosted organization runners in a containerized way.

# Installation steps
## Build and run image
```
$ docker build actions-runner-image .

$ docker run \
  --detach \
  --env ORGANIZATION=<Your Organization> \
  --env ACCESS_TOKEN=<Your Github Access token> \
  --name runner \
  actions-runner-image
```

## Start docker compose 
```
$ docker compose build

$ docker compose up --scale runner=2 -d
```
