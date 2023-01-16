# packer-example

## Packer installation
https://developer.hashicorp.com/packer/downloads

## Run command

### Initialize Packer configuration
```bash
packer init .
```

### Format and validate your Packer template

```bash
packer fmt .
packer validate .
```

### Build Packer image
```bash
packer build docker-ubuntu.pkr.hcl
packer build -var "docker_username=*****" -var "docker_password=*****" docker-ubuntu-with-nginx.pkr.hcl
```

### Setting Authenticate to AWS
```bash
export AWS_ACCESS_KEY_ID="<YOUR_AWS_ACCESS_KEY_ID>"
export AWS_SECRET_ACCESS_KEY="<YOUR_AWS_SECRET_ACCESS_KEY>"
```

### Build image with variable file
```bash
packer build --var-file=3.aws-ubuntu-with-variables.pkrvars.hcl
```

### Regarding output directory and new box
```bash
mkdir output2
cp package.box ./output2
vagrant box add new-box name-of-the-packer-box.box
vagrant init new-box
vagrant up
```