## Exposing Spring Boot Application with Kubernetes Ingress

Ingress: It let the external access to the services inside the Kubernetes cluster.
Service: It is the endpoint by which external access is given to the application. Without a service, only pods can communicate in the cluster.

You can expose your application in various ways, NodePort and LoadBalancer are the most common ways by which you can expose while Ingress is the another way of exposing the pods where you expose multiple services using the same DNS by configuring the paths so that individual service can be accessed using individual paths. 

Clone the below project.

```
https://github.com/clonerohit/spring-boot-docker-compose.git
```

After pulling the repository. You will see in the application.properties that there are no database configurations being hardcoded which means if you want to change something then you have to do it in the deployments files and thus everything becomes loosely coupled and easy to replace.

Go to the src/main/resources/deployments and change:

1. Root password of MySQL in mysqldb-root-credentials.yml (only if you have a different password, in my case, it is root)

Note: In the config maps and secrets, you have to write the sensitive data in base 64 formats instead of the plain text and if you don't how to do that then simply open up the terminal and hit the below command:

```
echo -n {plaintext} | base 64
```

It will give you the plaintext in base 64 formats which you can add inside the config maps and secrets

2. Also change the database username and password in mysqldb-credentials.yml files (in my case, it is root and root, you can keep the same credentials)

3. Now go to mysql-configmap.yml file and replace the host(docker image name) and name(database name)

4. Go to the ingress-deployment.yml and replace the host to whatever you want. It can be anything you would like to name your application. It's only limited to your local environment.

That's it. Now let's run the application.

To run the application, you need to perform certain steps:

1. Generate the jar file in the target directory with the mvn clean install command
2. Build the docker image using the Dockerfile with the below command:

```
docker build -t {enter-your-dockerhub-username}/spring-boot-app:1.0 .
```

3. Push the same image which you have generated on the Docker Hub using below command:

```
docker push {enter-your-dockerhub-username}/spring-boot-app:1.0
```

Note: It will ask for the username and password of your Docker Hub account.

4. Enable docker local environment for the Minikube using the below command so that it won't download the image again and will take the image available on the local system.

```
eval $(minikube docker-env)
```

That's it, now all you have to do is apply the deployments one by one and your app will start.

Go to the directory where all the deployments files are present and hit the below command one by one.

```
kubectl apply -f mysql-configmap.yml
kubectl apply -f mysqldb-root-credentials.yml
kubectl apply -f mysqldb-credentials.yml
kubectl apply -f mysql-deployment.yml
kubectl apply -f deployment.yaml
```

After applying all the above commands successfully, you will see that new pods and services have been created. You can check them using.

```
kubectl get pods
kubectl get services
kubectl get deployments
kubectl get configmaps
kubectl get secrets
```

Now it's time to access the application. Hit the below command.

```
minikube service {service-name} --url
```

Eg: minikube service spring-boot-app --url

It will give you the access URL, open this URL in the browser and you will see your application is up!!!

But we're supposed to enable ingress in your application, right? Let's expose the service using the DNS. But before that, you have to enable the ingress add on in the minikube which is disabled by default. 

To enable:

```
minikube addons enable ingress
```

Now go and see the ingress-deployment.yml for a while. Here remember the host you have defined, you have to add this host in your /etc/hosts files along with IP address. Which IP?

To get the external IP address on which your service is currently being exposed. Hit the below command to get the IP or you can see it using the services list too.

```
minikube ip
```

This will give you the IP address and add this IP and DNS name in the hosts files in this way.

```
19X.XXX.43.2   spring-boot.com
```

Now, go to the browser and type in this DNS name and your app will run successfully.
