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
        --environment) environment="$2"; shift ;;
        --project) project="$2"; shift ;;
        # --helm_chart_url) helm_chart_url="$2"; shift ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

# Check for required arguments
if [ -z "${environment}" ] || [ -z "${project}" ]; then
    echo "Usage: $0 --environment <environment> --project <project>"
    exit 1
fi

# Convert project and environment to lowercase
environment=$(echo "$environment" | tr '[:upper:]' '[:lower:]')
project=$(echo "$project" | tr '[:upper:]' '[:lower:]')

namespace="${project}-${environment}"
helm_release_name="${project}-${environment}-release"

helm_chart_url="https://charts.bitnami.com/bitnami/nginx-9.3.0.tgz"

# Login to OpenShift
debug "Logging in to OpenShift"
oc login $OPENSHIFT_API_URL --username=$OPENSHIFT_USERNAME --password=$OPENSHIFT_PASSWORD --insecure-skip-tls-verify=true >/dev/null 2>&1
if [ $? -ne 0 ]; then
    error "Failed to log in to OpenShift"
fi
debug "Successfully logged in to OpenShift"

# Check if namespace exists
debug "Checking if namespace $namespace exists"
if oc get namespace $namespace > /dev/null 2>&1; then
    debug "Namespace $namespace already exists"
else
    debug "Namespace $namespace does not exist. Creating namespace."
    oc create namespace $namespace
    if [ $? -ne 0 ]; then
        error "Failed to create namespace $namespace"
    fi
    debug "Namespace $namespace created successfully"
fi

# Switch to the namespace
debug "Switching to namespace $namespace"
oc project $namespace >/dev/null 2>&1
if [ $? -ne 0 ]; then
    error "Failed to switch to namespace $namespace"
fi
debug "Namespace $namespace selected"

# Deploy the Helm chart
debug "Deploying Helm chart from $helm_chart_url to namespace $namespace"
helm install $helm_release_name $helm_chart_url -n $namespace
if [ $? -ne 0 ]; then
    error "Failed to deploy Helm chart to namespace $namespace"
fi

# Verify the deployment
debug "Verifying the deployment in namespace $namespace"
if oc get deploy -n $namespace > /dev/null 2>&1; then
    debug "Deployment in namespace $namespace verified successfully"
else
    error "Failed to verify deployment in namespace $namespace"
fi
