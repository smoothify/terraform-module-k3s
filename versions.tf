terraform {
  required_providers {
    http = {
      source  = "hashicorp/http"
      version = "~> 1.2"
    }
    null = {
      source  = "hashicorp/null"
      version = "> 2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "> 2.1"
    }
  }
  required_version = ">= 0.13"
}
