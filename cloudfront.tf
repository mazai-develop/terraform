# resource "aws_cloudfront_distribution" "cloudfront" {
#     origin {
#         domain_name = aws_route53_zone.technonebulas.name
#         origin_id = aws_instance.ec2.id
#     }

#     enabled =  false

#     default_cache_behavior {
#         allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
#         cached_methods = [ "GET", "HEAD" ]
#         target_origin_id = aws_instance.ec2.id
        
#         forwarded_values {
#             query_string = false

#             cookies {
#               forward = "none"
#             }
#         }

#         viewer_protocol_policy = "redirect-to-https"
#         min_ttl = 0
#         default_ttl = 3600
#         max_ttl = 86400
#     }

#     restrictions {
#       geo_restriction {
#           restriction_type = "none"
#       }
#     }
#     viewer_certificate {
#         cloudfront_default_certificate = false
#         acm_certificate_arn = aws_acm_certificate.acm.arn
#         ssl_support_method = "sni-only"
#     }

#     wait_for_deployment = true
# }
