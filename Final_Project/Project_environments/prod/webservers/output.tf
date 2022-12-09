# load balancer dns
output "alb_dns_name" {
 value = module.webserver-prod.alb_dns_name
}