#!/bin/bash

# Function to display usage instructions
show_usage() {
    echo "Usage: ./serverloganaly.sh [log_file_path]"
    echo "Example: ./serverloganaly.sh /var/log/nginx/access.log"
    echo "If no log file is specified, script will exit."
    exit 1
}

# Function to print section headers
print_header() {
    echo -e "\n=== $1 ==="
}

# Debug information
print_debug_info() {
    echo "=== Debug Information ==="
    echo "Log file path: $1"
    echo "File exists: $(if [ -f "$1" ]; then echo "Yes"; else echo "No"; fi)"
    echo "File readable: $(if [ -r "$1" ]; then echo "Yes"; else echo "No"; fi)"
    echo "File size: $(ls -lh "$1" 2>/dev/null | awk '{print $5}' || echo "Cannot determine")"
    echo "File permissions: $(ls -l "$1" 2>/dev/null | awk '{print $1}' || echo "Cannot determine")"
    echo "File owner: $(ls -l "$1" 2>/dev/null | awk '{print $3":"$4}' || echo "Cannot determine")"
    echo "Last modified: $(ls -l "$1" 2>/dev/null | awk '{print $6, $7, $8}' || echo "Cannot determine")"
    echo "First line of file: $(head -n 1 "$1" 2>/dev/null || echo "Cannot read")"
    echo "----------------------------------------"
}

# Check if log file is provided as argument
if [ $# -ne 1 ]; then
    show_usage
fi

LOG_FILE="$1"

# Print debug information
print_debug_info "$LOG_FILE"

# Check if the log file exists and is readable
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file not found: $LOG_FILE"
    show_usage
fi

if [ ! -r "$LOG_FILE" ]; then
    echo "Error: Cannot read log file: $LOG_FILE"
    exit 1
fi

echo "Analyzing log file: $LOG_FILE"
echo "----------------------------------------"

# Total Requests
print_header "Total Requests"
wc -l < "$LOG_FILE"

# Top 10 IP Addresses
print_header "Top 10 IP Addresses"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10

# HTTP Status Codes Summary
print_header "HTTP Status Codes"
awk '{print $9}' "$LOG_FILE" | sort | uniq -c | sort -nr

# Top 404 Errors
print_header "Top 10 404 Errors (URLs)"
grep ' 404 ' "$LOG_FILE" | awk '{print $7}' | sort | uniq -c | sort -nr | head -n 10

# Most Requested Pages
print_header "Top 10 Most Requested Pages"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -n 10

# Traffic by Hour
print_header "Requests Per Hour"
awk '{print substr($4, 14, 2)}' "$LOG_FILE" | sort | uniq -c | sort -n | awk '{printf("%02d:00 - %d requests\n", $2, $1)}'

output:
Log file path: /var/log/nginx/access.log
File exists: Yes
File readable: Yes
File size: 304
File permissions: -rw-r--r--
File owner: www-data:adm
Last modified: Nov 15 06:41
First line of file: 1.34.254.21 - - [15/Nov/2024:06:40:11 +0000] "GET / HTTP/1.0" 200 615 "-" "Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30"
----------------------------------------
Analyzing log file: /var/log/nginx/access.log
----------------------------------------

=== Total Requests ===
2

=== Top 10 IP Addresses ===
      1 172.31.14.12
      1 1.34.254.21

=== HTTP Status Codes ===
      2 200

=== Top 10 404 Errors (URLs) ===

=== Top 10 Most Requested Pages ===
      2 /

=== Requests Per Hour ===
06:00 - 2 requests
