import os
import boto3
from sagemaker.jumpstart.model import JumpStartModel


def main():
    action = os.environ["TF_ACTION"]
    model_id = os.environ["MODEL_ID"]
    endpoint_name = os.environ["ENDPOINT_NAME"]
    size = os.getenv("INSTANCE_TYPE")

    if action == "create":
        print(f"creating model endpoint {model_id} {size}...")
        model = JumpStartModel(
            name=endpoint_name,
            model_id=model_id,
            instance_type=size)

        # pass envvars that start with "TF_MODEL_" to the model
        for key, val in os.environ.items():
            if key.startswith("TF_MODEL_"):
                k = key[9:]
                model.env[k] = val

        model.deploy(endpoint_name=endpoint_name)


    if action == "destroy":
        print(f"deleting model endpoint {endpoint_name}...")
        client = boto3.client("sagemaker")
        client.delete_endpoint(EndpointName=endpoint_name)
        client.delete_endpoint_config(EndpointConfigName=endpoint_name)
        client.delete_model(ModelName=endpoint_name)


if __name__ == "__main__":
    main()
