# Using AWS Ground Station Digital Twin

This document provides a comprehensive guide on how to use AWS Ground Station Digital Twin after completing the onboarding process.

## Console Overview

The AWS Ground Station Digital Twin console is organized into the following sections:

- **Dashboard**: Overview of active simulations and recent activities
- **Simulations**: Create and manage digital twin simulations
- **Satellites**: Configure and manage satellite profiles
- **Contacts**: Schedule and monitor simulated contacts
- **Dataflow Endpoints**: Configure where your data will be delivered
- **Mission Profiles**: Define mission-specific configurations
- **Config Profiles**: Manage configuration profiles for different scenarios

### Navigating the Console

1. Log in to the AWS Management Console
2. Navigate to AWS Ground Station
3. Select "Digital Twin" from the left navigation pane
4. Use the tabs to access different functional areas

## Creating Your First Simulation

### Step 1: Define Satellite Parameters

1. Navigate to the Satellites section
2. Click "Create Satellite"
3. Enter the following details:
   - Satellite name
   - NORAD ID (use test ID for simulation)
   - Orbit parameters
   - Frequency bands
   - Transmitter/receiver specifications
4. Click "Create"

### Step 2: Create a Mission Profile

1. Navigate to the Mission Profiles section
2. Click "Create Mission Profile"
3. Configure the following:
   - Profile name
   - Tracking configuration
   - Minimum viable contact duration
   - Antenna downlink and uplink configurations
4. Associate with your satellite
5. Click "Create Mission Profile"

### Step 3: Set Up Config Profiles

1. Navigate to Config Profiles
2. Create the following config profiles:
   - Tracking config
   - Downlink config
   - Uplink config (if applicable)
3. Specify parameters for each config profile:
   - Frequency
   - Bandwidth
   - Polarization
   - Data format
   - Modulation scheme

### Step 4: Create a Simulation

1. Navigate to the Simulations section
2. Click "Create Simulation"
3. Select the following:
   - Satellite
   - Mission profile
   - Ground station location(s)
   - Simulation duration
   - Start time
4. Configure simulation parameters:
   - Signal strength
   - Interference levels
   - Weather conditions
   - Orbital variations
5. Click "Create Simulation"

## API Reference

AWS Ground Station Digital Twin can be accessed programmatically using the AWS SDK or CLI.

### Key API Operations

```bash
# List available simulations
aws groundstation list-digital-twin-simulations --region <region>

# Create a new simulation
aws groundstation create-digital-twin-simulation \
  --name "TestSimulation" \
  --satellite-id <satellite-id> \
  --mission-profile-id <mission-profile-id> \
  --ground-stations <ground-station-list> \
  --start-time <start-time> \
  --end-time <end-time> \
  --parameters <simulation-parameters> \
  --region <region>

# Get simulation details
aws groundstation get-digital-twin-simulation \
  --simulation-id <simulation-id> \
  --region <region>

# Cancel a simulation
aws groundstation cancel-digital-twin-simulation \
  --simulation-id <simulation-id> \
  --region <region>
```

### SDK Example (Python)

```python
import boto3
import datetime

# Initialize the Ground Station client
client = boto3.client('groundstation', region_name='us-west-2')

# Create a simulation
response = client.create_digital_twin_simulation(
    name='TestSimulation',
    satelliteId='sat-1234567890abcdef0',
    missionProfileId='mp-1234567890abcdef0',
    groundStations=['Ohio-1', 'Oregon-2'],
    startTime=datetime.datetime.now() + datetime.timedelta(hours=1),
    endTime=datetime.datetime.now() + datetime.timedelta(hours=2),
    parameters={
        'signalStrength': 'NOMINAL',
        'interference': 'LOW',
        'weatherCondition': 'CLEAR'
    }
)

simulation_id = response['simulationId']
print(f"Created simulation: {simulation_id}")
```

## CLI Commands

Common CLI commands for working with AWS Ground Station Digital Twin:

```bash
# List all satellites
aws groundstation list-satellites --region <region>

# List mission profiles
aws groundstation list-mission-profiles --region <region>

# List config profiles
aws groundstation list-config-profiles --region <region>

# List scheduled contacts
aws groundstation list-contacts \
  --status SCHEDULED \
  --region <region>

# List dataflow endpoint groups
aws groundstation list-dataflow-endpoint-groups --region <region>
```

## Monitoring Simulations

1. Navigate to the Simulations section in the console
2. Select the active simulation
3. View real-time metrics:
   - Signal quality
   - Data throughput
   - Contact status
   - Error rates
4. Download simulation logs for detailed analysis

## Next Steps

After familiarizing yourself with the basic usage of AWS Ground Station Digital Twin, proceed to:

- [Uplink Configuration](04-uplink-configuration.md) to learn how to set up and use uplink capabilities
- [Customer-Provided Ephemeris](05-customer-provided-ephemeris.md) to understand how to work with custom ephemeris data
