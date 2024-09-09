#!/bin/bash
cd $(dirname "$0")
source test-utils.sh

# Template specific tests
check "distro" lsb_release -c
check "git" git --version
check "nix" nix --version
check "fzf" fzf --version
check "direnv" direnv --version

# Report result
reportResults
