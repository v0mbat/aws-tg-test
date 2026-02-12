variable "ami" {
  description = "AMI for ec2"
}

variable "instance_type" {
  description = "EC2 type"
}

variable "key_name" {
  description = "SSH key used for instance craetion"
}

variable "vpc_security_group_ids" {
  description = "Security group IDS"
  type        = list(any)
}

variable "subnet_id" {
  description = "Subnets IDs"
  default     = ""
}

variable "subnet_ids" {
  description = "List of subnet IDs where instances will be launched."
  type        = list(string)
  default     = []
}

variable "ec2_env" {
  description = "Environment"
}

variable "root_block_device" {
  description = "Data for root device"
  type        = list(any)
}

variable "enable_volume_tags" {
  description = "Variable for the volume tags"
  type        = bool
}

variable "name" {
  description = "Name of instance"
}

variable "domain" {
  description = "Name of domain"
}

variable "number" {
  description = "Number of instances by list"
  type = list(string)
  default =  []
}

variable "role" {
  description = "Role of instance"
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type = string
  default = null
}

variable "metadata_options" {
  description = "Customize the metadata options of the instance"
  type        = map(string)
  default     = { "http_endpoint": "enabled", "http_put_response_hop_limit": 1, "http_tokens": "required" }
}

variable "ignore_ami_changes" {
  description = "Whether changes to the AMI ID changes should be ignored by Terraform. Note - changing this value will result in the replacement of the instance"
  type = bool
  default = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
