terraform {
    required_version = ">= 1.0"
    backend "local" {}
    required_providers {
        google = {
        source  = "hashicorp/google"
        }
    }
}

provider "google" {
    project = var.project
    region = var.region
}

resource "google_storage_bucket" "data-lake" {
    name = "${var.project}-data-lake"
    location = var.region

    versioning {
        enabled = true
    }

    lifecycle_rule {
        action {
            type = "Delete"
        }
        condition {
            age = 30
        }
    }

    force_destroy = true
}

resource "google_bigquery_dataset" "data-warehouse" {
    project = var.project
    location = var.region
    dataset_id  = "${var.project}-data-warehouse"
}