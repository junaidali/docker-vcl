# Running Apache VCL in docker container within Kubernetes

You will need the following setup before you can run apache VCL as a containerized application
1. [Docker](https://www.docker.com/get-docker)
2. [Docker Compose](https://docs.docker.com/compose/install/)
3. [Kubernetes](https://kubernetes.io/)

## Building Images
The images built need to be published to a remote repository that will be used to pull the image down for execution. The default image repositories uses [Dockerhub - Junaid](https://hub.docker.com/u/junaid/).

Update the docker-compose.yml file with the path of the image repository that will be used for pulling images at runtime within the kubernetes cluster. Update line # 26 and 39 with the settings that match your envioronment. To build the image
```
docker-compose build
```

## Pushing Images
To push the image to your image repository
```
docker push <image name> <tag>
e.g. docker push junaid/vcl-www k8s && docker push junaid/vcl-mgmt k8s
```

## Running them in Kubernetes cluster
Refer to [Kubernetes VCL Project](https://github.com/junaidali/k8s-vcl) for detail step by step instructions on how to launch dockerized VCL application on a kubernetes cluster.
