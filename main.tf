provider "aws" {
  region = "eu-west-1"
}


# ROUTE 53 RECORD TO APP
resource "aws_route53_record" "manvir" {
  zone_id = "Z3CCIZELFLJ3SC"
  name    = "engineering12.spartaglobal.education"
  type    = "CNAME"
  ttl     = "300"
  records = ["${module.app.elb_app}"]
}


## TEMPLATE
data "template_file" "app_user_data" {
template = "${file("${path.cwd}/scripts/app/init.sh.tpl")}"
  vars {
    db_host = "mongodb://${module.db.db_1a_privateip}:27017/posts"
  }
}

module "app" {
  source = "modules/app_tier"
  vpc_id = "${module.app.vpc_id}"
  name = "APP-PROJECT4"
  app_ami_id = "${module.app.app_ami_id}"
  cidr_block = "10.10.0.0/16"
  user_data = "${data.template_file.app_user_data.rendered}"
}

module "db" {
  source = "modules/db_tier"
  vpc_id = "${module.app.vpc_id}"
  name = "DB-PROJECT4"
  app_security_group = "${module.app.app_security_group}"
  db_ami_id = "${module.db.db_ami_id}"
  app_internet_gateway = "${module.app.app_internet_gateway}"
#  cidr_block = ""
}
