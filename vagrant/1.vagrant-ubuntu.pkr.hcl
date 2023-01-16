source "vagrant" "ubuntu" {
  communicator = "ssh"
  source_path  = "generic/ubuntu2004"
  provider     = "virtualbox"
  add_force    = true
  output_dir   = "target"
}

build {
  sources = ["source.vagrant.ubuntu"]
}
