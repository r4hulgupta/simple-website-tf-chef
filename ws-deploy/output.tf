
# Load Balancer IP
output "home_page_url" {
  value = "https://${module.lb-https.external_ip}/root/home/index.html"
  description = "URL to the home page of the website"
}
