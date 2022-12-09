# load balancer dns
output "prod_alb_dns_name" {
 value = module.webserver-prod.alb_dns_name
}