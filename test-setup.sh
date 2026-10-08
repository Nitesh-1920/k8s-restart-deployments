#!/usr/bin/env bash
set -e

kind create cluster --name restart-test

kubectl create namespace team-a
kubectl create namespace team-b

kubectl create deployment web-a --image=nginx:1.27 --replicas=2 -n team-a
kubectl create deployment web-b --image=nginx:1.27 --replicas=2 -n team-b

kubectl rollout status deployment web-a -n team-a
kubectl rollout status deployment web-b -n team-b


 


