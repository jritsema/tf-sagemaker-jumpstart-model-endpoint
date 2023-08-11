# tf-sagemaker-jumpstart-model-endpoint

A Terraform module for provisioning AWS Sagemaker Jumpstart model endpoints

Note:  This is a hacky wrapper around the [sagemaker jumpstart python sdk](https://github.com/aws/sagemaker-python-sdk/).


## Usage

Reference module
```hcl
module "falcon-7b" {
  source = "github.com/jritsema/tf-sagemaker-jumpstart-model-endpoint"

  name          = "falcon-7b-demo"
  model_id      = "huggingface-llm-falcon-7b-instruct-bf16"
  instance_type = "ml.g5.8xlarge"

  environment = {
    MAX_INPUT_LENGTH = "2048"
    MAX_TOTAL_TOKENS = "4096"
  }
}
```

```
terraform init
```

One time initialization to setup python environment using venv and install deps
```
cd .terraform/modules/falcon-7b
make init && make install
```

Now you can use normally
```
terraform apply
...
terraform destroy
```
