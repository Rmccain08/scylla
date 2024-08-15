from collections import Counter
import re

# Empty list to store IP addresses
ip_addresses = []

# Open access log file and process each line
with open('access.log', 'r') as file:
    for line in file:
        # Extract IP addresses
        match = re.search(r'(\d{1,3}\.){3}\d{1,3}', line)
        if match:
            ip_addresses.append(match.group())

# Count each IP address
ip_counts = Counter(ip_addresses)

# Display the results
for ip, count in ip_counts.most_common():
    print(f"{count} {ip}")

