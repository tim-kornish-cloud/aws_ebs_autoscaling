# Author: Timothy Kornish
# CreatedDate: 9/08/2025
# Description: set up variables for aws resources

variable "environment" {
  description = "Name of environment (debug/production)"
  type        = string
  default     = "debug"
  # default     = "production"
}
variable "owner" {
  description = "Project owner/runner"
  type        = string
  # Change this to your identifier
  default = "tkornish"
}

variable "min_size" {
  description = "minumum number of nodes allowed by load balancer, do not set number of nodes to 0 ever"
  type    = number
  default = 1
}
variable "max_size" {
  description = "maximum number of nodes allowed by load balancer, never go above 10 to avoid runnaway cost build up"
  type    = number
  default = 10
}
variable "desired_size" {
  description = "attempt to always have as few nodes as possible to save money"
  type    = number
  default = 1
}

variable "docker_img_tar_file" {
  description = "docker image tar file"
  type        = string
  default     = "docker_image.tar"
}
variable "docker_img_tag" {
  description = "Tag used for the docker image"
  type        = string
  default     = "my-site"
}

#need to update ami value when changing regions: 
variable "ami_al2_ecs" {
  description = "Amazon Linux 2 with ECS. Latest as of 2022-02-11"
  type        = string
  default     = "ami-00ca32bbc84273381" # value set based on region: us-east-1
}