# Prerequisites

Before you begin using AWS Ground Station Digital Twin, ensure you have the following prerequisites in place:

## AWS Account Requirements

- An active AWS account with appropriate permissions
- AWS Ground Station service access (contact aws-groundstation@amazon.com for onboarding)
- Service quotas reviewed and increased if necessary
- Understanding of satellite communications concepts

## Regional Availability

AWS Ground Station Digital Twin is available in regions where AWS Ground Station is supported. For the most current list of supported regions, refer to the [AWS Ground Station documentation](https://docs.aws.amazon.com/ground-station/latest/ug/what-is.html).

## Technical Requirements

- AWS CLI installed and configured (version 2.0 or later recommended)
- Python 3.7 or later (for SDK usage)
- AWS SDK for your preferred programming language
- Network connectivity to AWS Ground Station endpoints
- Basic understanding of satellite orbital mechanics

## Installing the AWS CLI

The AWS Command Line Interface (CLI) is essential for interacting with AWS Ground Station Digital Twin. Follow these steps to install and configure it:

### Installation

#### macOS
```bash
# Using Homebrew
brew install awscli

# Or download the official installer
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

#### Linux
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

#### Windows
Download and run the AWS CLI MSI installer from the [AWS CLI download page](https://aws.amazon.com/cli/).

### Configuration

After installation, configure the AWS CLI:

```bash
aws configure
```

Provide the following information:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name (e.g., us-west-2)
- Default output format (json recommended)

### Verification

Verify your installation and configuration:

```bash
# Check AWS CLI version
aws --version

# Test connectivity
aws sts get-caller-identity

# List Ground Station resources (after onboarding)
aws groundstation list-satellites --region us-west-2
```

## IAM Permissions

Your AWS user or role needs the following permissions for AWS Ground Station Digital Twin:

### Minimum Required Permissions

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "groundstation:ListSatellites",
        "groundstation:GetSatellite",
        "groundstation:ListGroundStations",
        "groundstation:ListContacts",
        "groundstation:DescribeContact",
        "groundstation:ReserveContact",
        "groundstation:CancelContact"
      ],
      "Resource": "*"
    }
  ]
}
```

### Extended Permissions for Ephemeris Management

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "groundstation:*",
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket",
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "events:PutEvents"
      ],
      "Resource": "*"
    }
  ]
}
```

## AWS SDK Installation

### Python (Boto3)

```bash
pip install boto3
```

### Node.js

```bash
npm install aws-sdk
```

### Java

Add to your Maven `pom.xml`:

```xml
<dependency>
    <groupId>software.amazon.awssdk</groupId>
    <artifactId>groundstation</artifactId>
    <version>2.20.0</version>
</dependency>
```

## Network Requirements

### Outbound Connectivity

Ensure your environment can reach:
- AWS Ground Station API endpoints
- Amazon S3 (for ephemeris data storage)
- CloudWatch Logs (for monitoring)

### Firewall Configuration

If behind a corporate firewall, ensure access to:
- `*.amazonaws.com` on port 443 (HTTPS)
- Regional Ground Station endpoints

## Knowledge Prerequisites

### Satellite Communications

Basic understanding of:
- Orbital mechanics and satellite passes
- Frequency bands (S-band, X-band)
- Doppler shift and link budgets
- Antenna pointing and tracking

### AWS Services

Familiarity with:
- AWS IAM (Identity and Access Management)
- Amazon S3 (for data storage)
- Amazon CloudWatch (for monitoring)
- Amazon EventBridge (for event handling)

## Development Environment Setup

### Recommended Tools

- **Code Editor**: VS Code, PyCharm, or similar
- **Version Control**: Git for managing configurations
- **API Testing**: Postman or curl for API testing
- **Monitoring**: AWS CLI and console access

### Environment Variables

Set up useful environment variables:

```bash
export AWS_DEFAULT_REGION=us-west-2
export AWS_PROFILE=groundstation
export GS_SATELLITE_ID=your-satellite-id
```

## Verification Checklist

Before proceeding to onboarding, verify:

- [ ] AWS CLI installed and configured
- [ ] AWS account has appropriate permissions
- [ ] Network connectivity to AWS services confirmed
- [ ] Basic satellite communications knowledge acquired
- [ ] Development environment set up

## Getting Help

If you encounter issues with prerequisites:

1. **AWS CLI Issues**: Check the [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
2. **Permission Issues**: Review [AWS IAM documentation](https://docs.aws.amazon.com/iam/)
3. **Network Issues**: Consult your network administrator
4. **General Questions**: Contact aws-groundstation@amazon.com

## Next Steps

Once all prerequisites are met, proceed to [Onboarding](02-onboarding.md) to begin using AWS Ground Station Digital Twin.

## AWS Documentation References

- [Installing the AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Configuring the AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)
- [AWS Ground Station User Guide](https://docs.aws.amazon.com/ground-station/latest/ug/)
- [AWS IAM User Guide](https://docs.aws.amazon.com/iam/)
