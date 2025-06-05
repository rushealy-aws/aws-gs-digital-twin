# Uplink Configuration

This document provides detailed instructions for configuring and using uplink capabilities with AWS Ground Station Digital Twin.

## Understanding Uplink in Digital Twin

Uplink refers to the transmission of data from a ground station to a satellite. In AWS Ground Station Digital Twin, you can simulate uplink operations to test command and control systems before deploying them in production environments.

Key benefits of testing uplink with Digital Twin:
- Validate command sequences without risk to actual satellites
- Test edge cases and failure scenarios
- Verify timing and sequencing of commands
- Ensure compatibility between ground systems and satellite systems

## Setting Up Uplink

### Step 1: Create an Uplink Config

1. Navigate to the AWS Ground Station console
2. Select "Config Profiles" from the left navigation pane
3. Click "Create Config"
4. Select "Uplink Config" as the config type
5. Configure the following parameters:
   - Config name (e.g., "UplinkTestConfig")
   - Target satellite
   - Frequency (MHz)
   - Bandwidth (MHz)
   - Polarization (RHCP/LHCP)
   - EIRP (dBW)
6. Click "Create Config"

### Step 2: Associate Uplink Config with Mission Profile

1. Navigate to "Mission Profiles"
2. Select your existing mission profile or create a new one
3. Click "Edit"
4. In the "Uplink Configs" section, add your newly created uplink config
5. Click "Save changes"

### Step 3: Configure Dataflow Endpoints for Uplink

```bash
aws groundstation create-dataflow-endpoint-group \
  --endpoint-details '[{
    "endpoint": {
      "name": "UplinkEndpoint",
      "awsEc2": {
        "securityGroupIds": ["sg-1234567890abcdef0"],
        "subnetId": "subnet-1234567890abcdef0"
      }
    }
  }]' \
  --region <region>
```

## Uplink Waveforms

AWS Ground Station Digital Twin supports various uplink waveforms and modulation schemes:

### Supported Modulation Types

- BPSK (Binary Phase Shift Keying)
- QPSK (Quadrature Phase Shift Keying)
- 8PSK (8-Phase Shift Keying)
- 16APSK (16-Amplitude Phase Shift Keying)
- FM (Frequency Modulation)

### Configuring Custom Waveforms

1. Navigate to "Config Profiles"
2. Select your uplink config
3. Click "Edit"
4. In the "Advanced Settings" section, configure:
   - Modulation scheme
   - Symbol rate
   - FEC coding
   - Spectral mask
5. Click "Save changes"

### Waveform Templates

AWS Ground Station Digital Twin provides pre-configured waveform templates for common satellite platforms:

```bash
aws groundstation list-waveform-templates --region <region>
```

To use a template:

```bash
aws groundstation get-waveform-template \
  --template-id <template-id> \
  --region <region>
```

## Uplink Scheduling

### Scheduling an Uplink Contact

1. Navigate to "Contacts" in the console
2. Click "Reserve Contact"
3. Select:
   - Satellite
   - Mission profile (with uplink config)
   - Ground station location
   - Contact time window
4. Enable "Include Uplink" option
5. Click "Reserve"

### Programmatic Scheduling

```python
import boto3
import datetime

client = boto3.client('groundstation', region_name='us-west-2')

response = client.reserve_contact(
    satelliteId='sat-1234567890abcdef0',
    missionProfileId='mp-1234567890abcdef0',
    groundStation='Ohio-1',
    startTime=datetime.datetime.now() + datetime.timedelta(hours=2),
    endTime=datetime.datetime.now() + datetime.timedelta(hours=2, minutes=15),
    uplinkEnabled=True
)

contact_id = response['contactId']
print(f"Reserved uplink contact: {contact_id}")
```

## Testing Uplink Commands

### Command Sequence Testing

1. Create a command sequence file in your preferred format
2. Upload the command sequence to your S3 bucket:

```bash
aws s3 cp command_sequence.bin s3://your-bucket/commands/
```

3. Configure the dataflow endpoint to use this file:

```bash
aws groundstation update-dataflow-endpoint-group \
  --dataflow-endpoint-group-id <endpoint-group-id> \
  --endpoint-details '[{
    "endpoint": {
      "name": "UplinkCommandEndpoint",
      "awsS3": {
        "bucketArn": "arn:aws:s3:::your-bucket",
        "keyPattern": "commands/command_sequence.bin"
      }
    }
  }]' \
  --region <region>
```

### Real-time Command Testing

For real-time command testing, use the EC2 dataflow endpoint:

1. Set up an EC2 instance with your command generation software
2. Configure the security group to allow traffic on the required ports
3. Use the AWS Ground Station Agent to stream commands during the contact

## Monitoring Uplink Performance

During a Digital Twin simulation with uplink enabled, you can monitor:

1. Command acknowledgment rates
2. Signal quality metrics
3. Timing accuracy
4. Error conditions

Access these metrics through:
- CloudWatch metrics
- Ground Station console
- Simulation logs

## Best Practices for Uplink Testing

1. **Start Simple**: Begin with basic command sequences before testing complex operations
2. **Test Edge Cases**: Deliberately introduce timing issues, out-of-sequence commands, and other anomalies
3. **Validate Responses**: Verify that the simulated satellite responds correctly to commands
4. **Document Results**: Keep detailed records of test scenarios and outcomes
5. **Iterate**: Use test results to refine command sequences and timing

## Next Steps

After configuring and testing uplink capabilities, proceed to [Customer-Provided Ephemeris](05-customer-provided-ephemeris.md) to learn how to use custom ephemeris data with AWS Ground Station Digital Twin.

## AWS Documentation References

- [AWS Ground Station Uplink Configuration](https://docs.aws.amazon.com/ground-station/latest/ug/uplink-ec.html)
- [AWS Ground Station Dataflow Endpoint Groups](https://docs.aws.amazon.com/ground-station/latest/ug/dataflow-endpoint-groups.html)
- [AWS Ground Station Contact Scheduling](https://docs.aws.amazon.com/ground-station/latest/ug/contact-scheduling.html)
- [AWS Ground Station CloudWatch Metrics](https://docs.aws.amazon.com/ground-station/latest/ug/monitoring-cloudwatch.html)
- [AWS Ground Station Config Types](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ConfigTypeData.html)
