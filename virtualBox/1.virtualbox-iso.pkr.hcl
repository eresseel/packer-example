variable "host_ip" {
  type    = string
  default = "10.109.5.8"
}

source "virtualbox-iso" "ubuntu" {
  vm_name                 = "ubuntu-20.04"
  guest_os_type           = "Ubuntu_64"
  hard_drive_interface    = "sata"
  disk_size               = "20000"
  headless                = false
  http_directory          = "http"
  boot_wait               = "5s"
  output_directory        = "output"
  shutdown_command        = "echo 'vagrant'|sudo -S shutdown -P now"
  ssh_timeout             = "4h"
  ssh_password            = "vagrant"
  ssh_username            = "vagrant"
  iso_checksum            = "f11bda2f2caed8f420802b59f382c25160b114ccc665dbac9c5046e7fceaced2"
  iso_urls                = [
    "iso/ubuntu-20.04.1-legacy-server-amd64.iso", 
    "http://cdimage.ubuntu.com/ubuntu-legacy-server/releases/20.04/release/ubuntu-20.04.1-legacy-server-amd64.iso"
  ]
  boot_command            = [
    "<esc><esc><enter><wait>",
    "/install/vmlinuz noapic ",
    "preseed/url=http://${var.host_ip}:{{ .HTTPPort }}/preseed.cfg ",
    "debian-installer=en_US auto locale=en_US kbd-chooser/method=us ",
    "hostname=vagrant ",
    "fb=false debconf/frontend=noninteractive ",
    "keyboard-configuration/modelcode=SKIP keyboard-configuration/layout=USA ",
    "keyboard-configuration/variant=USA console-setup/ask_detect=false ",
    "initrd=/install/initrd.gz -- <enter>"
  ]
  vboxmanage              = [
    ["modifyvm", "{{ .Name }}", "--audio", "none"],
    ["modifyvm", "{{ .Name }}", "--usb", "off"],
    ["modifyvm", "{{ .Name }}", "--vram", "12"],
    ["modifyvm", "{{ .Name }}", "--vrde", "off"],
    ["modifyvm", "{{ .Name }}", "--nictype1", "virtio"],
    ["modifyvm", "{{ .Name }}", "--memory", "2048"],
    ["modifyvm", "{{ .Name }}", "--cpus", "1"]
  ]
}

build {
  sources = ["source.virtualbox-iso.ubuntu"]

  provisioner "shell" {
    environment_vars  = [
      "DEBIAN_FRONTEND=noninteractive", 
      "UPDATE=true"
    ]
    execute_command   = "echo 'vagrant' | {{ .Vars }} sudo -E -S bash '{{ .Path }}'"
    expect_disconnect = true
    scripts           = [
      "script/update.sh"
    ]
  }

  post-processor "vagrant" {
    keep_input_artifact  = false
    output               = "box/{{ .Provider }}/ubuntu-20.04-1.0.0.box"
    vagrantfile_template = ""
  }
}
