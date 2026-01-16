output "env_seqtoid_org_zone_id" {
  value = aws_route53_zone.env-seqtoid-org.zone_id
}

output "env_seqtoid_org_name_servers" {
  value = aws_route53_zone.env-seqtoid-org.name_servers
}
