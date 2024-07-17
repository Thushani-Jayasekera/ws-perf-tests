#!/bin/bash

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

  cat <<EOF > "test${test_number}.yaml"
config:
  target: '$target'
  phases:
    - duration: 1800
      arrivalRate: 2000
      maxVusers: $max_vusers
  ws:
    headers:
      Authorization: '$authorization'
scenarios:
  - engine: ws
    flow:
      - loop:
          - send: 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
        count: 1800
EOF
}

# Parameters for test files
# arrival_rates=(200 500 1000 2000)
max_vusers=(200 500 1000 2000)
# send_contents=("message1" "message2" "message3" "message4" "message5" "message6" "message7" "message8" "message9" "message10" "message11" "message12" "message13" "message14" "message15" "message16" "message17" "message18" "message19" "message20" "message21")

# Create test files for test 14 to 34
for i in {9..13}; do
  index=$(($i - 9))
  create_test_file $i ${max_vusers[$index]}
done

echo "Test files created."
