# Using AWS Ground Station Digital Twin

This document provides a comprehensive guide on how to use AWS Ground Station Digital Twin after completing the onboarding process.

## Overview

The AWS Ground Station digital twin feature provides an environment where you can test and integrate your satellite mission management and command and control software without using production antenna capacity. Testing your AWS Ground Station integration with the digital twin feature enables you to have increased confidence in your system's ability to manage your satellite operations smoothly.

**Key Benefits:**
- Test scheduling and configurations without using production capacity
- Validate AWS Ground Station APIs without spectrum licensing requirements
- Verify mission profiles and dataflow configurations
- Test error handling and recovery procedures
- Fine-tune configurations using EventBridge events and API responses

**Important Limitation:** At this time, the digital twin feature does not support data delivery as described in standard AWS Ground Station dataflows.

## Console Overview

The AWS Ground Station console provides access to Digital Twin functionality through the main Ground Station interface. Key sections include:

- **Satellites**: View and manage your onboarded satellites
- **Contacts**: Schedule and monitor contacts with digital twin ground stations
- **Mission Profiles**: Define mission-specific configurations
- **Config Profiles**: Manage configuration profiles for different scenarios
- **Dataflow Endpoint Groups**: Configure data delivery endpoints (for testing purposes)

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

The response includes both production and digital twin ground stations. Filter for digital twin stations by looking for the "Digital Twin " prefix.

### Understanding Digital Twin Capabilities

Digital twin ground stations are exact copies of production ground stations with the following characteristics:

- **Naming Convention**: Prefixed with "Digital Twin " (e.g., "Digital Twin Oregon 1")
- **Antenna Capabilities**: Same as production ground stations
- **Metadata**: Includes actual GPS coordinates and site mask information
- **Technical Specifications**: Identical frequency bands, polarization, and EIRP

**What Digital Twin Provides:**
- Testing environment for scheduling and configurations
- API testing without spectrum licensing requirements
- Configuration verification for mission profiles
- Error handling and recovery testing
- EventBridge event emission identical to production

**What Digital Twin Does Not Provide:**
- Actual data delivery from satellites
- Real RF signal processing
- Production antenna capacity

## Scheduling Contacts

### Prerequisites

Before scheduling contacts, ensure you have:
- Completed satellite onboarding for digital twin access
- Created mission profiles
- Configured dataflow endpoint groups (for testing purposes)
- Valid ephemeris data (TLE, OEM, or azimuth/elevation)

### Using the Console

1. Navigate to the **Contacts** section in the AWS Ground Station console
2. Click **Schedule Contact**
3. Select your satellite from the dropdown
4. Choose a digital twin ground station (prefixed with "Digital Twin ")
5. Select your mission profile
6. Choose the contact time window
7. Review and confirm the contact

### Using the AWS CLI

#### List Available Contact Windows

```bash
aws groundstation list-contacts \
  --status-list AVAILABLE \
  --start-time "2024-12-15T00:00:00Z" \
  --end-time "2024-12-16T00:00:00Z" \
  --region us-west-2
```

#### Reserve a Contact

```bash
aws groundstation reserve-contact \
  --mission-profile-arn "arn:aws:groundstation:us-west-2:123456789012:mission-profile/12345678-1234-1234-1234-123456789012" \
  --satellite-arn "arn:aws:groundstation:us-west-2:123456789012:satellite/12345678-1234-1234-1234-123456789012" \
  --start-time "2024-12-15T10:00:00Z" \
  --end-time "2024-12-15T10:15:00Z" \
  --ground-station "Digital Twin Oregon 1" \
  --region us-west-2
```

#### Verify Contact Status

After reserving a contact, verify it reaches the `SCHEDULED` state:

```bash
aws groundstation describe-contact \
  --contact-id <contact-id> \
  --region us-west-2
```

### Contact States

Contacts progress through the following states:

| State | Description |
|-------|-------------|
| `SCHEDULING` | Contact is being scheduled |
| `SCHEDULED` | Contact successfully scheduled |
| `FAILED_TO_SCHEDULE` | Contact could not be scheduled |
| `PREPASS` | Pre-pass activities in progress |
| `PASS` | Contact in progress |
| `POSTPASS` | Post-pass activities in progress |
| `COMPLETED` | Contact completed successfully |
| `CANCELLED` | Contact cancelled by user |
| `AWS_CANCELLED` | Contact cancelled by AWS |
| `FAILED` | Contact failed due to client/user error |
| `AWS_FAILED` | Contact failed due to service error |

### Best Practices for Contact Scheduling

1. **Verify Contact Status**: Always check that contacts reach `SCHEDULED` state after reservation
2. **Monitor with EventBridge**: Set up EventBridge rules to monitor contact state changes
3. **Reserve in Advance**: Schedule contacts well ahead of time (within the 7-day lead time limit)
4. **Handle Failures**: Implement retry logic for `FAILED_TO_SCHEDULE` states
5. **Ephemeris Validation**: Ensure ephemeris is in `ENABLED` state before reserving contacts

## Monitoring and Events

### EventBridge Integration

AWS Ground Station Digital Twin emits the same Amazon EventBridge events as the production service. This allows you to fine-tune your configurations and automate workflows.

#### Contact State Change Events

```json
{
  "source": ["aws.groundstation"],
  "detail-type": ["Ground Station Contact State Change"],
  "detail": {
    "contactId": {"exists": true},
    "contactStatus": ["SCHEDULED", "PREPASS", "PASS", "POSTPASS", "COMPLETED", "FAILED"]
  }
}
```

#### Setting Up Event Rules

Create an EventBridge rule to monitor digital twin activities:

```bash
aws events put-rule \
  --name "GroundStationDigitalTwinMonitor" \
  --event-pattern '{
    "source": ["aws.groundstation"],
    "detail-type": ["Ground Station Contact State Change"]
  }' \
  --region us-west-2
```

Add a target (e.g., Lambda function, SNS topic):

```bash
aws events put-targets \
  --rule "GroundStationDigitalTwinMonitor" \
  --targets "Id"="1","Arn"="arn:aws:lambda:us-west-2:123456789012:function:ProcessContactEvents" \
  --region us-west-2
```

### CloudWatch Logs

Monitor digital twin activities through CloudWatch logs:
- Contact execution logs
- Configuration validation logs
- Error and debugging information

For more information, see [Automate AWS Ground Station with Events](https://docs.aws.amazon.com/ground-station/latest/ug/monitoring.automating-events.html).

## API Reference

### Key APIs for Digital Twin

All standard AWS Ground Station APIs work with digital twin resources. The digital twin feature emits the same API responses as the production service.

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

#### Ground Station Information

```python
# List ground stations (including digital twin stations)
ground_stations = client.list_ground_stations()

# Filter for digital twin stations
digital_twin_stations = [
    gs for gs in ground_stations['groundStationList']
    if gs['groundStationName'].startswith('Digital Twin ')
]

print(f"Found {len(digital_twin_stations)} digital twin ground stations")
```

#### Contact Management

```python
# List contacts
contacts = client.list_contacts(
    statusList=['SCHEDULED', 'PASS_COMPLETED']
)

# Reserve a contact
reserve_response = client.reserve_contact(
    missionProfileArn='arn:aws:groundstation:us-west-2:123456789012:mission-profile/12345678-1234-1234-1234-123456789012',
    satelliteArn='arn:aws:groundstation:us-west-2:123456789012:satellite/12345678-1234-1234-1234-123456789012',
    startTime='2024-12-15T10:00:00Z',
    endTime='2024-12-15T10:15:00Z',
    groundStation='Digital Twin Oregon 1'
)

contact_id = reserve_response['contactId']

# Describe contact
contact_details = client.describe_contact(
    contactId=contact_id
)

print(f"Contact status: {contact_details['contactStatus']}")
```

#### Mission Profile Management

```python
# List mission profiles
mission_profiles = client.list_mission_profiles()

# Get mission profile details
profile_details = client.get_mission_profile(
    missionProfileId='12345678-1234-1234-1234-123456789012'
)
```

## CLI Commands

### Essential Commands

```bash
# List satellites
aws groundstation list-satellites --region us-west-2

# List ground stations (including digital twin)
aws groundstation list-ground-stations --region us-west-2

# List contacts with specific status
aws groundstation list-contacts \
  --status-list SCHEDULED COMPLETED \
  --region us-west-2

# Describe a specific contact
aws groundstation describe-contact \
  --contact-id <contact-id> \
  --region us-west-2

# Cancel a contact
aws groundstation cancel-contact \
  --contact-id <contact-id> \
  --region us-west-2

# List mission profiles
aws groundstation list-mission-profiles --region us-west-2

# List config profiles
aws groundstation list-configs --region us-west-2
```

### Configuration Management

```bash
# Create a tracking config
aws groundstation create-config \
  --name "DigitalTwinTrackingConfig" \
  --config-data '{
    "trackingConfig": {
      "autotrack": "REQUIRED"
    }
  }' \
  --region us-west-2

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
5. **EventBridge Monitoring**: Set up automated monitoring for all contact state changes

### Resource Management

1. **Naming Conventions**: Use clear, descriptive names for test resources
2. **Tagging**: Tag resources for easy identification and cost tracking
3. **Cleanup**: Remove test resources when no longer needed
4. **Documentation**: Document test scenarios and expected outcomes
5. **Version Control**: Store mission profiles and configs in version control

### Monitoring and Observability

1. **Event Monitoring**: Set up EventBridge rules for automated monitoring
2. **Log Analysis**: Regularly review CloudWatch logs for issues
3. **Metrics Tracking**: Track contact success rates and configuration validation
4. **Alerting**: Set up alerts for critical test failures
5. **CloudTrail**: Enable CloudTrail logging for audit and compliance

### Contact Scheduling Best Practices

1. **Verify Ephemeris**: Ensure ephemeris is in `ENABLED` state before scheduling
2. **Check Contact Status**: Always verify contacts reach `SCHEDULED` state
3. **Implement Retries**: Add retry logic for `FAILED_TO_SCHEDULE` states
4. **Reserve Early**: Schedule contacts well in advance (within 7-day lead time)
5. **Monitor State Changes**: Use EventBridge to track contact progression

## Troubleshooting

### Common Issues

1. **Ground Station Not Found**
   - Verify you're looking for stations prefixed with "Digital Twin "
   - Check that you're using the correct AWS region
   - Confirm your satellite is onboarded to the digital twin feature

2. **Contact Scheduling Fails**
   - Verify satellite onboarding and ephemeris data
   - Check mission profile and config profile settings
   - Ensure contact time is within allowed lead time (7 days)
   - Verify ephemeris is in `ENABLED` state

3. **Configuration Errors**
   - Review mission profile dataflow edges
   - Check tracking config settings
   - Verify dataflow endpoint group configuration

4. **Permission Issues**
   - Review IAM policies for required permissions
   - Verify service role trust relationships
   - Check permissions for EventBridge and CloudWatch

### Getting Help

- **CloudWatch Logs**: Check for detailed error messages
- **EventBridge Events**: Monitor for `FAILED_TO_SCHEDULE` events
- **Troubleshooting Guide**: See [Troubleshooting](06-troubleshooting.md)
- **AWS Support**: Contact aws-groundstation@amazon.com for onboarding issues

## Next Steps

After familiarizing yourself with basic Digital Twin operations:

1. Explore [Uplink Configuration](04-uplink-configuration.md) for advanced testing
2. Learn about [Customer-Provided Ephemeris](05-customer-provided-ephemeris.md) for accurate simulations
3. Review [Best Practices](07-best-practices.md) for optimal usage
4. Check the [FAQ](08-faq.md) for common questions

## AWS Documentation References

- [Use the AWS Ground Station digital twin feature](https://docs.aws.amazon.com/ground-station/latest/ug/digital-twin.html)
- [ListGroundStations API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ListGroundStations.html)
- [ReserveContact API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ReserveContact.html)
- [DescribeContact API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_DescribeContact.html)
- [Automate AWS Ground Station with Events](https://docs.aws.amazon.com/ground-station/latest/ug/monitoring.automating-events.html)
- [Work with contacts](https://docs.aws.amazon.com/ground-station/latest/ug/contacts.html)
