# Customer-Provided Ephemeris

This document explains how to use customer-provided ephemeris data with AWS Ground Station Digital Twin to accurately simulate satellite positions and movements.

## Understanding Ephemeris Data

Ephemeris data contains information about a satellite's position and velocity as a function of time. This data is crucial for:

- Accurately predicting satellite passes
- Planning contact schedules
- Pointing antennas correctly
- Calculating Doppler shifts

In AWS Ground Station Digital Twin, you can provide your own ephemeris data to ensure simulations match your specific satellite parameters.

## Ephemeris Format

AWS Ground Station Digital Twin supports the following ephemeris formats:

### OEM (Orbit Ephemeris Message)

The OEM format follows the CCSDS standard and includes:
- Header information
- Metadata section
- State vectors (position and velocity)

Example OEM file structure:
```
CCSDS_OEM_VERS = 2.0
CREATION_DATE = 2025-01-15T00:00:00
ORIGINATOR = EXAMPLE

META_START
OBJECT_NAME = EXAMPLESAT
OBJECT_ID = 2025-001A
CENTER_NAME = EARTH
REF_FRAME = EME2000
TIME_SYSTEM = UTC
START_TIME = 2025-01-15T00:00:00.000
STOP_TIME = 2025-01-16T00:00:00.000
META_STOP

2025-01-15T00:00:00.000 -6800.0 1200.0 600.0 2.0 5.0 -3.0
2025-01-15T01:00:00.000 -6600.0 1300.0 700.0 2.1 5.1 -2.9
...
```

### TLE (Two-Line Element Set)

TLE is a data format encoding a list of orbital elements for an Earth-orbiting object:

Example TLE:
```
EXAMPLESAT
1 25544U 98067A   25015.50000000  .00000000  00000-0  00000-0 0  9990
2 25544  51.6400  15.0000 0007000  0.0000 180.0000 15.50000000    00
```

### CPE (Customer-Provided Ephemeris)

AWS Ground Station also supports a proprietary CPE format that includes:
- Satellite identification
- Time range
- Position and velocity vectors
- Additional metadata

## Uploading Ephemeris Data

### Step 1: Prepare Your Ephemeris File

Ensure your ephemeris file follows one of the supported formats and covers the time period of your planned simulation.

### Step 2: Upload to S3

```bash
# Upload OEM file
aws s3 cp satellite_ephemeris.oem s3://your-bucket/ephemeris/

# Upload TLE file
aws s3 cp satellite_tle.txt s3://your-bucket/ephemeris/
```

### Step 3: Register Ephemeris with Ground Station

Using the AWS CLI:

```bash
aws groundstation register-ephemeris \
  --satellite-id <satellite-id> \
  --ephemeris-data '{
    "oem": {
      "s3Object": {
        "bucket": "your-bucket",
        "key": "ephemeris/satellite_ephemeris.oem"
      }
    }
  }' \
  --name "CustomEphemeris-2025-01" \
  --priority 100 \
  --region <region>
```

Using the AWS SDK (Python):

```python
import boto3

client = boto3.client('groundstation', region_name='us-west-2')

response = client.register_ephemeris(
    satelliteId='sat-1234567890abcdef0',
    ephemerisData={
        'oem': {
            's3Object': {
                'bucket': 'your-bucket',
                'key': 'ephemeris/satellite_ephemeris.oem'
            }
        }
    },
    name='CustomEphemeris-2025-01',
    priority=100
)

ephemeris_id = response['ephemerisId']
print(f"Registered ephemeris: {ephemeris_id}")
```

## Ephemeris Validation

AWS Ground Station Digital Twin automatically validates your ephemeris data upon registration. The validation process checks:

1. Format compliance
2. Time range coverage
3. Consistency of state vectors
4. Orbital parameters within expected ranges

### Checking Validation Status

```bash
aws groundstation describe-ephemeris \
  --ephemeris-id <ephemeris-id> \
  --region <region>
```

The response includes a validation status:
- `VALID`: Ephemeris passed all validation checks
- `INVALID`: Ephemeris failed validation
- `VALIDATING`: Validation in progress

### Validation Errors

If your ephemeris is marked as `INVALID`, check the validation messages:

```bash
aws groundstation list-ephemeris-validation-messages \
  --ephemeris-id <ephemeris-id> \
  --region <region>
```

Common validation errors include:
- Time format issues
- Gaps in coverage
- Physically impossible state transitions
- Reference frame inconsistencies

## Using Custom Ephemeris in Simulations

### Step 1: Create a Simulation with Custom Ephemeris

```bash
aws groundstation create-digital-twin-simulation \
  --name "CustomEphemerisSimulation" \
  --satellite-id <satellite-id> \
  --mission-profile-id <mission-profile-id> \
  --ground-stations <ground-station-list> \
  --start-time <start-time> \
  --end-time <end-time> \
  --ephemeris-id <ephemeris-id> \
  --region <region>
```

### Step 2: Monitor Simulation with Custom Ephemeris

1. Navigate to the Simulations section in the console
2. Select your simulation
3. View the "Ephemeris" tab to see:
   - Source of ephemeris data
   - Coverage period
   - Validation status
   - Orbital parameters derived from ephemeris

## Advanced Ephemeris Features

### Ephemeris Priority

When multiple ephemeris sources are available, AWS Ground Station uses a priority system:

1. Register ephemeris with priority values:
```bash
aws groundstation register-ephemeris \
  --satellite-id <satellite-id> \
  --ephemeris-data <ephemeris-data> \
  --name "PrimaryEphemeris" \
  --priority 200 \
  --region <region>

aws groundstation register-ephemeris \
  --satellite-id <satellite-id> \
  --ephemeris-data <ephemeris-data> \
  --name "BackupEphemeris" \
  --priority 100 \
  --region <region>
```

Higher priority values take precedence when multiple valid ephemeris sources overlap.

### Ephemeris Propagation

For simulations extending beyond ephemeris coverage, AWS Ground Station can propagate orbits:

```bash
aws groundstation create-digital-twin-simulation \
  --name "PropagatedSimulation" \
  --satellite-id <satellite-id> \
  --mission-profile-id <mission-profile-id> \
  --ground-stations <ground-station-list> \
  --start-time <start-time> \
  --end-time <end-time> \
  --ephemeris-id <ephemeris-id> \
  --propagation-settings '{
    "maxPropagationMinutes": 1440,
    "propagationModel": "SGP4"
  }' \
  --region <region>
```

## Best Practices for Ephemeris Management

1. **Regular Updates**: Upload fresh ephemeris data regularly to maintain accuracy
2. **Overlap Coverage**: Ensure new ephemeris overlaps with previous data to avoid gaps
3. **Validation**: Always check validation status before using in critical simulations
4. **Priority Management**: Use priority settings to establish clear precedence rules
5. **Time Range**: Provide ephemeris that extends beyond your simulation window

## Next Steps

After learning how to use customer-provided ephemeris, proceed to [Troubleshooting](06-troubleshooting.md) to understand how to diagnose and resolve common issues with AWS Ground Station Digital Twin.
