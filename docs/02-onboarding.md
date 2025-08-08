# Onboarding to AWS Ground Station Digital Twin

This document outlines the step-by-step process for onboarding to AWS Ground Station Digital Twin.

## Account Setup

### Step 1: Request Access

To start onboarding your satellite to AWS Ground Station Digital Twin:

1. Email `aws-groundstation@amazon.com` with a brief summary of your mission and satellite needs, including:
   - Your organization name
   - The frequencies required
   - When the satellites will be or were launched
   - The satellite's orbit type
   - Confirmation that you plan to use the AWS Ground Station digital twin feature

2. Once your request is reviewed and approved, AWS Ground Station will guide you through the onboarding process

3. The onboarding process typically takes 1-3 business days after submitting your request

### Step 2: Initial Configuration

Once your access request is approved:

1. Log in to the AWS Ground Station console at https://console.aws.amazon.com/groundstation/
2. Navigate to the "Satellites and Resources" section
3. Complete the initial setup, which includes:
   - Selecting your primary AWS region
   - Configuring default dataflow endpoints
   - Setting up notification preferences

## IAM Permissions

### Required IAM Policies

Create an IAM policy with the following permissions for AWS Ground Station Digital Twin:

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
        "s3:ListBucket",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
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

AWS Ground Station Digital Twin requires specific network configurations for dataflow endpoints:

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

3. Add inbound and outbound rules as needed for your dataflow endpoints

### Dataflow Endpoint Configuration

Note: At this time, the digital twin feature does not support data delivery as described in the standard AWS Ground Station dataflows. However, you can configure endpoints for testing purposes.

1. Create S3 dataflow endpoints for testing:
   ```bash
   aws groundstation create-dataflow-endpoint-group \
     --endpoint-details '[{
       "endpoint": {
         "name": "DigitalTwinS3Endpoint",
         "address": {
           "name": "<your-bucket-name>",
           "port": 443
         }
       }
     }]' \
     --region <region>
   ```

## Satellite Configuration

### Listing Available Ground Stations

Once onboarded to the digital twin feature, you can retrieve the list of ground stations available to you:

```bash
aws groundstation list-ground-stations --region <region>
```

Digital twin ground stations are exact copies of the ground stations listed in AWS Ground Station Locations with a modifying prefix to Ground Station Name of "Digital Twin ". This includes their antenna capabilities and metadata, including site mask and actual GPS coordinates.

### Satellite Tagging (Optional)

You may want to add a name to your satellite record to more easily recognize it:

1. Get the satellite ARN:
   ```bash
   aws groundstation list-satellites --region <region>
   ```

2. Tag the satellite with a name:
   ```bash
   aws groundstation tag-resource \
     --region <region> \
     --resource-arn <satellite-arn> \
     --tags '{"Name":"<satellite-name>"}'
   ```

## Verification

After completing the onboarding steps:

1. Verify satellite access:
   ```bash
   aws groundstation list-satellites --region <region>
   ```

2. Verify ground station access:
   ```bash
   aws groundstation list-ground-stations --region <region>
   ```

3. Check for digital twin ground stations (prefixed with "Digital Twin ")

## Next Steps

After successful onboarding, proceed to [Using AWS Ground Station Digital Twin](03-using-digital-twin.md) to learn how to create and manage simulations.

## AWS Documentation References

- [AWS Ground Station Digital Twin](https://docs.aws.amazon.com/ground-station/latest/ug/digital-twin.html)
- [Onboard Satellite](https://docs.aws.amazon.com/ground-station/latest/ug/getting-started.step1.html)
- [AWS Ground Station Locations](https://docs.aws.amazon.com/ground-station/latest/ug/aws-ground-station-antenna-locations.html)
- [ListGroundStations API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ListGroundStations.html)
