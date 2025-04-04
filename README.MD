# Advanced K8SLab
The primary objective of this project is to establish a Kubernetes cluster within the AWS environment. The implementation will involve deploying the "cloud-provider-aws". The AWS cloud provider provides the interface between a Kubernetes cluster and AWS service APIs.

## Prerequisite
You should have AWS account created. Install and configure the AWS CLI. OpenToFu and Ansible are also necessary.

## How to create Advanced K8Slab
Clone the repository 

```
git clone https://github.com/mgospodinov-mg/AdvancedK8SLab.git
```

### Run OpenTofu 

By default the aws region is "us-west-2", the instance type is "t2.medium" and the number of worker nodes is "1". Of course you may change them when you run the tofu command.

```
tofu plan
tofu apply
```
If you want to modify the variables

```
tofu apply -var="aws_region="us-east-1" -var="instance_type=t2.large" -var="number_workers=2"
```

OpenTofu will generate an SSH key for accessing EC2 instances; this key will be located in the sshkeys directory.

### Run Ansible

The Ansible inventory file is automatically populated with the correct IP addresses. No need to change anything else.
Navigate to the ansible directory "<path>/ansible_advk8slab" and execute the command below. 

```
ansible-playbook -i inventory.ini advk8s-playbook.yaml -v
```

By default the playbook will install Kubernetes 1.30.1

To install a different Kubernetes version, modify the variables.