# load balancer dns
output "alb_dns_name" {
 value = module.webserver-staging.alb_dns_name
}