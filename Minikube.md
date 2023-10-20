# Setup Minikube Node on Remote Machine


# Remote Machine

## Start minikube

```
$ minikube addons enable volumesnapshots
$ minikube addons enable csi-hostpath-driver

$ minikube start --nodes=3 --memory=4096
```

## Setup Nginx Reverse Proxy

### Add Password file

```
$ apt-get install apache2-utils -y
$ htpasswd -c /etc/nginx/.htpasswd minikube
```

### Create nginx conf
Filename: `/etc/nginx/conf.d/minikube.conf`
Content:
```
server {
    listen       8080;
    listen  [::]:8080;
    server_name  localhost;
    auth_basic "Administrator’s Area";
    auth_basic_user_file /etc/nginx/.htpasswd;

    location / {
        proxy_pass https://`minikube ip`:8443;
        proxy_ssl_certificate /etc/nginx/certs/client.crt;
        proxy_ssl_certificate_key /etc/nginx/certs/client.key;
    }
}
```

### Start Nginx

```
systemctl service start nginx.service
```

# Local Machine

### Edit Config File

Open `~/.kube/config`

```
apiVersion: v1
clusters:
- cluster:
    extensions:
    - extension:
        last-update: Wed, 05 Oct 2022 10:12:36 EDT
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: cluster_info
    server: http://minikube:<htpasswd-password>@<minikube-remote-host-ip>:8080
  name: minikube-ubuntu
contexts:
- context:
    cluster: minikube-ubuntu
    extensions:
    - extension:
        last-update: Wed, 05 Oct 2022 10:12:36 EDT
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: context_info
    namespace: default
    user: minikube-ubuntu
  name: minikube-ubuntu
current-context: minikube-ubuntu
kind: Config
preferences: {}
users:
- name: minikube-ubuntu
  user:
```
