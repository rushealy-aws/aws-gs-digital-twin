# Using AWS Ground Station Digital Twin

This document provides a comprehensive guide on how to use AWS Ground Station Digital Twin after completing the onboarding process.

## Console Overview

The AWS Ground Station console provides access to Digital Twin functionality through the main Ground Station interface. Key sections include:

- **Satellites**: View and manage your onboarded satellites
- **Contacts**: Schedule and monitor contacts with digital twin ground stations
- **Mission Profiles**: Define mission-specific configurations
- **Config Profiles**: Manage configuration profiles for different scenarios
- **Dataflow Endpoint Groups**: Configure data delivery endpoints

### Accessing Digital Twin

1. Log in to the AWS Management Console
2. Navigate to AWS Ground Station at https://console.aws.amazon.com/groundstation/
3. Access digital twin ground stations through the standard Ground Station interface
4. Digital twin ground stations are prefixed with "Digital Twin " in their names

## Working with Digital Twin Ground Stations

### Listing Available Ground Stations

Use the AWS CLI to see available digital twin ground stations:

```bash
aws groundstation list-ground-stations --region us-west-2
```

Digital twin ground stations are exact copies of production ground stations with the prefix "Digital Twin " added to their names. They include:
- Same antenna capabilities and metadata
- Actual GPS coordinates
- Site mask information
- All technical specifications

### Understanding Digital Twin Capabilities

Digital twin ground stations provide:
- **Testing Environment**: Test scheduling and configurations without using production capacity
- **API Testing**: Validate AWS Ground Station APIs without spectrum licensing requirements
- **Configuration Verification**: Verify mission profiles and dataflow configurations
- **Error Handling**: Test error scenarios and recovery procedures

**Important Note**: The digital twin feature does not support actual data delivery. It's designed for testing and validation purposes.

## Scheduling Contacts

### Prerequisites

Before scheduling contacts, ensure you have:
- Completed satellite onboarding for digital twin access
- Created mission profiles
- Configured dataflow endpoint groups (for testing purposes)
- Uploaded ephemeris data (if using custom ephemeris)

### Using the Console

1. Navigate to the Contacts section in the AWS Ground Station console
2. Click "Schedule Contact"
3. Select your satellite from the dropdown
4. Choose a digital twin ground station (prefixed with "Digital Twin ")
5. Select your mission profile
6. Choose the contact time window
7. Review and confirm the contact

### Using the AWS CLI

```bash
# List available contacts
aws groundstation list-contacts \
  --status-list SCHEDULED PASS_COMPLETED \
  --region us-west-2

# Reserve a contact
aws groundstation reserve-contact \
  --mission-profile-arn "arn:aws:groundstation:us-west-2:123456789012:mission-profile/12345678-1234-1234-1234-123456789012" \
  --satellite-arn "arn:aws:groundstation:us-west-2:123456789012:satellite/12345678-1234-1234-1234-123456789012" \
  --start-time "2024-12-01T10:00:00Z" \
  --end-time "2024-12-01T10:15:00Z" \
  --ground-station "Digital Twin Oregon 1" \
  --region us-west-2
```

## Monitoring and Events

### EventBridge Integration

AWS Ground Station Digital Twin emits the same Amazon EventBridge events as the production service:

- Contact state changes
- Ephemeris validation events
- Configuration validation events

### Setting Up Event Rules

Create EventBridge rules to monitor digital twin activities:

```json
{
  "source": ["aws.groundstation"],
  "detail-type": ["Ground Station Contact State Change"],
  "detail": {
    "contactId": {"exists": true}
  }
}
```

### CloudWatch Logs

Monitor digital twin activities through CloudWatch logs:
- Contact execution logs
- Configuration validation logs
- Error and debugging information

## API Reference

### Key APIs for Digital Twin

All standard AWS Ground Station APIs work with digital twin resources:

#### Satellite Management
```python
import boto3

client = boto3.client('groundstation', region_name='us-west-2')

# List satellites
response = client.list_satellites()

# Get satellite details
satellite_details = client.get_satellite(
    satelliteId='12345678-1234-1234-1234-123456789012'
)
```

#### Contact Management
```python
# List contacts
contacts = client.list_contacts(
    statusList=['SCHEDULED', 'PASS_COMPLETED']
)

# Get contact details
contact_details = client.describe_contact(
    contactId='12345678-1234-1234-1234-123456789012'
)
```

#### Ground Station Information
```python
# List ground stations (including digital twin stations)
ground_stations = client.list_ground_stations()

# Filter for digital twin stations
digital_twin_stations = [
    gs for gs in ground_stations['groundStationList']
    if gs['groundStationName'].startswith('Digital Twin ')
]
```

## CLI Commands

### Essential Commands

```bash
# List satellites
aws groundstation list-satellites --region us-west-2

# List ground stations
aws groundstation list-ground-stations --region us-west-2

# List contacts
aws groundstation list-contacts --status-list SCHEDULED --region us-west-2

# Describe a contact
aws groundstation describe-contact --contact-id <contact-id> --region us-west-2

# List mission profiles
aws groundstation list-mission-profiles --region us-west-2

# List config profiles
aws groundstation list-configs --region us-west-2
```

### Configuration Management

```bash
# Create a mission profile
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

## Best Practices

### Testing Strategy

1. **Start Simple**: Begin with basic contact scheduling and configuration validation
2. **Incremental Testing**: Gradually add complexity to your test scenarios
3. **Error Scenarios**: Test failure conditions and error handling
4. **Automation**: Use APIs and CLI for repeatable testing workflows

### Resource Management

1. **Naming Conventions**: Use clear naming for test resources
2. **Tagging**: Tag resources for easy identification and cost tracking
3. **Cleanup**: Remove test resources when no longer needed
4. **Documentation**: Document test scenarios and expected outcomes

### Monitoring

1. **Event Monitoring**: Set up EventBridge rules for automated monitoring
2. **Log Analysis**: Regularly review CloudWatch logs for issues
3. **Metrics**: Track contact success rates and configuration validation
4. **Alerting**: Set up alerts for critical test failures

## Troubleshooting

### Common Issues

1. **Ground Station Not Found**: Ensure you're looking for stations prefixed with "Digital Twin "
2. **Contact Scheduling Fails**: Verify satellite onboarding and ephemeris data
3. **Configuration Errors**: Check mission profile and config profile settings
4. **Permission Issues**: Verify IAM roles and policies

### Getting Help

- Check CloudWatch logs for detailed error messages
- Review the [Troubleshooting](06-troubleshooting.md) guide
- Contact aws-groundstation@amazon.com for onboarding issues

## Next Steps

After familiarizing yourself with basic Digital Twin operations:

1. Explore [Uplink Configuration](04-uplink-configuration.md) for advanced testing
2. Learn about [Customer-Provided Ephemeris](05-customer-provided-ephemeris.md) for accurate simulations
3. Review [Best Practices](07-best-practices.md) for optimal usage
4. Check the [FAQ](08-faq.md) for common questions

## AWS Documentation References

- [Use the AWS Ground Station digital twin feature](https://docs.aws.amazon.com/ground-station/latest/ug/digital-twin.html)
- [ListGroundStations API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ListGroundStations.html)
- [Automate AWS Ground Station with Events](https://docs.aws.amazon.com/ground-station/latest/ug/monitoring.automating-events.html)
