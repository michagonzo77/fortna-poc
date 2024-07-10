# Debugging function
function debug {
    echo "DEBUG: $1"
}

# Error handling function
function error {
    echo "ERROR: $1" >&2
    exit 1
}

# Login to OpenShift
debug "Logging in to OpenShift"
oc login $OPENSHIFT_API_URL --username=$OPENSHIFT_USERNAME --password=$OPENSHIFT_PASSWORD --insecure-skip-tls-verify=true

debug "Successfully logged in to OpenShift"

# Extract and execute the OpenShift CLI command
command="{{.command}}"
debug "Executing OpenShift CLI command: oc $command"

oc $command || error "Failed to execute command: oc $command"