data "aws_ami" "ubunutu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# TS worker Instance 
resource "aws_instance" "ts_worker" {
  ami           = data.aws_ami.ubunutu.id
  instance_type = "t3.micro"

  subnet_id              = aws_subnet.public_sn.id
  vpc_security_group_ids = [aws_security_group.ts_sg.id]

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = templatefile(
    "${path.Module}/user_data/ts_worker.sh",
    {
      py_private_ip = aws_instance.py_worker.py_private_ip
    }
  )

  tags = {
    project = "di_assignment"
    name    = "ts_worker"
  }

  depends_on = [aws_instance.py_worker]
}

# PY worker Instance 
resource "aws_instance" "py_worker" {
  ami           = data.aws_ami.ubunutu
  instance_type = "t3.medium"

  subnet_id              = aws_subnet.private_sn.id
  vpc_security_group_ids = [aws_security_group.py_sg.id]

  associate_public_ip_address = false

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  user_data = file("${path.module}/user_data/py_worker.sh")

  tags = {
    project = "di_assignment"
    name    = "py_worker"
  }
}
