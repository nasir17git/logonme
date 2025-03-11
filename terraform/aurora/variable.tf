locals {
    name="rds-replication"
    vpc_id="aa"
    ec2_key_name="nasirk17"
    rds_master_user="admin"
    rds_master_pwd="admin1!"
    rds_db_name="testdb"
    user_data="aa"
    tags = {
        Terraform = "true"
        Environment = "dev"
    }
}

