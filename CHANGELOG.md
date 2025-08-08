# Changelog

All notable changes to the AWS Ground Station Digital Twin Guide.

## [2.0.0] - 2025-08-08

### Changed
- **License**: Updated from Creative Commons Attribution 4.0 to MIT License
- **Documentation**: Completely revised all documentation to align with current AWS Ground Station documentation
- **FAQ**: Numbered all questions (1-33) for easier reference
- **Orbital Support**: Removed references to GEO (Geostationary Orbit) and HEO (Highly Elliptical Orbit) simulations, focusing on LEO and MEO
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
