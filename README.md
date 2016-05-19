# kube-nginx-websocket
Nginx container to load-balance websocket servers in Kubernetes

## Getting Started
This container is designed to be run in a pod in Kubernetes to proxy websocket requests to a socket server.
You can provide following environment variables to customize it.

```
# set env var to dns name of the socket server
SOCKET_SERVER=socket-service
```

This is supposed to work with the service exposed via AWS Elastic Loadbalancer. Make sure you [enable proxy protocol in your ELB](http://docs.aws.amazon.com/ElasticLoadBalancing/latest/DeveloperGuide/enable-proxy-protocol.html).

You should run this as a Kubernetes service. Remember to set `sessionAffinity: ClientIP` to both, this nginx and upstream socket service.

Example manifest:

```
apiVersion: v1
kind: Service
metadata:
  name: nginx-socket
  labels:
    run: nginx-socket
spec:
  type: NodePort
  ports:
  - port: 80
    protocol: TCP
    nodePort: 31110
  selector:
    run: nginx-socket
  sessionAffinity: ClientIP
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: nginx-socket
spec:
  replicas: 3
  template:
    metadata:
      labels:
        run: nginx-socket
    spec:
      containers:
      - name: nginx-socket
        image: apsops/kube-nginx-websocket:v0.1
        ports:
        - containerPort: 80
        env:
          - name: SOCKET_SERVER
            value: socket-service
```

## Contributing
I plan to make this more modular and reliable.

Feel free to open issues and pull requests for bug fixes or features.

## Licence

This project is licensed under the MIT License. Refer [LICENSE](https://github.com/ApsOps/kube-nginx-websocket/blob/master/LICENSE) for details.
