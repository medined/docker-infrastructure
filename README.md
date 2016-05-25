# docker-infrastructure

Develop docker containers that work together for common developer tools.

## Introduction

The first goal of this project is to get a Docker Registry working. I am using a 4 core Linode box.

I used the following guides:

* https://www.linode.com/docs/getting-started
* https://www.linode.com/docs/security/securing-your-server
* https://www.linode.com/docs/security/ssl/install-lets-encrypt-to-create-ssl-certificates
* https://www.digitalocean.com/community/tutorials/how-to-secure-nginx-with-let-s-encrypt-on-ubuntu-14-04

## Prequisities

1. Ensure your server has a hostname with an A record. Run 'hostname' to check. Run 'ping' to verify IP address. Run 'dig' to check DNS.
1. Install Let's Encrypt.
1. Use the following as a template. Move to the next step when you have fullchain.pem and privkey.pem files.
1. Create a /etc/ssl/certs/dhparam.pem file with 2048 bits.
1. Install BATS for BASH tests.

## Create Docker Images

Please review the build.sh before you run it because it refers to several host files. The host files are copied into the project directory but their names are in .gitignore so they are not accidentally added to the git repository.

```
./build.sh
```

## Run Docker Images

```
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
```

## Test the Registry

```
# This login will fail.
docker login -u jack -p ppp$ $(hostname):443

# This login will succeed.
docker login -u medined -p LeftPruneGreen234$ $(hostname):443
docker pull hello-world
docker tag hello-world:latest $(hostname):443/hello-secure-world:latest
docker push $(hostname):443/hello-secure-world:latest
docker pull $(hostname):443/hello-secure-world:latest
```

# Install BATS

```
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:duggan/bats --yes
sudo apt-get update -qq
sudo apt-get install -qq bats
```

* https://github.com/sstephenson/bats
* https://blog.engineyard.com/2014/bats-test-command-line-tools
* http://blog.spike.cx/post/60548255435/testing-bash-scripts-with-bats
* https://github.com/aespinosa/docker-jenkins/blob/master/test/jenkins_test.bats
* https://github.com/rightscale-cookbooks/rs-cookbooks_ci/blob/master/test/integration/jenkins/bats/jenkins.bats

# TODO

* Use BATS for BASH-level unit testing.
* Use docker compose to start multiple containers instead of manually
* LDAP in docker
* Use Portus to provide user interface for docker
* Jenkins
* BitBucket
* JIRA
* Confluence
* Investigate python version of maven

