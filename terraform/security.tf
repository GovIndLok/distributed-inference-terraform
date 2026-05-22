# TS worker security group
resource "aws_security_group" "ts_sg" {
  name   = "ts_worker_sg"
  vpc_id = aws_vpc.di_vpc.id

  ingress {
    description = "HTTP API"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound for worker mesh"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    project = "di_assignment"
    name    = "ts-worker-sg"
  }
}

# PY worker security group 
resource "aws_security_group" "py_sg" {
  name   = "py_worker_sg"
  vpc_id = aws_vpc.di_vpc.id

  ingress {
    description     = "Allow TS worker via worker mesh"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.ts_sg.id]
  }

  egress {
    description = "Allow outbound internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    project = "di_assignment"
    name    = "ts-worker-sg"
  }
}
