# Setup Minikube Node on Remote Machine

# Start minikube

```
$ minikube addons enable volumesnapshots
$ minikube addons enable csi-hostpath-driver

# Get Ip of remote server
$ hostname -I

# Start minikube with apiserver-ips flag to enable remote connection
$ minikube start --nodes=3 --memory=4096 -- apiserver-ips=<ip-of-remote-server>
```

# Remotely Connect Using SSH Tunnel

## On Remote Machine

```
# Copy minikube certs after minikube is started with apiserver-ips flag
$ scp <server>:~/.minikube/ca.crt ~/.minikube/ca-remote-minikube.crt
$ scp <server>:~/.minikube/profiles/minikube/client.crt ~/.minikube/profiles/minikube/client-remote-minikube.crt
$ scp <server>:~/.minikube/profiles/minikube/client.key ~/.minikube/profiles/minikube/client-remote-minikube.key

# Get minikube IP from remote server
$ minikube ip
```

## On Local Machine

### Start remote tunnel on a separate terminal

```
$ ssh -N -p 22 <username>@<remote-server-ip> -L 127.0.0.1:18443:<remote-minikube-ip>:8443
```

### Edit Config File

Open `~/.kube/config`

```
apiVersion: v1
clusters:
- cluster:
    certificate-authority: ~/.minikube/ca-remote-minikube.crt
    extensions:
    - extension:
        last-update: Wed, 05 Oct 2022 10:12:36 EDT
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: cluster_info
    server: http://127.0.0.1:18843
  name: remote-minikube
contexts:
- context:
    cluster: remote-minikube
    extensions:
    - extension:
        last-update: Wed, 05 Oct 2022 10:12:36 EDT
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: context_info
    namespace: default
    user: remote-minikube
  name: remote-minikube
current-context: remote-minikube
kind: Config
preferences: {}
users:
- name: remote-minikube
  user:
    client-certificate: ~/.minikube/profiles/minikube/client-remote-minikube.crt
    client-key: ~/.minikube/profiles/minikube/client-remote-minikube.key
```


# Remotely Connect Using Nginx Proxy

## On Remote Machine

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

## On Local Machine

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
  name: remote-minikube
contexts:
- context:
    cluster: remote-minikube
    extensions:
    - extension:
        last-update: Wed, 05 Oct 2022 10:12:36 EDT
        provider: minikube.sigs.k8s.io
        version: v1.25.2
      name: context_info
    namespace: default
    user: remote-minikube
  name: remote-minikube
current-context: remote-minikube
kind: Config
preferences: {}
users:
- name: remote-minikube
  user:
```

# Expose Ingress Gateway

## On Remote Machine

```
$ minikube tunnel
```

## On Local Machine

### Get minikube ingress external IP

```
# If running istio-ingress
$ kubectl get svc istio-ingress -n istio-ingress

# If running istio-ingressgateway
$ kubectl get svc istio-ingressgateway -n istio-system

# Output should be something like
NAME                   TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                                      AGE
istio-ingressgateway   LoadBalancer   10.97.107.111   10.97.107.111   15021:32686/TCP,80:30325/TCP,443:31384/TCP   6m7s
```

```

$ ssh -N -p 22 <username>@<remote-server-ip> -L 127.0.0.1:18443:<remote-minikube-ip>:8443 -L 127.0.0.1:8080:<ingress-external-ip>:80
```
