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

## Installing the AWS CLI

The AWS Command Line Interface (CLI) is essential for interacting with AWS Ground Station Digital Twin. Follow these steps to install and configure it on your local machine:

### For macOS

Using Homebrew:
```bash
brew install awscli
```

Using the official installer:
1. Download the macOS pkg file from the [AWS CLI download page](https://aws.amazon.com/cli/)
2. Run the downloaded installer and follow the on-screen instructions
3. Verify the installation:
   ```bash
   aws --version
   ```

### For Windows

1. Download the Windows installer (64-bit) from the [AWS CLI download page](https://aws.amazon.com/cli/)
2. Run the downloaded MSI installer and follow the installation wizard
3. Open Command Prompt or PowerShell and verify the installation:
   ```
   aws --version
   ```

### For Linux

Using package manager (Ubuntu/Debian):
```bash
sudo apt-get update
sudo apt-get install awscli
```

Using package manager (Amazon Linux/RHEL/CentOS):
```bash
sudo yum install awscli
```

Using the bundled installer:
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
```

## Setting Up AWS Credentials

After installing the AWS CLI, you need to configure it with your AWS account credentials:

### Step 1: Create an IAM User with Appropriate Permissions

1. Sign in to the AWS Management Console
2. Navigate to the IAM service
3. Click "Users" in the left navigation pane, then "Add user"
4. Enter a username and select "Programmatic access"
5. Attach policies that include the necessary Ground Station permissions:
   - `AmazonGroundStationFullAccess`
   - `AmazonEC2FullAccess` (for dataflow endpoints)
   - `AmazonS3FullAccess` (for data storage)
6. Complete the user creation process
7. **Important**: Save the displayed Access Key ID and Secret Access Key securely

### Step 2: Configure the AWS CLI

Run the following command and follow the prompts:
```bash
aws configure
```

You'll be asked to provide:
- AWS Access Key ID
- AWS Secret Access Key
- Default region name (use one of the supported regions, e.g., `us-west-2`)
- Default output format (recommended: `json`)

### Step 3: Verify Configuration

Test your configuration with a simple command:
```bash
aws sts get-caller-identity
```

This should return your AWS account ID, IAM user ARN, and user ID.

### Step 4: Create Named Profiles (Optional)

If you work with multiple AWS accounts or need different permission sets, create named profiles:
```bash
aws configure --profile groundstation-dev
```

To use a named profile with commands:
```bash
aws groundstation list-satellites --profile groundstation-dev
```

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
- [AWS CLI Configuration Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)
- [IAM Best Practices](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
