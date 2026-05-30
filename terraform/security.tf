# TS worker security group
resource "aws_security_group" "ts_sg" {
  name   = "ts_worker_sg"
  vpc_id = aws_vpc.di_vpc.id

  ingress {
    description = "HTTP API"
    from_port   = 3111
    to_port     = 3111
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # iii engine port (internal only, for Python worker to connect)
  ingress {
    from_port   = 49134
    to_port     = 49134
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]  
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
    from_port       = 49134
    to_port         = 49134
    protocol        = "tcp"
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
