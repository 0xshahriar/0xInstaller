# 0xInstaller

`0xInstaller` is a powerful and user-friendly bash script designed to automate the installation of essential development and cybersecurity tools. This script is perfect for developers, ethical hackers, and security researchers who want to set up their environment quickly and efficiently.

---

## Features

- Automatically installs development tools such as `git`, `python3`, and `golang`.
- Sets up popular cybersecurity tools like `Nmap`, `Httpx`, `Nuclei`, `Subfinder`, and more.
- Includes an update checker to keep the script up-to-date.
- Displays a colorful banner for an engaging user experience.
- Error handling, logging, and dry-run mode for safe execution.
- Supports Linux systems (Debian-based distributions).

---

## Tools Installed

### Development Tools
- **Git**: Version control system.
- **Python3**: Programming language.
- **Pip3**: Python package manager.
- **Go**: Programming language.
- **Ruby**: Scripting language.

### General Utilities
- **Tree**: Directory structure visualization.

### Cybersecurity Tools
- **Nmap**: Network mapper.
- **Httpx**: HTTP probing tool.
- **Waybackurls**: Fetch URLs from archive.org.
- **Anew**: Tool to append unique lines to files.
- **Nuclei**: Vulnerability scanner.
- **Shuffledns**: Subdomain enumeration tool.
- **Subfinder**: Subdomain discovery tool.
- **Ffuf**: Fuzzing tool.
- **Naabu**: Port scanner.
- **Uncover**: Asset discovery tool.
- **AWSBucketDump**: Tool for auditing S3 buckets.
- **Sublist3r**: Subdomain enumeration tool.

---

## Prerequisites

- A Debian-based Linux system (e.g., Ubuntu, Kali Linux).
- Root or sudo privileges.

---

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/0xShahriar/0xInstaller.git
   cd 0xInstaller
2. Make the script executable:
   ```bash
   chmod +x 0xInstaller.sh
3. Run the script:
   ```bash
   sudo ./0xInstaller.sh

---

## Usage

- **Normal Execution**: Run the script to install all tools.
   ```bash
   sudo ./0xInstaller.sh
- **Dry-Run Mode**: Test the script without making any changes.
   ```bash
   sudo ./0xInstaller.sh --dry-run
- **Update Checker**: Automatically updates the script from the GitHub repository.

---

## Logs
- All script output is logged to ```~/0xInstaller.log```. Use this file for debugging or to review installation progress.

---

## Contribution

Contributions are welcome! If you’d like to improve this script or add support for more tools, please fork the repository and create a pull request.

---

## Issues

If you encounter any issues or bugs, please open an issue in the [GitHub repository](https://github.com/0xShahriar/0xInstaller/issues).

---

## Disclaimer

This script is provided "as-is" without any guarantees. Use it responsibly and ensure you have the necessary permissions before running it on any system.


---

## Author

- **Md. Shahriar Alam Shaon**  
  Ethical Hacker and Programmer  
  GitHub: [0xShahriar](https://github.com/0xShahriar)
