#!/usr/bin/env bash
#
# Copyright (c) 2024 Microsoft Corporation
#
# SPDX-License-Identifier: Apache-2.0

set -o errexit
set -o pipefail
set -o errtrace

[ -n "$DEBUG" ] && set -x

CONF_PODS=${CONF_PODS:-no}

script_dir="$(dirname $(readlink -f $0))"
repo_dir="${script_dir}/../../../../"

common_file="common.sh"
source "${common_file}"

pushd "${repo_dir}"

pushd tools/osbuilder

echo "Creating target directory"
mkdir -p "${UVM_PATH}"

echo "Installing UVM files to target directory"
if [ "${CONF_PODS}" == "yes" ]; then
	cp -a --backup=numbered "${IGVM_FILE_NAME}" "${UVM_PATH}"
	cp -a --backup=numbered "${IGVM_DBG_FILE_NAME}" "${UVM_PATH}"
	cp -a --backup=numbered "${UVM_MEASUREMENT_FILE_NAME}" "${UVM_PATH}"
	cp -a --backup=numbered "${UVM_DBG_MEASUREMENT_FILE_NAME}" "${UVM_PATH}"
fi

cp -a --backup=numbered "${IMG_FILE_NAME}" "${UVM_PATH}"

popd

popd
