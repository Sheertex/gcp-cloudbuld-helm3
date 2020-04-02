#!/bin/bash

set -eu

usage() {
    cat 1>&2 <<EOF
Required environment variables missing.

Both of:

  CLOUDSDK_CONTAINER_PROJECT=<project name>
  CLOUDSDK_CONTAINER_CLUSTER=<cluster name>

Must be set, in addition to either:

  CLOUDSDK_COMPUTE_REGION=<cluster region> (for regional clusters)

or:

  CLOUDSDK_COMPUTE_ZONE=<cluster zone> (for zonal clusters)

(depending on whether your cluster is regional or zonal)

Hint: see example in the README at: https://github.com/Sheertex/gcp-cloudbuld-helm3
EOF
    exit 1
}

cmd=(
    gcloud container clusters get-credentials
    "--project=${CLOUDSDK_CONTAINER_PROJECT-:$(usage)}"
)

if [[ ! -z "${CLOUDSDK_COMPUTE_REGION:-}" ]]; then
    cmd=( "${cmd[@]}" "--region=${CLOUDSDK_COMPUTE_REGION}" )
elif [[ ! -z "${CLOUDSDK_COMPUTE_ZONE:-}" ]]; then
    cmd=( "${cmd[@]}" "--zone=${CLOUDSDK_COMPUTE_ZONE}" )
else
    usage
fi

cmd=( "${cmd[@]}" "${CLOUDSDK_CONTAINER_CLUSTER:-$(usage)}" )

echo "Fetching credentials: ${cmd[@]}"
"${cmd[@]}"

echo "Running: helm ${@}"
exec helm "${@}"
