# init

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 4.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_instance.web](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/resources/instance) | resource |
| [aws_internet_gateway.igw](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/resources/internet_gateway) | resource |
| [aws_route_table.pubrt](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/resources/route_table) | resource |
| [aws_route_table_association.pub-rta](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/resources/route_table_association) | resource |
| [aws_security_group.web](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/resources/security_group) | resource |
| [aws_subnet.pub](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/resources/subnet) | resource |
| [aws_vpc.vpc](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/resources/vpc) | resource |
| [aws_ami.amazonlinux2](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/data-sources/ami) | data source |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/4.10.0/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_env"></a> [env](#input\_env) | n/a | `string` | `"init2"` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | variable 사전 입력 | `string` | `"logonme"` | no |
| <a name="input_pri_subnet_cidrs"></a> [pri\_subnet\_cidrs](#input\_pri\_subnet\_cidrs) | n/a | `map` | <pre>{<br>  "1": "10.0.44.0/24",<br>  "2": "10.0.50.0/24",<br>  "3": "10.0.60.0/24"<br>}</pre> | no |
| <a name="input_pub_subnet_cidrs"></a> [pub\_subnet\_cidrs](#input\_pub\_subnet\_cidrs) | n/a | `map` | <pre>{<br>  "1": "10.0.13.0/24",<br>  "2": "10.0.23.0/24",<br>  "3": "10.0.33.0/24"<br>}</pre> | no |
| <a name="input_server_port"></a> [server\_port](#input\_server\_port) | n/a | `string` | `"80"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | n/a | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_remote_ip"></a> [remote\_ip](#output\_remote\_ip) | ------ Outputs |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
