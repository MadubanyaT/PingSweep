# PING SWEEP - Bash Script Tool

Ping Sweep is a simple Bash script that automates the process of scanning a range of IP addresses to identify which ones are responsive (alive) and unresponsive (dead). Instead of manually pinging each address, users can input a starting and ending IP range, and the script will do the rest — saving all live/dead IPs into an output file for later use.

## 🛠 Features:
- Accepts custom IP range input.
- Automatically pings each IP within the range.
- Saves reachable and unreachable IP addresses to a file.
- Lightweight and easy to use.
- Add and removes previous stored IPs (You don't have to worry about deleting files (Alive_IPs/Dead_IPs))