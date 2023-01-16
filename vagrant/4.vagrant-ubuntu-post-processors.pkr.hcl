variable "source_path" {
  type    = string
  default = "generic/ubuntu2004"
}

source "vagrant" "ubuntu" {
  communicator = "ssh"
  source_path  = var.source_path
  provider     = "virtualbox"
  add_force    = true
  output_dir   = "target"
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
    inline = ["echo Running ${var.source_path} Vagrant Box."]
  }

  post-processors {
    post-processor "shell-local" {
      inline = ["vagrant box add ./target/package.box --name eresseel/ubuntu2004 --provider virtualbox"]
    }
  }
}
