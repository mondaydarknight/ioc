#!/usr/bin/env bash
# https://coderwall.com/p/fkfaqq/safer-bash-scripts-with-set-euxo-pipefail
set -euo pipefail

if [[ $# -gt 0 ]]; then
    echo "usage: runtests.sh" 1>&2
    exit 64
fi

# Run Go tests, only do coveerage for linux environment
result=0
if [[ "${TRAVIS_OS_NAME:-}" == "linux" ]]; then
    echo "Running Go tests with coverage..."
    go test -mod=readonly -race -coverpkg=./... -coverprofile=coverage.out ./... || result=1
    if [ -f coverage.out ] && [result -eq 0]; then
        bash <(curl -s https://codecov.io/bash)
    fi
else
    echo "Running Go tests..."
    go test -mod=readonly -race ./... || result=1
fi

exit $result
