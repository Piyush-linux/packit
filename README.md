<p align="center">
   <img src="logo.png" alt="" width="250" />
</p>

---

# Packit - A Simple Package Manager

Packit is a lightweight package manager written in Bash. It uses GitHub repositories to manage packages, making it easy to install, update, and remove software components. This tool is ideal for developers who want to distribute and manage software packages using GitHub.

## Features

- **Install Packages**: Clone repositories from GitHub to a local directory.
- **Remove Packages**: Clean up installed packages.
- **Update Packages**: Pull the latest changes from GitHub.
- **List Available Packages**: View packages listed in an `index.txt` file.
- **Support for GitHub Integration**: Download raw files or full repositories using `curl` or `git`.

## Getting Started

### Prerequisites

- **Bash**: Ensure you have a Unix-like shell.
- **Git**: Required for cloning repositories.
- **curl**: For downloading files from GitHub.

### Installation

```sh
curl -s https://raw.githubusercontent.com/Piyush-linux/packit/refs/heads/master/setup.sh | bash -x
```

### Activate

Add the below line and source your `.bashrc` / `.zshrc` file

```sh
export PATH=$HOME/.local/bin/packit-scripts:$PATH
```
```sh
source ~/.bashrc
```

### Commands

1. **Install a Package**

Installs a package by cloning its GitHub repository to a specified directory.

```bash
packit install <package_name>
```

2. **Remove a Package**

Removes a package from the installation directory.

```bash
packit remove <package_name>
```

3. **Update a Package**

Pulls the latest changes from the GitHub repository.

```bash
packit update <package_name>
```

4. **List Available Packages**

```bash
packit list
```


### Directory Structure

```plaintext
packit/
|-- scripts/
|   |-- install.sh      # Installation script
|   |-- remove.sh       # Removal script
|   |-- update.sh       # Update script
|   |-- list.sh         # List script
|-- repo/
|   |-- index.txt       # Package metadata
|-- packit.sh           # Main CLI
```


## Future Improvements

- **Version Management**: Use Git tags to manage package versions.
- **Dependency Resolution**: Add support for resolving and installing dependencies.
- **Improved Error Handling**: Robust checks for network errors or missing files.
- **Checksum Validation**: Verify file integrity during downloads.


## Contributing

Contributions are welcome! Please fork this repository, make your changes, and submit a pull request.


## License

This project is licensed under the MIT License.


## Author

Packit is developed by [Piyush](https://github.com/Piyush-linux).

Enjoy using Packit!
