
#### Docker Section #######

##Build the Dockerfile with the following:

##Now build the actual Docker Image (needed amd64 flag as I have an M1 chip so mine uses arm64 locally):
docker buildx build --platform linux/amd64 -t bitcoin:22.0 . --load


##Run the Docker Image with:

docker run bitcoin:22.0



#### K8s Section #######

##I did this in AWS EKS pulling images I pushed to AWS ECR. I also used secrets manager as well for secrets for more security

##Deploy the yamls
kubectl apply -f namespace.yaml
kubectl apply -f deployment.yaml
kubectl apply -f configmap.yaml
kubectl apply -f aws_secrets.yaml
kubectl apply -f networkpolicy.yaml


##Port Forwarding for access
kubectl port-forward pod/<name_of_pod> -n bitcoin-namespace 8332:8332

##Get output using bitcoin-cli
bitcoin-cli -rpcconnect=127.0.0.1 -rpcport=8332 -rpcuser=bitcoinrpc -rpcpassword=Passw0rd! getblockchaininfo



#### CI-CD Section


##Pretty self explanatory looking at the .github/workflows/ci-cd.yml


#### Scripts Section #####

##Located inside the scripts/ directory. There is a access.log file, a Bash script, and a Python script in there.




#### Terraform Section ####

##There is a singular iam.tf file. It will create all 6 resources and has toggleable suffixes that can be turned on by setting true or false



#### Nomad Section #####


## There is a file named bitcoin-core.nomad. Once you run it with:

nomad job run bitcoin-core.nomad

##Once that is run, there is no -printtoconsole as in docker so in order to see the output, look at:

nomad alloc logs <allocation-id>



