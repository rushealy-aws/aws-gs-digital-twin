#!/usr/bin/env python3
"""
AWS Ground Station Digital Twin - Create Simulation Script

This script demonstrates how to create a Digital Twin simulation using the AWS SDK for Python (Boto3).
"""

import boto3
import argparse
import datetime
import json
import time
import sys

def parse_arguments():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser(description='Create an AWS Ground Station Digital Twin simulation.')
    parser.add_argument('--name', required=True, help='Name for the simulation')
    parser.add_argument('--satellite-id', required=True, help='Satellite ID')
    parser.add_argument('--mission-profile-id', required=True, help='Mission Profile ID')
    parser.add_argument('--ground-station', required=True, help='Ground Station name')
    parser.add_argument('--region', default='us-west-2', help='AWS region (default: us-west-2)')
    parser.add_argument('--duration-hours', type=int, default=1, help='Simulation duration in hours (default: 1)')
    parser.add_argument('--start-offset-hours', type=int, default=1, help='Hours from now to start (default: 1)')
    parser.add_argument('--ephemeris-id', help='Optional ephemeris ID to use')
    parser.add_argument('--wait', action='store_true', help='Wait for simulation to complete')
    return parser.parse_args()

def create_simulation(args):
    """Create a Digital Twin simulation with the provided parameters."""
    client = boto3.client('groundstation', region_name=args.region)
    
    # Calculate start and end times
    start_time = datetime.datetime.now(datetime.timezone.utc) + datetime.timedelta(hours=args.start_offset_hours)
    end_time = start_time + datetime.timedelta(hours=args.duration_hours)
    
    # Prepare simulation parameters
    params = {
        'name': args.name,
        'satelliteId': args.satellite_id,
        'missionProfileId': args.mission_profile_id,
        'groundStations': [args.ground_station],
        'startTime': start_time,
        'endTime': end_time,
        'parameters': {
            'signalStrength': 'NOMINAL',
            'interference': 'LOW',
            'weatherCondition': 'CLEAR'
        }
    }
    
    # Add ephemeris ID if provided
    if args.ephemeris_id:
        params['ephemerisId'] = args.ephemeris_id
    
    print(f"Creating simulation with parameters:")
    print(f"  Name: {args.name}")
    print(f"  Satellite ID: {args.satellite_id}")
    print(f"  Mission Profile ID: {args.mission_profile_id}")
    print(f"  Ground Station: {args.ground_station}")
    print(f"  Start Time: {start_time.isoformat()}")
    print(f"  End Time: {end_time.isoformat()}")
    if args.ephemeris_id:
        print(f"  Ephemeris ID: {args.ephemeris_id}")
    
    try:
        response = client.create_digital_twin_simulation(**params)
        simulation_id = response['simulationId']
        print(f"\nSuccessfully created simulation: {simulation_id}")
        return simulation_id
    except Exception as e:
        print(f"\nError creating simulation: {str(e)}")
        sys.exit(1)

def wait_for_simulation(client, simulation_id, region):
    """Wait for a simulation to complete and print status updates."""
    print(f"\nWaiting for simulation {simulation_id} to complete...")
    
    try:
        while True:
            response = client.get_digital_twin_simulation(
                simulationId=simulation_id
            )
            status = response['status']
            print(f"Current status: {status}")
            
            if status in ['COMPLETED', 'FAILED', 'CANCELLED']:
                print(f"\nSimulation finished with status: {status}")
                if status == 'FAILED' and 'errorMessage' in response:
                    print(f"Error message: {response['errorMessage']}")
                break
                
            # Wait 30 seconds before checking again
            time.sleep(30)
            
    except KeyboardInterrupt:
        print("\nMonitoring interrupted. The simulation will continue running.")
        print(f"You can check its status with: aws groundstation get-digital-twin-simulation --simulation-id {simulation_id} --region {region}")
    except Exception as e:
        print(f"\nError monitoring simulation: {str(e)}")

def main():
    """Main function to create and optionally monitor a simulation."""
    args = parse_arguments()
    
    # Create the simulation
    simulation_id = create_simulation(args)
    
    # Print command to check status
    print(f"\nTo check simulation status:")
    print(f"aws groundstation get-digital-twin-simulation --simulation-id {simulation_id} --region {args.region}")
    
    # Wait for simulation to complete if requested
    if args.wait:
        client = boto3.client('groundstation', region_name=args.region)
        wait_for_simulation(client, simulation_id, args.region)

if __name__ == "__main__":
    main()
