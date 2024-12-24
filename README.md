# 0xInstaller

## Overview
**0xInstaller** is an all-in-one installer script designed to simplify the installation of essential packages, cybersecurity tools, and development utilities. It is particularly useful for setting up a new Linux environment for penetration testing or, ethical hacking.

## Features
- **Root Privileges Check**: Ensures the script is run with sufficient permissions.
- **Automatic Updates**: Checks for and applies updates to the script itself.
- **Dry-Run Mode**: Simulate installations without making changes.
- **Customizable Installation**:
  - Supports Go-based and Python-based tools.
  - Allows selective installation via configuration files or command-line arguments.
- **Parallel Processing**: Faster installations using parallel execution for Go-based tools.
- **Error Handling**: Robust checks for all critical commands, ensuring reliability.
- **Logging**: Maintains a log of all operations for troubleshooting and auditing.

## Tools Installed
### Essential Packages
- [`git`](https://git-scm.com/)
- [`python3`](https://www.python.org/) and [`python3-pip`](https://pip.pypa.io/)
- [`golang`](https://go.dev/)
- [`ruby`](https://www.ruby-lang.org/)
- [`tree`](http://mama.indstate.edu/users/ice/tree/)

### Cybersecurity Tools
- [`nmap`](https://nmap.org/)

### Go-Based Tools
- [`httpx`](https://github.com/projectdiscovery/httpx)
- [`waybackurls`](https://github.com/tomnomnom/waybackurls)
- [`anew`](https://github.com/tomnomnom/anew)
- [`nuclei`](https://github.com/projectdiscovery/nuclei)
- [`shuffledns`](https://github.com/projectdiscovery/shuffledns)
- [`subfinder`](https://github.com/projectdiscovery/subfinder)
- [`ffuf`](https://github.com/ffuf/ffuf)
- [`uncover`](https://github.com/projectdiscovery/uncover)
- [`naabu`](https://github.com/projectdiscovery/naabu)

### Python-Based Tools
- [`AWSBucketDump`](https://github.com/jordanpotti/AWSBucketDump)
- [`Sublist3r`](https://github.com/aboul3la/Sublist3r)

## Requirements
- **Operating System**: Debian-based distributions (e.g., Ubuntu, Kali Linux).
- **Root Privileges**: The script requires root access to install system-wide packages.
- **Internet Connection**: Required to download and install tools.

## Installation and Usage
1. Clone the repository:
   ```bash
   git clone https://github.com/0xShahriar/0xInstaller.git
   cd 0xInstaller
   ```
2. Make the script executable:
   ```bash
   chmod +x 0xInstaller.sh
   ```
3. Run the script:
   ```bash
   ./0xInstaller.sh
   ```
4. **Optional**: Use the dry-run mode to preview actions without making changes:
   ```bash
   ./0xInstaller.sh --dry-run
   ```
5. Selective Installation:
  - Use command-line arguments:
    ```bash
    ./0xInstaller.sh --install-go-tools
    ./0xInstaller.sh --install-python-tools
    ```
  - Alternatively, create a tools.conf file:
    ```bash
    # tools.conf
    INSTALL_GO_TOOLS=true
    INSTALL_PYTHON_TOOLS=false
    ```
  

---

## Configuration

- The script supports a tools.conf file for custom installations. Example:
  ```bash
  # tools.conf
  INSTALL_GO_TOOLS=true    # Install Go-based tools
  INSTALL_PYTHON_TOOLS=false # Skip Python-based Tools
  ```

## Logs

- All script output is logged to ```$HOME/0xInstaller/0xInstaller.log```. Use this file for debugging or to review installation progress.

---

## Troubleshooting

- Permission Denied: Ensure you run the script at root privilege.
- Missing Dependencies: The script will attempt to install missing dependencies like figlet and lolcat.
- Installation Fails: Check the log file for details:
  ```bash
  less $HOME/0xInstaller/0xInstaller.log
  ```

---

## Contribution

- Contributions are welcome! If you’d like to improve this script or add support for more tools, please fork the repository and create a pull request.

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