# Customer-Provided Ephemeris

This document explains how to use customer-provided ephemeris data with AWS Ground Station Digital Twin to accurately simulate satellite positions and movements.

## Understanding Ephemeris Data

An ephemeris is a file or data structure providing the trajectory of astronomical objects. AWS Ground Station uses ephemeris data to determine when contacts become available for your satellite and correctly command antennas in the AWS Ground Station Network to point at your satellite.

In AWS Ground Station Digital Twin, you can provide your own ephemeris data to ensure simulations match your specific satellite parameters and improve simulation accuracy.

## Ephemeris Format

AWS Ground Station Digital Twin supports the following ephemeris formats:

### OEM (Orbit Ephemeris Message)

The OEM format follows the CCSDS standard with some AWS Ground Station-specific requirements:

**Required Header Fields:**
- `CCSDS_OEM_VERS = 2.0`
- `CREATION_DATE`
- `ORIGINATOR`

**Required Metadata Fields:**
- `OBJECT_NAME`
- `OBJECT_ID`
- `CENTER_NAME = Earth`
- `REF_FRAME` (EME2000 or ITRF2000)
- `TIME_SYSTEM = UTC`
- `START_TIME`
- `STOP_TIME`
- `INTERPOLATION` (required for AWS Ground Station)
- `INTERPOLATION_DEGREE` (required for AWS Ground Station)

**Data Fields:**
- Position: X, Y, Z (in km)
- Velocity: X_DOT, Y_DOT, Z_DOT (in km/s)

Example OEM file structure:
```
CCSDS_OEM_VERS = 2.0
CREATION_DATE = 2024-07-22T05:20:59
ORIGINATOR = Example-Organization

META_START
OBJECT_NAME = EXAMPLE-SAT
OBJECT_ID = 2024-001A
CENTER_NAME = Earth
REF_FRAME = EME2000
TIME_SYSTEM = UTC
START_TIME = 2024-07-22T00:00:00.000000
STOP_TIME = 2024-07-22T00:06:00.000000
INTERPOLATION = Lagrange
INTERPOLATION_DEGREE = 5
META_STOP

2024-07-22T00:00:00.000000   590.5147360000000  -1860.082793999999  -6944.807075000000  -5.784245796000000   4.347501391999999  -1.657256863000000
2024-07-22T00:01:00.000000   242.5572045154201  -1595.860765983339  -7030.938457373539  -5.810660250794190   4.457103652219009  -1.212889340333023
```

### TLE (Two-Line Element Set)

TLE is a data format encoding orbital elements for an Earth-orbiting object. AWS Ground Station supports standard TLE format.

Example TLE:
```
EXAMPLE SATELLITE
1 25544U 98067A   24001.00000000  .00002182  00000-0  10270-4 0  9990
2 25544  51.6461 339.7939 0001393  83.2776 276.9717 15.48919103123456
```

**Note:** When providing custom ephemeris before a satellite catalog number is assigned, you can use 00000 for the satellite catalog number field of the TLE.

## Uploading Ephemeris Data

### Prerequisites

Access to the Ephemeris API is provided only on an as-needed basis. If you require the ability to upload custom ephemeris data, contact `aws-groundstation@amazon.com`.

### Using the AWS CLI

1. **Create ephemeris from inline data:**
   ```bash
   aws groundstation create-ephemeris \
     --name "example-ephemeris" \
     --satellite-id "11111111-2222-3333-4444-555555555555" \
     --enabled \
     --priority 1 \
     --ephemeris-data '{
       "tle": {
         "tleLine1": "1 25544U 98067A   24001.00000000  .00002182  00000-0  10270-4 0  9990",
         "tleLine2": "2 25544  51.6461 339.7939 0001393  83.2776 276.9717 15.48919103123456"
       }
     }' \
     --region us-west-2
   ```

2. **Create ephemeris from S3:**
   ```bash
   aws groundstation create-ephemeris \
     --name "example-ephemeris-s3" \
     --satellite-id "11111111-2222-3333-4444-555555555555" \
     --enabled \
     --priority 1 \
     --ephemeris-data '{
       "oem": {
         "oemData": "s3://your-bucket/path/to/ephemeris.oem"
       }
     }' \
     --region us-west-2
   ```

### Using the AWS SDK (Python)

```python
import boto3

client = boto3.client('groundstation', region_name='us-west-2')

response = client.create_ephemeris(
    name='example-ephemeris',
    satelliteId='11111111-2222-3333-4444-555555555555',
    enabled=True,
    priority=1,
    ephemerisData={
        'tle': {
            'tleLine1': '1 25544U 98067A   24001.00000000  .00002182  00000-0  10270-4 0  9990',
            'tleLine2': '2 25544  51.6461 339.7939 0001393  83.2776 276.9717 15.48919103123456'
        }
    }
)

print(f"Ephemeris ID: {response['ephemerisId']}")
```

## Ephemeris Validation

After uploading, ephemeris data goes through validation:

1. **VALIDATING**: Initial validation and contact generation
2. **ENABLED**: Ready for use
3. **INVALID**: Failed validation

### Monitoring Ephemeris Status

```bash
aws groundstation describe-ephemeris \
  --ephemeris-id "22222222-3333-4444-5555-666666666666" \
  --region us-west-2
```

### Using CloudWatch Events

Set up CloudWatch Events to monitor ephemeris status changes:

```json
{
  "source": ["aws.groundstation"],
  "detail-type": ["Ground Station Ephemeris State Change"],
  "detail": {
    "state": ["ENABLED", "INVALID"]
  }
}
```

## Best Practices

### Update Frequency

- **LEO satellites**: Update at least weekly
- **MEO satellites**: Update at least monthly
- **After maneuvers**: Update immediately
- **When accuracy degrades**: Update when simulation results deviate from expected behavior

### Data Quality

1. Ensure ephemeris data covers the entire simulation period
2. Use high-precision ephemeris when available
3. Validate ephemeris data before uploading
4. Monitor ephemeris expiration times

### Priority Management

- Higher priority ephemeris (lower number) takes precedence
- Use priority 1 for most accurate/recent data
- Use higher priority numbers for backup ephemeris

## Troubleshooting

### Common Issues

1. **Invalid format**: Ensure OEM follows CCSDS standard with AWS requirements
2. **Missing required fields**: Check all required metadata fields are present
3. **Time coverage**: Ensure ephemeris covers simulation time period
4. **Coordinate system**: Use EME2000 or ITRF2000 reference frames

### Getting Current Ephemeris

Check which ephemeris is currently in use:

```bash
aws groundstation get-satellite \
  --satellite-id "11111111-2222-3333-4444-555555555555" \
  --region us-west-2
```

### Reverting to Default Ephemeris

To revert to default Space-Track ephemeris, disable all custom ephemeris:

```bash
aws groundstation update-ephemeris \
  --ephemeris-id "22222222-3333-4444-5555-666666666666" \
  --enabled false \
  --region us-west-2
```

## Next Steps

After configuring ephemeris data, proceed to [Troubleshooting](06-troubleshooting.md) for common issues and solutions.

## AWS Documentation References

- [Understand how AWS Ground Station uses satellite ephemeris data](https://docs.aws.amazon.com/ground-station/latest/ug/ephemeris.html)
- [Provide custom ephemeris data](https://docs.aws.amazon.com/ground-station/latest/ug/providing-custom-ephemeris-data.html)
- [Default ephemeris data](https://docs.aws.amazon.com/ground-station/latest/ug/default-ephemeris-data.html)
- [CreateEphemeris API](https://docs.aws.amazon.com/ground-station/latest/APIReference/API_CreateEphemeris.html)
