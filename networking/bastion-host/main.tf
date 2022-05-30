resource "aws_eip" "bastion_host" {
  vpc = true

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.this.id]
  subnet_id                   = var.subnets[0]
  associate_public_ip_address = false
  user_data = base64encode(
    templatefile(
      "${path.module}/templates/userdata.sh.tpl",
      {
        ssh_public_keys = join(",", var.ssh_public_keys),
        username        = "ubuntu",
      }
    )
  )

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
  }

  lifecycle {
    ignore_changes = [ami, associate_public_ip_address]
  }

  tags = merge({ "Environment" = var.environment }, { "Terraform" = "true" }, var.tags)
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.bastion.id
  allocation_id = aws_eip.bastion_host.id
}


# TODO - add autoscaling group -> 1
