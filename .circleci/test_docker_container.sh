#!/usr/bin/env bash

set -xeuo pipefail

echo 'Validating correctly configured en_US.UTF-8 locale...'
locale -a | grep -i 'en_US.UTF.\?8'
[ "$( LC_ALL=en_US.UTF-8 sh -c : 2>&1 )" = "" ]
# make sure the above fails for non-existent locale
[ ! "$( LC_ALL=badlocale sh -c : 2>&1 )" = "" ]

# check that /opt/conda has correct permissions
touch /opt/conda/bin/test_conda_forge

# check that conda is activated
conda info

# show all packages installed in root
conda list

# check that we can install a conda package
conda install --yes --quiet conda-forge-pinning -c conda-forge

if [[ "$DOCKERIMAGE" == "linux-anvil-cuda" ]]; then
  conda install --yes gxx_linux-64 nvcc_linux-64
fi

touch /home/conda/feedstock_root/build_artifacts/conda-forge-build-done
