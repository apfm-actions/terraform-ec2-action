output "ec2" {
    value = {
        arn = aws_elasticsearch_domain.es_domain.arn
    } 
}