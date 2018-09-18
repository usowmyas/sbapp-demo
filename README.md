# Dev SetUp

## Git cmds to clone and make changes

* git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/sbapp-demo ( Enter credentials when prompted )
* Navigate to sbapp-demo
* Execute `git init`
* Execute `git status`
* Change / Add a file 
* Execute `git status` , you should see your changes
* Execute `git add .`
* Execute `git commit -m "NewFile\ChangeFile"`
* Execute `git push -u origin master`

## Prerequisites

* Install Docker
* Install Docker Compose 
* Install HTTPie - <https://httpie.org/>
* Install terraform - <https://www.terraform.io/>

### Build the spring boot Docker images

* **On Linux** 
* Execute `./build-docker-images.sh`


* **On Windows**
* cd to ./docker-images/sbapp-demo
* Execute `./gradlew.bat clean bootRepackage buildDockerImage`

This will build the following images:

* **sbapp-demo**: Spring Boot app 

## 1: Prometheus without using docker 

* Start Prometheus via commandline ./prometheus and check if its running
* Prometheus
  * Navigate to <http://localhost:9090/metrics]> > check metrics that Prometheus itself is generating
  * Navigate to <http://localhost:9090> > check prometheus webinterface
  * Check Config file (prometheus.yml) -> check Targets
  * Explain that scraping can be done by various ways (Consul, DNS, or dropping in new config file)

## 2: Prometheus using Docker

* Start Prometheus using docker-compose up
* Check docker-compose.yml > including portmapping

## 3: Consul using Docker

* Start Prometheus using docker-compose up
* Prometheus
  * Check prometheus.yml > explain consul config
  * Navigate to  http://localhost:9090
  * Check targets and see that we are missing the services
* Consul
  * Navigate to http://localhost:8500
  * Check missing services
  * Register the services using ‘register-services-with-consul.sh`
  * Check the services appearing in Consul
* Prometheus
  * Navigate to  http://localhost:9090
  * Check targets and see that the services have appeared

## 10: Terraform 
* Execute terraform init
* Execute terraform plan --var-file=".\dev.tfvars" -out dev.tfplan 
* Execute terraform apply
---

# Links

* [Prometheus webinterface][prometheus-ui]
* [Prometheus metrics][prometheus-metrics]
* [SpringBoot Demo App * metrics][springboot metrics]
* [SpringBoot Demo App * helloworld][springboot helloworld]

[prometheus-ui]: http://localhost:9090
[prometheus-metrics]: http://localhost:9090/metrics
[springboot metrics]: http://localhost:8080/metrics
[springboot helloworld]: http://localhost:8080/helloworld

References:
https://github.com/stefanprodan/dockprom
