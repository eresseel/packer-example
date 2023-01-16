variable "docker_image" {
  type    = string
  default = "nginx:latest"
}

variable  "docker_username" {
  type = string
  sensitive = true
}

variable "docker_password" {
  type = string
  sensitive = true
}

source "docker" "nginx" {
  image  = var.docker_image
  commit = true
  changes = [
    "WORKDIR /usr/share/nginx/html/",
    "ENV HOSTNAME www.example.com",
    "EXPOSE 80 443",
    "ENTRYPOINT [\"/docker-entrypoint.sh\"]",
    "CMD [\"nginx\", \"-g\", \"daemon off;\"]"
  ]
}

build {
  name = "nginx"
  sources = [
    "source.docker.nginx"
  ]

  provisioner "shell" {
    inline = ["apt update && apt install -qqy vim"]
  }

  provisioner "file" {
    source = "./docker-ubuntu-with-nginx/"
    destination = "/usr/share/nginx/html/"
  }

  post-processors {
    post-processor "docker-tag" {
      repository = "eresseel/nginx"
      tags       = ["latest", "1.22.3"]
      only       = ["docker.nginx"]
    }

    post-processor "docker-push" {
      login=true
      login_server="https://index.docker.io/v1/"
      login_username = var.docker_username
      login_password = var.docker_password
    }

    post-processor "shell-local" {
      inline = ["docker system prune -af"]
    }
  }
}
