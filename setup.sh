#!/bin/bash

# Function to display usage instructions
show_usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -u <website_url>   Specify the website URL to crawl (e.g., https://www.example.com)."
    echo "  -o <output_dir>    Specify the output directory (default: output)."
    echo "  -d <max_depth>     Specify the maximum crawling depth (default: 2)."
    echo "  -h                 Display this help message."
    echo ""
    echo "Examples:"
    echo "  Crawl example.com up to depth 2, saving to 'my_output':"
    echo "  $0 -u https://www.example.com -o my_output -d 2"
    echo ""
    echo "  Crawl example.com with default settings:"
    echo "  $0 -u https://www.example.com"
    exit 0
}


# --- INSTALLATION SCRIPT ---

# Check for necessary permissions
if [ "$(whoami)" != "root" ]; then
    echo "You must run this script as root or with sudo."
    exit 1
fi

# Copy the script to /usr/local/bin
cp crawl.sh /usr/local/bin/crawl

# Make it executable
chmod +x /usr/local/bin/crawl

echo "Installation complete! You can now run the crawl command from anywhere."
show_usage
