// This block tells Terraform that we're going to provision AWS resources.
provider "aws" {
  region = "us-east-1"
}

// Create a variable for our domain name because we'll be using it a lot.
variable "www_domain_name" {
  default = "www.mersileatti-omam.com"
}

// We'll also need the root domain (also known as zone apex or naked domain).
variable "root_domain_name" {
  default = "mersileatti-omam.com"
}

resource "aws_s3_bucket" "www" {
  // Our bucket's name is going to be the same as our site's domain name.
  bucket = "${var.www_domain_name}"
  // Because we want our site to be available on the internet, we set this so
  // anyone can read this bucket.
  acl    = "public-read"
  // We also need to create a policy that allows anyone to view the content.
  // This is basically duplicating what we did in the ACL but it's required by
  // AWS. This post: http://amzn.to/2Fa04ul explains why.
  policy = <<POLICY
{
  "Version":"2012-10-17",
  "Statement":[
    {
      "Sid":"AddPerm",
      "Effect":"Allow",
      "Principal": "*",
      "Action":["s3:GetObject"],
      "Resource":["arn:aws:s3:::${var.www_domain_name}/*"]
    }
  ]
}
POLICY

  // S3 understands what it means to host a website.
  website {
    // Here we tell S3 what to use when a request comes in to the root
    // ex. https://www.runatlantis.io
    index_document = "index.html"
    // The page to serve up if a request results in an error or a non-existing
    // page.
    error_document = "404.html"
  }
}

resource "aws_acm_certificate" "certificate" {
  // We want a wildcard cert so we can host subdomains later.
  domain_name       = "*.${var.root_domain_name}"
  validation_method = "EMAIL"

  // We also want the cert to be valid for the root domain even though we'll be
  // redirecting to the www. domain immediately.
  subject_alternative_names = ["${var.root_domain_name}"]
}