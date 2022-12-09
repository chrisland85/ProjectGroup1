# load balancer dns
output "staging_alb_dns_name" {
 value = module.webserver-staging.alb_dns_name
}