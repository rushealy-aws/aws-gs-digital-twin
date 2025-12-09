# Onboarding to AWS Ground Station Digital Twin

This document outlines the step-by-step process for onboarding to AWS Ground Station Digital Twin.

## Overview

The AWS Ground Station digital twin feature provides an environment where you can test and integrate your satellite mission management and command and control software without using production antenna capacity. The digital twin feature allows you to test scheduling, verification of configurations, and proper error handling. It also allows you to test AWS Ground Station APIs without using production capacity or requiring spectrum licensing.

## Account Setup

### Step 1: Request Access

To start onboarding your satellite to AWS Ground Station Digital Twin:

1. Follow the standard [Onboard satellite](https://docs.aws.amazon.com/ground-station/latest/ug/getting-started.step1.html) process
2. In your onboarding request to `aws-groundstation@amazon.com`, include:
   - Your organization name
   - The frequencies required
   - When the satellites will be or were launched
   - The satellite's orbit type
   - **Confirmation that you plan to use the AWS Ground Station digital twin feature**

3. Once your request is reviewed and approved, AWS Ground Station will onboard your satellite to the digital twin feature

4. The onboarding process typically takes 1-3 business days after submitting your request

### Step 2: Verify Digital Twin Access

Once your satellite is onboarded to the digital twin feature:

1. Log in to the AWS Ground Station console at https://console.aws.amazon.com/groundstation/
2. Navigate to the "Satellites and Resources" section
3. Verify your satellite appears in the list
4. Check that you can access digital twin ground stations

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

1. Create a service role for AWS Ground Station:
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

**Important Note**: At this time, the digital twin feature does not support data delivery as described in the standard AWS Ground Station dataflows. However, you can configure endpoints for testing purposes to validate your configurations.

1. Create dataflow endpoint groups for testing:
   ```bash
   aws groundstation create-dataflow-endpoint-group \
     --endpoint-details '[{
       "endpoint": {
         "name": "DigitalTwinTestEndpoint",
         "address": {
           "name": "<your-endpoint-name>",
           "port": 55888
         }
       }
     }]' \
     --region <region>
   ```

## Understanding Digital Twin Ground Stations

### Listing Available Ground Stations

Once onboarded to the digital twin feature, retrieve the list of ground stations available to you:

```bash
aws groundstation list-ground-stations --region us-west-2
```

### Digital Twin Ground Station Characteristics

Digital twin ground stations are exact copies of the ground stations listed in [AWS Ground Station Locations](https://docs.aws.amazon.com/ground-station/latest/ug/aws-ground-station-antenna-locations.html) with the following characteristics:

- **Naming Convention**: Prefixed with "Digital Twin " (e.g., "Digital Twin Oregon 1")
- **Antenna Capabilities**: Identical to production ground stations
- **Metadata**: Includes site mask and actual GPS coordinates
- **Technical Specifications**: Same frequency bands, polarization, and EIRP as production stations

### Available Digital Twin Locations

Digital twin ground stations are available at all AWS Ground Station locations, including:

- US East (Ohio)
- US West (Oregon, Hawaii, Alaska)
- Africa (Cape Town)
- Asia Pacific (Dubbo, Seoul, Singapore)
- Europe (Ireland, Stockholm)
- Middle East (Bahrain)
- South America (Punta Arenas)

## Satellite Configuration

### Listing Your Satellites

Verify your satellite has been onboarded:

```bash
aws groundstation list-satellites --region us-west-2
```

### Satellite Tagging (Optional)

Add a name tag to your satellite for easier identification:

1. Get the satellite ARN:
   ```bash
   aws groundstation list-satellites --region us-west-2
   ```

2. Tag the satellite with a name:
   ```bash
   aws groundstation tag-resource \
     --region us-west-2 \
     --resource-arn <satellite-arn> \
     --tags '{"Name":"<satellite-name>"}'
   ```

## Mission Profile Configuration

### Creating a Mission Profile

Create a mission profile for digital twin testing:

```bash
aws groundstation create-mission-profile \
  --name "Digital Twin Test Profile" \
  --minimum-viable-contact-duration-seconds 300 \
  --dataflow-edges '[
    {
      "source": "antenna-downlink",
      "destination": "dataflow-endpoint"
    }
  ]' \
  --tracking-config-arn "arn:aws:groundstation:us-west-2:123456789012:config/tracking/12345678-1234-1234-1234-123456789012" \
  --region us-west-2
```

### Mission Profile Components

A mission profile for digital twin testing should include:

- **Tracking Config**: Defines how the antenna tracks the satellite
- **Dataflow Edges**: Specifies the data flow path (for configuration testing)
- **Minimum Contact Duration**: Minimum viable contact time in seconds

## Verification

After completing the onboarding steps, verify your setup:

1. **Verify satellite access**:
   ```bash
   aws groundstation list-satellites --region us-west-2
   ```

2. **Verify ground station access**:
   ```bash
   aws groundstation list-ground-stations --region us-west-2
   ```

3. **Check for digital twin ground stations** (prefixed with "Digital Twin ")

4. **Verify mission profiles**:
   ```bash
   aws groundstation list-mission-profiles --region us-west-2
   ```

## Testing Your Setup

### Schedule a Test Contact

Once onboarded, test your setup by scheduling a contact:

```bash
aws groundstation reserve-contact \
  --mission-profile-arn "arn:aws:groundstation:us-west-2:123456789012:mission-profile/12345678-1234-1234-1234-123456789012" \
  --satellite-arn "arn:aws:groundstation:us-west-2:123456789012:satellite/12345678-1234-1234-1234-123456789012" \
  --start-time "2024-12-15T10:00:00Z" \
  --end-time "2024-12-15T10:15:00Z" \
  --ground-station "Digital Twin Oregon 1" \
  --region us-west-2
```

### Monitor Contact Status

Check the status of your scheduled contact:

```bash
aws groundstation describe-contact \
  --contact-id <contact-id> \
  --region us-west-2
```

## EventBridge Integration

The digital twin feature emits the same Amazon EventBridge events as the production service. Set up EventBridge rules to monitor digital twin activities:

```json
{
  "source": ["aws.groundstation"],
  "detail-type": ["Ground Station Contact State Change"],
  "detail": {
    "contactId": {"exists": true}
  }
}
```

For more information, see [Automate AWS Ground Station with Events](https://docs.aws.amazon.com/ground-station/latest/ug/monitoring.automating-events.html).

## Troubleshooting Onboarding

### Common Issues

1. **Cannot see digital twin ground stations**
   - Verify your satellite has been onboarded to the digital twin feature
   - Check that you're using the correct AWS region
   - Confirm your IAM permissions include `groundstation:ListGroundStations`

2. **Cannot schedule contacts**
   - Ensure you have created a mission profile
   - Verify your satellite has valid ephemeris data
   - Check that the contact time is within the allowed lead time (default: 7 days)

3. **Permission errors**
   - Review your IAM policies
   - Ensure the service role has the correct trust relationship
   - Verify you have permissions for all required AWS services

## Next Steps

After successful onboarding, proceed to:

1. [Using AWS Ground Station Digital Twin](03-using-digital-twin.md) to learn how to schedule and manage contacts
2. [Uplink Configuration](04-uplink-configuration.md) for uplink testing
3. [Customer-Provided Ephemeris](05-customer-provided-ephemeris.md) for custom ephemeris data

## AWS Documentation References

- [Use the AWS Ground Station digital twin feature](https://docs.aws.amazon.com/ground-station/latest/ug/digital-twin.html)
- [Onboard satellite](https://docs.aws.amazon.com/ground-station/latest/ug/getting-started.step1.html)
- [AWS Ground Station Locations](https://docs.aws.amazon.com/ground-station/latest/ug/aws-ground-station-antenna-locations.html)
- [ListGroundStations API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ListGroundStations.html)
- [Automate AWS Ground Station with Events](https://docs.aws.amazon.com/ground-station/latest/ug/monitoring.automating-events.html)
