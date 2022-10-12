variable "bucket" {
    type=string
    default = "resumecloud13"
  
}

variable "endpoint" {
    description = "Endpoint url"
    type = string
    default = "http://resumecloud13.s3-website-us-east-1.amazonaws.com"
  
}

variable "domain_name" {
  description = "Domain name"
  type        = string
  default = "gwresume.com"
}

variable "domain" { 
  default = "gwresume.com" 
}



variable "sub_domain" {
  default = "www.gwresume.com"
  
}

variable "lambda_function_name" {
  default = "test-function"

}