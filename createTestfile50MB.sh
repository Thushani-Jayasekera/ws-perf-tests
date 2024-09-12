#!/bin/bash

# Function to generate a payload of 50MB
generate_payload() {
  local payload_size=$((50 * 1024 * 1024))  # 50MB in bytes
  payload=$(head -c $payload_size </dev/urandom | base64)
}

# Define the common target URL and authorization header
target='wss://7375bc81-330f-47f2-8e8b-62ee5105dfce-dev.e1-us-east-azure.perf.choreoapis.dev/thushaniwebsocket/websocketservice/websocket-5cd/v1.0'
authorization='Bearer '
# Function to create a test file
create_test_file() {
  local test_number=$1
#   local duration=$2
#   local arrival_rate=$3
  local max_vusers=$2
#   local send_content=$5

  generate_payload

  cat <<EOF > "configstage${test_number}.yaml"
config:
  target: '$target'
  phases:
    - duration: 1800
      arrivalRate: 1
      maxVusers: $max_vusers
  ws:
    headers:
      Authorization: '$authorization'
scenarios:
  - engine: ws
    flow:
      - loop:
          - send: '$payload'
        count: 8000000000
EOF
}

# Parameters for test files
# arrival_rates=(200 500 1000 2000)
max_vusers=15
# send_contents=("message1" "message2" "message3" "message4" "message5" "message6" "message7" "message8" "message9" "message10" "message11" "message12" "message13" "message14" "message15" "message16" "message17" "message18" "message19" "message20" "message21")

# Create test files for test 14 to 34

create_test_file 9 15


echo "Test files created."
