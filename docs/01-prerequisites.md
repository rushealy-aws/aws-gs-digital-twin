# Prerequisites

Before you begin using AWS Ground Station Digital Twin, ensure you have the following prerequisites in place:

## AWS Account Requirements

- An active AWS account with appropriate permissions. Note: This account may not be onboarded (previously or in the future) to the AWS Ground Station service for production use.
- AWS Ground Station service access (contact aws-groundstation@amazon.com or your AWS account team--Account Manager and Solutions Architect **preferred** onboarding)
- Service quotas reviewed and increased if necessary
- Understanding of satellite communications concepts

## Regional Availability

AWS Ground Station Digital Twin is available in all AWS Regions where AWS Ground Station is supported. The digital twin feature is available at the following AWS Ground Station locations:

- US East (Ohio, N. Virginia)
- US West (Oregon, Hawaii, Alaska)
- Africa (Cape Town)
- Asia Pacific (Seoul, Singapore, Sydney)
- Europe (Frankfurt, Ireland, Stockholm)
- Middle East (Bahrain)
- South America (São Paulo)

For the most current list of supported regions and endpoints, refer to the [AWS Ground Station endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/gs.html) documentation.

## Technical Requirements

- AWS CLI version 2 installed and configured
- Python 3.8 or later (for SDK usage)
- AWS SDK for your preferred programming language
- Network connectivity to AWS Ground Station endpoints
- Basic understanding of satellite orbital mechanics

## Installing the AWS CLI

The AWS Command Line Interface (CLI) version 2 is essential for interacting with AWS Ground Station Digital Twin.

### Installation

#### macOS

**GUI Installer (Recommended)**
1. Download the macOS pkg file: [https://awscli.amazonaws.com/AWSCLIV2.pkg](https://awscli.amazonaws.com/AWSCLIV2.pkg)
2. Run the downloaded file and follow the on-screen instructions
3. The installer automatically creates a symlink at `/usr/local/bin/aws`

**Command Line Installer**
```bash
curl "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o "AWSCLIV2.pkg"
sudo installer -pkg AWSCLIV2.pkg -target /
```

**Note**: AWS CLI version 2 supports macOS 11 and later.

#### Linux

**Quick Installation**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

**To Update Existing Installation**
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update
```

#### Windows

Download and run the AWS CLI MSI installer:
[https://awscli.amazonaws.com/AWSCLIV2.msi](https://awscli.amazonaws.com/AWSCLIV2.msi)

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

### Extended Permissions for Full Digital Twin Access

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

Install the latest version of Boto3:

```bash
pip install boto3
```

Or specify a minimum version:

```bash
pip install 'boto3>=1.26.0'
```

### Node.js

Install the AWS SDK for JavaScript v3:

```bash
npm install @aws-sdk/client-groundstation
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
- AWS Ground Station API endpoints (HTTPS port 443)
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

## Service Quotas

AWS Ground Station has the following default service quotas:

| Quota | Default Value | Adjustable |
|-------|--------------|------------|
| Configs | 100 | Yes |
| Contact Lead Time Maximum | 7 days | Yes |
| Dataflow Endpoint Groups | 100 | Yes |
| Dataflow Endpoints per Group | 20 | Yes |
| Enabled Ephemerides | 30 | Yes |
| Maximum Contact Duration | 20 minutes | Yes |
| Mission Profiles | 100 | Yes |
| Scheduled Contacts | 100 | Yes |
| Scheduled Minutes | 1,000 | Yes |

To request quota increases, use the [Service Quotas console](https://console.aws.amazon.com/servicequotas/).

## Verification Checklist

Before proceeding to onboarding, verify:

- [ ] AWS CLI version 2 installed and configured
- [ ] AWS account has appropriate permissions
- [ ] Network connectivity to AWS services confirmed
- [ ] Basic satellite communications knowledge acquired
- [ ] Development environment set up
- [ ] Service quotas reviewed

## Getting Help

If you encounter issues with prerequisites:

1. **AWS CLI Issues**: Check the [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
2. **Permission Issues**: Review [AWS IAM documentation](https://docs.aws.amazon.com/iam/)
3. **Network Issues**: Consult your network administrator
4. **General Questions**: Contact aws-groundstation@amazon.com

## Next Steps

Once all prerequisites are met, proceed to [Onboarding](02-onboarding.md) to begin using AWS Ground Station Digital Twin.

## AWS Documentation References

- [Installing or updating to the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS Ground Station endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/gs.html)
- [AWS Ground Station User Guide](https://docs.aws.amazon.com/ground-station/latest/ug/)
- [AWS IAM User Guide](https://docs.aws.amazon.com/iam/)
