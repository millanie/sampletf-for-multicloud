### env
provider "google" {
  credentials = "${file("account.json")}"
  project = "${var.projectid}"
  region = "${var.region}"
}

### network
resource "google_compute_network" "demo" {
  name = "${var.prefix}"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "demo" {
  name          = "${var.prefix}"
  ip_cidr_range = "${var.pub_sub_cidr}"
  network = "${google_compute_network.demo.name}"
  region = "${var.region}"
}

resource "google_compute_firewall" "demo-web" {
  name = "${var.prefix}-firewall"
  network = "${google_compute_network.demo.name}"

  allow {
    protocol = "tcp"
    ports    = "${var.tcp_port_list}" 
  }

  source_ranges = ["${var.jumpbox_ip}"]
  target_tags = ["${var.prefix}-web"]

}

### gce
resource "google_compute_instance" "demo" {
  project      = "${var.projectid}"
  name         = "${var.prefix}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "${google_compute_network.demo.name}"
    subnetwork = "${google_compute_subnetwork.demo.name}"
    access_config {
    }
  }

  tags = ["${var.prefix}-web"]
}

