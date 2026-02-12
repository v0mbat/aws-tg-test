variable "ami" {
  description = "AMI for ec2"
}

variable "instance_type" {
  description = "EC2 type"
}

variable "key_name" {
  description = "SSH key used for instance craetion"
  default = null
}

variable "vpc_security_group_ids" {
  description = "Security group IDS"
  type        = list(any)
}

variable "subnet_id" {
  description = "Subnets IDs"
  type = string
}

variable "ec2_env" {
  description = "Environment"
}

variable "root_block_device" {
  description = "Data for root device"
  type        = list(any)
}

variable "ebs_block_device" {
  description = "Data for root device"
  type        = list(any)
  default = []
}

variable "enable_volume_tags" {
  description = "Variable for the volume tags"
  type        = bool
}

variable "create_eip" {
  description = "Determines whether a public EIP will be created and associated with the instance."
  type        = bool
  default     = false
}

variable "name" {
  description = "Name of instance"
}
variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = true
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
  default     = { "http_tokens": "required" }
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
