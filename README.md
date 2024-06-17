# guestbook-go
Kubernetes app with Go and Redis

## Use Namespace Kubernetes Previews
This sample application demonstrates how you can embed Namespace Kubernetes Previews
into your development workflow. You can build, deploy and get a preview of your features in less than a minute.

### Prerequisites 

1. [Install nsc](https://cloud.namespace.so/docs/getting-started/installation)

1. [Install kubectl](https://kubernetes.io/docs/tasks/tools/)

1. Install `kustomize`
    ```sh
    $ go install sigs.k8s.io/kustomize/kustomize/v5@latest
    ```

### Instructions

1. Log in to your Namespace workspace
    ```sh
    $ nsc login
    ```

1. Clone this repository
    ```sh
    $ git clone https://github.com/namespacelabs/guestbook-go.git && cd guestbook-go
    ```

1. Docker build and push the Go application  
    ```sh 
    $ nsc build .  -n guestbook:v1 -p

    Pushed:
    nscr.io/01gr48y5j6qv4mgheyj4mchj76/guestbook:v4
    ```

1. Set the Docker image in the `kustomization.yaml` file
    ```sh
    $ kustomize edit set image guestbook=nscr.io/01gr48y5j6qv4mgheyj4mchj76/guestbook:v1
    ```

1. Create an ephemeral cluster for your isolated tests and preview
    ```sh
    $ nsc create

    Created new ephemeral environment! ID: oabpalureod3g

    More at: https://cloud.namespace.so/01gr48y5j6qv4mgheyj4mchj76/cluster/oabpalureod3g
    ```

1. Extract the _kubeconfig_ file to access the remote Kubernetes cluster
    ```sh
    $ nsc kubeconfig write oabpalureod3g --output_to /tmp/kubeconfig.yaml && \
        export KUBECONFIG=$(cat /tmp/kubeconfig.yaml)
    ```

1. Deploy the manifests to the cluster with `kustomize`
    ```sh
    $ kubectl apply -k .

    service/frontend created
    service/redis-master created
    service/redis-replica created
    deployment.apps/guestbook created
    deployment.apps/redis-master created
    deployment.apps/redis-replica created
    ```

1. (Optional) You can verify that pods and services are up and running
    ```sh
    $ kubectl get pods,svc
    NAME                                 READY   STATUS    RESTARTS   AGE
    pod/guestbook-685577f476-qk594       1/1     Running   0          25m
    pod/guestbook-685577f476-pl8pw       1/1     Running   0          25m
    pod/redis-replica-5d5bb655db-w9m7v   1/1     Running   0          25m
    pod/redis-replica-5d5bb655db-l8vtz   1/1     Running   0          25m
    pod/redis-master-67dcb4f96f-rq7ch    1/1     Running   0          25m
    pod/guestbook-685577f476-bswp2       1/1     Running   0          25m

    NAME                    TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
    service/kubernetes      ClusterIP      10.143.0.1       <none>        443/TCP          37m
    service/frontend        LoadBalancer   10.143.145.119   10.0.1.1      3000:31970/TCP   25m
    service/redis-master    ClusterIP      10.143.191.80    <none>        6379/TCP         25m
    service/redis-replica   ClusterIP      10.143.114.185   <none>        6379/TCP         25m
    ```

1. Create a public authenticated preview for the `frontend` LoadBalancer service
    ```sh
    $ nsc expose kubernetes oabpalureod3g --namespace=default --service=frontend --name=frontend

    Exported port 3000 from default/frontend:
    https://frontend-oabpalureod3g.fra1.nscluster.cloud
    ```

1. Done! Now you can access the above URL and check out your changes. The same URL is also accessible by all your teammates that are part of your Namespace workspace. 

## Attributions

The prominent Kubernetes tutorial heavily inspired the Guestbook application we used in this guide.
Check [their repository](https://github.com/kubernetes/examples/tree/master/guestbook-go) out!
