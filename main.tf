variable "name" {
  description = "name of the sagemaker endpoint"
  type        = string
}

variable "model_id" {
  description = "sagemaker model id"
  type        = string
}

variable "instance_type" {
  description = "sagemaker model endpoint instance type"
  type        = string
}

variable "environment" {
  description = "environment variables when setting up the model"
  type        = map(string)
  default     = {}
}

locals {
  envvars = { for k, v in var.environment : "TF_MODEL_${k}" => v }
}

data "aws_region" "current" {}

resource "null_resource" "main" {

  triggers = {
    id            = var.model_id
    name          = var.name
    instance_type = var.instance_type
    region        = data.aws_region.current.name
  }

  provisioner "local-exec" {
    working_dir = path.module

    environment = merge(tomap({
      TF_ACTION     = "create"
      AWS_REGION    = data.aws_region.current.name
      MODEL_ID      = var.model_id
      ENDPOINT_NAME = var.name
      INSTANCE_TYPE = var.instance_type
      }),
      local.envvars
    )

    command = ". .venv/bin/activate && python -u main.py"
  }

  provisioner "local-exec" {
    when = destroy

    working_dir = path.module

    environment = {
      TF_ACTION     = "destroy"
      AWS_REGION    = self.triggers.region
      MODEL_ID      = self.triggers.id
      ENDPOINT_NAME = self.triggers.name
      INSTANCE_TYPE = self.triggers.instance_type
    }

    command = ". .venv/bin/activate && python -u main.py"
  }
}

