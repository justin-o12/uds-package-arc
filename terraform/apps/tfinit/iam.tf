
locals {
  local_iam_policies = [
    aws_iam_policy.s3_bucket.arn,
    data.aws_iam_policy.ReadOnlyAccess.arn,
    data.aws_iam_policy.AdministratorAccess.arn,
    aws_iam_policy.dynamo-rw.arn
  ]
}


resource "aws_iam_instance_profile" "edafos_instance_profile" {
  name = "${var.shortname}-Profile"
  role = aws_iam_role.edafos-instance.name
}

resource "aws_iam_role" "edafos-instance" {
  name                = "${var.shortname}-role"
  managed_policy_arns = local.local_iam_policies
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })
  tags = var.default_tags
}

resource "aws_iam_policy" "s3_bucket" {
  name = "${var.shortname}-s3-policy"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "s3:DeleteAccessPoint",
          "s3:DeleteAccessPointForObjectLambda",
          "s3:DeleteJobTagging",
          "s3:PutLifecycleConfiguration",
          "s3:PutObjectTagging",
          "s3:DeleteObject",
          "s3:CreateMultiRegionAccessPoint",
          "s3:GetBucketWebsite",
          "s3:DeleteStorageLensConfigurationTagging",
          "s3:GetMultiRegionAccessPoint",
          "s3:PutReplicationConfiguration",
          "s3:GetObjectAttributes",
          "s3:DeleteObjectVersionTagging",
          "s3:InitiateReplication",
          "s3:GetObjectLegalHold",
          "s3:GetBucketNotification",
          "s3:GetReplicationConfiguration",
          "s3:DescribeMultiRegionAccessPointOperation",
          "s3:PutObject",
          "s3:PutBucketNotification",
          "s3:PutBucketObjectLockConfiguration",
          "s3:GetStorageLensDashboard",
          "s3:GetLifecycleConfiguration",
          "s3:GetBucketTagging",
          "s3:GetInventoryConfiguration",
          "s3:GetAccessPointPolicyForObjectLambda",
          "s3:ReplicateTags",
          "s3:ListBucket",
          "s3:AbortMultipartUpload",
          "s3:PutBucketTagging",
          "s3:UpdateJobPriority",
          "s3:DeleteBucket",
          "s3:PutBucketVersioning",
          "s3:GetMultiRegionAccessPointPolicyStatus",
          "s3:PutIntelligentTieringConfiguration",
          "s3:PutMetricsConfiguration",
          "s3:PutStorageLensConfigurationTagging",
          "s3:PutObjectVersionTagging",
          "s3:GetBucketVersioning",
          "s3:GetAccessPointConfigurationForObjectLambda",
          "s3:PutInventoryConfiguration",
          "s3:GetMultiRegionAccessPointRoutes",
          "s3:GetStorageLensConfiguration",
          "s3:DeleteStorageLensConfiguration",
          "s3:PutBucketWebsite",
          "s3:PutBucketRequestPayment",
          "s3:PutObjectRetention",
          "s3:CreateAccessPointForObjectLambda",
          "s3:GetBucketCORS",
          "s3:GetObjectVersion",
          "s3:PutAnalyticsConfiguration",
          "s3:PutAccessPointConfigurationForObjectLambda",
          "s3:GetObjectVersionTagging",
          "s3:CreateBucket",
          "s3:GetStorageLensConfigurationTagging",
          "s3:ReplicateObject",
          "s3:GetObjectAcl",
          "s3:GetBucketObjectLockConfiguration",
          "s3:DeleteBucketWebsite",
          "s3:GetIntelligentTieringConfiguration",
          "s3:GetObjectVersionAcl",
          "s3:DeleteObjectTagging",
          "s3:GetBucketPolicyStatus",
          "s3:GetObjectRetention",
          "s3:GetJobTagging",
          "s3:PutObjectLegalHold",
          "s3:PutBucketCORS",
          "s3:GetObject",
          "s3:DescribeJob",
          "s3:PutBucketLogging",
          "s3:GetAnalyticsConfiguration",
          "s3:GetObjectVersionForReplication",
          "s3:GetAccessPointForObjectLambda",
          "s3:CreateAccessPoint",
          "s3:PutAccelerateConfiguration",
          "s3:SubmitMultiRegionAccessPointRoutes",
          "s3:DeleteObjectVersion",
          "s3:GetBucketLogging",
          "s3:RestoreObject",
          "s3:GetAccelerateConfiguration",
          "s3:GetObjectVersionAttributes",
          "s3:GetBucketPolicy",
          "s3:PutEncryptionConfiguration",
          "s3:GetEncryptionConfiguration",
          "s3:GetObjectVersionTorrent",
          "s3:GetBucketRequestPayment",
          "s3:GetAccessPointPolicyStatus",
          "s3:GetObjectTagging",
          "s3:GetBucketOwnershipControls",
          "s3:GetMetricsConfiguration",
          "s3:GetBucketPublicAccessBlock",
          "s3:GetMultiRegionAccessPointPolicy",
          "s3:GetAccessPointPolicyStatusForObjectLambda",
          "s3:PutBucketOwnershipControls",
          "s3:DeleteMultiRegionAccessPoint",
          "s3:PutJobTagging",
          "s3:UpdateJobStatus",
          "s3:GetBucketAcl",
          "s3:GetObjectTorrent",
          "s3:GetBucketLocation",
          "s3:GetAccessPointPolicy",
          "s3:ReplicateDelete",
        ],
        Resource : aws_s3_bucket.tfbucket.arn
      },
      {
        Effect : "Allow",
        Action : [
          "s3:GetAccessPoint",
          "s3:GetAccountPublicAccessBlock",
          "s3:PutStorageLensConfiguration",
          "s3:CreateJob"
        ],
        Resource : aws_s3_bucket.tfbucket.arn
      }
    ]
  })
  tags = var.default_tags
}

resource "aws_iam_policy" "dynamo-rw" {
  name = "${var.shortname}-dynamo-policy"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Effect : "Allow",
        Action : [
          "dynamodb:DescribeContributorInsights",
          "dynamodb:RestoreTableToPointInTime",
          "dynamodb:UpdateGlobalTable",
          "dynamodb:DeleteTable",
          "dynamodb:UpdateTableReplicaAutoScaling",
          "dynamodb:DescribeTable",
          "dynamodb:PartiQLInsert",
          "dynamodb:GetItem",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeExport",
          "dynamodb:EnableKinesisStreamingDestination",
          "dynamodb:BatchGetItem",
          "dynamodb:DisableKinesisStreamingDestination",
          "dynamodb:UpdateTimeToLive",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:PartiQLUpdate",
          "dynamodb:Scan",
          "dynamodb:StartAwsBackupJob",
          "dynamodb:UpdateItem",
          "dynamodb:UpdateGlobalTableSettings",
          "dynamodb:CreateTable",
          "dynamodb:RestoreTableFromAwsBackup",
          "dynamodb:GetShardIterator",
          "dynamodb:DescribeReservedCapacity",
          "dynamodb:ExportTableToPointInTime",
          "dynamodb:DescribeEndpoints",
          "dynamodb:DescribeBackup",
          "dynamodb:UpdateTable",
          "dynamodb:GetRecords",
          "dynamodb:DescribeTableReplicaAutoScaling",
          "dynamodb:DescribeImport",
          "dynamodb:ListTables",
          "dynamodb:DeleteItem",
          "dynamodb:PurchaseReservedCapacityOfferings",
          "dynamodb:CreateTableReplica",
          "dynamodb:ListTagsOfResource",
          "dynamodb:UpdateContributorInsights",
          "dynamodb:CreateBackup",
          "dynamodb:UpdateContinuousBackups",
          "dynamodb:DescribeReservedCapacityOfferings",
          "dynamodb:PartiQLSelect",
          "dynamodb:UpdateGlobalTableVersion",
          "dynamodb:CreateGlobalTable",
          "dynamodb:DescribeKinesisStreamingDestination",
          "dynamodb:DescribeLimits",
          "dynamodb:ImportTable",
          "dynamodb:ConditionCheckItem",
          "dynamodb:Query",
          "dynamodb:DescribeStream",
          "dynamodb:DeleteTableReplica",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListStreams",
          "dynamodb:DescribeGlobalTableSettings",
          "dynamodb:DescribeGlobalTable",
          "dynamodb:RestoreTableFromBackup",
          "dynamodb:DeleteBackup",
          "dynamodb:PartiQLDelete"
        ],
        Resource : aws_dynamodb_table.action_locktable.arn
      }
    ]
  })
  tags = var.default_tags
}

data "aws_iam_policy" "ReadOnlyAccess" {
  arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

data "aws_iam_policy" "AdministratorAccess" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
