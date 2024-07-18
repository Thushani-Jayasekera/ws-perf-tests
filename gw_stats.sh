#!/bin/bash

#port-forward choreo connect gw before running this script
# URL to check
URL="http://localhost:9090/stats"

# Function to check for cx-overflow
check_cx_metrics() {
  curl -s $URL | grep -E "upstream_cx_overflow|upstream_cx_active|upstream_cx_total"
}

# Infinite loop to run the check every 5 minutes
while true; do
  check_cx_overflow
  # Wait for 5 minutes
  sleep 300
done
