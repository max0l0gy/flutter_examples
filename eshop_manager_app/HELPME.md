# Publish Container Images to Docker Hub / Image registry with Podman
podman build -t maxmorev/eshop-manager-web:0.0.1 .
podman build -t docker.io/maxmorev/eshop-manager-web:0.0.1 .
podman push docker.io/maxmorev/eshop-manager-web:0.0.1
