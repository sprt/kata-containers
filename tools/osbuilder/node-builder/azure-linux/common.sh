#!/usr/bin/env bash
#
# Copyright (c) 2024 Microsoft Corporation
#
# SPDX-License-Identifier: Apache-2.0

script_dir="$(dirname $(readlink -f $0))"
lib_file="${script_dir}/../../scripts/lib.sh"
source "${lib_file}"

OS_VERSION=${OS_VERSION:-2.0}

([[ "${OS_VERSION}" == "2.0" ]] || [[ "${OS_VERSION}" == "3.0" ]]) || die "OS_VERSION: must equal 2.0 (default) or 3.0"

if [ "${CONF_PODS}" == "yes" ]; then
	INSTALL_PATH_PREFIX="/opt/confidential-containers"
	UVM_TOOLS_PATH_OSB="${INSTALL_PATH_PREFIX}/uvm/tools/osbuilder"
	UVM_TOOLS_PATH_SRC="${INSTALL_PATH_PREFIX}/uvm/src"
	UVM_PATH="${INSTALL_PATH_PREFIX}/share/kata-containers"
	IMG_FILE_NAME="kata-containers.img"
	IGVM_FILE_NAME="kata-containers-igvm.img"
	IGVM_DBG_FILE_NAME="kata-containers-igvm-debug.img"
	UVM_MEASUREMENT_FILE_NAME="igvm-measurement.cose"
	UVM_DBG_MEASUREMENT_FILE_NAME="igvm-debug-measurement.cose"
	SHIM_CONFIG_PATH="${INSTALL_PATH_PREFIX}/share/defaults/kata-containers"
	SHIM_CONFIG_FILE_NAME="configuration-clh-snp.toml"
	SHIM_CONFIG_INST_FILE_NAME="${SHIM_CONFIG_FILE_NAME}"
	SHIM_DBG_CONFIG_FILE_NAME="configuration-clh-snp-debug.toml"
	SHIM_DBG_CONFIG_INST_FILE_NAME="${SHIM_DBG_CONFIG_FILE_NAME}"
	DEBUGGING_BINARIES_PATH="${INSTALL_PATH_PREFIX}/bin"
	SHIM_BINARIES_PATH="/usr/local/bin"
	SHIM_BINARY_NAME="containerd-shim-kata-cc-v2"
else
	INSTALL_PATH_PREFIX="/usr"
	UVM_TOOLS_PATH_OSB="/opt/kata-containers/uvm/tools/osbuilder"
	UVM_TOOLS_PATH_SRC="/opt/kata-containers/uvm/src"
	UVM_PATH="${INSTALL_PATH_PREFIX}/share/kata-containers"
	IMG_FILE_NAME="kata-containers.img"
	SHIM_CONFIG_PATH="${INSTALL_PATH_PREFIX}/share/defaults/kata-containers"
	SHIM_CONFIG_FILE_NAME="configuration-clh.toml"
	SHIM_CONFIG_INST_FILE_NAME="configuration.toml"
	DEBUGGING_BINARIES_PATH="${INSTALL_PATH_PREFIX}/local/bin"
	SHIM_BINARIES_PATH="${INSTALL_PATH_PREFIX}/local/bin"
	SHIM_BINARY_NAME="containerd-shim-kata-v2"
fi

# this is where cloud-hypervisor-cvm gets installed (see package SPEC)
CLOUD_HYPERVISOR_LOCATION="/usr/bin/cloud-hypervisor"
# this is where kernel-uvm gets installed (see package SPEC)
KERNEL_BINARY_LOCATION="/usr/share/cloud-hypervisor/vmlinux.bin"
# Mariner 3: different binary name
if [ "${OS_VERSION}" == "2.0" ]; then
	VIRTIOFSD_BINARY_LOCATION="/usr/libexec/virtiofsd-rs"
else
	VIRTIOFSD_BINARY_LOCATION="/usr/libexec/virtiofsd"
fi

AGENT_INSTALL_DIR="${script_dir}/agent-install"

set_uvm_kernel_vars() {
	UVM_KERNEL_VERSION=$(rpm -q --queryformat '%{VERSION}' kernel-uvm-devel)
	UVM_KERNEL_RELEASE=$(rpm -q --queryformat '%{RELEASE}' kernel-uvm-devel)
	UVM_KERNEL_HEADER_DIR="/usr/src/linux-headers-${UVM_KERNEL_VERSION}-${UVM_KERNEL_RELEASE}"
}
