#!/bin/bash

NAMESPACE="default"  # Set the Kubernetes namespace
POD_NAME="your-pod-name"  # Set your pod name
LOCAL_PORT=9090
REMOTE_PORT=9090
URL="http://localhost:${LOCAL_PORT}/stat"

# Function to set up port forwarding
setup_port_forward() {
  echo "Setting up port forwarding from ${LOCAL_PORT} to ${REMOTE_PORT} on pod ${POD_NAME}..."
  kubectl port-forward -n ${NAMESPACE} pod/${POD_NAME} ${LOCAL_PORT}:${REMOTE_PORT} &
  PORT_FORWARD_PID=$!
}

# Function to clean up port forwarding
cleanup_port_forward() {
  echo "Cleaning up port forwarding..."
  kill ${PORT_FORWARD_PID}
}

# Function to check for upstream_cx_overflow, upstream_cx_active, or upstream_cx_total
check_cx_metrics() {
  curl -s $URL | grep -E "upstream_cx_overflow|upstream_cx_active|upstream_cx_total"
}

# Set up port forwarding
setup_port_forward

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

# Trap EXIT signal to clean up port forwarding
trap cleanup_port_forward EXIT
