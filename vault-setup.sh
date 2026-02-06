#!/bin/bash

##login to vault first
#kubectl exec vault-0 -n vault -- vault login <ROOT_TOKEN>

# Global Constants
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Set Bash Options
set -o errexit      # Exit immediately if a command exits with a non-zero status.
set -o nounset      # Treat unset variables as an error when substituting.
set -o pipefail     # Return the exit status of the last command in a pipeline.

APP_NAME=$1
NAMESPACE=${2:-apps}
TTL=${3:-4h}

log() {
    local message="$1"
    echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $message"
}

checkCommand() {
    log "Checking if command $1 is available"
    for i in $1; do
        if [[ ! $(command -v "$i") ]]; then
            echo "$i could not be found"
            exit
        fi
    done
}

executeKubectl() {
    log "Running command on vault-0 pod"
    kubectl exec vault-0 -n vault -- "$@"
    ret=$?
    if [[ $ret -ne 0 ]]; then
        log "Error connecting to vault-0 pod, exiting."
    fi
}

checkCommand kubectl

log "Creating policy for ${APP_NAME}"
executeKubectl /bin/sh -c "vault policy write ${APP_NAME} - <<EOF
path \"secret/data/${NAMESPACE}/${APP_NAME}\" {
    capabilities = [\"read\"]
}
EOF"

log "Creating role for ${APP_NAME}"
executeKubectl vault write auth/kubernetes/role/"${APP_NAME}" \
    bound_service_account_names="${APP_NAME}" \
    bound_service_account_namespaces="${NAMESPACE}" \
    policies="${APP_NAME}" \
    ttl="${TTL}"

exit 0
