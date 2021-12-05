# Insomnia Linting as a service with docker
## Created for customers wanting to call inso as a docker image service
---

## Descriptions
This repository contains an example of one main purpose: to consume a docker based inso-cli as a callable service.

## Docker Build
This image needs to built at least once, so that docker can use it.

To run this in a PROD environment you will want to generate the image like so:
``` bash
make build
```

The make build command calls on docker-compose to build the image.

## Docker Compose
``` yaml
services:
  inso-cli:
    container_name: inso-cli
    image: inso-cli:latest
    network_mode: none
    build:
      context: build/inso-cli
    volumes:
      - ./run:/workdir:ro
    environment:
      TERM: dumb
```

Breakdown:
* `container_name` is used to indicate no network connectivity is needed.
* `build/context` is used to reference the exact Dockerfile to use for building the image.
* `volumes` is used to configure the files to be passed into the image filesystem.

## Testing the image
To run the docker-compose and build the underlying Docker image can be done by executing the following:
``` bash
make test
```

Sample output will be:
``` bash
./wrapper-inso-service.sh -v -d run/oas -f kong-demo-api.yaml
./wrapper-inso-service.sh -v -d run/oas -f kong-demo-api-errors.yaml
[
  {
    "position": "0:0",
    "error": "Object should have required property paths."
  },
  {
    "position": "2:14",
    "error": "Property descriptio is not expected to be here."
  },
  {
    "position": "12:7",
    "error": "Property pathsa is not expected to be here."
  }
]
make: *** [test] Error 3
```

There is no error on calling the service with the valid contract (exit code 0).

The error in the 2nd call is expected, as the exit status is being set to the number of errors.

## Using the service
The wrapper wrapper-inso-service.sh is created to handle the service output, and
return a non-zero error exit code for the pipeline calling this script to reject
the build step.

The wrapper script can be called from a pipeline, and will spawn a docker image run.
A workspace folder that contains the OAS contracts should be mounted, and this is covered by the script `-d` parameter.
The file to be tested should be specified without full or relative paths.

``` bash
./wrapper-inso-service.sh -v -d run/oas -f kong-demo-api-errors.yaml ; echo $?
```

* The `-v` parameter writes the errors found as a json to the console output.
* The `-d` specifies the folder in which that is to be mounted into the service.
* The `-f` specifies the file in the folder that is to be lint tested.
* `echo $?` is not needed, but added here to showcase fail/pass if there is a non-zero exit code
