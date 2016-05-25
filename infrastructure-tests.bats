#!/usr/bin/env bats

@test "Check that Docker is installed" {
  docker --version
}

@test "Check that Docker info can be executed" {
  docker info
}

@test "Login with incorrect username should fail" {
  run docker login -u jack -p ppp -e test@example.com $(hostname):443
  [ "$status" -eq 0 ]
}

@test "Login with correct username" {
  docker login -u medined -p LeftPruneGreen234$ -e test@example.com $(hostname):443
}

@test "Can pull hello-world image from default registry" {
  docker pull hello-world
}

@test "Can tag image" {
  docker tag hello-world:latest $(hostname):443/hello-secure-world:latest
}

@test "Can push image to registry" {
  docker push $(hostname):443/hello-secure-world:latest
}

@test "Can pull just pushed image from registry" {
  docker pull $(hostname):443/hello-secure-world:latest
}


