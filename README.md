# Fluentd Daemonset Barito
A Kubernetes daemonset for fluentd output plugin to [BaritoLog](https://github.com/BaritoLog)
---

## HowTo
* `$ kubectl apply -f fluentd-daemonset-baritolog.yaml`
---
#### Build docker locally (without pulling from docker hub)
* `$ docker build -t fluentd-kubernetes-daemonset:baritolog docker-image/v0.12/debian-baritolog`
* Modify `fluentd-daemonset-baritolog.yaml` with :
    ```yaml
        ...
        containers:
              - image: fluentd-kubernetes-daemonset:baritolog
                imagePullPolicy: Never
        ...
    ```
---
Note: You can use `deploy.sh` to automate above steps.