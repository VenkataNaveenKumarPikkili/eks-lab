# --------------------------------------------------
# 1. EKS Worker Node Security Group
# --------------------------------------------------

resource "aws_security_group" "eks_nodes" {

  name = "${var.name_prefix}-eks-node-sg"

  description = "Security group for EKS worker nodes"

  vpc_id = var.vpc_id

  revoke_rules_on_delete = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-eks-node-sg"
    }
  )
}

# --------------------------------------------------
# 2. Node-to-Node Communication
# --------------------------------------------------

resource "aws_vpc_security_group_ingress_rule" "node_to_node" {

  security_group_id = aws_security_group.eks_nodes.id

  description = "Allow communication between EKS worker nodes"

  ip_protocol = "-1"

  referenced_security_group_id = aws_security_group.eks_nodes.id

}

# --------------------------------------------------
# 3. Worker Node Outbound Traffic
# --------------------------------------------------

resource "aws_vpc_security_group_egress_rule" "node_egress" {

  security_group_id = aws_security_group.eks_nodes.id

  description = "Allow outbound traffic from EKS worker nodes"

  ip_protocol = "-1"

  cidr_ipv4 = "0.0.0.0/0"

}