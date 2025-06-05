# Onboarding to AWS Ground Station Digital Twin

This document outlines the step-by-step process for onboarding to AWS Ground Station Digital Twin.

## Account Setup

### Step 1: Request Access

1. Navigate to the AWS Ground Station console at https://console.aws.amazon.com/groundstation/
2. Click on "Digital Twin" in the navigation pane
3. If Digital Twin is not enabled for your account, you'll see an option to request access
4. Complete the request form with the following details:
   - AWS Account ID
   - Primary contact information
   - Use case description
   - Satellite details
   - Expected testing timeline
5. Submit the request and wait for approval from the AWS Ground Station team

### Step 2: Initial Configuration

Once your access request is approved:

1. Log in to the AWS Ground Station console
2. Navigate to the Digital Twin section
3. Complete the initial setup wizard, which includes:
   - Selecting your primary AWS region
   - Configuring default dataflow endpoints
   - Setting up notification preferences
   - Accepting the service terms and conditions

## IAM Permissions

### Required IAM Policies

Create an IAM policy with the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "groundstation:*",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DescribeSecurityGroups",
        "ec2:DescribeSubnets",
        "ec2:DescribeVpcs",
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ],
      "Resource": "*"
    }
  ]
}
```

### Creating IAM Roles

1. Create a service role for AWS Ground Station Digital Twin:
   ```bash
   aws iam create-role --role-name GroundStationDigitalTwinRole --assume-role-policy-document '{
     "Version": "2012-10-17",
     "Statement": [
       {
         "Effect": "Allow",
         "Principal": {
           "Service": "groundstation.amazonaws.com"
         },
         "Action": "sts:AssumeRole"
       }
     ]
   }'
   ```

2. Attach the required policy to the role:
   ```bash
   aws iam attach-role-policy --role-name GroundStationDigitalTwinRole --policy-arn <policy-arn>
   ```

## Network Configuration

### VPC Requirements

AWS Ground Station Digital Twin requires specific network configurations:

1. Create or select a VPC with:
   - At least two subnets in different Availability Zones
   - Internet connectivity (via Internet Gateway or NAT Gateway)
   - Appropriate CIDR range to accommodate dataflow endpoints

2. Configure security groups:
   ```bash
   aws ec2 create-security-group \
     --group-name gs-digital-twin-sg \
     --description "Security group for Ground Station Digital Twin" \
     --vpc-id <vpc-id>
   ```

3. Add inbound and outbound rules:
   ```bash
   aws ec2 authorize-security-group-ingress \
     --group-id <security-group-id> \
     --protocol tcp \
     --port 55888 \
     --cidr 0.0.0.0/0
   ```

### Dataflow Endpoint Configuration

1. Create S3 dataflow endpoints:
   ```bash
   aws groundstation create-dataflow-endpoint-group \
     --endpoint-details '[{
       "endpoint": {
         "name": "DigitalTwinS3Endpoint",
         "awsS3": {
           "bucketArn": "arn:aws:s3:::<your-bucket-name>",
           "keyPattern": "digital-twin-data/{satellite_id}/{year}/{month}/{day}/{hour}/{minute}"
         }
       }
     }]' \
     --region <region>
   ```

2. Create EC2 dataflow endpoints:
   ```bash
   aws groundstation create-dataflow-endpoint-group \
     --endpoint-details '[{
       "endpoint": {
         "name": "DigitalTwinEC2Endpoint",
         "awsEc2": {
           "securityGroupIds": ["<security-group-id>"],
           "subnetId": "<subnet-id>"
         }
       }
     }]' \
     --region <region>
   ```

## Verification

After completing the onboarding steps:

1. Verify IAM permissions:
   ```bash
   aws groundstation get-config --config-id <config-id> --region <region>
   ```

2. Verify network configuration:
   ```bash
   aws groundstation list-dataflow-endpoint-groups --region <region>
   ```

3. Verify Digital Twin access:
   ```bash
   aws groundstation list-digital-twin-simulations --region <region>
   ```

## Next Steps

After successful onboarding, proceed to [Using AWS Ground Station Digital Twin](03-using-digital-twin.md) to learn how to create and manage simulations.

## AWS Documentation References

- [AWS Ground Station Getting Started Guide](https://docs.aws.amazon.com/ground-station/latest/ug/getting-started.html)
- [AWS Ground Station IAM Permissions](https://docs.aws.amazon.com/ground-station/latest/ug/auth-and-access-control.html)
- [AWS Ground Station Dataflow Endpoint Groups](https://docs.aws.amazon.com/ground-station/latest/ug/dataflow-endpoint-groups.html)
- [AWS Ground Station VPC Requirements](https://docs.aws.amazon.com/ground-station/latest/ug/dataflow-endpoint-groups.html#dataflow-endpoint-groups-vpc)
