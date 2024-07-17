#!/bin/bash

# List of input and output files
declare -a input_files=(
    "test14.yaml" "test15.yaml" "test16.yaml" "test17.yaml" "test18.yaml" 
    "test19.yaml" "test20.yaml" "test21.yaml" "test22.yaml" "test23.yaml" 
    "test24.yaml" "test25.yaml" "test26.yaml" "test27.yaml" "test28.yaml" 
    "test29.yaml" "test30.yaml" "test31.yaml" "test32.yaml" "test33.yaml" 
    "test34.yaml"
)
declare -a output_files=(
    "output14.json" "output15.json" "output16.json" "output17.json" "output18.json" 
    "output19.json" "output20.json" "output21.json" "output22.json" "output23.json" 
    "output24.json" "output25.json" "output26.json" "output27.json" "output28.json" 
    "output29.json" "output30.json" "output31.json" "output32.json" "output33.json"
    "output34.json"
)
declare -a log_files=(
    "log14.txt" "log15.txt" "log16.txt" "log17.txt" "log18.txt" 
    "log19.txt" "log20.txt" "log21.txt" "log22.txt" "log23.txt" 
    "log24.txt" "log25.txt" "log26.txt" "log27.txt" "log28.txt" 
    "log29.txt" "log30.txt" "log31.txt" "log32.txt" "log33.txt"
    "log34.txt"
)
declare -a top_logs=(
    "top_log14.txt" "top_log15.txt" "top_log16.txt" "top_log17.txt" "top_log18.txt" 
    "top_log19.txt" "top_log20.txt" "top_log21.txt" "top_log22.txt" "top_log23.txt" 
    "top_log24.txt" "top_log25.txt" "top_log26.txt" "top_log27.txt" "top_log28.txt" 
    "top_log29.txt" "top_log30.txt" "top_log31.txt" "top_log32.txt" "top_log33.txt"
    "top_log34.txt"
)

# Check if the number of input files matches the number of output files
if [ ${#input_files[@]} -ne ${#output_files[@]} ]; then
    echo "Error: Number of input files and output files must be the same."
    exit 1
fi

# Function to run the artillery test and monitor with top
run_test() {
    local input_file=$1
    local output_file=$2
    local log_file=$3
    local top_log=$4

    echo "Running test with input: $input_file, output: $output_file, log: $log_file, top log: $top_log"

    # Start monitoring with top
    nohup top -b -d 10 > "$top_log" 2>&1 &
    local top_pid=$!

    # Run the artillery test
    nohup artillery run "$input_file" --output "$output_file" --insecure > "$log_file" 2>&1

    # Kill the top monitoring process
    kill $top_pid
}

# Loop through the files and run tests with a 15-minute gap
for i in "${!input_files[@]}"; do
    run_test "${input_files[$i]}" "${output_files[$i]}" "${log_files[$i]}" "${top_logs[$i]}"
    if [ $i -lt $((${#input_files[@]} - 1)) ]; then
        echo "Waiting for 15 minutes before running the next test..."
        sleep 900 # 900 seconds = 15 minutes
    fi
done

echo "All tests are running in the background."
