/* Output value from the IAM module */

output "ecstaskexecution_iam_role_arn" {
  value = "${aws_iam_role.ecstaskexecution_iam_role.arn}"
}

output "codepipeline_iam_role_arn" {
  value = "${aws_iam_role.codepipeline_role.arn}"
}

output "codebuild_iam_role_arn" {
  value = "${aws_iam_role.codebuild_role.arn}"
}