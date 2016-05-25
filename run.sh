
docker run -d -e \
 VIRTUAL_HOST=$(hostname) \
 -v /opt/registry/data:/var/lib/registry \
 -p 5000:5000 \
 --name docker-registry registry:2

docker run -d -p 443:443 \
 -e REGISTRY_HOST="docker-registry" \
 -e REGISTRY_PORT="5000" \
 -e SERVER_NAME="affy.com" \
 --link docker-registry:docker-registry \
 -v $(pwd)/fullchain.pem:/etc/nginx/certs/fullchain.pem:ro \
 -v $(pwd)/privkey.pem:/etc/nginx/certs/privkey.pem:ro \
 -v $(pwd)/dhparam.pem:/etc/nginx/certs/dhparam.pem:ro \
 -v $(pwd)/.htpasswd:/etc/nginx/.htpasswd:ro \
 d13/docker-registry-proxy


