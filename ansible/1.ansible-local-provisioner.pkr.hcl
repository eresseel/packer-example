variable "topping" {
  type    = string
  default = "mushroom"
}

source "docker" "ansible" {
  image       = "eresseel/ansible:6.3.0"
  export_path = "packer_ansible"
  run_command = ["-d", "-i", "-t", "--entrypoint=/bin/sh", "{{.Image}}"]
}

build {
  sources = [
    "source.docker.ansible"
  ]

  provisioner "ansible-local" {
    playbook_file   = "./playbook.yml"
    extra_arguments = ["--extra-vars", "\"pizza_toppings=${var.topping}\""]
  }

  post-processors {
    post-processor "docker-import" {
      repository = "eresseel/test"
      tag        = "1.0.0"
    }
  }
}
