provider "google" {
  credentials = "${file("account.json")}"
  project = "${var.projectid}"
  region = "${var.region}"
}

resource "google_compute_instance" "default" {
  project      = "${var.projectid}"
  name         = "terraform"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }
}
