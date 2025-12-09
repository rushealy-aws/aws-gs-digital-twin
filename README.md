# AWS Ground Station Digital Twin - Getting Started Guide

This repository contains comprehensive documentation for getting started with AWS Ground Station Digital Twin, including onboarding steps, usage guides, and detailed troubleshooting procedures.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Table of Contents

- [Introduction](#introduction)
- [What is AWS Ground Station Digital Twin?](#what-is-aws-ground-station-digital-twin)
- [Key Features](#key-features)
- [Getting Started](#getting-started)
- [Documentation](#documentation)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Resources](#resources)

## Introduction

AWS Ground Station Digital Twin provides an environment where you can test and integrate your satellite mission management and command and control software without using production antenna capacity. The digital twin feature allows you to test scheduling, verification of configurations, and proper error handling. Testing your AWS Ground Station integration with the digital twin feature enables you to have increased confidence in your system's ability to manage your satellite operations smoothly.

## What is AWS Ground Station Digital Twin?

The digital twin feature for AWS Ground Station enables you to:

- **Test and Integrate**: Test your satellite mission management and command and control software in a virtual environment
- **Validate Configurations**: Verify mission profiles, dataflow configurations, and error handling without using production capacity
- **API Testing**: Test AWS Ground Station APIs without requiring spectrum licensing or production antenna time
- **EventBridge Integration**: Receive the same Amazon EventBridge events and API responses as the production service
- **Cost-Effective Development**: Develop and test your ground segment integration before satellite launch

### Key Benefits

✅ **No Production Impact**: Test without using production antenna capacity  
✅ **No Spectrum Licensing Required**: Begin integration and testing immediately  
✅ **Identical API Responses**: Same EventBridge events and API responses as production  
✅ **Exact Ground Station Replicas**: Digital twin ground stations have identical capabilities and metadata  
✅ **Accelerated Development**: Test and validate before satellite launch  

### Important Limitation

⚠️ **Data Delivery Not Supported**: At this time, the digital twin feature does not support actual data delivery as described in standard AWS Ground Station dataflows. The feature is designed for testing scheduling, configurations, and API integration.

## Key Features

### Digital Twin Ground Stations

Digital twin ground stations are exact copies of production ground stations with:
- **Naming Convention**: Prefixed with "Digital Twin " (e.g., "Digital Twin Oregon 1")
- **Antenna Capabilities**: Identical to production ground stations
- **Metadata**: Includes actual GPS coordinates and site mask information
- **Global Coverage**: Available at all AWS Ground Station locations worldwide

### Available Locations

Digital twin ground stations are available at the following AWS Ground Station locations:

- **US East**: Ohio, N. Virginia
- **US West**: Oregon, Hawaii, Alaska
- **Africa**: Cape Town
- **Asia Pacific**: Dubbo, Seoul, Singapore
- **Europe**: Ireland, Stockholm
- **Middle East**: Bahrain
- **South America**: Punta Arenas

### EventBridge Integration

The digital twin feature emits the same Amazon EventBridge events as the production service, including:
- Contact state changes
- Ephemeris validation events
- Configuration validation events

This allows you to fine-tune your configurations and automate workflows before production deployment.

## Getting Started

### Prerequisites

Before you begin, ensure you have:

1. **AWS Account**: An active AWS account with appropriate permissions
2. **AWS CLI**: AWS CLI version 2 installed and configured
3. **Ground Station Access**: Onboarding to AWS Ground Station (contact aws-groundstation@amazon.com)
4. **Digital Twin Access**: Request digital twin feature access during onboarding

See [Prerequisites](docs/01-prerequisites.md) for detailed requirements.

### Quick Start

1. **Request Access**: Email aws-groundstation@amazon.com to onboard your satellite to the digital twin feature
2. **Verify Access**: List available digital twin ground stations
   ```bash
   aws groundstation list-ground-stations --region us-west-2
   ```
3. **Create Mission Profile**: Configure your mission profile for testing
4. **Schedule Contact**: Reserve a contact with a digital twin ground station
   ```bash
   aws groundstation reserve-contact \
     --mission-profile-arn <mission-profile-arn> \
     --satellite-arn <satellite-arn> \
     --start-time "2024-12-15T10:00:00Z" \
     --end-time "2024-12-15T10:15:00Z" \
     --ground-station "Digital Twin Oregon 1" \
     --region us-west-2
   ```
5. **Monitor Events**: Set up EventBridge rules to monitor contact state changes

## Documentation

### Core Documentation

- **[Prerequisites](docs/01-prerequisites.md)**: AWS account requirements, CLI installation, IAM permissions, and SDK setup
- **[Onboarding](docs/02-onboarding.md)**: Step-by-step onboarding process for digital twin access
- **[Using Digital Twin](docs/03-using-digital-twin.md)**: Console overview, API reference, CLI commands, and best practices
- **[Uplink Configuration](docs/04-uplink-configuration.md)**: Setting up and testing uplink capabilities
- **[Customer-Provided Ephemeris](docs/05-customer-provided-ephemeris.md)**: Ephemeris formats, uploading, and validation

### Additional Resources

- **[Troubleshooting](docs/06-troubleshooting.md)**: Common issues, error codes, and support channels
- **[Best Practices](docs/07-best-practices.md)**: Recommended practices for digital twin usage
- **[FAQ](docs/08-faq.md)**: Frequently asked questions
- **[Resources](docs/09-resources.md)**: Additional AWS Ground Station resources and links

## Prerequisites

### Required

- AWS account with Ground Station access
- AWS CLI version 2 (latest)
- Python 3.8+ (for SDK usage)
- Basic understanding of satellite communications

### IAM Permissions

Minimum required permissions:

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

See [Prerequisites](docs/01-prerequisites.md) for complete IAM policy examples.

## Use Cases

### Pre-Launch Testing

Test your ground segment integration before satellite launch:
- Validate mission profiles and configurations
- Test command and control software
- Verify API integration and error handling
- Develop automated workflows

### Configuration Changes

Test configuration changes without impacting production:
- Validate mission profile updates
- Test new dataflow configurations
- Verify ephemeris handling
- Test failover scenarios

### DevOps Integration

Integrate digital twin into your CI/CD pipeline:
- Automated testing of infrastructure as code
- Configuration validation in non-production environments
- Integration testing before production deployment
- Continuous validation of ground segment changes

### Training and Development

Use digital twin for team training and development:
- Onboard new team members
- Practice operational procedures
- Test new features and capabilities
- Develop and test automation scripts

## Sample Code

### Python (Boto3)

```python
import boto3

client = boto3.client('groundstation', region_name='us-west-2')

# List digital twin ground stations
response = client.list_ground_stations()
digital_twin_stations = [
    gs for gs in response['groundStationList']
    if gs['groundStationName'].startswith('Digital Twin ')
]

print(f"Found {len(digital_twin_stations)} digital twin ground stations")

# Reserve a contact
reserve_response = client.reserve_contact(
    missionProfileArn='arn:aws:groundstation:us-west-2:123456789012:mission-profile/abc123',
    satelliteArn='arn:aws:groundstation:us-west-2:123456789012:satellite/xyz789',
    startTime='2024-12-15T10:00:00Z',
    endTime='2024-12-15T10:15:00Z',
    groundStation='Digital Twin Oregon 1'
)

print(f"Contact ID: {reserve_response['contactId']}")
```

### AWS CLI

```bash
# List satellites
aws groundstation list-satellites --region us-west-2

# List ground stations (including digital twin)
aws groundstation list-ground-stations --region us-west-2

# Reserve a contact
aws groundstation reserve-contact \
  --mission-profile-arn "arn:aws:groundstation:us-west-2:123456789012:mission-profile/abc123" \
  --satellite-arn "arn:aws:groundstation:us-west-2:123456789012:satellite/xyz789" \
  --start-time "2024-12-15T10:00:00Z" \
  --end-time "2024-12-15T10:15:00Z" \
  --ground-station "Digital Twin Oregon 1" \
  --region us-west-2

# Describe contact
aws groundstation describe-contact \
  --contact-id <contact-id> \
  --region us-west-2
```

## Resources

### AWS Documentation

- [Use the AWS Ground Station digital twin feature](https://docs.aws.amazon.com/ground-station/latest/ug/digital-twin.html)
- [AWS Ground Station User Guide](https://docs.aws.amazon.com/ground-station/latest/ug/)
- [AWS Ground Station API Reference](https://docs.aws.amazon.com/ground-station/latest/APIReference/)
- [AWS Ground Station Locations](https://docs.aws.amazon.com/ground-station/latest/ug/aws-ground-station-antenna-locations.html)
- [AWS Ground Station endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/gs.html)

### AWS Blogs

- [Test and integrate ground segment with AWS Ground Station digital twin](https://aws.amazon.com/blogs/publicsector/test-and-integrate-ground-segment-with-aws-ground-station-digital-twin/)
- [Digital twin is now generally available for AWS Ground Station](https://aws.amazon.com/about-aws/whats-new/2024/08/digital-twin-available-aws-ground-station/)

### Additional Resources

- [AWS Ground Station Features](https://aws.amazon.com/ground-station/features/)
- [AWS Ground Station Pricing](https://aws.amazon.com/ground-station/pricing/)
- [AWS CLI User Guide](https://docs.aws.amazon.com/cli/latest/userguide/)
- [Boto3 Documentation](https://boto3.amazonaws.com/v1/documentation/api/latest/index.html)

## Support

### Getting Help

- **Documentation Issues**: Open an issue in this repository
- **AWS Ground Station Questions**: Contact aws-groundstation@amazon.com
- **AWS Support**: Use the [AWS Support Center](https://console.aws.amazon.com/support/)
- **Community**: Engage with the AWS community on [re:Post](https://repost.aws/)

### Onboarding Support

To request access to AWS Ground Station Digital Twin:
1. Email aws-groundstation@amazon.com
2. Include your organization name, satellite details, and confirmation that you want digital twin access
3. Follow the onboarding process outlined in [Onboarding](docs/02-onboarding.md)

## Contributing

Contributions to improve this documentation are welcome! Please:
1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a history of changes to this documentation.

---

**Note**: This is community-maintained documentation for AWS Ground Station Digital Twin. For official AWS documentation, please refer to the [AWS Ground Station User Guide](https://docs.aws.amazon.com/ground-station/latest/ug/).
