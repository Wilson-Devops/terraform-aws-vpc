resource "aws_lb_target_group" "web_tg" {

  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"

  vpc_id = aws_vpc.main.id

  health_check {

    enabled = true

    path = "/"

    port = "traffic-port"

    healthy_threshold   = 2
    unhealthy_threshold = 2

    interval = 30
    timeout  = 5

    matcher = "200"
  }

  tags = {
    Name = "web-target-group"
  }
}

# Register Web2
resource "aws_lb_target_group_attachment" "web2" {

  target_group_arn = aws_lb_target_group.web_tg.arn

  target_id = aws_instance.web2.id

  port = 80
}

# Create ALB
resource "aws_lb" "web_alb" {

  name = "devops-web-alb"

  internal = false

  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb_sg.id
  ]

  subnets = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name = "devops-web-alb"
  }
}

# Create Listener
resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.web_alb.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}