resource "aws_security_group" "alb" {
  name        = "alb_security_group"
  vpc_id      = "${aws_vpc.tns_vpc.id}"

  # セキュリティグループ内のリソースからインターネットへのアクセスを許可する
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tns-alb"
  }
}

# SecurityGroup Rule
# https://www.terraform.io/docs/providers/aws/r/security_group.html
resource "aws_security_group_rule" "alb_http" {
  security_group_id = "${aws_security_group.alb.id}"

  # セキュリティグループ内のリソースへインターネットからのアクセスを許可する
  type = "ingress"

  from_port = 80
  to_port   = 80
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_https" {
  security_group_id = "${aws_security_group.alb.id}"

  type = "ingress"

  from_port = 443
  to_port   = 443
  protocol  = "tcp"

  cidr_blocks = ["0.0.0.0/0"]
}

# ALB
# https://www.terraform.io/docs/providers/aws/d/lb.html
resource "aws_lb" "main" {
  load_balancer_type = "application"
  name               = "tns"

  security_groups = ["${aws_security_group.alb.id}"]
  subnets         = ["${aws_subnet.public_1a.id}","${aws_subnet.public_1c.id}"]
}

resource "aws_lb_listener" "main" {
  # HTTPでのアクセスを受け付ける
  port              = "80"
  protocol          = "HTTP"

  # ALBのarnを指定します。
  #XXX: arnはAmazon Resource Names の略で、その名の通りリソースを特定するための一意な名前(id)です。
  load_balancer_arn = "${aws_lb.main.arn}"

  # "ok" という固定レスポンスを設定する
  default_action {
    type             = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "ok"
    }
  }
}

# ELB Target Group
# https://www.terraform.io/docs/providers/aws/r/lb_target_group.html
resource "aws_lb_target_group" "main" {
  name = "tns"

  # ターゲットグループを作成するVPC
  vpc_id = "${aws_vpc.tns_vpc.id}"

  # ALBからEC2へトラフィックを振り分ける設定
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"

#   # コンテナへの死活監視設定
#   health_check = {
#     port = 80
#     path = "/"
#   }
}

# ALB Listener Rule
# https://www.terraform.io/docs/providers/aws/r/lb_listener_rule.html
resource "aws_lb_listener_rule" "main" {
  # ルールを追加するリスナー
  listener_arn = "${aws_lb_listener.main.arn}"

  # 受け取ったトラフィックをターゲットグループへ受け渡す
  action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main.id}"
  }

  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
        values = ["/*"]
    }
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = "${aws_lb.main.arn}"

  certificate_arn = "${aws_acm_certificate_validation.acm_validation.certificate_arn}"

  port     = "443"
  protocol = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.main.id}"
  }
}

resource "aws_lb_listener_rule" "http_to_https" {
  listener_arn = "${aws_lb_listener.main.arn}"

  priority = 99

  action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  condition {
    host_header {
        values = ["${aws_route53_zone.app_technonebulas.name}"]
    }
  }
}
