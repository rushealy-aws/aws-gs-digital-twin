# Prerequisites

Before you begin using AWS Ground Station Digital Twin, ensure you have the following prerequisites in place:

## AWS Account Requirements

- An active AWS account with appropriate permissions
- AWS Ground Station service enabled for your account
- Service quotas reviewed and increased if necessary

## Technical Requirements

- AWS CLI installed and configured (version 2.0 or later recommended)
- Python 3.6 or later (for SDK usage)
- AWS SDK for your preferred programming language
- Network connectivity to AWS Ground Station endpoints

## Knowledge Prerequisites

- Basic understanding of satellite communications concepts
- Familiarity with AWS services and IAM permissions
- Understanding of ephemeris data formats and parameters

## Supported Regions

AWS Ground Station Digital Twin is available in the following AWS regions:

- US East (Ohio) - us-east-2
- US West (Oregon) - us-west-2
- Europe (Ireland) - eu-west-1
- Asia Pacific (Sydney) - ap-southeast-2

Ensure that your AWS account is configured to use one of these regions when working with Ground Station Digital Twin.

## Required Information

Before proceeding with onboarding, gather the following information:

- Satellite NORAD IDs
- Frequency bands and ranges for your satellite communications
- Antenna specifications and requirements
- Contact scheduling requirements
- Dataflow endpoint details

## Next Steps

Once you have confirmed all prerequisites are met, proceed to the [Onboarding](02-onboarding.md) section to begin setting up AWS Ground Station Digital Twin for your account.

## AWS Documentation References

- [AWS Ground Station User Guide](https://docs.aws.amazon.com/ground-station/latest/ug/what-is-aws-ground-station.html)
- [AWS Ground Station Service Quotas](https://docs.aws.amazon.com/general/latest/gr/groundstation.html)
- [AWS Regions and Endpoints](https://docs.aws.amazon.com/general/latest/gr/rande.html#groundstation_region)
- [AWS CLI Installation Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html)
