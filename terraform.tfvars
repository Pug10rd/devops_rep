aws_region         = "us-west-2"
cluster_name       = "lesson-8-9-eks-cluster"
node_group_name    = "lesson-8-9-node-group"
kubernetes_version = "1.35"

desired_size = 2
min_size     = 2
max_size     = 2

instance_types = ["t3.micro"]

ecr_name               = "lesson-8-9-django-ecr"
scan_on_push           = true
jenkins_admin_password = "CHANGE_ME"

