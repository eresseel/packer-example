source "vagrant" "ubuntu" {
  communicator = "ssh"
  source_path  = "generic/ubuntu2004"
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
    inline = ["echo This provisioner runs last"]
  }
}
