output "ts_worker_public_ip" {
  description = "Public IP of the TypeScript (API) worker"
  value       = aws_instance.ts_worker.public_ip
}

output "ts_worker_private_ip" {
  description = "Private IP of the TypeScript (API) worker"
  value       = aws_instance.ts_worker.private_ip
}

output "py_worker_private_ip" {
  description = "Private IP of the Python (inference) worker"
  value       = aws_instance.py_worker.private_ip
}

output "api_url" {
  description = "HTTP endpoint for the inference API"
  value       = "http://${aws_instance.ts_worker.public_ip}:3111/v1/chat/completions"
}
