variable "aws_region" {
    description = "The region in AWS"
    default = "us-west-2"
}

variable "instance_type" {
    description = "AWS instance type"
    default = "t2.medium"
}

variable "number_workers" {
    description = "Number of worker nodes"
    type = number
    default = 1

    validation {
      condition = var.number_workers > 0 && var.number_workers < 3
      error_message = "The worker node count should be either one or two."
    }
}