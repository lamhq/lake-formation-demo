resource "aws_s3_object" "customer_csv_file" {
  bucket      = var.artifact_bucket
  key         = "${var.project}/${local.env}/source/customers/customers-1.csv"
  source      = "./data/customers-1.csv"
  source_hash = filemd5("./data/customers-1.csv")
}

resource "aws_s3_object" "product_csv_file" {
  bucket      = var.artifact_bucket
  key         = "${var.project}/${local.env}/source/products/products-1.csv"
  source      = "./data/products.csv"
  source_hash = filemd5("./data/products.csv")
}