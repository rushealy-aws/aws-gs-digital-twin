# Changelog

All notable changes to the AWS Ground Station Digital Twin Guide.

## [2.1.0] - 2025-12-09

### Changed
- **Complete Documentation Refresh**: Updated all core documentation files using latest AWS official documentation
- **AWS CLI Installation**: Updated to AWS CLI v2 with current installation instructions for macOS, Linux, and Windows
- **Regional Availability**: Updated with current AWS Ground Station regions and endpoints
- **Service Quotas**: Added current AWS Ground Station service quotas and limits
- **API References**: Updated all API examples with latest parameters and best practices

### Updated Files

#### Core Documentation
- `README.md`: Complete rewrite with current Digital Twin features, use cases, and sample code
- `docs/01-prerequisites.md`: Updated AWS CLI v2 installation, SDK versions, regional availability, and service quotas
- `docs/02-onboarding.md`: Updated onboarding process, digital twin ground station characteristics, and EventBridge integration
- `docs/03-using-digital-twin.md`: Updated API references, contact states, EventBridge patterns, and monitoring best practices

### Key Updates

#### Prerequisites
- AWS CLI v2 installation instructions for all platforms
- Python 3.8+ requirement (updated from 3.7+)
- Current AWS SDK versions (Boto3 1.26.0+, AWS SDK for JavaScript v3)
- Updated service quotas table with adjustable limits
- macOS 11+ support requirement for AWS CLI v2

#### Onboarding
- Clarified digital twin onboarding request process
- Added digital twin ground station naming convention details
- Updated mission profile configuration examples
- Added EventBridge integration setup
- Included verification and testing procedures

#### Using Digital Twin
- Added complete contact state lifecycle table
- Updated API examples for ListGroundStations, ReserveContact, DescribeContact
- Added EventBridge event patterns for monitoring
- Included best practices for contact scheduling
- Added troubleshooting section with common issues

#### README
- Added "What is AWS Ground Station Digital Twin?" section
- Included key benefits and important limitations
- Added use cases (pre-launch testing, configuration changes, DevOps integration)
- Updated sample code for Python and AWS CLI
- Added comprehensive resource links to AWS documentation

### AWS Documentation Sources
All updates verified against official AWS documentation:
- [Use the AWS Ground Station digital twin feature](https://docs.aws.amazon.com/ground-station/latest/ug/digital-twin.html)
- [Installing or updating to the latest version of the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [AWS Ground Station endpoints and quotas](https://docs.aws.amazon.com/general/latest/gr/gs.html)
- [ReserveContact API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ReserveContact.html)
- [DescribeContact API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_DescribeContact.html)
- [Automate AWS Ground Station with Events](https://docs.aws.amazon.com/ground-station/latest/ug/monitoring.automating-events.html)

### Technical Improvements
- All code samples verified against current AWS APIs
- Updated Python examples for current boto3 version
- CLI examples tested with AWS CLI v2
- Added contact state management best practices
- Improved EventBridge integration examples

## [2.0.0] - 2025-08-08

### Changed
- **License**: Updated from Creative Commons Attribution 4.0 to MIT License
- **Documentation**: Completely revised all documentation to align with current AWS Ground Station documentation
- **FAQ**: Numbered all questions (1-33) for easier reference
- **Orbital Support**: Removed references to GEO (Geostationary Orbit) and HEO (Highly Elliptical Orbit) simulations, focusing on LEO and MEO
- **Frequency Bands**: Removed all references to Ka-band, focusing on S-band and X-band support
- **Contact Availability**: Removed any references to contacts being unavailable, as this does not occur with Digital Twin

### Updated Files

#### Core Documentation
- `README.md`: Updated introduction and license badge
- `LICENSE`: Changed to MIT License
- `docs/01-prerequisites.md`: Updated with current AWS CLI installation and IAM requirements
- `docs/02-onboarding.md`: Aligned with current AWS Ground Station onboarding process
- `docs/03-using-digital-twin.md`: Updated with current Digital Twin capabilities and limitations
- `docs/05-customer-provided-ephemeris.md`: Updated with current ephemeris API and formats
- `docs/08-faq.md`: Numbered questions and removed GEO/HEO references
- `docs/09-resources.md`: Updated with current AWS documentation links and code samples

### Key Updates Based on AWS Documentation

#### Digital Twin Capabilities
- Clarified that Digital Twin does not support actual data delivery
- Updated ground station naming convention (prefixed with "Digital Twin ")
- Emphasized testing and validation purposes

#### Ephemeris Management
- Updated with current ephemeris API requirements
- Added OEM format specifications per CCSDS standard
- Included ephemeris validation workflow information

#### API and CLI Usage
- Updated all code samples with current API parameters
- Added proper error handling examples
- Included CloudWatch Events integration

#### Onboarding Process
- Updated contact information (aws-groundstation@amazon.com)
- Clarified manual onboarding process
- Updated IAM permission requirements

### Technical Improvements
- All code samples tested for current API compatibility
- CloudFormation templates updated with current resource types
- Python examples updated for boto3 current version
- CLI examples verified against AWS CLI v2

### Documentation Standards
- Consistent formatting across all documents
- Updated AWS documentation links to current URLs
- Improved code block formatting and syntax highlighting
- Added proper error handling in examples

### Removed Content
- References to unavailable contacts (not applicable to Digital Twin)
- GEO and HEO simulation capabilities
- Outdated API parameters and methods
- Deprecated configuration options

### AWS Documentation Sources
All updates based on official AWS documentation:
- [AWS Ground Station Digital Twin](https://docs.aws.amazon.com/ground-station/latest/ug/digital-twin.html)
- [Onboard Satellite](https://docs.aws.amazon.com/ground-station/latest/ug/getting-started.step1.html)
- [Provide Custom Ephemeris Data](https://docs.aws.amazon.com/ground-station/latest/ug/providing-custom-ephemeris-data.html)
- [AWS Ground Station API Reference](https://docs.aws.amazon.com/ground-station/latest/APIReference/)

### Migration Notes
Users upgrading from version 1.x should:
1. Review updated IAM permissions
2. Update any hardcoded orbital type references
3. Verify ephemeris upload procedures
4. Test CLI commands with updated parameters
