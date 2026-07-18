resource "aws_launch_template" "web_lt" {

  name_prefix   = "web-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"

  key_name = "devops-key"

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  user_data = base64encode(<<-EOF
#!/bin/bash

dnf update -y
dnf install httpd -y

systemctl enable httpd
systemctl start httpd

echo "<h1>Auto Scaling Web Server</h1>" > /var/www/html/index.html
EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "asg-web-server"
    }
  }
}

# Create Auto Scaling Group
resource "aws_autoscaling_group" "web_asg" {

  name = "web-asg"

  min_size         = 1
  desired_capacity = 1
  max_size         = 2

  health_check_type = "ELB"

  vpc_zone_identifier = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  target_group_arns = [
    aws_lb_target_group.web_tg.arn
  ]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "asg-web-server"
    propagate_at_launch = true
  }
}

