resource "aws_s3_object" "customer_csv_file" {
  bucket      = var.artifact_bucket
  key         = "${var.project}/${local.env}/raw/customers/customers-1.csv"
  source      = "./data/customers-1.csv"
  source_hash = filemd5("./data/customers-1.csv")
}