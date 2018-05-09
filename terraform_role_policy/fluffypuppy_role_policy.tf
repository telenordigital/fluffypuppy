// Used to configure all aws accounts with the fluffypuppy role and padding_policy
// Change the IAM-ACCOUNTNUMBER on line 14 with your IAM account number

data "aws_iam_policy_document" "assume_fluffypuppy_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::AWS-IAM-ACCOUNTNUMBER:root"]
    }
  }
}

// Creates security-audit-role and allows role switching from DGS-IAM Account, specifically only the security-audit-group
resource "aws_iam_role" "fluffypuppy_role" {
  name               = "fluffypuppy-role"
  path               = "/"
  assume_role_policy = "${data.aws_iam_policy_document.assume_fluffypuppy_role.json}"
}

data "aws_iam_policy_document" "fluffypuppy_policy" {
  statement {
    effect = "Allow"

    actions = [
      "acm:describecertificate",
      "acm:listcertificates",
      "autoscaling:describe*",
      "cloudformation:describestack*",
      "cloudformation:getstackpolicy",
      "cloudformation:gettemplate",
      "cloudformation:liststack*",
      "cloudfront:get*",
      "cloudfront:list*",
      "cloudtrail:describetrails",
      "cloudtrail:gettrailstatus",
      "cloudtrail:listtags",
      "cloudwatch:describe*",
      "cloudwatchlogs:describeloggroups",
      "cloudwatchlogs:describemetricfilters",
      "codecommit:batchgetrepositories",
      "codecommit:getbranch",
      "codecommit:getobjectidentifier",
      "codecommit:getrepository",
      "codecommit:list*",
      "codedeploy:batch*",
      "codedeploy:get*",
      "codedeploy:list*",
      "config:deliver*",
      "config:describe*",
      "config:get*",
      "datapipeline:describeobjects",
      "datapipeline:describepipelines",
      "datapipeline:evaluateexpression",
      "datapipeline:getpipelinedefinition",
      "datapipeline:listpipelines",
      "datapipeline:queryobjects",
      "datapipeline:validatepipelinedefinition",
      "directconnect:describe*",
      "dynamodb:listtables",
      "ec2:describe*",
      "ecs:describe*",
      "ecs:list*",
      "elasticache:describe*",
      "elasticbeanstalk:describe*",
      "elasticfilesystem:describefilesystems",
      "elasticloadbalancing:describe*",
      "elasticmapreduce:describejobflows",
      "elasticmapreduce:listclusters",
      "es:describeelasticsearchdomainconfig",
      "es:listdomainnames",
      "firehose:describe*",
      "firehose:list*",
      "glacier:listvaults",
      "iam:generatecredentialreport",
      "iam:get*",
      "iam:list*",
      "kms:describekey",
      "kms:getkeypolicy",
      "kms:getkeyrotationstatus",
      "kms:getparametersforimport",
      "kms:listaliases",
      "kms:listgrants",
      "kms:listkeypolicies",
      "kms:listkeys",
      "kms:listretirablegrants",
      "lambda:getpolicy",
      "lambda:listfunctions",
      "logs:DescribeMetricFilters",
      "rds:describe*",
      "rds:downloaddblogfileportion",
      "rds:listtagsforresource",
      "redshift:describe*",
      "route53:getchange",
      "route53:getcheckeripranges",
      "route53:getgeolocations",
      "route53:gethealthcheck",
      "route53:gethealthcheckcount",
      "route53:gethealthchecklastfailurereason",
      "route53:gethostedzone",
      "route53:gethostedzonecount",
      "route53:getreusabledelegationset",
      "route53:listgeolocations",
      "route53:listhealthchecks",
      "route53:listhostedzones",
      "route53:listhostedzonesbyname",
      "route53:listresourcerecordsets",
      "route53:listreusabledelegationsets",
      "route53:listtagsforresource",
      "route53:listtagsforresources",
      "route53domains:getdomaindetail",
      "route53domains:getoperationdetail",
      "route53domains:listdomains",
      "route53domains:listoperations",
      "route53domains:listtagsfordomain",
      "s3:getbucket*",
      "s3:getlifecycleconfiguration",
      "s3:getobjectacl",
      "s3:getobjectversionacl",
      "s3:listallmybuckets",
      "s3:listbucket",
      "sdb:domainmetadata",
      "sdb:listdomains",
      "ses:getidentitydkimattributes",
      "ses:getidentityverificationattributes",
      "ses:listidentities",
      "ses:listidentitypolicies",
      "ses:listverifiedemailaddresses",
      "sns:gettopicattributes",
      "sns:listsubscriptions",
      "sns:listsubscriptionsbytopic",
      "sns:listtopics",
      "sqs:getqueueattributes",
      "sqs:listqueues",
      "tag:getresources",
      "tag:gettagkeys",
    ]

    resources = [
      "*",
    ]
  }
}

// Creates a custom read-only security-audit-policy and attaches this to the security-audit-role.
resource "aws_iam_policy" "fluffypuppy_policy" {
  name        = "fluffypuppy-policy"
  description = "Read-only policy for AWS security monitoring"
  policy      = "${data.aws_iam_policy_document.fluffypuppy_policy.json}"
}

// Attaches policy to the role
resource "aws_iam_role_policy_attachment" "fluffypuppy-policy-attachment" {
  role       = "${aws_iam_role.fluffypuppy_role.name}"
  policy_arn = "${aws_iam_policy.fluffypuppy_policy.arn}"
}
