resource "aws_lb" "api_ecs" {
  name               = "api-ecs-nlb-ansong"
  load_balancer_type = "network"
  internal           = false
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]

  tags = {
    Name = "ansong844-nlb"
  }
}

resource "aws_lb_listener" "api_ecs" {
  load_balancer_arn = aws_lb.api_ecs.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_ecs.arn
  }

  tags = {
    Name = "ansong844-nlb-listener"
  }
}

resource "aws_lb_target_group" "api_ecs" {
  name        = "api-ecs-ansong-tg"
  port        = 8080
  protocol    = "TCP"
  vpc_id      = aws_vpc.api_ecs.id
  target_type = "ip"

  /*health_check {
    path                = "/"
    protocol            = "TCP"
    interval            = 30
    timeout             = 6
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }*/

  tags = {
    Name = "ansong844-nlb-tg"
  }
}
