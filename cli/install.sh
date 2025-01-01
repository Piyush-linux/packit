### tInstall Script

#!/bin/bash

REPO_URL="https://raw.githubusercontent.com/<username>/<repo>/refs/heads/master/<dir>/<file>.sh"
INSTALL_DIR="/usr/local/my-pm"   

install_package() {

  local package_name="$1"

  # Download the package
    echo "Downloading $package_name..."
    curl -L -o "/tmp/${package_name}" "$package_url"

}
