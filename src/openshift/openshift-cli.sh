#!/bin/bash
# Debugging function
function debug {
    echo "DEBUG: $1"
}

# Error handling function
function error {
    echo "ERROR: $1" >&2
    exit 1
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --command) command="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check for required argument
if [ -z "${command}" ]; then
    echo "Usage: $0 --command <command>"
    exit 1
fi

# Login to OpenShift
debug "Logging in to OpenShift"
oc login $OPENSHIFT_API_URL --username=$OPENSHIFT_USERNAME --password=$OPENSHIFT_PASSWORD --insecure-skip-tls-verify=true

if [ $? -ne 0 ]; then
    error "Failed to log in to OpenShift"
fi

debug "Successfully logged in to OpenShift"

# Execute the OpenShift CLI command
debug "Executing OpenShift CLI command: oc $command"
oc $command || error "Failed to execute command: oc $command"
