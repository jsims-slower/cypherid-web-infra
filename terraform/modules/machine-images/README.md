# Machine Images

A simple module for getting the lastest AMI IDs for the base images we build.

Read more about these images [here](/packer).

<!-- START -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| czi\_amazon1\_main\_pinned | n/a | `map(string)` | <pre>{<br>  "us-east-1": "ami-0fc5781d1d520711c",<br>  "us-east-2": "ami-0a44c06a5a8cab8e0",<br>  "us-west-1": "ami-0bf98f52cab7f2d37",<br>  "us-west-2": "ami-0aafe3dafd1634e7e"<br>}</pre> | no |
| czi\_amazon2\_ecs\_main\_pinned | n/a | `map(string)` | <pre>{<br>  "us-east-1": "ami-0633be66ac3513330",<br>  "us-east-2": "ami-07d774cc9e2eb313f",<br>  "us-west-1": "ami-04e07f1ce2e9d3d89",<br>  "us-west-2": "ami-087a41a5f3f4ead9b"<br>}</pre> | no |
| czi\_amazon2\_eks\_1\_16\_main\_pinned | n/a | `map(string)` | <pre>{<br>  "us-east-1": "ami-0c0820a8fdbe016c7",<br>  "us-east-2": "ami-03a8bac5da6aa6d3c",<br>  "us-west-1": "ami-0858fd30f8de868bd",<br>  "us-west-2": "ami-0115cdede08a9f812"<br>}</pre> | no |
| czi\_amazon\_main\_pinned | n/a | `map(string)` | <pre>{<br>  "us-east-1": "ami-0ad0e76963afe60a6",<br>  "us-east-2": "ami-059e0242bdfed18df",<br>  "us-west-1": "ami-017543474bfaceeb8",<br>  "us-west-2": "ami-040551199f0489d9e"<br>}</pre> | no |
| czi\_ubuntu16\_main\_pinned | n/a | `map(string)` | <pre>{<br>  "us-east-1": "ami-09b7a0117e7334299",<br>  "us-east-2": "ami-0478c4ec545eb8352",<br>  "us-west-1": "ami-032b97d7e8a2bf5c6",<br>  "us-west-2": "ami-0913acde05acb8c17"<br>}</pre> | no |
| czi\_ubuntu18\_deep\_learning\_main\_pinned | n/a | `map(string)` | <pre>{<br>  "us-east-1": "ami-0ea85151d89f43777",<br>  "us-east-2": "ami-0c2155cd2efb47dff",<br>  "us-west-1": "ami-007de35fa390e1398",<br>  "us-west-2": "ami-0fc3116e791be3497"<br>}</pre> | no |
| czi\_ubuntu18\_main\_pinned | n/a | `map(string)` | <pre>{<br>  "us-east-1": "ami-063d83ca61822e612",<br>  "us-east-2": "ami-0c73e054a8b3c67ed",<br>  "us-west-1": "ami-0bb8948bde2c55c78",<br>  "us-west-2": "ami-0700d9eac1644d072"<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| czi\_amazon | Stable id for a recent build. Updated explicitly to avoid unintended changes. |
| czi\_amazon1 | Stable id for a recent build. Updated explicitly to avoid unintended changes. |
| czi\_amazon1\_master\_pinned | DEPRECATED use czi\_amazon1 |
| czi\_amazon2\_ecs | Stable id for a recent build. Updated explicitly to avoid unintended changes. |
| czi\_amazon2\_ecs\_master\_pinned | DEPRECATED use czi\_amazon2\_ecs |
| czi\_amazon2\_eks | Stable id for a recent build. Updated explicitly to avoid unintended changes. |
| czi\_amazon2\_eks\_master\_pinned | DEPRECATED use czi\_amazon2\_eks |
| czi\_amazon\_master\_pinned | DEPRECATED use czi\_amazon |
| czi\_ubuntu16 | Stable id for a recent build. Updated explicitly to avoid unintended changes. |
| czi\_ubuntu16\_master\_pinned | DEPRECATED use czi\_ubuntu16 |
| czi\_ubuntu18 | Stable id for a recent build. Updated explicitly to avoid unintended changes. |
| czi\_ubuntu18\_deep\_learning | Stable id for a recent build. Updated explicitly to avoid unintended changes. |
| czi\_ubuntu18\_deep\_learning\_master\_pinned | DEPRECATED use czi\_ubuntu18\_deep\_learning |
| czi\_ubuntu18\_master\_pinned | DEPRECATED use czi\_ubuntu18 |

<!-- END -->
