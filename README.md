# Kubernetes Cluster to try various tools

* [ ] Setup local kubernetes cluster using minikube
* [ ] Ensure there is script to install required toolchain
    * [ ] helm
    * [ ] kubectl
    * [ ] jq
    * [ ] minikube
    * [ ] docker
    * [ ] Istio

# Setup Sample Services

Add weather or address services that either can generate dummy data locally or go out to get external data.

* [ ] Weather external, gets data from external API
    * [ ] Setup egress rules for this.
* [ ] Weather internal, generate random dummy data
* [ ] Service to consume weather service in same namspace.

# Service Mesh

## Sample service

* [ ] Service to consume weather service in seperate namespace.

Setup
## Istio

### Requirements

* [ ] Configure istio to connect services

### Bonus

* [ ] Setup tls
* [ ] Setup canary deployment
* [ ] Setup authz/n
* [ ] Load balancing
