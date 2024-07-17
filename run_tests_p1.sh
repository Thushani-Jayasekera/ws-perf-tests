#!/bin/bash

# List of input and output files
declare -a input_files=("test9.yaml" "test10.yaml" "test11.yaml" "test12.yaml" "test13.yaml")
declare -a output_files=("output9.json" "output10.json" "output11.json" "output12.json" "output13.json")
declare -a log_files=("log9.txt" "log10.txt" "log11.txt" "log12.txt" "log13.txt")
declare -a top_logs=("top_log9.txt" "top_log10.txt" "top_log11.txt" "top_log12.txt" "top_log13.txt")

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

    local artillery_pid=$!
    wait $artillery_pid
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
