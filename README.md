# Test task

## 1) Terraform and Linux

Write a Terraform playbook that will deploy a simple web application in AWS/GCP/Azure or any cloud of your choose. The application must work through the Load Balancer and serve static web pages with demo content. The number of pages and structure of the site d.b. such that you can demonstrate the work of the balancer. For example, http://<ip site address>/page1.html is routed to one backend group, and /page2.html is routed to another, and so on. 

Requirements and hints:

- You can use cloud application load balancer for that task.
- Use linux VMs as backend for load balancer . You can use nginx for emulating an application. Any in backend VMs ip addresses must not require any changes of load balancer configuration.
- Linux VMs for backend must be prepared via packer. Prepared image must contain a web service .
- You must use the same image for both backends ( page1 and page2) , backends must show different content via configuring different meta-data parameters for VMs
- Use a autoscaling groups  ( or instance groups - name depends on a cloud) to provision backend VMs. Every backend must contain be at least 1 VMs  for the demo purposes - but configuration should allow to scale application to multiple AZs via 1 change in terraform configuration

Hints:

- Use minimal size VM to create a minimal configuration, stop all resources at night to save the budget.
- Use free tiers and trials to get cloud access

## 2) Helm chart

Create a helm chart  with nginx container we service that  following inputs variables

- Number nginx of replicas in pod - integer. Only values between 1 and 10 should be allowed
- Content of a web page ( which has “Hello Word” value by default) - string value. 
- Vault enabled - boolean. True or false. If enabled - a sidecar container with hashicorp vault container must be attached to nginx containers in the same pod. 

Hints:

- You don’t need any configuration of containers in the pods. Main goal is to create a helm chart
