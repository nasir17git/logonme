variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  type = map(any)
  default = {
    pub1 = "10.0.10.0/24"
    pub2 = "10.0.20.0/24"
    pub3 = "10.0.30.0/24"
    pri1 = "10.0.40.0/24"
    pri2 = "10.0.50.0/24"
    pri3 = "10.0.60.0/24"
  }
}