variable "cloud_token" {
  type    = string
  default = "${env("VAGRANT_CLOUD_TOKEN")}"
}

variable "source_path" {
  type    = string
  default = "generic/ubuntu2004"
}

variable "box_name" {
  type    = string
  default = "eresseel/ubuntu2004"
}

variable "box_version" {
  type    = string
  default = "1.0.0"
}

variable "output_dir" {
  type    = string
  default = "target"
}

source "vagrant" "ubuntu" {
  communicator = "ssh"
  source_path  = var.source_path
  provider     = "virtualbox"
  add_force    = true
  output_dir   = var.output_dir
  box_name     = var.box_name
  box_version  = var.box_version
  add_clean    = true
  skip_package = false
  skip_add     = false
}

build {
  name = "learn-packer"
  sources = [
    "source.vagrant.ubuntu"
  ]

  provisioner "shell" {
    environment_vars = [
      "FOO=hello world",
    ]
    inline = [
      "echo Adding file to Vagrant Box",
      "echo \"FOO is $FOO\" > example.txt",
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y nginx"
    ]
  }

  post-processors {
    post-processor "vagrant-cloud" {
      access_token = "${var.cloud_token}"
      box_tag      = var.box_name
      version      = var.box_version
    }

    post-processor "shell-local" {
      inline = [
        "vagrant box add ./${var.output_dir}/package.box --name ${var.box_name} --provider virtualbox",
        "rm -rf ${var.output_dir}/"
        ]
    }
  }
}
