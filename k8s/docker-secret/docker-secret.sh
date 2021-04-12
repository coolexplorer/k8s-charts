kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/home/eass-build/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson