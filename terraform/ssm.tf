# Store HF_TOKEN securely in SSM
resource "aws_ssm_parameter" "hf_token" {
  name        = "/di/hf_token"
  description = "Hugging Face API token for model downloads"
  type        = "SecureString"
  value       = var.HF_TOKEN

  tags = {
    project = "di_assignment"
    name    = "hf-token"
  }
}