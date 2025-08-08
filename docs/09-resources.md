# Resources

This document provides a comprehensive collection of resources to help you effectively use AWS Ground Station Digital Twin.

## Official Documentation

### AWS Ground Station Documentation

- [What is AWS Ground Station?](https://docs.aws.amazon.com/ground-station/latest/ug/what-is.html)
- [AWS Ground Station User Guide](https://docs.aws.amazon.com/ground-station/latest/ug/)
- [AWS Ground Station API Reference](https://docs.aws.amazon.com/ground-station/latest/APIReference/)
- [Use the AWS Ground Station digital twin feature](https://docs.aws.amazon.com/ground-station/latest/ug/digital-twin.html)
- [Onboard satellite](https://docs.aws.amazon.com/ground-station/latest/ug/getting-started.step1.html)
- [AWS Ground Station Locations](https://docs.aws.amazon.com/ground-station/latest/ug/aws-ground-station-antenna-locations.html)

### Ephemeris Documentation

- [Understand how AWS Ground Station uses satellite ephemeris data](https://docs.aws.amazon.com/ground-station/latest/ug/ephemeris.html)
- [Provide custom ephemeris data](https://docs.aws.amazon.com/ground-station/latest/ug/providing-custom-ephemeris-data.html)
- [Default ephemeris data](https://docs.aws.amazon.com/ground-station/latest/ug/default-ephemeris-data.html)
- [Get the current ephemeris for a satellite](https://docs.aws.amazon.com/ground-station/latest/ug/getting-current-ephemeris.html)

### AWS CLI Documentation

- [AWS CLI Command Reference for Ground Station](https://docs.aws.amazon.com/cli/latest/reference/groundstation/index.html)
- [Installing the AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Configuring the AWS CLI version 2](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html)

### AWS SDK Documentation

- [AWS SDK for Python (Boto3) - Ground Station](https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/groundstation.html)
- [AWS SDK for Java - Ground Station](https://sdk.amazonaws.com/java/api/latest/software/amazon/awssdk/services/groundstation/package-summary.html)
- [AWS SDK for JavaScript - Ground Station](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/GroundStation.html)

## API References

### Key APIs for Digital Twin

- [ListGroundStations](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ListGroundStations.html) - List available ground stations
- [ListSatellites](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ListSatellites.html) - List satellites
- [GetSatellite](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_GetSatellite.html) - Get satellite details
- [CreateEphemeris](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_CreateEphemeris.html) - Upload custom ephemeris
- [DescribeEphemeris](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_DescribeEphemeris.html) - Check ephemeris status

### Contact Management APIs

- [ListContacts](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ListContacts.html) - List scheduled contacts
- [DescribeContact](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_DescribeContact.html) - Get contact details
- [ReserveContact](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_ReserveContact.html) - Schedule a contact

## Code Samples

### Python Examples

#### List Digital Twin Ground Stations

```python
import boto3

client = boto3.client('groundstation', region_name='us-west-2')

response = client.list_ground_stations()

# Filter for digital twin ground stations
digital_twin_stations = [
    station for station in response['groundStationList']
    if station['groundStationName'].startswith('Digital Twin ')
]

for station in digital_twin_stations:
    print(f"Ground Station: {station['groundStationName']}")
    print(f"ID: {station['groundStationId']}")
    print(f"Region: {station['region']}")
    print("---")
```

#### Upload TLE Ephemeris

```python
import boto3

client = boto3.client('groundstation', region_name='us-west-2')

response = client.create_ephemeris(
    name='example-tle-ephemeris',
    satelliteId='your-satellite-id',
    enabled=True,
    priority=1,
    ephemerisData={
        'tle': {
            'tleLine1': '1 25544U 98067A   24001.00000000  .00002182  00000-0  10270-4 0  9990',
            'tleLine2': '2 25544  51.6461 339.7939 0001393  83.2776 276.9717 15.48919103123456'
        }
    }
)

print(f"Ephemeris created with ID: {response['ephemerisId']}")
```

#### Monitor Ephemeris Status

```python
import boto3
import time

client = boto3.client('groundstation', region_name='us-west-2')

def wait_for_ephemeris_enabled(ephemeris_id, max_wait_time=300):
    start_time = time.time()
    
    while time.time() - start_time < max_wait_time:
        response = client.describe_ephemeris(ephemerisId=ephemeris_id)
        status = response['status']
        
        print(f"Ephemeris status: {status}")
        
        if status == 'ENABLED':
            print("Ephemeris is ready for use!")
            return True
        elif status == 'INVALID':
            print("Ephemeris validation failed!")
            return False
        
        time.sleep(10)
    
    print("Timeout waiting for ephemeris to be enabled")
    return False

# Usage
ephemeris_id = 'your-ephemeris-id'
wait_for_ephemeris_enabled(ephemeris_id)
```

### AWS CLI Examples

#### List Satellites

```bash
# List all satellites
aws groundstation list-satellites --region us-west-2

# Get specific satellite details
aws groundstation get-satellite \
  --satellite-id "11111111-2222-3333-4444-555555555555" \
  --region us-west-2
```

#### Tag a Satellite

```bash
# Add a name tag to a satellite
aws groundstation tag-resource \
  --region us-west-2 \
  --resource-arn "arn:aws:groundstation:us-west-2:123456789012:satellite/11111111-2222-3333-4444-555555555555" \
  --tags '{"Name":"My-Satellite"}'
```

#### Create Ephemeris from S3

```bash
aws groundstation create-ephemeris \
  --name "s3-ephemeris-example" \
  --satellite-id "11111111-2222-3333-4444-555555555555" \
  --enabled \
  --priority 1 \
  --ephemeris-data '{
    "oem": {
      "oemData": "s3://my-bucket/ephemeris/satellite.oem"
    }
  }' \
  --region us-west-2
```

## CloudFormation Templates

### Basic IAM Role for Ground Station

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'IAM role for AWS Ground Station Digital Twin'

Resources:
  GroundStationRole:
    Type: AWS::IAM::Role
    Properties:
      RoleName: GroundStationDigitalTwinRole
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: groundstation.amazonaws.com
            Action: sts:AssumeRole
      Policies:
        - PolicyName: GroundStationDigitalTwinPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - s3:GetObject
                  - s3:PutObject
                  - s3:ListBucket
                  - logs:CreateLogGroup
                  - logs:CreateLogStream
                  - logs:PutLogEvents
                Resource: '*'

Outputs:
  RoleArn:
    Description: 'ARN of the Ground Station role'
    Value: !GetAtt GroundStationRole.Arn
```

### S3 Bucket for Ephemeris Data

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'S3 bucket for storing ephemeris data'

Parameters:
  BucketName:
    Type: String
    Default: 'groundstation-ephemeris-data'
    Description: 'Name for the S3 bucket'

Resources:
  EphemerisBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub '${BucketName}-${AWS::AccountId}'
      VersioningConfiguration:
        Status: Enabled
      PublicAccessBlockConfiguration:
        BlockPublicAcls: true
        BlockPublicPolicy: true
        IgnorePublicAcls: true
        RestrictPublicBuckets: true

Outputs:
  BucketName:
    Description: 'Name of the created S3 bucket'
    Value: !Ref EphemerisBucket
  BucketArn:
    Description: 'ARN of the created S3 bucket'
    Value: !GetAtt EphemerisBucket.Arn
```

## Monitoring and Logging

### CloudWatch Log Groups

AWS Ground Station Digital Twin logs are available in:
- `/aws/groundstation/digital-twin` - Digital twin simulation logs
- `/aws/groundstation/contacts` - Contact execution logs

### CloudWatch Events

Monitor ephemeris and contact events:

```json
{
  "source": ["aws.groundstation"],
  "detail-type": [
    "Ground Station Ephemeris State Change",
    "Ground Station Contact State Change"
  ]
}
```

## Troubleshooting Resources

### Common Error Codes

- `AccessDeniedException` - Check IAM permissions
- `ValidationException` - Verify input parameters
- `ResourceNotFoundException` - Confirm resource exists in correct region
- `LimitExceededException` - Request quota increase

### Support Channels

1. **AWS Support** - For customers with support plans
2. **AWS Documentation** - Comprehensive guides and references
3. **AWS Forums** - Community support and discussions
4. **AWS Ground Station Team** - Contact aws-groundstation@amazon.com for onboarding

## External Resources

### Standards and Specifications

- [CCSDS OEM Standard](https://ccsds.org/wp-content/uploads/gravity_forms/5-448e85c647331d9cbaf66c096458bdd5/2025/01//502x0b3e1.pdf) - Orbit Ephemeris Message format
- [Two-Line Element Set](https://en.wikipedia.org/wiki/Two-line_element_set) - TLE format specification
- [Space-Track.org](https://www.space-track.org/) - Source of default ephemeris data

### Industry Resources

- [AWS Satellite Blog](https://aws.amazon.com/blogs/aws/category/satellite/) - Latest updates and use cases
- [AWS re:Invent Sessions](https://www.youtube.com/results?search_query=aws+reinvent+ground+station) - Technical presentations
- [AWS Workshops](https://workshops.aws/) - Hands-on learning experiences

## Getting Help

### Before Contacting Support

1. Check the [troubleshooting guide](06-troubleshooting.md)
2. Review CloudWatch logs for error details
3. Verify IAM permissions and resource configurations
4. Consult the FAQ section

### Contact Information

- **General inquiries**: aws-groundstation@amazon.com
- **Technical support**: Through your AWS Support plan
- **Documentation feedback**: Use the feedback links in AWS documentation

## Next Steps

- Review the [Best Practices](07-best-practices.md) guide
- Explore the [FAQ](08-faq.md) for common questions
- Start with the [Prerequisites](01-prerequisites.md) if you're new to AWS Ground Station Digital Twin
