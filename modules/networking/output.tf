output "region" {
    value = var.region_name
}

output "project_name" {
    value = var.project_name
}

output "vpc_id" {
    value = aws_vpc.eks_vpc.id
}

output "igw_id" {
    value = aws_internet_gateway.eks_igw.id
}

output "pubsn_web_az1_id" {
    value = aws_subnet.pubsn_web_az1.id
}

output "pubsn_web_az2_id" {
    value = aws_subnet.pubsn_web_az2.id
}

output "privsn_app_az1_id" {
    value = aws_subnet.privsn_app_az1.id
}

output "privsn_app_az2_id" {
    value = aws_subnet.privsn_app_az2.id
}

output "privsn_db_az1_id" {
    value = aws_subnet.privsn_db_az1.id
}

output "privsn_db_az2_id" {
    value = aws_subnet.privsn_db_az2.id
}

output "pubrt_web_id" {
    value = aws_route_table.privrt_az1.id
}

output "privrt_az1_id" {
    value = aws_route_table.privrt_az1.id
}

output "privrt_az2_id" {
    value = aws_route_table.privrt_az2.id
}

output "eip_az1_id" {
    value = aws_eip.eip_az1.id
}

output "nat_gw_az1_id" {
    value = aws_nat_gateway.nat_gw_az1.id
}

output "nat_gw_az2_id" {
    value = aws_nat_gateway.nat_gw_az2.id
}


