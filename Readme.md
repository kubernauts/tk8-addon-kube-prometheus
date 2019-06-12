# TK8 addon - kube-prometheus

## What are TK8 addons?

- TK8 add-ons provide freedom of choice for the user to deploy tools and applications without being tied to any customized formats of deployment.
- Simplified deployment process via CLI (will also be available via TK8 web in future).
- With the TK8 add-ons platform, you can also build your own add-ons.

## What is kube-prometheus?

Kube-prometheus is a complete monitoring stack which includes:

- The [Prometheus Operator](https://github.com/coreos/prometheus-operator)
- Highly available [Prometheus](https://prometheus.io/)
- Highly available [Alertmanager](https://github.com/prometheus/alertmanager)
- [Prometheus node-exporter](https://github.com/prometheus/node_exporter)
- [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)
- [Grafana](https://grafana.com/)

This stack is meant for cluster monitoring, so it is pre-configured to collect metrics from all Kubernetes components. In addition to that, it delivers a default set of dashboards and alerting rules. Many of the useful dashboards and alerts come from the [kubernetes-mixin project](https://github.com/kubernetes-monitoring/kubernetes-mixin), similar to this project it provides composable jsonnet as a library for users to customize to their needs.

## Prerequisites

- A kubernetes cluster.
- Kubelet configuration must contain these flags:
  - authentication-token-webhook=true This flag enables, that a ServiceAccount token can be used to authenticate against the kubelet(s).
  - authorization-mode=Webhook This flag enables, that the kubelet will perform an RBAC request with the API to determine, whether the requesting entity (Prometheus in this case) is allowed to access a resource, in specific for this project the /metrics endpoint.


## Get Started

You can set up the kube-prometheus stack on a Kubernetes cluster by using TK8 addons.

What do you need:
- tk8 binary

## Deploy kube-prometheus on the Kubernetes Cluster

Run:
```
$ tk8 addon install kube-prometheus
....
....
....
kube-prometheus installation complete
```

This command will clone the kubernauts' kube-prometheus repository (https://github.com/kubernauts/tk8-addon-kube-prometheus) locally and install the necessary components.

This command also creates:
- A monitoring namespace to install the stack
- A service of type ClusterIP for Prometheus, Grafana, and Alertmanager. (Feel free to change the service type of Granfana to LoadBalancer).

## Accessing the Dashboard

# Prometheus

For visualizing Prometheus, use port-forwarding to expose the service. Run:

    $ kubectl --namespace monitoring port-forward svc/prometheus-k8s 9090

Then access Prometheus via http://localhost:9090

# Grafana

Run:

    $ kubectl --namespace monitoring port-forward svc/grafana 3000

Then access Grafana via http://localhost:3000

# Altertmanager

Run:

    $ kubectl --namespace monitoring port-forward svc/alertmanager-main 9093

Then access Alertmanager via http://localhost:9093

## Uninstalling kube-prometheus

For removing kube-prometheus from your cluster, we can use TK8 addon's destroy functionality. Run:
```
$ tk8 addon destroy kube-prometheus
....
....
....
kube-prometheus destroy complete
```

## Troubleshooting

Race condition while installing the addon. This might happen sometimes if the resources on which the newly created resources are dependent were not in a Ready state. You might see an error description matching to the one below. 
```
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "Alertmanager" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "Prometheus" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "PrometheusRule" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
unable to recognize "main.yml": no matches for kind "ServiceMonitor" in version "monitoring.coreos.com/v1"
```

Note that, the error message might differ depending on the resource which caused it.

A simple resolution for this case is to rerun `tk8 addon install kube-prometheus` and this should resolve the issue.
