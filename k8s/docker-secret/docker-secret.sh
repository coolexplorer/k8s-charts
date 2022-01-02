kubectl create secret generic regcred \
    --from-file=.dockerconfigjson=/Users/kimseunghwan/.docker/config.json \
    --type=kubernetes.io/dockerconfigjson