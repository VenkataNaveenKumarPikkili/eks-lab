# --------------------------------------------------
# 1. Availability Zone Discovery
# --------------------------------------------------

data "aws_availability_zones" "available" {
  state = "available"

  exclude_zone_ids = var.excluded_az_ids

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

# --------------------------------------------------
# 2. Local Values
# --------------------------------------------------

locals {

  availability_zones = slice(
    sort(data.aws_availability_zones.available.names),
    0,
    var.az_count
  )

  subnet_map = {
    for index, az in local.availability_zones :
    az => index
  }

  public_subnet_cidrs = {
    for index, az in local.availability_zones :
    az => cidrsubnet(var.vpc_cidr, 8, index)
  }

  private_subnet_cidrs = {
    for index, az in local.availability_zones :
    az => cidrsubnet(var.vpc_cidr, 4, index + 1)
  }

  nat_gateway_count = var.single_nat_gateway ? 1 : var.az_count
}

# --------------------------------------------------
# 3. VPC
# --------------------------------------------------

resource "aws_vpc" "main" {

  cidr_block = var.vpc_cidr

  enable_dns_support   = true
  enable_dns_hostnames = true

  instance_tenancy = "default"

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-vpc"
    }
  )
}

# --------------------------------------------------
# 4. Internet Gateway
# --------------------------------------------------

resource "aws_internet_gateway" "main" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-igw"
    }
  )
}

# --------------------------------------------------
# 5. Public Subnets
# --------------------------------------------------

resource "aws_subnet" "public" {

  for_each = local.subnet_map

  vpc_id = aws_vpc.main.id

  cidr_block = local.public_subnet_cidrs[each.key]

  availability_zone = each.key

  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-${each.key}"

      "kubernetes.io/cluster/${var.name_prefix}" = "shared"

      "kubernetes.io/role/elb" = "1"
    }
  )
}

# --------------------------------------------------
# 6. Private Subnets
# --------------------------------------------------

resource "aws_subnet" "private" {

  for_each = local.subnet_map

  vpc_id = aws_vpc.main.id

  cidr_block = local.private_subnet_cidrs[each.key]

  availability_zone = each.key

  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-${each.key}"

      "kubernetes.io/cluster/${var.name_prefix}" = "shared"

      "kubernetes.io/role/internal-elb" = "1"
    }
  )
}

# --------------------------------------------------
# 7. Public Route Table
# --------------------------------------------------

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-public-rt"
    }
  )
}

# --------------------------------------------------
# 8. Public Internet Route
# --------------------------------------------------

resource "aws_route" "public_internet" {

  route_table_id = aws_route_table.public.id

  destination_cidr_block = "0.0.0.0/0"

  gateway_id = aws_internet_gateway.main.id
}

# --------------------------------------------------
# 9. Public Route Table Associations
# --------------------------------------------------

resource "aws_route_table_association" "public" {

  for_each = aws_subnet.public

  subnet_id = each.value.id

  route_table_id = aws_route_table.public.id
}

# --------------------------------------------------
# 10. Elastic IPs
# --------------------------------------------------

resource "aws_eip" "nat" {

  count = local.nat_gateway_count

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-eip-${count.index + 1}"
    }
  )
}

# --------------------------------------------------
# 11. NAT Gateways
# --------------------------------------------------

resource "aws_nat_gateway" "main" {

  count = local.nat_gateway_count

  allocation_id = aws_eip.nat[count.index].id

  subnet_id = aws_subnet.public[
    local.availability_zones[
      var.single_nat_gateway ? 0 : count.index
    ]
  ].id

  connectivity_type = "public"

  depends_on = [
    aws_route.public_internet,
    aws_route_table_association.public
  ]

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-nat-${count.index + 1}"
    }
  )
}

# --------------------------------------------------
# 12. Private Route Tables
# --------------------------------------------------

resource "aws_route_table" "private" {

  for_each = local.subnet_map

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-private-rt-${each.key}"
    }
  )
}

# --------------------------------------------------
# 13. Private NAT Routes
# --------------------------------------------------

resource "aws_route" "private_nat" {

  for_each = local.subnet_map

  route_table_id = aws_route_table.private[each.key].id

  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.main[
    var.single_nat_gateway ? 0 : each.value
  ].id
}

# --------------------------------------------------
# 14. Private Route Table Associations
# --------------------------------------------------

resource "aws_route_table_association" "private" {

  for_each = aws_subnet.private

  subnet_id = each.value.id

  route_table_id = aws_route_table.private[each.key].id
}