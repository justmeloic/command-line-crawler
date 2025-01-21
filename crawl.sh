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

# Default Variables
WEBSITE=""
OUTPUT_DIR="output"
MAX_DEPTH=2

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -u)
            WEBSITE="$2"
            shift 2
            ;;
        -o)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -d)
            MAX_DEPTH="$2"
            shift 2
            ;;
        -h)
            show_usage
            ;;
        *)
            echo "Error: Unknown option '$1'"
            show_usage
            exit 1
            ;;
    esac
done

# Check if the required website URL is provided
if [ -z "$WEBSITE" ]; then
    echo "Error: Website URL is required."
    show_usage
    exit 1
fi

# The rest of the script (from VISITED_LINKS=() onwards) remains the same as in the previous version...
VISITED_LINKS=()

# Create the output directory if it doesn't exist
if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Creating output directory: $OUTPUT_DIR"
    mkdir -p "$OUTPUT_DIR"
fi

# Function to fetch and save a webpage
fetch_page() {
    local URL=$1
    local DEPTH=$2
    local OUTPUT_FOLDER="$OUTPUT_DIR/depth_$DEPTH"

    echo "fetch_page called with URL: $URL, DEPTH: $DEPTH"

    # Create folder for the current depth
    echo "Creating output folder: $OUTPUT_FOLDER"
    mkdir -p "$OUTPUT_FOLDER"

    # Generate a filename based on the URL
    local FILENAME=$(echo "$URL" | sed 's/[^a-zA-Z0-9]/_/g').html
    echo "Generated filename: $FILENAME"

    # Fetch the page content and save it
    if ! echo "${VISITED_LINKS[@]}" | grep -q "$URL"; then
        echo "Fetching: $URL (depth $DEPTH)"
        if curl -s "$URL" -o "$OUTPUT_FOLDER/$FILENAME"; then
            echo "Successfully fetched: $URL"
            VISITED_LINKS+=("$URL")
        else
            echo "Error fetching: $URL"
        fi
    else
        echo "URL already visited: $URL"
    fi
}

# Function to convert relative URLs to absolute URLs
resolve_url() {
    local BASE_URL=$1
    local RELATIVE_URL=$2
    echo "resolve_url called with BASE_URL: $BASE_URL, RELATIVE_URL: $RELATIVE_URL"

    # Check if the URL is already absolute
    if [[ "$RELATIVE_URL" =~ ^https?:// ]]; then
        echo "URL is already absolute: $RELATIVE_URL"
        echo "$RELATIVE_URL"
    elif [[ "$RELATIVE_URL" == /* ]]; then
        # Handle URLs starting with //
        local PROTOCOL=$(echo "$BASE_URL" | cut -d ':' -f 1)
        echo "Detected protocol: $PROTOCOL"
        echo "$PROTOCOL:$RELATIVE_URL"
    elif [[ "$RELATIVE_URL" == /* ]]; then
        # Handle URLs starting with /
        local DOMAIN=$(echo "$BASE_URL" | sed -E 's#^(https?://[^/]+).*#\1#')
        echo "Detected domain: $DOMAIN"
        echo "$DOMAIN$RELATIVE_URL"
    else
        # Resolve other relative URLs
        resolved_url=$(echo "$BASE_URL/$RELATIVE_URL" | sed 's#//+#/#g' | sed 's#/./#/#' | sed 's#/[^/]*/\.\./#/#' )
        echo "Resolved URL: $resolved_url"
        echo "$resolved_url"
    fi
}

# Recursive crawling function
crawl() {
    local URL=$1
    local DEPTH=$2

    echo "crawl called with URL: $URL, DEPTH: $DEPTH"

    if [ "$DEPTH" -gt "$MAX_DEPTH" ]; then
        echo "Maximum depth reached. Returning."
        return
    fi

    # Fetch and save the page
    fetch_page "$URL" "$DEPTH"

    # Extract links from the current page
    echo "Extracting links from: $URL"
    # Simplified link extraction for debugging (extract all hrefs)
    local LINKS=$(curl -s "$URL" | grep -Eo 'href="[^"]+"' | sed 's/href="//;s/"//')
    # local LINKS=$(curl -s "$URL" | grep -Eo 'href="[^"]+"' | sed 's/href="//;s/"//')

    echo "Found links: $LINKS"

    for LINK in $LINKS; do
        # Skip links that are just # or javascript:void(0)
        if [[ "$LINK" == "#" || "$LINK" == "javascript:void(0)" ]]; then
            echo "Skipping link: $LINK"
            continue
        fi

        # Resolve relative URLs
        echo "Resolving link: $LINK"
        ABSOLUTE_URL=$(resolve_url "$URL" "$LINK")
        echo "Resolved to absolute URL: $ABSOLUTE_URL"

        crawl "$ABSOLUTE_URL" $((DEPTH + 1))
    done
}

# Start crawling from the given website
echo "Starting crawl with website: $WEBSITE"
crawl "$WEBSITE" 1

echo "Crawling completed! Files saved in $OUTPUT_DIR."