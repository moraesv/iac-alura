terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }
}

provider "google" {
  project = "supple-hangout-448400-m2"
  region  = "us-central1"
  zone    = "us-central1-c"
}

resource "google_service_account" "app_server_sa" {
  account_id   = var.ssh_user
  display_name = var.ssh_user
}

resource "google_compute_instance" "app_server" {
  name         = "iac-alura"
  machine_type = var.machine_type
  zone         = var.zone


  tags = ["http-server"]

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/debian-12-bookworm-v20250113"
      labels = {
        my_label = "iac-alura-disk"
      }
    }
  }

  network_interface {
    network = "default"

    access_config {
      network_tier = "PREMIUM"
    }
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.ssh_pub_key_file)}"
  }

  # metadata_startup_script = "sudo apt-get -y install apache2 php7.0 | echo '<!doctype html><html><body><h1>Hello World!</h1></body></html>' | sudo tee /var/www/html/index.html"

  service_account {
    email  = google_service_account.app_server_sa.email
    scopes = ["cloud-platform"]
  }
}

resource "google_compute_firewall" "app_server_firewall" {
  name    = "app-server-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "8000"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags = ["http-server"]
}


output "PUBLIC_IPS" {
  value = "${join(" ", google_compute_instance.app_server.*.network_interface.0.access_config.0.nat_ip)}"
  description = "The public IP address of the newly created instance"
}