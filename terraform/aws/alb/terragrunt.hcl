include "root" {
  path    = find_in_parent_folders()
  expose  = true
}

terraform {
  source = "git@github.com:terraform-aws-modules/terraform-aws-alb.git/?ref=v8.6.0"
}

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/..//vpc"
}

# Security Groups ############################################
dependency "internet-to-pub-http" {
  config_path = "${get_terragrunt_dir()}/..//sg/internet-to-pub-http"
}

dependency "egress-to-anywhere" {
  config_path = "${get_terragrunt_dir()}/..//sg/egress-to-anywhere"
}
#################################################################

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("environment.hcl"))
}

inputs = {
  name                = "example-alb"
  load_balancer_type  = "application"
  vpc_id              = dependency.vpc.outputs.vpc_id
  subnets             = dependency.vpc.outputs.public_subnets

  security_groups     = [
    dependency.internet-to-pub-http.outputs.security_group_id,
    dependency.egress-to-anywhere.outputs.security_group_id
  ]

  target_groups = [
    {
      name              = "backend-1"
      name_prefix       = "backend-1-"
      backend_protocol  = "HTTP"
      backend_port      = 80
      target_type       = "instance"
      health_check = {
        enabled             = true
        interval            = 5
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 4
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },
    {
      name              = "backend-2"
      name_prefix       = "backend-2-"
      backend_protocol  = "HTTP"
      backend_port      = 80
      target_type       = "instance"
      health_check = {
        enabled             = true
        interval            = 5
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 4
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  http_tcp_listener_rules = [
    {
      http_tcp_listener_index = 0
      priority                = 3
      actions = [{
        type          = "fixed-response"
        content_type  = "text/plain"
        message_body  = "OK"
        status_code   = "200"
      }]

      conditions = [{
        path_patterns = ["/status"]
      }]
    },
    {
      http_tcp_listener_index = 0
      priority                = 2
      target_group_index      = 0

      conditions = [{
        path_patterns = ["/page1.html"]
      }]
    },
    {
      http_tcp_listener_index = 0
      priority                = 1
      target_group_index      = 1

      conditions = [{
        path_patterns = ["/page2.html"]
      }]
    }
  ]
}
