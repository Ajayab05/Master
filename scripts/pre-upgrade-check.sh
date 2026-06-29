#!/bin/bash

set -e

REGION="us-east-1"
CLUSTER="eks-upgrade-demo-dev"

echo "============================================================"
echo "           EKS PRE-UPGRADE HEALTH CHECK"
echo "============================================================"

echo
echo "1. AWS Account"
aws sts get-caller-identity \
  --query "Account" \
  --output text

echo
echo "2. AWS Region"
echo "$REGION"

echo
echo "3. EKS Cluster Status"
aws eks describe-cluster \
  --name $CLUSTER \
  --region $REGION \
  --query "cluster.status"

echo
echo "4. EKS Kubernetes Version"
aws eks describe-cluster \
  --name $CLUSTER \
  --region $REGION \
  --query "cluster.version"

echo
echo "5. kubectl Client Version"
kubectl version --client

echo
echo "6. Kubernetes Nodes"
kubectl get nodes -o wide

echo
echo "7. kube-system Pods"
kubectl get pods -n kube-system -o wide

echo
echo "8. Application Pods"
kubectl get pods -A -o wide

echo
echo "9. Persistent Volumes"
kubectl get pv

echo
echo "10. Persistent Volume Claims"
kubectl get pvc -A

echo
echo "11. Storage Classes"
kubectl get storageclass

echo
echo "12. Services"
kubectl get svc -A

echo
echo "13. Ingress"
kubectl get ingress -A

echo
echo "14. AWS Managed Add-ons"
aws eks list-addons \
  --cluster-name $CLUSTER \
  --region $REGION

echo
echo "15. Add-on Status"

for addon in $(aws eks list-addons \
  --cluster-name $CLUSTER \
  --region $REGION \
  --query "addons[]" \
  --output text)
do
    printf "%-30s : " "$addon"

    aws eks describe-addon \
      --cluster-name $CLUSTER \
      --addon-name $addon \
      --region $REGION \
      --query "addon.status" \
      --output text
done

echo
echo "16. Node Groups"

aws eks list-nodegroups \
  --cluster-name $CLUSTER \
  --region $REGION \
  --query "nodegroups[]" \
  --output text

echo
echo "17. Node Group Status"

for ng in $(aws eks list-nodegroups \
  --cluster-name $CLUSTER \
  --region $REGION \
  --query "nodegroups[]" \
  --output text)
do
    printf "%-30s : " "$ng"

    aws eks describe-nodegroup \
      --cluster-name $CLUSTER \
      --nodegroup-name $ng \
      --region $REGION \
      --query "nodegroup.status" \
      --output text
done

echo
echo "18. EBS Volumes"

aws ec2 describe-volumes \
  --filters Name=tag:CSIVolumeName,Values=* \
  --region $REGION \
  --query "Volumes[*].[VolumeId,State,Size,VolumeType]" \
  --output table

echo
echo "19. ALB Ingress"

kubectl get ingress -A

echo
echo "20. Cluster Events"

kubectl get events -A \
--sort-by=.metadata.creationTimestamp | tail -20

echo
echo "============================================================"
echo "         PRE-UPGRADE HEALTH CHECK COMPLETED"
echo "============================================================"
