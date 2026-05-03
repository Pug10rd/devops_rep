variable "cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "region" {
  type = string
  default = "us-west-2"
}