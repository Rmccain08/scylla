#!/bin/bash

# Log file path
LOG_FILE="access.log"

# Extract IPs, count, sort, and display
awk '{print $3}' access.log | sort | uniq -c | sort -nr

