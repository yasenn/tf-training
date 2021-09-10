provider "template" {
  version = "2.2.0"
}

provider "time" {
  version = "0.7.2"
}

data "aws_ami" "latest_ubuntu" {
  owners = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

data "template_file" "userdata" {
  template = file("userdata.sh")

  vars = {
    dns_efs = aws_efs_file_system.EFS.dns_name
    domain = aws_elb.web.dns_name
    db_port = aws_db_instance.mysql.port
    db_host = aws_db_instance.mysql.address
    db_username = var.db_username
    db_password = var.db_password
    db_name = var.db_name
    wp_username = var.wp_username
    wp_password = var.wp_password
    wp_email = var.wp_email
  }
}

resource "time_sleep" "dns_resolving_timeout_90s" {
  depends_on = [aws_efs_file_system.EFS]
  create_duration = "90s"
}

resource "time_sleep" "wait_for_WP_installing_30s" {
  depends_on = [aws_autoscaling_group.web]
  create_duration = "30s"
}

resource "aws_elb" "web" {
  name = "WebServer"
  subnets = [aws_subnet.a_public.id, aws_subnet.b_public.id]
  security_groups = [aws_security_group.LoadBalancer.id]
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  health_check {
    healthy_threshold = 2
    interval = 10
    target = "HTTP:80/"
    timeout = 3
    unhealthy_threshold = 2
  }
  tags = {
    Name = "Load Balancer"
  }
}

resource "aws_db_instance" "mysql" {
  allocated_storage      = 10
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = var.db_name
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.mysql.id]
  db_subnet_group_name  = aws_db_subnet_group.mysql.name
  skip_final_snapshot    = true


  tags = {
    Name = "MySQL"
  }
}

resource "aws_launch_configuration" "webservers" {
  name   = "Launch configuration web-server"
  image_id      = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  security_groups = [aws_security_group.web.id]
  user_data = data.template_file.userdata.rendered
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "web" {
  depends_on = [time_sleep.dns_resolving_timeout_90s, aws_nat_gateway.nat_a, aws_nat_gateway.nat_b]
  name                      = "autoscaler"
  launch_configuration      = aws_launch_configuration.webservers.name
  vpc_zone_identifier  = [aws_subnet.a_private.id, aws_subnet.b_private.id]
  min_size         = 2
  max_size         = 2
  min_elb_capacity = 2
  health_check_type = "ELB"
  load_balancers = [aws_elb.web.name]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_efs_file_system" "EFS" {
  creation_token = "EFS for WP files"

  tags = {
    Name = "EFS for media WordPress"
  }
}

resource "aws_efs_mount_target" "a_mount" {
  file_system_id = aws_efs_file_system.EFS.id
  subnet_id      = aws_subnet.a_private.id
  security_groups = [aws_security_group.AccessToEFS.id]
}

resource "aws_efs_mount_target" "b_mount" {
  file_system_id = aws_efs_file_system.EFS.id
  subnet_id      = aws_subnet.b_private.id
  security_groups = [aws_security_group.AccessToEFS.id]
}

output "dns_name_to_connect"{
  value = aws_elb.web.dns_name
}

//output "DNS_EFS" {
//  value = aws_efs_file_system.EFS.dns_name
//}

//output "userdata" {
//  value = data.template_file.userdata.rendered
//}