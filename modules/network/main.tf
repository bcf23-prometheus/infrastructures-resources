# import modules

module "config" {
  source = "../config"
}

# Create the bcf23-surokkha VPC network
resource "google_compute_network" "bcf23-surokkha" {
  name                    = "bcf23-surokkha"
  auto_create_subnetworks = false
}

# Create the surokkha subnet in the bcf23-surokkha VPC network
resource "google_compute_subnetwork" "surokkha" {
  name          = "surokkha"
  ip_cidr_range = "10.240.0.0/24"
  network       = google_compute_network.bcf23-surokkha.name
}

# Create a firewall rule that allows internal communication across all protocols
resource "google_compute_firewall" "bcf23-surokkha-allow-internal" {
  name    = "bcf23-surokkha-allow-internal"
  project = module.config.project_id
  network = google_compute_network.bcf23-surokkha.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }
  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }
  source_ranges = [
    module.config.subnet_ip_cidr_range.node,
    module.config.subnet_ip_cidr_range.controller,
    module.config.subnet_ip_cidr_range.worker
  ]
}

# Create a firewall rule that allows external SSH, ICMP, and HTTPS
resource "google_compute_firewall" "bcf23-surokkha-allow-external" {
  name    = "bcf23-surokkha-allow-external"
  network = google_compute_network.bcf23-surokkha.name
  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22", "2377", "8000-8999"]
  }
  source_ranges = [
    # allow from any range for external access
    "0.0.0.0/0"
  ]
}
