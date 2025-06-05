#!/bin/bash
# Script to upload and register ephemeris data with AWS Ground Station Digital Twin

# Exit on error
set -e

# Default values
REGION="us-west-2"
PRIORITY=100
EPHEMERIS_TYPE="oem"  # oem or tle

# Function to display usage
usage() {
  echo "Usage: $0 -s SATELLITE_ID -b BUCKET_NAME -k KEY_PATH -f FILE_PATH [-n NAME] [-p PRIORITY] [-t TYPE] [-r REGION]"
  echo ""
  echo "Required arguments:"
  echo "  -s SATELLITE_ID   The satellite ID to associate with the ephemeris"
  echo "  -b BUCKET_NAME    S3 bucket name where ephemeris will be uploaded"
  echo "  -k KEY_PATH       S3 key path where ephemeris will be stored"
  echo "  -f FILE_PATH      Local path to the ephemeris file"
  echo ""
  echo "Optional arguments:"
  echo "  -n NAME           Name for the ephemeris (default: generated from date)"
  echo "  -p PRIORITY       Priority value (default: 100)"
  echo "  -t TYPE           Ephemeris type: 'oem' or 'tle' (default: oem)"
  echo "  -r REGION         AWS region (default: us-west-2)"
  echo ""
  echo "Example:"
  echo "  $0 -s sat-1234567890abcdef0 -b my-ephemeris-bucket -k ephemeris/satellite1.oem -f ./satellite1.oem -n \"Satellite1-Ephemeris\" -p 200"
  exit 1
}

# Parse command line arguments
while getopts "s:b:k:f:n:p:t:r:" opt; do
  case ${opt} in
    s)
      SATELLITE_ID=$OPTARG
      ;;
    b)
      BUCKET_NAME=$OPTARG
      ;;
    k)
      KEY_PATH=$OPTARG
      ;;
    f)
      FILE_PATH=$OPTARG
      ;;
    n)
      NAME=$OPTARG
      ;;
    p)
      PRIORITY=$OPTARG
      ;;
    t)
      EPHEMERIS_TYPE=$OPTARG
      ;;
    r)
      REGION=$OPTARG
      ;;
    \?)
      usage
      ;;
  esac
done

# Check required arguments
if [ -z "$SATELLITE_ID" ] || [ -z "$BUCKET_NAME" ] || [ -z "$KEY_PATH" ] || [ -z "$FILE_PATH" ]; then
  echo "Error: Missing required arguments"
  usage
fi

# Check if file exists
if [ ! -f "$FILE_PATH" ]; then
  echo "Error: File $FILE_PATH does not exist"
  exit 1
fi

# Generate name if not provided
if [ -z "$NAME" ]; then
  NAME="Ephemeris-$(date +%Y%m%d-%H%M%S)"
fi

# Validate ephemeris type
if [ "$EPHEMERIS_TYPE" != "oem" ] && [ "$EPHEMERIS_TYPE" != "tle" ]; then
  echo "Error: Ephemeris type must be 'oem' or 'tle'"
  exit 1
fi

echo "=== AWS Ground Station Digital Twin - Ephemeris Upload ==="
echo "Satellite ID: $SATELLITE_ID"
echo "Ephemeris Name: $NAME"
echo "Ephemeris Type: $EPHEMERIS_TYPE"
echo "Priority: $PRIORITY"
echo "Region: $REGION"
echo "Local File: $FILE_PATH"
echo "S3 Destination: s3://$BUCKET_NAME/$KEY_PATH"
echo ""

# Upload file to S3
echo "Uploading ephemeris file to S3..."
aws s3 cp "$FILE_PATH" "s3://$BUCKET_NAME/$KEY_PATH" --region "$REGION"

# Prepare ephemeris data JSON based on type
if [ "$EPHEMERIS_TYPE" = "oem" ]; then
  EPHEMERIS_DATA="{\"oem\":{\"s3Object\":{\"bucket\":\"$BUCKET_NAME\",\"key\":\"$KEY_PATH\"}}}"
else
  EPHEMERIS_DATA="{\"tle\":{\"s3Object\":{\"bucket\":\"$BUCKET_NAME\",\"key\":\"$KEY_PATH\"}}}"
fi

# Register ephemeris with Ground Station
echo "Registering ephemeris with AWS Ground Station..."
RESPONSE=$(aws groundstation register-ephemeris \
  --satellite-id "$SATELLITE_ID" \
  --ephemeris-data "$EPHEMERIS_DATA" \
  --name "$NAME" \
  --priority "$PRIORITY" \
  --region "$REGION" \
  --output json)

# Extract ephemeris ID from response
EPHEMERIS_ID=$(echo "$RESPONSE" | jq -r '.ephemerisId')

echo ""
echo "Ephemeris registered successfully!"
echo "Ephemeris ID: $EPHEMERIS_ID"
echo ""
echo "To check validation status:"
echo "aws groundstation describe-ephemeris --ephemeris-id $EPHEMERIS_ID --region $REGION"
echo ""
echo "To check validation messages:"
echo "aws groundstation list-ephemeris-validation-messages --ephemeris-id $EPHEMERIS_ID --region $REGION"
