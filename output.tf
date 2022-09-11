data "aws_region" "current" {}

output "region" {
  value = data.aws_region.current

}
# #"arn:aws:logs:ap-southeast-1:234949410202:log-group:/aws/lambda/demoupload:*"
# # output "aws_vpc" {
# #   value = aws_vpc.vpc.id
# # }
# # output "aws_key_pair" {
# #   value = aws_key_pair.master.id
# # }
# # output "aws_ami" {
# #   value = aws_instance.apache1.id
# }
# # # }
# # output "aws_instance"{
# #   value = aws_instance.public_ip.id
# # }
