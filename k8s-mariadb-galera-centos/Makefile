IMAGE_NAME=adfinissygroup/k8s-mariadb-galera-centos
IMAGE_VERSION=v004
LOCAL_REGISTRY=localhost:5000

image:
	docker build -t $(IMAGE_NAME):$(IMAGE_VERSION) .

push:
	docker tag $(IMAGE_NAME):$(IMAGE_VERSION) $(LOCAL_REGISTRY)/$(IMAGE_NAME):$(IMAGE_VERSION)
	docker push $(LOCAL_REGISTRY)/$(IMAGE_NAME):$(IMAGE_VERSION)
