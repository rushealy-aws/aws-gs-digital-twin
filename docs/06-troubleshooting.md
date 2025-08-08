# Troubleshooting AWS Ground Station Digital Twin

This document provides comprehensive troubleshooting guidance for common issues encountered when using AWS Ground Station Digital Twin.

## Common Issues

### Simulation Creation Failures

#### Issue: Simulation fails to create with "InvalidParameterException"

**Possible causes:**
- Invalid satellite configuration
- Mission profile incompatibility
- Time range issues

**Resolution steps:**
1. Verify that the satellite ID is valid:
   ```bash
   aws groundstation get-satellite --satellite-id <satellite-id> --region <region>
   ```

2. Check mission profile compatibility:
   ```bash
   aws groundstation get-mission-profile --mission-profile-id <mission-profile-id> --region <region>
   ```

3. Ensure start time is in the future and end time is after start time:
   ```bash
   aws groundstation create-digital-twin-simulation \
     --name "TestSimulation" \
     --satellite-id <satellite-id> \
     --mission-profile-id <mission-profile-id> \
     --ground-stations <ground-station-list> \
     --start-time $(date -u -v+1H +"%Y-%m-%dT%H:%M:%SZ") \
     --end-time $(date -u -v+2H +"%Y-%m-%dT%H:%M:%SZ") \
     --region <region>
   ```

#### Issue: "ResourceNotFoundException" when creating simulation

**Possible causes:**
- Satellite, mission profile, or ground station doesn't exist
- Resource exists in a different region

**Resolution steps:**
1. List available resources:
   ```bash
   aws groundstation list-satellites --region <region>
   aws groundstation list-mission-profiles --region <region>
   aws groundstation list-ground-stations --region <region>
   ```

2. Check if you're using the correct region:
   ```bash
   aws configure get region
   aws configure set region <correct-region>
   ```

### Contact Scheduling Problems

#### Issue: No available contact windows

**Possible causes:**
- Ground station capacity constraints
- Satellite visibility issues
- Ephemeris data problems

**Resolution steps:**
1. Check ground station availability:
   ```bash
   aws groundstation list-ground-stations --region <region>
   ```

2. Verify satellite ephemeris:
   ```bash
   aws groundstation list-ephemerides --satellite-id <satellite-id> --region <region>
   ```

3. Try a different time window or ground station location

#### Issue: Contact scheduling fails with "ConflictException"

**Possible causes:**
- Overlapping contact reservation
- Resource contention

**Resolution steps:**
1. List existing contacts:
   ```bash
   aws groundstation list-contacts \
     --status SCHEDULED \
     --satellite-id <satellite-id> \
     --region <region>
   ```

2. Choose a different time window:
   ```bash
   aws groundstation list-available-contact-windows \
     --satellite-id <satellite-id> \
     --mission-profile-id <mission-profile-id> \
     --ground-stations <ground-station-list> \
     --start-time <start-time> \
     --end-time <end-time> \
     --region <region>
   ```

### Dataflow Issues

#### Issue: No data received during simulation

**Possible causes:**
- Misconfigured dataflow endpoints
- Network connectivity issues
- Incorrect S3 bucket permissions

**Resolution steps:**
1. Verify dataflow endpoint configuration:
   ```bash
   aws groundstation list-dataflow-endpoint-groups --region <region>
   aws groundstation get-dataflow-endpoint-group \
     --dataflow-endpoint-group-id <endpoint-group-id> \
     --region <region>
   ```

2. Check S3 bucket permissions:
   ```bash
   aws s3api get-bucket-policy --bucket <bucket-name>
   ```

3. Ensure the Ground Station service role has access to your S3 bucket:
   ```bash
   aws iam get-role --role-name GroundStationDigitalTwinRole
   ```

4. Add required permissions if missing:
   ```bash
   aws iam put-role-policy \
     --role-name GroundStationDigitalTwinRole \
     --policy-name S3Access \
     --policy-document '{
       "Version": "2012-10-17",
       "Statement": [
         {
           "Effect": "Allow",
           "Action": [
             "s3:PutObject",
             "s3:GetObject",
             "s3:ListBucket"
           ],
           "Resource": [
             "arn:aws:s3:::<bucket-name>",
             "arn:aws:s3:::<bucket-name>/*"
           ]
         }
       ]
     }'
   ```

### Uplink Configuration Problems

#### Issue: Uplink commands not being processed

**Possible causes:**
- Incorrect uplink config
- Command format issues
- Timing problems

**Resolution steps:**
1. Verify uplink config:
   ```bash
   aws groundstation list-configs \
     --config-type uplink-echo \
     --region <region>
   ```

2. Check command format against documentation
3. Review simulation logs for timing issues:
   ```bash
   aws logs get-log-events \
     --log-group-name /aws/groundstation/digital-twin \
     --log-stream-name <simulation-id> \
     --region <region>
   ```

#### Issue: "InvalidFrequencyException" for uplink config

**Possible causes:**
- Frequency outside supported range
- Frequency conflicts with other configurations

**Resolution steps:**
1. Check supported frequency ranges in documentation
2. Modify uplink config with valid frequency:
   ```bash
   aws groundstation update-config \
     --config-id <config-id> \
     --config-data '{
       "uplinkEchoConfig": {
         "antennaUplinkConfig": {
           "targetEirp": {
             "units": "dBW",
             "value": 20.0
           },
           "transmitDisabled": false,
           "spectrumConfig": {
             "centerFrequency": {
               "units": "MHz",
               "value": 2075.0
             },
             "polarization": "RIGHT_HAND"
           }
         }
       }
     }' \
     --region <region>
   ```

### Ephemeris-Related Issues

#### Issue: Ephemeris validation fails

**Possible causes:**
- Format errors in ephemeris file
- Invalid orbital parameters
- Time range issues

**Resolution steps:**
1. Check validation messages:
   ```bash
   aws groundstation list-ephemeris-validation-messages \
     --ephemeris-id <ephemeris-id> \
     --region <region>
   ```

2. Common fixes based on error type:
   - Format errors: Ensure compliance with OEM/TLE standards
   - Time range: Provide ephemeris covering simulation period
   - Orbital parameters: Verify physical plausibility

3. Re-upload corrected ephemeris:
   ```bash
   aws s3 cp corrected_ephemeris.oem s3://your-bucket/ephemeris/
   
   aws groundstation register-ephemeris \
     --satellite-id <satellite-id> \
     --ephemeris-data '{
       "oem": {
         "s3Object": {
           "bucket": "your-bucket",
           "key": "ephemeris/corrected_ephemeris.oem"
         }
       }
     }' \
     --name "CorrectedEphemeris" \
     --priority 100 \
     --region <region>
   ```

## Error Codes

| Error Code | Description | Resolution |
|------------|-------------|------------|
| `AccessDeniedException` | Insufficient permissions | Check IAM roles and policies |
| `ConflictException` | Resource conflict | Choose different timing or resources |
| `DependencyException` | Dependent service failure | Check AWS service health dashboard |
| `InvalidParameterException` | Invalid input parameter | Verify parameter values against documentation |
| `InvalidFrequencyException` | Frequency out of range | Use supported frequency values |
| `LimitExceededException` | Service quota exceeded | Request quota increase or optimize usage |
| `ResourceNotFoundException` | Resource not found | Verify resource IDs and region |
| `ThrottlingException` | API rate limit exceeded | Implement exponential backoff |
| `ValidationException` | Input validation failed | Check input format and constraints |

## Diagnostic Tools

### CloudWatch Logs

Access detailed logs for your simulations:

```bash
# List log streams for Digital Twin
aws logs describe-log-groups \
  --log-group-name-prefix /aws/groundstation/digital-twin \
  --region <region>

# Get specific simulation logs
aws logs get-log-events \
  --log-group-name /aws/groundstation/digital-twin \
  --log-stream-name <simulation-id> \
  --region <region>
```

### CloudWatch Metrics

Monitor key performance metrics:

```bash
# List available metrics
aws cloudwatch list-metrics \
  --namespace "AWS/GroundStation" \
  --region <region>

# Get specific metric data
aws cloudwatch get-metric-data \
  --metric-data-queries '[{
    "Id": "m1",
    "MetricStat": {
      "Metric": {
        "Namespace": "AWS/GroundStation",
        "MetricName": "SignalQuality",
        "Dimensions": [
          {
            "Name": "SimulationId",
            "Value": "<simulation-id>"
          }
        ]
      },
      "Period": 60,
      "Stat": "Average"
    }
  }]' \
  --start-time <start-time> \
  --end-time <end-time> \
  --region <region>
```

### AWS CLI Diagnostic Commands

```bash
# Check service health
aws health describe-events --region <region>

# Verify account limits
aws service-quotas get-service-quota \
  --service-code groundstation \
  --quota-code L-12345678 \
  --region <region>

# Test network connectivity
aws ec2 describe-network-interfaces \
  --filters "Name=description,Values=*GroundStation*" \
  --region <region>
```

## Support Channels

### AWS Support

If you're unable to resolve an issue using the troubleshooting steps above, contact AWS Support:

1. Navigate to the AWS Support Center: https://console.aws.amazon.com/support/home
2. Click "Create case"
3. Select "Technical support"
4. For service, select "Ground Station"
5. Provide details about your issue:
   - Simulation ID
   - Error messages
   - Steps to reproduce
   - Troubleshooting steps already taken

### AWS Ground Station Documentation

Refer to the official AWS documentation:
- [AWS Ground Station User Guide](https://docs.aws.amazon.com/ground-station/latest/ug/what-is-aws-ground-station.html)
- [AWS Ground Station API Reference](https://docs.aws.amazon.com/ground-station/latest/APIReference/Welcome.html)

### AWS Forums

Post questions on the AWS forums:
- [AWS Ground Station Forum](https://forums.aws.amazon.com/forum.jspa?forumID=328)

## Best Practices for Troubleshooting

1. **Systematic Approach**: Work through issues methodically, checking one component at a time
2. **Log Analysis**: Always check CloudWatch logs for detailed error information
3. **Version Control**: Keep track of configuration changes to identify when issues were introduced
4. **Test Incrementally**: Start with simple configurations and add complexity gradually
5. **Documentation**: Maintain detailed records of issues and resolutions for future reference

## Next Steps

After resolving any issues with AWS Ground Station Digital Twin, refer to [Best Practices](07-best-practices.md) for guidance on optimizing your use of the service.
