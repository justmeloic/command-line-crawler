![Bash](https://img.shields.io/badge/language-Bash-green.svg) ![MIT License](https://img.shields.io/badge/license-MIT-blue.svg) ![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)

**Author:** [Loïc Muhirwa](https://github.com/justmeloic/)

# Lightweight Command-Line Web Crawler

A simple and lightweight web crawler written in Bash designed to be extensible and easy to use. This tool allows you to crawl websites and download their content, following links up to a specified depth.

- [Features](#features)
- [Directory Structure](#directory-structure)
- [Installation](#installation)
  - [Using setup.sh (Recommended)](#using-setupsh-recommended)
  - [Manual Installation](#manual-installation)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Features

- Crawls websites up to a specified depth.
- Downloads and saves web pages locally.
- Handles relative and absolute URLs.
- Easy to set up and use.
- Extensible.

## Directory Structure

```
crawl/
├── crawl.sh*       # Main script for the web crawler
├── setup.sh*       # Installation script
├── README.md
├── LICENSE
├── .gitignore
└── output/         # Default output directory for crawled data (created by crawl.sh)
```

## Installation

### Using setup.sh (Recommended)

The `setup.sh` script simplifies the installation process. It copies the `crawl.sh` script to `/usr/local/bin` and makes it executable.

1.  **Clone the repository (if you haven't already):**

    ```bash
    git clone https://github.com/justmeloic/command-line-crawler.git
    cd crawl
    ```

2.  **Run the `setup.sh` script with root privileges:**

    ```bash
    sudo ./setup.sh
    ```

    This will copy `crawl.sh` to `/usr/local/bin/crawl` and make it executable globally.

3.  **Verify the installation**

    ```bash
    crawl -h
    ```

### Manual Installation

If you prefer to install manually, follow these steps:

1.  **Clone the repository (if you haven't already):**

    ```bash
    git clone https://github.com/justmeloic/command-line-crawler.git
    cd crawl
    ```

2.  **Copy `crawl.sh` to a directory in your `PATH`:**

    ```bash
    sudo cp crawl.sh /usr/local/bin/crawl
    ```

3.  **Make the script executable:**

    ```bash
    sudo chmod +x /usr/local/bin/crawl
    ```

4.  **Verify the installation**

    ```bash
    crawl -h
    ```

## Usage

```bash
crawl -u <website_url> [-o <output_dir>] [-d <max_depth>] [-h]
```

## Options:

`-u <website_url>`: Required. The URL of the website to crawl (e.g., https://fromfirstprinciple.com/).

`-o <output_dir>`: Optional. The directory where crawled data will be saved. Default is output.

`-d <max_depth>`: Optional. The maximum depth of links to follow. Default is 2.

`-h`: Displays the help (instructions) message.

### Examples

Crawl [example.com](https://fromfirstprinciple.com/) up to depth 2, saving to my_output:

    ```bash
    crawl -u https://fromfirstprinciple.com/ -o my_output -d 2
    ```

## Contributing

Contributions are welcome! 👍
